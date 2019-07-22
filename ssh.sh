#!/bin/env bash

set -x 

dir="tf/ec2"

prefix=$(cd $dir && terraform workspace show)

tmux new-session -d -s $prefix  -n window

function createtmux(){
  { 
    cd $dir &&  terraform output -json ips | \
      jq -r \
      'to_entries[]| select(.key|contains("amz")) .user|="ec2-user" | select(.key|contains("cent")) .user|="centos" | select(.key|contains("ubuntu")) .user|="ubuntu"| "ssh -i key_pair -l "+.user + " " + .value' 
  }| xargs -i tmux splitw -v  \; select-layout even-vertical  \; send-keys '{}' C-m
}


createtmux
tmux kill-pane -t ${prefix}:0.0 \; select-layout even-vertical
