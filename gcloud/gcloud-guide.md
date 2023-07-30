# App Engine
```shell
gcloud app deploy
gcloud app browse
```


# Cloud Storage
```shell
gsutil mb gs://<bucket-name>

gsutil cp gs://<bucket-name> .
```


# Config
```shell
gcloud config set project <project-name>
gcloud config set compute/zone <zone-name>
```


# IAM roles
create
```shell
gcloud iam roles create <role-name> --project $DEVSHELL_PROJECT_ID \
--title "Custom role title" --description "Custom role description." \
--permissions compute.instances.get,compute.instances.list --stage ALPHA
```

read
```shell
gcloud iam list-testable-permissions //cloudresourcemanager.googleapis.com/projects/$DEVSHELL_PROJECT_ID
gcloud iam list-grantable-roles //cloudresourcemanager.googleapis.com/projects/$DEVSHELL_PROJECT_ID
gcloud iam roles describe <role-name>
gcloud iam roles describe <role-name> --project $DEVSHELL_PROJECT_ID
gcloud iam roles list --project $DEVSHELL_PROJECT_ID
gcloud iam roles list
```

update
```shell
gcloud iam roles update <role-name> --project $DEVSHELL_PROJECT_ID \
--add-permissions storage.buckets.get,storage.buckets.list

gcloud iam roles update <role-name> --project $DEVSHELL_PROJECT_ID \
--stage DISABLED
```

delete
```shell
gcloud iam roles delete <role-name> --project $DEVSHELL_PROJECT_ID
gcloud iam roles undelete <role-name> --project $DEVSHELL_PROJECT_ID
```


# KMS
```shell
gcloud kms keyrings create <keyring-name> --location global

gcloud kms keys create <crypto-key-name> --location global \
      --keyring <keyring-name> \
      --purpose encryption
```


# Kubernetes
private
```shell
gcloud container clusters create <cluster-name> \
    --enable-private-nodes \
    --master-ipv4-cidr 172.16.0.16/28 \
    --enable-ip-alias \
    --create-subnetwork ""
    
gcloud container clusters create <cluster-name> \
    --enable-private-nodes \
    --enable-ip-alias \
    --master-ipv4-cidr 172.16.0.32/28 \
    --network <network-name> \
    --subnetwork <subnetwork-name> \
    --zone <zone-name>
    
gcloud container clusters update <cluster-name> \
    --enable-master-authorized-networks \
    --zone <zone-name> \
    --master-authorized-networks 34.170.110.64/32
```

Binary Authorization
```shell
gcloud beta container binauthz policy export > policy.yaml
gcloud beta container binauthz policy import policy.yaml

gcloud --project="${PROJECT_ID}" \
    beta container binauthz attestors create "${ATTESTOR}" \
    --attestation-authority-note="${NOTE_ID}" \
    --attestation-authority-note-project="${PROJECT_ID}"
    
gcloud --project="${PROJECT_ID}" \
    beta container binauthz attestors public-keys add \
    --attestor="${ATTESTOR}" \
    --pgp-public-key-file="${PGP_PUB_KEY}"
    
gcloud --project="${PROJECT_ID}" \
    beta container binauthz attestors list
    
    
gcloud beta container binauthz attestations create \
    --artifact-url="${IMAGE_PATH}@${IMAGE_DIGEST}" \
    --attestor="projects/${PROJECT_ID}/attestors/${ATTESTOR}" \
    --signature-file=${GENERATED_SIGNATURE} \
    --public-key-id="${PGP_FINGERPRINT}"

gcloud beta container binauthz attestations list \
    --attestor="projects/${PROJECT_ID}/attestors/${ATTESTOR}"
```

Container Registry (GCR)
```shell
gcloud container images list-tags "gcr.io/${PROJECT_ID}/nginx"
```


# Managed instance group
```shell
gcloud compute instance-templates create <instance-template-name> \
--machine-type=n1-standard-1 \
--network-interface=network-tier=PREMIUM,subnet=<subnetwork-name> \
--metadata=startup-script-url=gs://cloud-training/gcpnet/ilb/startup.sh,enable-oslogin=true \
--maintenance-policy=MIGRATE \
--provisioning-model=STANDARD \
--service-account=546134550913-compute@developer.gserviceaccount.com \
--scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
--region=<region-name> \
--tags=lb-backend \
--create-disk=auto-delete=yes,boot=yes,device-name=instance-template-1,image=projects/debian-cloud/global/images/debian-11-bullseye-v20230411,mode=rw,size=10,type=pd-balanced \
--no-shielded-secure-boot \
--shielded-vtpm \
--shielded-integrity-monitoring \
--reservation-affinity=any
```


# Service account
```shell
gcloud iam service-accounts create <sa-name> --display-name "my service account"

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member serviceAccount:<sa-email> --role roles/editor
```


# VM
create
```shell
gcloud compute instances create <vm-name> \
--zone us-central1-f \
--machine-type=f1-micro \
--network <network-name> \
--subnet <subnetwork-name> \
--tags tag1,tag2
```

read
```shell
gcloud compute instances list --sort-by=ZONE
```


# VPC network, subnetwork, firewall rules
create
```shell
gcloud compute networks create <network-name> --subnet-mode=custom
gcloud compute networks subnets create <subnetwork-name> --network=<network-name> --region=<region-name> --range=172.16.0.0/24
gcloud compute firewall-rules create <firewall-rull-name> \
--direction=INGRESS \
--priority=1000 \
--network=<network-name> \
--action=ALLOW \
--rules=icmp,tcp:22,tcp:3389 \
--source-ranges=0.0.0.0/0

gcloud compute firewall-rules create <firewall-rull-name> \
--direction=INGRESS \
--priority=1000 \
--network=<network-name> \
--action=ALLOW \
--rules=tcp:80 \
--source-ranges=0.0.0.0/0 \
--target-tags=http-server
```

read
```shell
gcloud compute networks list
gcloud compute networks subnets list --sort-by=NETWORK
gcloud compute firewall-rules list --sort-by=NETWORK
gcloud compute firewall-rules list
```

delete
```shell
gcloud compute firewall-rules delete <firewall-rull-name>
gcloud compute networks delete <network-name>
```


# VPN
create
```shell
gcloud compute target-vpn-gateways create on-prem-gw1 --network on-prem --region us-central1
gcloud compute target-vpn-gateways create cloud-gw1 --network cloud --region us-east1

gcloud compute addresses create cloud-gw1 --region us-east1
gcloud compute addresses create on-prem-gw1 --region us-central1

cloud_gw1_ip=$(gcloud compute addresses describe cloud-gw1 \
    --region us-east1 --format='value(address)')
on_prem_gw_ip=$(gcloud compute addresses describe on-prem-gw1 \
    --region us-central1 --format='value(address)')
    
gcloud compute forwarding-rules create cloud-1-fr-esp --ip-protocol ESP \
    --address $cloud_gw1_ip --target-vpn-gateway cloud-gw1 --region us-east1
gcloud compute forwarding-rules create cloud-1-fr-udp500 --ip-protocol UDP \
    --ports 500 --address $cloud_gw1_ip --target-vpn-gateway cloud-gw1 --region us-east1
gcloud compute forwarding-rules create cloud-fr-1-udp4500 --ip-protocol UDP \
    --ports 4500 --address $cloud_gw1_ip --target-vpn-gateway cloud-gw1 --region us-east1
    
gcloud compute forwarding-rules create on-prem-fr-esp --ip-protocol ESP \
    --address $on_prem_gw_ip --target-vpn-gateway on-prem-gw1 --region us-central1
gcloud compute forwarding-rules create on-prem-fr-udp500 --ip-protocol UDP --ports 500 \
    --address $on_prem_gw_ip --target-vpn-gateway on-prem-gw1 --region us-central1
gcloud compute forwarding-rules create on-prem-fr-udp4500 --ip-protocol UDP --ports 4500 \
    --address $on_prem_gw_ip --target-vpn-gateway on-prem-gw1 --region us-central1
    
gcloud compute vpn-tunnels create on-prem-tunnel1 --peer-address $cloud_gw1_ip \
    --target-vpn-gateway on-prem-gw1 --ike-version 2 --local-traffic-selector 0.0.0.0/0 \
    --remote-traffic-selector 0.0.0.0/0 --shared-secret="sharedsecret" --region us-central1
gcloud compute vpn-tunnels create cloud-tunnel1 --peer-address $on_prem_gw_ip \
    --target-vpn-gateway cloud-gw1 --ike-version 2 --local-traffic-selector 0.0.0.0/0 \
    --remote-traffic-selector 0.0.0.0/0 --shared-secret="sharedsecret" --region us-east1
    
gcloud compute routes create on-prem-route1 --destination-range 10.0.1.0/24 \
    --network on-prem --next-hop-vpn-tunnel on-prem-tunnel1 \
    --next-hop-vpn-tunnel-region us-central1
gcloud compute routes create cloud-route1 --destination-range 192.168.1.0/24 \
    --network cloud --next-hop-vpn-tunnel cloud-tunnel1 \
    --next-hop-vpn-tunnel-region us-east1
```

delete
```shell
gcloud compute vpn-tunnels delete <tunnel-name> --region <region-name>
```
