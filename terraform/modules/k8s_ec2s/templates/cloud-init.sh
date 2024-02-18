#!/bin/bash

# Swap Off
sudo sed -i '/ swap / s/^/#/' /etc/fstab

# containerd pre-reqs

# Forwarding IPv4 and letting iptables see bridged traffic

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot

sudo systemctl restart systemd-sysctl

#Verify that the br_netfilter, overlay modules are loaded

lsmod | grep br_netfilter
lsmod | grep overlay

# verify iptables and ip forward setting

sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward

# Install containerd

sudo apt update
sudo apt install -y containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd
systemctl status containerd

# kubelet, kubeadm, kubectl

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo mkdir -p /etc/apt/keyrings
sudo chmod -R a=---,u=rw,go=r /etc/apt/keyrings
sudo curl -fsSLo /etc/apt/trusted.gpg.d/kubernetes-archivekeyring.gpg https://dl.k8s.io/apt/doc/apt-key.gpg
echo "deb [signed-by=/etc/apt/trusted.gpg.d/kubernetes-archivekeyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

#check versions

sudo apt-get update

apt-cache madison kubeadm

#Install

sudo apt-get install -y kubelet=1.27.6-00 kubeadm=1.27.6-00 kubectl=1.27.6-00

sudo apt-mark hold kubelet kubeadm kubectl

sudo apt-get install -y jq

sudo hostname ${new_hostname}

export PRIVATE_IP=$(TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` && curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/local-ipv4)

echo 'KUBELET_EXTRA_ARGS=--node-ip='$PRIVATE_IP | sudo tee -a /etc/default/kubelet