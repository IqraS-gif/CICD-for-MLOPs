# 1. Keeps the session alive so 'export PATH' works in all targets
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
	# 2. CRITICAL FIX: Add Makefile and App folder so fixes propagate to the update branch
	git add Model Results report.md Makefile App .github
	git commit -m "Update model, results, and pipeline code" || echo "No changes to commit"
	git push --force origin HEAD:update

hf-login:
	pip install -U "huggingface_hub[cli]"
	# 3. Add local bin to PATH
	export PATH="$$HOME/.local/bin:$$PATH"
	# 4. Use the correct CLI command
	huggingface-cli login --token $(HF) --add-to-git-credential

push-hub:
	export PATH="$$HOME/.local/bin:$$PATH"
	huggingface-cli upload IqraSAYEDhassan/DrugClassifier ./App --repo-type=space --commit-message="Sync App"
	huggingface-cli upload IqraSAYEDhassan/DrugClassifier ./Model /Model --repo-type=space --commit-message="Sync Model"
	huggingface-cli upload IqraSAYEDhassan/DrugClassifier ./Results /Results --repo-type=space --commit-message="Sync Results"

deploy: hf-login push-hub