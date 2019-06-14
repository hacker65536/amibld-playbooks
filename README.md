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

```console
$ touch ansible_log
```
```console
$ cp /path/key_pair .
```
```console
$ cat <<'EOF' > ansible.cfg
[defaults]
remote_user=centos
host_key_checking = False
log_path=ansible_log
private_key_file=keypair
EOF
```
```console
$ cat <<'EOF' > hosts
[amz2]
172.31.24.xxx ansible_user=ec2-user
EOF
```

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
$ ansible-playbook -i hosts test.yml --extra-vars platform=amazonlinux2
```
