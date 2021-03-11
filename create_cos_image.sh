#!/bin/bash

# with this image, you are replicated a dataflow worker setup (sort of)
# it allows you to pull your container, run it, and attach to debug any driver issues

PROJECT_ID=$(gcloud config get-value project)

cat <<'EOF' > cloud-init.yaml
#cloud-config

write_files:
  - path: /etc/systemd/system/cos-gpu-installer.service
    permissions: 0755
    owner: root
    content: |
      [Unit]
      Description=Run the GPU driver installer container
      Requires=network-online.target gcr-online.target
      After=network-online.target gcr-online.target

      [Service]
      User=root
      Type=oneshot
      RemainAfterExit=true
      Environment=INSTALL_DIR=/var/lib/nvidia
      ExecStartPre=/bin/mkdir -p ${INSTALL_DIR}
      ExecStartPre=/bin/mount --bind ${INSTALL_DIR} ${INSTALL_DIR}
      ExecStartPre=/bin/mount -o remount,exec ${INSTALL_DIR}
      ExecStart=/usr/bin/docker run --privileged \
                                    --net=host  \
                                    --pid=host \
                                    --volume ${INSTALL_DIR}:/usr/local/nvidia \
                                    --volume /dev:/dev \
                                    --volume /:/root \
                                    --env NVIDIA_DRIVER_VERSION=450.80.02 \
                                    gcr.io/cos-cloud/cos-gpu-installer:v20200701
      StandardOutput=journal+console
      StandardError=journal+console

runcmd:
  - systemctl daemon-reload
  - systemctl enable cos-gpu-installer.service
  - systemctl start cos-gpu-installer.service

EOF


gcloud compute instances create VM_NAME \
   --project $PROJECT_ID \
   --zone us-central1-a \
   --machine-type a2-highgpu-1g \
   --maintenance-policy TERMINATE --restart-on-failure \
   --image-family cos-85-lts \
   --image-project cos-cloud \
   --boot-disk-size 200GB \
   --metadata-from-file user-data=/tmp/cloud-init.yaml