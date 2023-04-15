Challenge lab

0) Optional
```shell
gcloud config set compute/zone us-central1-a
```

1) Cluster
```shell
gcloud container clusters create onlineboutique-cluster-132 --machine-type=n1-standard-2 --num-nodes=2 --zone us-central1-a
gcloud container clusters get-credentials onlineboutique-cluster-132
kubectl create namespace dev && kubectl create namespace prod
```

2) Node pool
```shell
gcloud container node-pools create optimized-pool-4606 \
  --cluster=onlineboutique-cluster-132 \
  --machine-type=custom-2-3584 \
  --num-nodes=2 \
  --zone=us-central1-a
```

2a) Cordon node pool
```shell
for node in $(kubectl get nodes -l cloud.google.com/gke-nodepool=default-pool -o=name); do
  kubectl cordon "$node";
done
```

2b) Drain node pool
```shell
for node in $(kubectl get nodes -l cloud.google.com/gke-nodepool=default-pool -o=name); do
  kubectl drain --force --ignore-daemonsets --delete-local-data --grace-period=10 "$node";
done
```

2c) Delete old node pool
```shell
gcloud container node-pools delete default-pool --cluster onlineboutique-cluster-132 --zone us-central1-a
```

3) Pod disruption budget
```shell
kubectl create poddisruptionbudget onlineboutique-frontend-pdb --namespace=dev --selector k8s-app=frontend --min-available 1
```

```shell
nano ./kubernetes-manifests/frontend.yaml
image: gcr.io/qwiklabs-resources/onlineboutique-frontend:v2.1
imagePullPolicy: Always
```

```shell
kubectl apply -f ./kubernetes-manifests/frontend.yaml --namespace=dev
```

4) HPA
```shell
kubectl autoscale deployment frontend --cpu-percent=50 --min=1 --max=11 --namespace=dev
kubectl autoscale deployment recommendationservice --cpu-percent=50 --min=1 --max=5 --namespace=dev
```

5) Cluster Autoscaler
```shell
gcloud beta container clusters update onlineboutique-cluster-132 --enable-autoscaling --min-nodes 1 --max-nodes 6 --zone=us-central1-a
```