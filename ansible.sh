tool_name=$1
os_type=$2

ssh_username=$(aws ssm get-parameter --name="ssh.username.${os_type}" --with-decryption --query 'Parameter.Value' --output text)
ssh_password=$(aws ssm get-parameter --name="ssh.password.${os_type}" --with-decryption --query 'Parameter.Value' --output text)


IP=$(aws ec2 describe-instances --filters Name=tag:Name,Values=$tool_name --query 'Reservations[*].Instances[*].PrivateIpAddress' --output text)
ansible-playbook -i ${IP}, playbook.yml -e ansible_user=$ssh_username -e ansible_password=$ssh_password -e tool_name=$tool_name
#os_type=$(aws ec2 describe-instances --filters Name=tag:Name,Values=$tool_name --query 'Reservations[*].Instances[*].Tags[?Key==`OS`].Value' --output text)

##!/bin/bash
 #
 #tool_name=$1
 #os_type=$2
 #
 #ssh_username=$(aws ssm get-parameter \
 #  --name "/dev/${os_type}/ssh/username" \
 #  --with-decryption \
 #  --query 'Parameter.Value' \
 #  --output text)
 #
 #ssh_password=$(aws ssm get-parameter \
 #  --name "/dev/${os_type}/ssh/password" \
 #  --with-decryption \
 #  --query 'Parameter.Value' \
 #  --output text)
 #
 #IP=$(aws ec2 describe-instances \
 #  --filters Name=tag:Name,Values=${tool_name} \
 #  --query 'Reservations[*].Instances[*].PrivateIpAddress' \
 #  --output text)
 #
 #ansible-playbook \
 #  -i ${IP}, \
 #  playbook.yml \
 #  -e ansible_user=${ssh_username} \
 #  -e ansible_password=${ssh_password} \
 #  -e tool_name=${tool_name}

