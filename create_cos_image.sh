#!/bin/bash

# with this image, you are replicated a dataflow worker setup (sort of)
# it allows you to pull your container, run it, and attach to debug any driver issues

PROJECT_ID=$(gcloud config get-value project)
VM_NAME=cos-dataflow-vm


gcloud compute instances create $VM_NAME \
   --project $PROJECT_ID \
   --zone us-central1-b \
   --machine-type n1-standard-4 \
   --accelerator type=nvidia-tesla-t4,count=1 \
   --maintenance-policy TERMINATE --restart-on-failure \
   --image-family cos-85-lts \
   --image-project cos-cloud \
   --boot-disk-size 200GB \
   --metadata-from-file user-data=./cloud-init.yaml
