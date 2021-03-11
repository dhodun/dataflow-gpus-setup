# dataflow-gpus-setup

## Create Dataflow Worker Image

```bash
cd pytorch-dl-container
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

docker run --rm \
  -it \
  --entrypoint=/bin/bash \
  --volume /var/lib/nvidia/lib64:/usr/local/nvidia/lib64 \
  --volume /var/lib/nvidia/bin:/usr/local/nvidia/bin \
  --privileged \
  gcr.io/$PROJECT_ID/dataflow-gpu-pytorch:latest
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

## Run Pipeline

Create venv

```bash
python3 -m venv .env
source .env/bin/activate

pip3 install -r pipeline/requirements.txt
```

Run pipeline:

```bash
cd pipeline
bash run.sh
```