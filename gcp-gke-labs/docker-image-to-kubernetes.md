0) (optional) gcloud config set compute/zone us-central1-a


1) Create cluster
```shell
gcloud container clusters create echo-cluster --machine-type=n1-standard-2 --num-nodes=2 --zone us-central1-a
gcloud container clusters get-credentials echo-cluster
```

2) Copy and unzip archive from GCS to current directory in Cloud Shell
```shell
gsutil cp gs://${BUCKET_NAME}/echo-web.tar.gz .
tar -xf echo-web.tar.gz
```

3) Build Docker image with Cloud Build and push tagged image (v1) to Container Registry
   _Note: Don't miss the dot (".") at the end of the command. The dot specifies that the source code is in the current working directory at build time._
```shell
gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/echo-app:v1 .
```


4) Update files from lab (migrate .yaml manifests - https://kubernetes.io/docs/reference/using-api/deprecation-guide)
Change image link in echoweb-deployment.yaml
Change 8080 port in Dockerfile to 8000


5) Reserve static IP and paste it in `echoweb-service-static-ip.yaml` into loadBalancerIP: "YOUR.IP.ADDRESS.HERE"
```shell
gcloud compute addresses create echoweb-ip --region us-central1
gcloud compute addresses describe echoweb-ip --region us-central1
```

6) Deploy to kubernetes
```shell
kubectl apply -f ./manifests/echoweb-deployment.yaml && \
kubectl apply -f ./manifests/echoweb-ingress-static-ip.yaml && \
kubectl apply -f ./manifests/echoweb-service-static-ip.yaml
```
