# testing env



```console
$ vim env.auto.tfvars
```
```ini
author  = "myname"
region  = "us-east-1"
profile = "<AWS_DEFAULT_PROFILE>"
vpc     = "vpc-xxxxxxxx"
```


```console
$ terraform plan
$ terraform apply
```


```console
$ terraform output -json ips | jq -r 'to_entries[]| select(.key|contains("amz")) .user|="ec2-user" | select(.key|contains("cent")) .user|="centos" | select(.key|contains("ubuntu")) .user|="ubuntu" | "[\(.key)]",.key[8:]+" ansible_host="+.value+" ansible_user=" + .user'
```
