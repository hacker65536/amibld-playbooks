# amibld-role




| platform | status |
|--------------|--------|
| amibld-codebuild-amazonlinux2 | ![]()
| amibld-codebuild-amazonlinux | ![]()
| amibld-codebuild-centos6 | ![]()
| amibld-codebuild-centos7 | ![]()
| amibld-codebuild-ubuntu18 | ![]()


| facts / OS                         | amazonlinux2 | centos7 | amazonlinux | centos6 | ubuntu18 |
|------------------------------------|--------------|---------|-------------|---------|----------|
| ansible_distribution               | Amazon       | CentOS  | Amazon      | CentOS  | Ubuntu   |
| ansible_distribution_major_version | 2            | 7       | NA          | 6       | 18       |
| ansible_service_mgr                | systemd      | systemd | upstart     | upstart | systemd  |
| ansible_os_family                  | RedHat       | RedHat  | RedHat      | RedHat  | Debian   |


## testing 

create key
```console
$ ssh-keygen -t rsa -N "" -C "" -f key_pair
```

enable log
```console
$ touch ansible_log
```

edit ansible.cfg
```console
$ cat <<'EOF' > ansible.cfg
[defaults]
remote_user=centos
host_key_checking = False
log_path=ansible_log
private_key_file=key_pair
EOF
```

edit variables for terraform to create testing env
```console
$ cat <<'EOF' > env.auto.tfvars
author  = "myname"
region  = "us-east-1"
profile = "<AWS_DEFAULT_PROFILE>"
vpc     = "vpc-xxxxxxxx"
EOF
```


deploy env with terraform
```console
$ sh ope.sh init (only first)
$ sh ope.sh start
```

check connection to host
```console
$ ansible -i inventory all -m ping
```

testing ansible codes
```console
$ cat <<'EOF' > test.yml
- hosts: all
  become: yes
  roles:
    - httpd
EOF
```

```console
$ ansible-playbook -i inventory test.yml 



individual host
```
testing ansible codes
```console
$ cat <<'EOF' > test.yml
- hosts: amz2
  become: yes
  roles:
#    - { role: '{{ platform }}/epel' }
    - httpd
EOF
```

```console
$ ansible-playbook -i inventory test.yml --extra-vars platform=amazonlinux2
```
