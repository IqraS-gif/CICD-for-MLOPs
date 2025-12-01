# Drug Classification MLOps Pipeline

This project demonstrates a complete **End-to-End MLOps Pipeline** for a Drug Classification Machine Learning model. It automates the entire lifecycle—from model training and evaluation to deployment—using **GitHub Actions** and **Hugging Face Spaces**.

## 🚀 Project Overview

The system trains a **Random Forest Classifier** to predict the appropriate drug for a patient based on their medical metrics (Age, Sex, Blood Pressure, Cholesterol, and Na-to-K ratio).

* **Model:** Scikit-Learn Random Forest
* **Interface:** Gradio Web App
* **Infrastructure:** GitHub Actions (CI/CD) + Hugging Face Spaces (Hosting)
* **Metrics Tracking:** CML (Continuous Machine Learning) reports in Pull Requests

---

## 🏗️ Architecture

1.  **Continuous Integration (CI):**
    * Triggered on every push to the `main` branch.
    * Formats code using `black`.
    * Retrains the model on the latest data.
    * Evaluates performance (Accuracy, F1 Score) and generates a Confusion Matrix.
    * Uses **CML** to post a training report directly to the GitHub commit/PR.

2.  **Continuous Deployment (CD):**
    * Triggered only if the CI pipeline completes successfully.
    * Automatically uploads the trained model, results, and application code to a **Hugging Face Space**.
    * The application updates live without manual intervention.

---

## 🛠️ Installation & Local Setup

To run this project locally on your machine:

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/YOUR_USERNAME/CICD-for-MLOPs.git](https://github.com/YOUR_USERNAME/CICD-for-MLOPs.git)
    cd CICD-for-MLOPs
    ```

2.  **Install dependencies:**
    ```bash
    pip install -r requirements.txt
    ```

3.  **Train the model:**
    ```bash
    python train.py
    ```
    *This will generate `Model/drug_pipeline.skops` and performance metrics in `Results/`.*

4.  **Run the App:**
    ```bash
    python App/drug_app.py
    ```
    *Open the URL provided (usually `http://127.0.0.1:7860`) to test the interface.*

---

## 📂 Project Structure

```text
├── .github/workflows/
│   ├── ci.yml              # CI pipeline (Train & Evaluate)
│   └── cd.yml              # CD pipeline (Deploy to Hugging Face)
├── App/
│   ├── drug_app.py         # Gradio application code
│   ├── requirements.txt    # Dependencies for the hosted app
│   └── README.md           # Hugging Face Space configuration
├── Data/
│   └── drug.csv            # Training dataset
├── Model/
│   └── drug_pipeline.skops # Trained model file (generated)
├── Results/
│   ├── metrics.txt         # Model performance stats
│   └── model_results.png   # Confusion Matrix image
├── Makefile                # Shortcuts for terminal commands
├── train.py                # Model training script
└── requirements.txt        # Development dependencies
````

-----

## ⚙️ Configuration Details

### 1\. Requirements (`requirements.txt`)

Crucially, we pin specific versions to ensure the model trained in CI matches the environment in deployment:

```text
scikit-learn==1.3.2
skops
gradio==6.0.1
...
```

### 2\. Hugging Face Deployment

The deployment requires specific secrets set in your GitHub Repository settings:

  * `HF_TOKEN`: Your Hugging Face Write Token.
  * `HF_USERNAME`: Your Hugging Face Username.

### 3\. Model Security

The app uses `skops` for secure persistence. In `App/drug_app.py`, we dynamically detect and trust the types required by the model:

```python
unknown_types = sio.get_untrusted_types(file="./Model/drug_pipeline.skops")
pipe = sio.load("./Model/drug_pipeline.skops", trusted=unknown_types)
```

-----

## 📈 Example Results

When the pipeline runs, it generates metrics like:

  * **Accuracy:** \~98%
  * **F1 Score:** \~0.98

And a Confusion Matrix to visualize predictions vs. actual values.

-----

## 🤝 Contributing

1.  Fork the repository.
2.  Create a feature branch (`git checkout -b feature/NewFeature`).
3.  Commit your changes.
4.  Push to the branch.
5.  Open a Pull Request (CML will generate a report on your PR\!).

