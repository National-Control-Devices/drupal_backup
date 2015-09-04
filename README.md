# drupal_backup

A simple bash script for backup up and restoring drupal installations, works with D7 and D8.

Unzip the file in /var/www (the folder should be visible in /var/www/backup_restore)

for simplicity sake I like to:

-ln -s /var/www/backup_restore/backup.sh /usr/bin/drupal_backup
-ln -s /var/www/backup_restore/restore.sh /usr/bin/drupal_restore

this makes the commands executible from the command line as drupal_backup and drupal_restore respectively

if you would like to set up a cron for the backup just send in the path to the drupal installation as an argument (i.e. drupal_backup mydrupslsite)
