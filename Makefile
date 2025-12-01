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
	git add Model Results report.md
	git commit -m "Update with new results"
	git push --force origin HEAD:update

hf-login:
	git pull origin update
	git switch update
	pip install -U "huggingface_hub[cli]"
	export PATH="$$HOME/.local/bin:$$PATH"
	huggingface-cli login --token $(HF) --add-to-git-credential

push-hub:
	export PATH="$$HOME/.local/bin:$$PATH"
	huggingface-cli upload IqraSAYEDhassan/DrugClassifier ./App --repo-type=space --commit-message="Sync App files"
	huggingface-cli upload IqraSAYEDhassan/DrugClassifier ./Model /Model --repo-type=space --commit-message="Sync Model"
	huggingface-cli upload IqraSAYEDhassan/DrugClassifier ./Results /Results --repo-type=space --commit-message="Sync Results"

deploy: hf-login push-hub
