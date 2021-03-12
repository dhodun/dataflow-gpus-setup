#!/bin/bash

PROJECT_ID=$(gcloud config get-value project)
BUCKET=$PROJECT_ID
REGION=us-central1

# make sure zone has your GPUs
WORKER_ZONE=us-central1-b

GPU_TYPE=nvidia-tesla-t4
GPU_COUNT=1

IMAGE=gcr.io/$PROJECT_ID/dataflow-gpu-pytorch

python3.8 pipeline.py \
  --runner "DataflowRunner" \
  --project "$PROJECT_ID" \
  --temp_location "gs://$BUCKET/tmp" \
  --region "$REGION" \
  --worker_zone "$WORKER_ZONE" \
  --worker_harness_container_image "$IMAGE" \
  --experiment "worker_accelerator=type:$GPU_TYPE;count:$GPU_COUNT;install-nvidia-driver" \
  --experiment "use_runner_v2"