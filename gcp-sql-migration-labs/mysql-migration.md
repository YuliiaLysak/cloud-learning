1) Create cluster
```shell
gcloud container clusters create echo-cluster --machine-type=n1-standard-2 --num-nodes=2 --zone us-central1-a
gcloud container clusters get-credentials echo-cluster
```


mysql --host=localhost --user=blogadmin --password=Password1* wordpress

```shell
mysqldump --databases wordpress -h localhost -u blogadmin -p \
--hex-blob --skip-triggers --single-transaction \
--default-character-set=utf8mb4 > wordpress.sql


export PROJECT_ID=$(gcloud info --format='value(config.project)')
gsutil mb gs://${PROJECT_ID}
gsutil cp ~/wordpress.sql gs://${PROJECT_ID}


gsutil cp ~/database_name.sql gs://[bucket-name]

```