# Ensures all commands in a target run in one shell
.ONESHELL:

install:
	pip install -r requirements.txt

format:
	black *.py

train:
	python train.py

eval:
	echo "## Model Metrics" > report.md
	cat Results/metrics.txt >> report.md
	echo "" >> report.md
	echo "## Confusion Matrix" >> report.md
	echo "![Confusion Matrix](./Results/model_results.png)" >> report.md
	cml comment create report.md

update-branch:
	git config --global user.name "$(USER_NAME)"
	git config --global user.email "$(USER_EMAIL)"
	git add Model Results report.md Makefile App
	git commit -m "Update model, results, and pipeline code" || echo "No changes to commit"
	git push --force origin HEAD:update

hf-login:
	# Install the library
	pip install -U "huggingface_hub[cli]"
	
	# FIX: Dynamically find the path to the 'huggingface-cli' script 
	# (It lives in the same folder as the python executable)
	CLI_PATH=$$(dirname $$(which python))/huggingface-cli; \
	$$CLI_PATH login --token $(HF) --add-to-git-credential

push-hub:
	# Use the same dynamic path logic for uploads
	CLI_PATH=$$(dirname $$(which python))/huggingface-cli; \
	$$CLI_PATH upload IqraSAYEDhassan/DrugClassifier ./App --repo-type=space --commit-message="Sync App" && \
	$$CLI_PATH upload IqraSAYEDhassan/DrugClassifier ./Model /Model --repo-type=space --commit-message="Sync Model" && \
	$$CLI_PATH upload IqraSAYEDhassan/DrugClassifier ./Results /Results --repo-type=space --commit-message="Sync Results"

deploy: hf-login push-hub