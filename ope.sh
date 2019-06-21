#!/bin/env bash



dir="./tf/ec2/"

case $1 in
	restart) 
		(cd $dir && terraform destroy -auto-approve && terraform apply -auto-approve && terraform output -json ips | jq -r 'to_entries[]| select(.key|contains("amz")) .user|="ec2-user" | select(.key|contains("cent")) .user|="centos" | select(.key|contains("ubuntu")) .user|="ubuntu" | .key[8:]+" ansible_host="+.value+" ansible_user=" + .user' > ../../inventory)
		;;
	rm | stop)
		(cd $dir && terraform destroy -auto-approve )
		;;
	start )
		(cd $dir && terraform apply -auto-approve && terraform output -json ips | jq -r 'to_entries[]| select(.key|contains("amz")) .user|="ec2-user" | select(.key|contains("cent")) .user|="centos" | select(.key|contains("ubuntu")) .user|="ubuntu" | .key[8:]+" ansible_host="+.value+" ansible_user=" + .user' > ../../inventory)
		;;
	list)
		(cd $dir && terraform state list)
		;;
	init)
		(cd $dir && terraform init && terraform workspace new amitest)
		;;
	chk)
		(ansible -i inventory all -m ping)
		;;
esac
