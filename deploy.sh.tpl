#!/bin/bash

dnf update -y
dnf upgrade -y

dnf install -y git python3 python3-pip

git clone https://github.com/pawel-czernecki/agh-cloud-project.git ~/app

export SECRET_ID="${secret_id}"
export DB_DATABASE="${db_name}"
export DB_HOST="${db_host}"
export DB_PORT="${db_port}"

cd app/pyapp

chmod +x install.sh run.sh

./install.sh
./run.sh