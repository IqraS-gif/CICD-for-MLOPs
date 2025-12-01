install:
	pip install -r requirements.txt

format:
	black *.py

train:
	python train.py
