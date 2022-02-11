#!/bin/bash

ssh-keygen -t rsa -b 2048 -f ~/.ssh/redis.pem -q -P ''
chmod 400 ~/.ssh/redis.pem
ssh-keygen -y -f ~/.ssh/redis.pem > ~/.ssh/redis.pub

