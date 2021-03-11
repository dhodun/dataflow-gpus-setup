FROM gcr.io/deeplearning-platform-release/pytorch-gpu

RUN pip install --no-cache-dir \
    albumentations \
    rasterio \
    earthengine-api \
    google_apitools \
    apache-beam[gcp]==2.28.0 

# # Copy the Apache Beam worker dependencies from the Beam Python 3.8 SDK image.
COPY --from=apache/beam_python3.6_sdk:2.28.0 /opt/apache/beam /opt/apache/beam

# A volume with GPU drivers will be mounted at runtime at /usr/local/nvidia.
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/nvidia/lib64:/usr/local/cuda/lib64

# Beam SDK worker looks for pip at a different location by default
RUN ln -s $(which pip) /usr/local/bin/pip

# Set the entrypoint to Apache Beam SDK worker launcher.
ENTRYPOINT [ "/opt/apache/beam/boot" ]