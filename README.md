# dataflow-gpus-setup

## Create Dataflow Worker Image (Based on Deep Learning)

```bash
cd pytorch-dl-container
bash build_and_push.sh
```

## Create Dataflow Worker Image (Based on Pytorch Image)

```bash
cd pytorch-container
bash build_and_push.sh
```

## Create COS Testing Image

```bash
cd ..
bash create_cos_image.sh
```

ssh to the new image. Run your container.

```bash
PROJECT_ID=<YOUR_PROJECT_ID>

# authenticate to gcr
docker-credential-gcr configure-docker

IMAGE=gcr.io/$PROJECT_ID/dataflow-gpu-pytorch:latest
IMAGE=pytorch/pytorch:1.7.1-cuda11.0-cudnn8-runtime

docker run --rm \
  -it \
  --entrypoint=/bin/bash \
  --volume /var/lib/nvidia/lib64:/usr/local/nvidia/lib64 \
  --volume /var/lib/nvidia/bin:/usr/local/nvidia/bin \
  --privileged \
  $IMAGE
```

On the container check to see if nvidia works:

```bash
nvidia-smi
```

You can also run pytorch and see if it can access the GPUs:
```bash
python3
```

In the REPL:
```python
import torch
torch.cuda.is_available()
```

Note python version

```bash
python --version
```

## Run Pipeline - DL Image

Create venv

```bash
python3.7 -m venv .env
source .env/bin/activate

pip3 install -r pipeline/requirements.txt
```

Run pipeline:

```bash
cd pipeline
bash run_pytorch_dl.sh
```

## Run Pipeline - Pytorch Image

Create venv
NOTE: Python 3.8 to align to Pytorch Image
Needed in Dockerfile and in pipeline creation.

```bash
python3.8 -m venv .env
source .env/bin/activate

pip3 install -r pipeline/requirements.txt
```

Run pipeline:

```bash
cd pipeline
bash run_pytorch.sh
```