1) 
```shell
gcloud iam roles create orca_storage_manager_400 \
--project $DEVSHELL_PROJECT_ID \
--title "orca storage manager" \
--description "Role with permissions required to be able to create and update storage objects" \
--permissions storage.buckets.get,storage.objects.get,storage.objects.list,storage.objects.update,storage.objects.create \
--stage ALPHA
```


2)
```shell
gcloud iam service-accounts create orca-private-cluster-551-sa --display-name "orca service account"
```

3)
```shell
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member serviceAccount:orca-private-cluster-551-sa@qwiklabs-gcp-00-6249d71dfc4b.iam.gserviceaccount.com \
    --role roles/monitoring.viewer
    
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member serviceAccount:orca-private-cluster-551-sa@qwiklabs-gcp-00-6249d71dfc4b.iam.gserviceaccount.com \
    --role roles/monitoring.metricWriter
    
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member serviceAccount:orca-private-cluster-551-sa@qwiklabs-gcp-00-6249d71dfc4b.iam.gserviceaccount.com \
    --role roles/logging.logWriter
    
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member serviceAccount:orca-private-cluster-551-sa@qwiklabs-gcp-00-6249d71dfc4b.iam.gserviceaccount.com \
    --role projects/qwiklabs-gcp-00-6249d71dfc4b/roles/orca_storage_manager_400
```

4)
```shell
gcloud beta container clusters create orca-cluster-488 \
    --enable-private-nodes \
    --enable-ip-alias \
    --enable-private-endpoint \
    --master-ipv4-cidr 172.16.0.32/28 \
    --network orca-build-vpc \
    --subnetwork orca-build-subnet \
    --service-account orca-private-cluster-551-sa@qwiklabs-gcp-00-6249d71dfc4b.iam.gserviceaccount.com \
    --zone us-east1-b

gcloud container clusters update orca-cluster-488 \
    --enable-master-authorized-networks \
    --zone us-east1-b \
    --master-authorized-networks 192.168.10.2/32
```

5)
```shell
sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
echo "export USE_GKE_GCLOUD_AUTH_PLUGIN=True" >> ~/.bashrc
source ~/.bashrc
gcloud container clusters get-credentials orca-cluster-488 --internal-ip --project=qwiklabs-gcp-00-6249d71dfc4b --zone us-east1-b
```



==================================================
```shell
gcloud compute firewall-rules create app-allow-http \
--direction INGRESS \
--priority 1000 \
--network my-internal-app \
--action ALLOW \
--rules tcp:80 \
--source-ranges 0.0.0.0/0 \
--target-tags lb-backend
gcloud compute firewall-rules create app-allow-health-check \
--direction INGRESS \
--priority 1000 \
--action ALLOW \
--rules tcp \
--source-ranges 130.211.0.0/22,35.191.0.0/16 \
--target-tags lb-backend
[LB_IP_v4]=35.241.59.223:80
[LB_IP_v6]=[2600:1901:0:2410::]:80
[SIEGE_IP]=35.193.239.205


sudo apt-get -y install siege
export LB_IP=35.241.59.223:80
siege -c 150 -t120s http://$LB_IP
```




=========================
```shell
gcloud compute firewall-rules create allow-ssh-ingress-from-iap \
--direction=INGRESS \
--action=allow \
--network=acme-vpc \
--rules=tcp:22 \
--target-tags=permit-ssh-iap-ingress-ql-635 \
--source-ranges=35.235.240.0/20

gcloud compute instances add-tags bastion --tags=permit-ssh-iap-ingress-ql-635

gcloud compute firewall-rules create allow-http \
--direction=INGRESS \
--priority=1000 \
--network=acme-vpc \
--action=ALLOW \
--rules=tcp:80 \
--source-ranges=0.0.0.0/0 \
--target-tags=permit-http-ingress-ql-344

gcloud compute instances add-tags juice-shop --tags=permit-http-ingress-ql-344

gcloud compute firewall-rules create allow-ssh-acme-mgmt-subnet \
--direction=INGRESS \
--action=allow \
--network=acme-vpc \
--rules=tcp:22 \
--target-tags=permit-ssh-internal-ingress-ql-538 \
--source-ranges=192.168.10.0/24

gcloud compute instances add-tags juice-shop --tags=permit-ssh-internal-ingress-ql-538

gcloud compute ssh juice-shop --zone=us-east1-b --troubleshoot
ssh
```




=======================
```shell
gcloud config set project qwiklabs-gcp-01-7e6f875fa38f
git clone https://github.com/GoogleCloudPlatform/gke-logging-sinks-demo
cd gke-logging-sinks-demo

gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-a
```


==========================
```shell
gcloud config set compute/zone us-east1-d
gcloud container clusters create spinnaker-tutorial \
    --machine-type=n1-standard-2
    
    
gcloud iam service-accounts create spinnaker-account \
    --display-name spinnaker-account
export SA_EMAIL=$(gcloud iam service-accounts list \
    --filter="displayName:spinnaker-account" \
    --format='value(email)')
export PROJECT=$(gcloud info --format='value(config.project)')
gcloud projects add-iam-policy-binding $PROJECT \
    --role roles/storage.admin \
    --member serviceAccount:$SA_EMAIL
gcloud iam service-accounts keys create spinnaker-sa.json \
     --iam-account $SA_EMAIL
     
     
gcloud pubsub topics create projects/$PROJECT/topics/gcr
gcloud pubsub subscriptions create gcr-triggers \
    --topic projects/${PROJECT}/topics/gcr
export SA_EMAIL=$(gcloud iam service-accounts list \
    --filter="displayName:spinnaker-account" \
    --format='value(email)')
gcloud beta pubsub subscriptions add-iam-policy-binding gcr-triggers \
    --role roles/pubsub.subscriber --member serviceAccount:$SA_EMAIL
    
    
kubectl create clusterrolebinding user-admin-binding \
    --clusterrole=cluster-admin --user=$(gcloud config get-value account)
kubectl create clusterrolebinding --clusterrole=cluster-admin \
    --serviceaccount=default:default spinnaker-admin
helm repo add stable https://charts.helm.sh/stable
helm repo update


export PROJECT=$(gcloud info \
    --format='value(config.project)')
export BUCKET=$PROJECT-spinnaker-config
gsutil mb -c regional -l us-east1 gs://$BUCKET
export SA_JSON=$(cat spinnaker-sa.json)
export PROJECT=$(gcloud info --format='value(config.project)')
export BUCKET=$PROJECT-spinnaker-config
cat > spinnaker-config.yaml <<EOF
gcs:
  enabled: true
  bucket: $BUCKET
  project: $PROJECT
  jsonKey: '$SA_JSON'
dockerRegistries:
- name: gcr
  address: https://gcr.io
  username: _json_key
  password: '$SA_JSON'
  email: 1234@5678.com
# Disable minio as the default storage backend
minio:
  enabled: false
# Configure Spinnaker to enable GCP services
halyard:
  spinnakerVersion: 1.19.4
  image:
    repository: us-docker.pkg.dev/spinnaker-community/docker/halyard
    tag: 1.32.0
    pullSecrets: []
  additionalScripts:
    create: true
    data:
      enable_gcs_artifacts.sh: |-
        \$HAL_COMMAND config artifact gcs account add gcs-$PROJECT --json-path /opt/gcs/key.json
        \$HAL_COMMAND config artifact gcs enable
      enable_pubsub_triggers.sh: |-
        \$HAL_COMMAND config pubsub google enable
        \$HAL_COMMAND config pubsub google subscription add gcr-triggers \
          --subscription-name gcr-triggers \
          --json-path /opt/gcs/key.json \
          --project $PROJECT \
          --message-format GCR
EOF



helm install -n default cd stable/spinnaker -f spinnaker-config.yaml \
           --version 2.0.0-rc9 --timeout 10m0s --wait
           
           
           
export DECK_POD=$(kubectl get pods --namespace default -l "cluster=spin-deck" \
    -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward --namespace default $DECK_POD 8080:9000 >> /dev/null &




gsutil -m cp -r gs://spls/gsp114/sample-app.tar .
mkdir sample-app
tar xvf sample-app.tar -C ./sample-app
cd sample-app
git config --global user.email "$(gcloud config get-value core/account)"
git config --global user.name "[USERNAME]"
git init
git add .
git commit -m "Initial commit"
gcloud source repos create sample-app
git config credential.helper gcloud.sh
export PROJECT=$(gcloud info --format='value(config.project)')
git remote add origin https://source.developers.google.com/p/$PROJECT/r/sample-app
git push origin master




export PROJECT=$(gcloud info --format='value(config.project)')
gsutil mb -l us-east1 gs://$PROJECT-kubernetes-manifests
gsutil versioning set on gs://$PROJECT-kubernetes-manifests
sed -i s/PROJECT/$PROJECT/g k8s/deployments/*
git commit -a -m "Set project ID"

git tag v1.0.0
git push --tags


curl -LO https://storage.googleapis.com/spinnaker-artifacts/spin/1.14.0/linux/amd64/spin
chmod +x spin
./spin application save --application-name sample \
                        --owner-email "$(gcloud config get-value core/account)" \
                        --cloud-providers kubernetes \
                        --gate-endpoint http://localhost:8080/gate
export PROJECT=$(gcloud info --format='value(config.project)')
sed s/PROJECT/$PROJECT/g spinnaker/pipeline-deploy.json > pipeline.json
./spin pipeline save --gate-endpoint http://localhost:8080/gate -f pipeline.json



sed -i 's/orange/blue/g' cmd/gke-info/common-service.go
git commit -a -m "Change color to blue"
git tag v1.0.1
git push --tags
```


=====================
```shell
sudo curl -O https://storage.googleapis.com/golang/go1.17.2.linux-amd64.tar.gz
sudo tar -xvf go1.17.2.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo mv go /usr/local
sudo apt-get update
sudo apt-get install git
export PATH=$PATH:/usr/local/go/bin
go get go.opencensus.io
go get contrib.go.opencensus.io/exporter/stackdriver
go mod init test3
go mod tidy
```