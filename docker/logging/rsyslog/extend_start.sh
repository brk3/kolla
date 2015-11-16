#!/bin/bash

if [[ -e "/dev/log" ]]; then
    sudo rm -rf /dev/log
fi

sudo chgrp kolla /dev /var/log
sudo chmod 775 /dev /var/log
