#!/bin/bash
SERVICE_NAME="hello-world"
REGION="us-central1"
PROJECT_ID=$(gcloud config get-value project)

echo "Deletando serviço Cloud Run: $SERVICE_NAME"
gcloud run services delete $SERVICE_NAME --platform=managed --region=$REGION --project=$PROJECT_ID -q
echo "Serviço deletado com sucesso!"
