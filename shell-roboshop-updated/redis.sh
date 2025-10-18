#!/bin/bash

source ./common.sh
app_name=redis

check_root

dnf module disable redis -y &>>$LOG_FILE
VALIDATE $? "Disabling Default Redis version"

dnf module enable redis:7 -y &>>$LOG_FILE
VALIDATE $? "Enabling Redis:7"

dnf install redis -y &>>$LOG_FILE
VALIDATE $? "Installing Redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
VALIDATE $? "Edited redis.conf to accept remote connections"

systemctl enable redis &>>$LOG_FILE
VALIDATE $? "Enabling Redis"

systemctl start redis  &>>$LOG_FILE
VALIDATE $? "Started Redis"

print_time
