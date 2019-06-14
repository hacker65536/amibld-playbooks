# amibld-role




| platform | status |
|--------------|--------|
| amibld-codebuild-amazonlinux2 | ![]()
| amibld-codebuild-amazonlinux | ![]()
| amibld-codebuild-centos6 | ![]()
| amibld-codebuild-centos7 | ![]()
| amibld-codebuild-ubuntu18 | ![]()





## testing 

```console
$ touch ansible_log
```
```console
$ cat <<'EOF' > ansible.cfg
[defaults]
remote_user=centos
host_key_checking = False
log_path=ansible_log
EOF
```
```console
$ cat <<'EOF' > hosts
[amz2]
172.31.24.xxx
EOF
```

```console
cat <<'EOF' > test.yml
- hosts: srv
  become: yes
  roles:
#    - { role: '{{ platform }}/epel' }
    - httpd
EOF
```

```console
$ ansible-playbook -i hosts test.yml --extra-vars platform=amazonlinux2
```
