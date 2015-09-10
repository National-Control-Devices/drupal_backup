# Drupal Backup

A simple set of bash scripts for backuping up and restoring drupal installations, works with D7 and D8.

Unzip the file in /var/www (the folder should be visible at /var/www/backup_restore)

for simplicity sake I like to:
```sh
ln -s /var/www/backup_restore/backup.sh /usr/bin/drupal_backup
ln -s /var/www/backup_restore/restore.sh /usr/bin/drupal_restore
```
this makes the commands executible from the command line as drupal_backup and drupal_restore respectively

if you would like to set up a cron for the backup just send in the path to the drupal installation as an argument (i.e. drupal_backup mydrupslsite)

# Migrate

 - The "Restore" portion of this uses the database credentials from the backup. If you are using this to migrate a site to another server, you will need to set up the database and user on the destination server to use the same credentials as the source server.
 - Backup files are read from the backup_restore/backups directory, place the file you are migrating into that directory to make it accessible for restore.
