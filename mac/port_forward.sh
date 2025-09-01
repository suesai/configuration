#!/bin/bash

sudo nohup socat TCP4-LISTEN:8800,fork TCP4:127.0.0.1:7897 &>/dev/null &
# sudo nohup socat TCP4-LISTEN:8822,fork TCP4:192.168.15.128:22 &>/dev/null &
