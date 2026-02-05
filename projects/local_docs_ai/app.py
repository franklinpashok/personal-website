import streamlit as st
import tempfile
import os
import pandas as pd
import uuid

# --- IMPORTS ---
from langchain_community.document_loaders import PyPDFLoader, Docx2txtLoader
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_community.vectorstores import Chroma
from langchain_ollama import OllamaEmbeddings, ChatOllama
from langchain_classic.chains import RetrievalQA
from langchain_core.documents import Document

# --- CONFIGURATION ---
#MODEL_NAME = "llama3"
MODEL_NAME = "mistral-nemo"
#MODEL_NAME = "gemma2:27b"
EMBEDDING_MODEL = "nomic-embed-text"

st.set_page_config(page_title="Private Doc Analyst", page_icon="🕵️‍♂️", layout="wide")

st.title("🔒 Private Local Document Analyst")
st.markdown(f"**Model in use:** `{MODEL_NAME}`")

# --- SESSION STATE INITIALIZATION (Memory) ---
if "messages" not in st.session_state:
    st.session_state.messages = []

if "processing_chain" not in st.session_state:
    st.session_state.processing_chain = None

# --- SIDEBAR ---
with st.sidebar:
    st.header("Upload Documents")
    # ENABLE MULTIPLE FILES
    uploaded_files = st.file_uploader(
        "Choose files", 
        type=["pdf", "docx", "xlsx"], 
        accept_multiple_files=True
    )
    process_btn = st.button("Analyze Documents")

# --- MAIN PROCESSING LOGIC ---
if uploaded_files and process_btn:
    st.session_state.messages = [] # Reset chat on new upload
    st.session_state.processing_chain = None
    
    with st.spinner("Ingesting documents... this may take a while depending on size."):
        all_docs = []
        
        # Loop through all uploaded files
        for uploaded_file in uploaded_files:
            file_ext = uploaded_file.name.split(".")[-1].lower()
            
            # Save to temp file
            with tempfile.NamedTemporaryFile(delete=False, suffix=f".{file_ext}") as tmp_file:
                tmp_file.write(uploaded_file.getvalue())
                tmp_path = tmp_file.name
            
            try:
                if file_ext == "pdf":
                    loader = PyPDFLoader(tmp_path)
                    all_docs.extend(loader.load())
                elif file_ext == "docx":
                    loader = Docx2txtLoader(tmp_path)
                    all_docs.extend(loader.load())
                elif file_ext == "xlsx":
                    df = pd.read_excel(tmp_path)
                    text_data = df.to_string(index=False)
                    all_docs.append(Document(page_content=text_data, metadata={"source": uploaded_file.name}))
            except Exception as e:
                st.error(f"Error loading {uploaded_file.name}: {e}")
            finally:
                os.remove(tmp_path) # Clean up temp file

        if all_docs:
            # Split Text
            text_splitter = RecursiveCharacterTextSplitter(chunk_size=1500, chunk_overlap=300)
            splits = text_splitter.split_documents(all_docs)

            # Create Vector Store (IN MEMORY - No persist_directory)
            embeddings = OllamaEmbeddings(model=EMBEDDING_MODEL)
            vectorstore = Chroma.from_documents(
                documents=splits, 
                embedding=embeddings,
                collection_name=f"collection_{uuid.uuid4()}"
            )

            # Setup Chain
            llm = ChatOllama(model=MODEL_NAME)
            retrieval_chain = RetrievalQA.from_chain_type(
                llm,
                retriever=vectorstore.as_retriever(),
                chain_type="stuff"
            )
            
            st.session_state.processing_chain = retrieval_chain
            st.success(f"Processed {len(uploaded_files)} files ({len(splits)} chunks)! Ready to chat.")
        else:
            st.error("No valid text could be extracted from the files.")

# --- CHAT INTERFACE (With History) ---
if st.session_state.processing_chain:
    st.divider()

    # 1. Display existing chat history
    for message in st.session_state.messages:
        with st.chat_message(message["role"]):
            st.markdown(message["content"])

    # 2. Handle new user input
    if user_question := st.chat_input("Ask a question about your documents..."):
        # Display user message immediately
        with st.chat_message("user"):
            st.markdown(user_question)
        # Save to history
        st.session_state.messages.append({"role": "user", "content": user_question})

        # Generate response
        with st.chat_message("assistant"):
            with st.spinner("Thinking..."):
                response = st.session_state.processing_chain.invoke({"query": user_question})
                answer = response['result']
                st.markdown(answer)
        
        # Save assistant response to history
        st.session_state.messages.append({"role": "assistant", "content": answer})