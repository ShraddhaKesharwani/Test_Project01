#!/bin/bash

 

while :

do

        dt=$(date '+%d%m%y')

        tm=$(date '+%H%M')

        if [ ${tm} -gt 0208 -a ${tm} -le 0210 ]

        then

                #login to the sql db from the EC2 instance and execute backup

 

                mysql -h shraddhadbinstance1.cxfyibiokz8s.us-east-2.rds.amazonaws.com -P 3306 -u root -pAdmin123 "mysqldump -u root newdb > newdb-backup.sql"

 

                #copy backup to EC2

 

                scp root@shraddhadbinstance1.cxfyibiokz8s.us-east-2.rds.amazonaws.com:/home/root/newdb-backup.sql .

 

                #push backup to S3 bucket

 

                aws s3 cp /home/root/newdb-backup.sql s3://shraddhas3bucket

 

                logger "Successfully Backedup" -t DBLogger

 

                echo -e "Hello, \nBackup was successful on `date` \nThank you." on 'hostname -i' | mail -s "DB Backup Status" -aFrom:support\<support@lokalise.com\> shraddha@lokalise.com

 

                logger "Successfully Backedup" -t DBLogger

 

                sleep 3300

 

        else

 

                logger "Failed to Back up" -t DBLogger

 

                echo -e "Hello, \nBackup was unsuccessful on `date`. \nPlease check. \nThank you." on 'hostname -i' | mail -s "DB Backup Status" -aFrom:support\<support@lokalise.com\> shraddha@lokalise.com

 

                #sleep 1h

        fi

 

done