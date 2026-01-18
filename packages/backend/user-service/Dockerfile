FROM python:3.11-slim

WORKDIR /app

# RNF8: Install dependencies for bcrypt
RUN apt-get update && \
    apt-get install -y build-essential libffi-dev libssl-dev && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# RNF8: Run batch seeding + FastAPI
CMD ["sh", "-c", "python batch.py && python batch_agreement.py && uvicorn main:app --host 0.0.0.0 --port 8000"]
