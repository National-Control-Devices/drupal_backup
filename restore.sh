#!/bin/bash

index=1
cd /var/www/backup_restore/backups
echo "Select a file to restore from:"
echo "--------------------"
for f in *.zip
do
        echo "[$index] $f"
        files[$index]=$f
        ((index++))
done
((index--))
echo "--------------------"
echo "select backup file to restore"

while true
do
        read -p "(1-$index): " selected
        if [[ ${files[$selected]} ]]; then
                break
        else
                echo "Please select a valid file"
        fi
done

backup=${files[$selected]}

trap 'rm -r /var/www/backup_restore/tmp' INT

mkdir -p ../tmp
cp $backup ../tmp

cd ../tmp
echo "Extracting $backup"
unzip -q $backup

cd backup
mv db.sql ../db.sql
echo "Extracting docroot"
unzip -q docroot.zip
rm docroot.zip
cd ../../

#fetch sql user data from backup
DB=$(php backup.php --site "backup_restore/tmp/backup" --fetch "database")
USER=$(php backup.php --site "backup_restore/tmp/backup" --fetch "username")
PASSWORD=$(php backup.php --site "backup_restore/tmp/backup" --fetch "password")

#echo "$DB $USER"
#rm -r /var/www/backup_restore/tmp
#exit 1

#restore db
echo "Restoring Database"
mysql -u $USER -p$PASSWORD $DB < tmp/db.sql

#ask for docroot name
index=1
cd /var/www

echo "Where would you like to restore this backup to?"
echo "--------------------"
for f in *; do
        if [[ -f "$f/sites/default/settings.php" ]]; then
                echo "[$index] $f"
                instances[$index]=$f
                ((index++))
        fi
done

((index--))
echo "--------------------"
echo "Select a destination directory, or enter a path to a custom directory"

while true
do
        read -p "(1-$index or path): " selected
        case $selected in
                $'\e') rm -r /var/www/backup_restore/tmp
                        exit 1
                        ;;
                *)
                        if [[ ${instances[$selected]} ]]; then
                                instance=${instances[$selected]}
                        else
                                instance=$selected
                        fi
                        break
                        ;;
        esac
done

cd /var/www

if [ -d $instance ]; then
        rm -r $instance
fi

echo "Moving docroot to $instance"

mv backup_restore/tmp/backup $instance

rm -r backup_restore/tmp

echo "Backup restored"

exit 1