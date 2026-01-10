"""
Backup Service: dumps DB → uploads to S3 (RNF18 simulated in QA).
In PROD: add SFTP to on-premise server.
"""
from fastapi import FastAPI
import os
import subprocess
import boto3
from datetime import datetime

app = FastAPI(title="Backup Service")

S3_BUCKET = os.getenv("AWS_S3_BUCKET", "academic-linkage-backups-dev")
s3 = boto3.client("s3")

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/backup")
def create_backup():
    fname = f"backup_{datetime.now():%Y%m%d}.sql.gz"
    local_path = f"/tmp/{fname}"
    cmd = f"PGPASSWORD=securepass123 pg_dump -h db -U admin academic_linkage | gzip > {local_path}"
    subprocess.run(cmd, shell=True, check=True)
    s3.upload_file(local_path, S3_BUCKET, fname)
    return {"backup": fname, "uploaded_to": f"s3://{S3_BUCKET}/{fname}"}