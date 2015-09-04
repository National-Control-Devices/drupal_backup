#!/bin/bash

cd /var/www
index=1

if [ -z "$1" ]; then
    echo "Which drupal installation would you like to backup?"
    echo "-------------------"
    for f in *; do
            if [[ -f "$f/sites/default/settings.php" ]]; then
                    echo "[$index] $f"
                    instances[$index]=$f
                    ((index++))
            fi
    done
    echo "-------------------"
    ((index--))
    	while true
	do
		read -p "(1-$index) or valid installation path: " selected
		case $selected in
			$'\e') exit 1
		esac
		if [ "$index" -lt "$selected" ]; then
			if [[ -d "$selected" && -f "$selected/sites/default/settings.php" ]]; then
    		            	instance=$selected
				break
            		else
                    		echo "you must select a valid drupal instalation"
            		fi
    		else
            		instance=${instances[$selected]}
			break
    		fi
	done
else
    instance=$1
fi

DB=$(php backup_restore/backup.php --site "$instance" --fetch "database")
USER=$(php backup_restore/backup.php --site "$instance" --fetch "username")
PASSWORD=$(php backup_restore/backup.php --site "$instance" --fetch "password")
FILENAME="$instance-"$(date +"%Y-%m-%d_%H-%M-%S")".zip"

mkdir backup_tmp
mkdir backup_tmp/backup
echo "Created Temporary Directory"
cd $instance
zip -rq ../backup_tmp/backup/docroot.zip .
echo "Zipped docroot"
cd ..
mysqldump -u $USER -p$PASSWORD $DB > backup_tmp/backup/db.sql
echo "exported SQL"
cd backup_tmp
zip -rq backup.zip backup
echo "zipped backup"
mv backup.zip ../backup_restore/backups/$FILENAME
cd ..
rm -r backup_tmp
echo "removed temp files"
echo "complete"
exit 1
