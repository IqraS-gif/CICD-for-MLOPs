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
	# Install the library (v1+ removes the old CLI, so we use Python below)
	pip install -U huggingface_hub
	
	# FIX: Use Python to login directly. 
	# Passing token via env var (HF_TOKEN) is safer than arguments.
	HF_TOKEN=$(HF) python -c "from huggingface_hub import login; import os; login(token=os.environ['HF_TOKEN'], add_to_git_credential=True)"

push-hub:
	# FIX: Use Python to upload folders directly.
	# This uses the 'upload_folder' API which is robust and handles large files automatically.
	
	# 1. Upload App to Root
	python -c "from huggingface_hub import HfApi; HfApi().upload_folder(repo_id='IqraSAYEDhassan/DrugClassifier', folder_path='./App', path_in_repo='.', repo_type='space', commit_message='Sync App')"
	
	# 2. Upload Model to /Model
	python -c "from huggingface_hub import HfApi; HfApi().upload_folder(repo_id='IqraSAYEDhassan/DrugClassifier', folder_path='./Model', path_in_repo='Model', repo_type='space', commit_message='Sync Model')"
	
	# 3. Upload Results to /Results
	python -c "from huggingface_hub import HfApi; HfApi().upload_folder(repo_id='IqraSAYEDhassan/DrugClassifier', folder_path='./Results', path_in_repo='Results', repo_type='space', commit_message='Sync Results')"

deploy: hf-login push-hub