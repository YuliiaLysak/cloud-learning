0) (optional) gcloud config set compute/zone us-central1-a

**Create VPC network with custom subnet**
```
gcloud compute networks create securenetwork --subnet-mode=custom
```

**Create custom subnet in created VPC network**
```
gcloud compute networks subnets create securenetwork --network=securenetwork --region=us-central1 --range=192.168.1.0/24
```

**Create firewall rule exists that allows TCP port 3389 traffic (for RDP)**
```
gcloud compute firewall-rules create myfirewalls --network securenetwork --allow=tcp:3389 --target-tags=rdp
```

**Create VM that has a public ip-address to which the TCP port 3389 firewall rule applies**
```
gcloud compute instances create vm-bastionhost --zone=us-central1-a --machine-type=n1-standard-2 --subnet=securenetwork --network-tier=PREMIUM --maintenance-policy=MIGRATE --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --tags=rdp --image=windows-server-2016-dc-v20200211 --image-project=windows-cloud --boot-disk-size=50GB --boot-disk-type=pd-standard --boot-disk-device-name=vm-bastionhost --reservation-affinity=any
```

**Create VM that does not have a public ip-address**
```
gcloud compute instances create vm-securehost --zone=us-central1-a --machine-type=n1-standard-2 --subnet=securenetwork --no-address --maintenance-policy=MIGRATE --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --tags=rdp --image=windows-server-2016-dc-v20200211 --image-project=windows-cloud --boot-disk-size=50GB --boot-disk-type=pd-standard --boot-disk-device-name=vm-securehost --reservation-affinity=any
```

**Create a new user and reset the password for a VM (choose Y and copy the password)**
```
gcloud compute reset-windows-password vm-bastionhost --user app_admin --zone us-central1-a
gcloud compute reset-windows-password vm-securehost --user app_admin --zone us-central1-a
```

**The vm-securehost is running Microsoft IIS web server software**

For macOS - use Microsoft Remote Desktop (from App Store)

Go to Compute Engine > VM instances 

Click RDP on vm-bastionhost, fill username with app_admin and password with your copied vm-bastionhost's password

Click Search, search for Remote Desktop Connection and run it

Copy and paste the internal ip from vm-securehost, click Connect

Fill username with app_admin and password with your copied vm-securehost's password

Click Search, type Powershell, right click and Run as Administrator

Run: Install-WindowsFeature -name Web-Server -IncludeManagementTools