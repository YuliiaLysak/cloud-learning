# Deploy Spring Boot app and Postgres on Kubernetes:
1. Deploy postgres
   ```
   kubectl create -f kubernetes-manifests/postgres.yml
   ```

2. Create a config map with the hostname of Postgres
   ```
   kubectl create configmap hostname-config --from-literal=postgres_host=$(kubectl get svc postgres-instance -o jsonpath="{.spec.clusterIP}")
   ```

3. Build jar and docker image

   ```
   mvn clean package docker:build
   ```

4. Deploy the app
   ```
   kubectl create -f kubernetes-manifests/sportApp.yml
   ```

## Deleting the Resources
1. Delete the Spring Boot app deployment
   ```
   kubectl delete -f kubernetes-manifests/sportApp.yml
   ```

2. Delete the hostname config map
   ```
   kubectl delete cm hostname-config
   ```

3. Delete Postgres
   ```
   kubectl delete -f kubernetes-manifests/postgres.yml
   ```



# Kubernetes info:

### Check version
```
kubectl version
```

### Check contexts
```
kubectl config get-contexts
```

### Check config/cluster info
```
kubectl config view
kubectl cluster-info
```


### DEPLOYMENT, SERVICE, NODE
#### Check nodes
```
kubectl get nodes
```

#### Create deployment/service (first build docker image)
```
kubectl create -f kubernetes-manifests/sportApp-deployment.yml
kubectl create -f kubernetes-manifests/sportApp-service.yml
```
or
```
kubectl apply -f kubernetes-manifests/sportApp-deployment.yml
kubectl apply -f kubernetes-manifests/sportApp-service.yml
```

or standalone manifest:
```
kubectl create -f kubernetes-manifests/sportApp.yml
```

#### Get info about deployments/services/pods/configMaps
```
kubectl get deployment
kubectl get svc
kubectl get pods
kubectl get cm
```
```
kubectl get svc,deployment,pods,cm
```

#### Get info about pods and other resources
```
kubectl describe pods
kubectl describe pods <pod-name>
kubectl describe cm
kubectl describe cm <config-map-name>
```

#### Get info about pods logs
```
kubectl logs <pod name>
```

#### Delete deployment/service/configMap etc
```
kubectl delete deployment <deployment name>
kubectl delete svc <service name>
kubectl delete cm <configMap name>
```

or using file name

```
kubectl delete -f kubernetes-manifests/sportApp-deployment.yml
kubectl delete -f kubernetes-manifests/sportApp-service.yml
```
```
kubectl delete -f kubernetes-manifests/sportApp.yml
```


### NAMESPACE
#### Create namespace
```
kubectl create ns <namespace-name>
```
#### Delete namespace
```
kubectl delete ns <namespace-name>
```
#### Get all namespaces
```
kubectl get ns
```


### CONFIG MAP
#### Get all config maps
```
kubectl get cm
```
#### Get info about specific config map
```
kubectl describe cm <configmap-name>
```

### SECRETS
#### Get all secrets
```
kubectl get secrets
```
#### Get info about specific secret
```
kubectl describe secret <secret-name>
```