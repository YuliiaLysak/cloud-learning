0) (optional) gcloud config set compute/zone us-central1-a


1) Passing a startup script that is stored in Cloud Storage to a new VM.
(for the value of the `--scope` flag, use `storage-ro` so the VM can access Cloud Storage)
```shell
gcloud compute instances create vm-with-startup-script \
  --zone=us-central1-a \
  --image-project=debian-cloud \
  --image-family=debian-10 \
  --tags=network-lb-tag \
  --scopes=storage-ro \
  --metadata=startup-script-url=gs://qwiklabs-gcp-03-69c6ebcffd68/install-web.sh
```

Alternative
```shell
gcloud compute instances create prd-eng-662 \
  --zone=us-central1-c \
  --image-project=debian-cloud \
  --image-family=debian-10 \
  --tags=network-lb-tag \
  --metadata=startup-script='#! /bin/bash
  apt update
  apt -y install apache2'
```

Allow http connection on port 80
```shell
gcloud compute instances add-tags prd-eng-662 --tags http-server
```





2) Create a firewall rule to allow external traffic to the VM instances:
```shell
gcloud compute firewall-rules create vm-firewall-network-lb \
  --target-tags network-lb-tag --allow tcp:80
```
