# 🔒 Local Secure Document Analyst

A **private, fully local Retrieval-Augmented Generation (RAG)** application that lets you chat with your own documents (PDF, DOCX, Excel) **without sending any data to the cloud**.

Built with **Python**, **Streamlit**, **LangChain**, and **Ollama**, this tool runs entirely on your machine, making it ideal for handling **sensitive or confidential data** (financial records, IDs, contracts, medical files, etc.).

---

## 🚀 Features

* **100% Offline & Private**
  No API keys. No external calls. All processing happens on `localhost`.

* **Multi-Format Document Support**
  Upload and analyze:

  * PDFs
  * Word documents (`.docx`)
  * Excel spreadsheets (`.xlsx`)

* **RAG Architecture**

  * Local vector storage using **ChromaDB**
  * Reasoning powered by **Llama 3** (via Ollama)

* **Interactive Chat UI**
  Clean, minimal chat interface built with **Streamlit**.

* **Hardware Aware**
  Works on laptops and scales up to powerful workstations (Apple Silicon, RTX GPUs).

---

## �️ Tech Stack

* **LLM Runtime:** [Ollama](https://ollama.com/)
  (Llama 3, Mistral, Gemma, Phi, DeepSeek, etc.)
* **Framework:** LangChain (v0.2+)
* **UI:** Streamlit
* **Vector Database:** ChromaDB (local persistence)
* **Embeddings:** `nomic-embed-text`

---

## ⚡ Quick Start Guide

### 1️⃣ Prerequisites

* **Python 3.8+** installed
* **Ollama** installed and running

  * Download: [https://ollama.com/download](https://ollama.com/download)

Verify Ollama:

```bash
ollama --version
```

---

### 2️⃣ Installation (Python)

Navigate to the project folder and create a virtual environment:

```bash
# 1. Create virtual environment
python3 -m venv venv

# 2. Activate it
# Linux / macOS / WSL
source venv/bin/activate

# Windows (PowerShell)
# .\venv\Scripts\Activate

# 3. Install dependencies
pip install -r requirements.txt
```

---

### 3️⃣ Setup the AI Models (Ollama)

Open a terminal and download the **Brain** (LLM) and the **Eyes** (Embeddings).
These are **one-time downloads**.

```bash
# 1. Download the reasoning model (The Brain)
# Default choice: good balance of speed + intelligence
ollama pull llama3

# 2. Download the embedding model (The Eyes)
# Converts text into vectors for semantic search
ollama pull nomic-embed-text
```

---

### 4️⃣ Run the Application

With the virtual environment active:

```bash
streamlit run app.py
```

The app will automatically open in your browser:

👉 **[http://localhost:8501](http://localhost:8501)**

---

## 🧪 Test Files Generator

### Purpose

The `generate_test_files.py` script creates sample documents for testing and development purposes. This allows you to quickly generate realistic test data without needing to provide your own documents.

### Generated Test Files

The script generates two test documents:

1. **cloud_budget_2026.xlsx** - An Excel spreadsheet containing a cloud service budget with the following columns:
   - Service (AWS EKS Cluster, RDS, NAT Gateway, CloudFront, Lambda)
   - Region (deployment regions)
   - Monthly Cost (in USD)
   - Status (Active/Deprecated)
   - Owner (responsible team)

2. **incident_report_feb_2026.docx** - A Word document containing a security incident report with:
   - Executive summary
   - Impact analysis
   - Required actions for remediation

These documents can be uploaded to the RAG application for testing document parsing and Q&A capabilities.

---

### 📦 Installation (Additional Dependencies)

To run the test files generator, install the required packages:

```bash
pip install openpyxl python-docx
```

**Package Details:**
- **openpyxl** - Required to generate Excel files (.xlsx)
- **python-docx** - Required to generate Word documents (.docx)

Add these to your virtual environment as shown in the [Installation section](#-installation-python).

---

### 🚀 Running the Test Generator

With your virtual environment activated:

```bash
python generate_test_files.py
```

**Output:**
- Generates `cloud_budget_2026.xlsx` in the project root
- Generates `incident_report_feb_2026.docx` in the project root
- Console output confirms file creation: `✅ Excel file created.` and `✅ Word document created.`

You can then upload these generated files directly into the application UI to test RAG functionality with different document types.

---

## 🧠 Model Selection & Hardware Guide

This project is **model-agnostic**. You can switch models in `app.py` using the `MODEL_NAME` variable based on your hardware.

---

### 💻 Laptops (8 GB – 32 GB RAM)

Recommended for **Lenovo P53, Dell XPS, MacBook Air/Pro (M1 / M2 / M3)**.

| Model            | Params | RAM / VRAM | Why Use It                                                       | Command              |
| ---------------- | ------ | ---------- | ---------------------------------------------------------------- | -------------------- |
| **Llama 3 (8B)** | 8B     | 8 GB+      | Best all-rounder. Balanced speed & reasoning. **Default choice** | `ollama run llama3`  |
| **Mistral (7B)** | 7B     | 8 GB+      | Very fast, concise answers. Great for summaries                  | `ollama run mistral` |
| **Gemma 2 (9B)** | 9B     | 12 GB+     | Strong reasoning from Google                                     | `ollama run gemma2`  |
| **Phi-3 (3.8B)** | 3.8B   | 4 GB+      | Low-resource fallback if others feel slow                        | `ollama run phi3`    |

---

### 🖥️ High-End Workstations

For machines with **48 GB+ RAM**, **Apple Mac Studio**, or **24 GB+ GPU VRAM (RTX 4090)**.

| Model                 | Size   | RAM Needed | Why Use It                                                   | Command                      |
| --------------------- | ------ | ---------- | ------------------------------------------------------------ | ---------------------------- |
| **Llama 3.3 (70B)**   | ~40 GB | 48 GB+     | GPT-4–class intelligence. Excellent for legal & medical docs | `ollama run llama3.3`        |
| **DeepSeek R1 (70B)** | ~40 GB | 48 GB+     | Reasoning specialist. Thinks step-by-step                    | `ollama run deepseek-r1:70b` |
| **Command R**         | ~20 GB | 32 GB+     | RAG-optimized. Designed for document Q&A                     | `ollama run command-r`       |

---

## 📊 Summary Comparison (Hardware-Oriented)

| Model | Size (RAM) | Speed | Intelligence | Best For |
|------|-----------|-------|--------------|----------|
| **Llama 3 (8B)** | 4.7 GB | Fast | Low / Medium | Quick summaries, simple chat |
| **Mistral Nemo (12B)** | 7 GB | Fast | Medium | Better reasoning than Llama 3 |
| **Qwen 2.5 (14B)** | 9 GB | Medium | High | Coding & technical documents |
| **Gemma 2 (27B)** | 16 GB | Slow | Very High | Deep analysis, logic, writing |
| **Command R (35B)** | 20 GB | Slow | Specialist | Strict document Q&A (RAG) |

---

## 📊 Real-World Benchmark (Test Case)

We tested multiple models on a **Spanish Social Security Document (Resolution of Affiliation)** to extract the "Addressee Name." The document contained complex layouts with multiple names (signers, authorities, and the user).

**Hardware:** Lenovo P53 (32GB RAM, Nvidia T1000 4GB VRAM)

| Model | Result | Analysis |
| :--- | :--- | :--- |
| **Llama 3 (8B)** | ❌ **FAILED** | **Hallucination.** It incorrectly identified the government authority signing the document ("CIGARRAN MAGAN...") as the addressee. |
| **Mistral-Nemo (12B)** | ✅ **PASSED** | **Accurate.** Correctly ignored the signer and identified the true addressee. |
| **Gemma 2 (27B)** | ✅ **PASSED** | **High Precision.** Slower inference, but provided detailed reasoning for *why* that person was the addressee. |

**Conclusion:** For this specific hardware setup, **Mistral-Nemo (12B)** offers the best balance of accuracy vs. speed.

---

## 🔐 Privacy & Security

* No cloud calls
* No telemetry
* No document uploads
* Vectors stored locally using ChromaDB

Your data **never leaves your machine**.

---

## ✅ Ideal Use Cases

* Financial statements & tax documents
* Legal contracts & agreements
* Medical reports
* Personal IDs & certificates
* Internal company documentation

---

## 📌 Notes

* Best performance when Ollama is already running
* First query may be slow while models warm up
* SSD storage recommended for faster vector search

---

**Local AI. Full control. Zero data leakage.** 🔒