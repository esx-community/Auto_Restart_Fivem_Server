# RestartFivemServer

Ce script va vous permettre de redémarrer votre serveur FiveM aux horaires définis tout en prennant en compte le screen crée.

Nous verrons aussi la création d'un journal pour loguer les restarts du serveur Fivem.

# Script:
```bash
#!/bin/bash
echo "***********************************************************"
echo `date '+%d-%B-%Y_%H:%M:%S'` " - Arrêt du serveur..."
kill -9 `ps -ef | grep "/home/fxserver/proot" | grep -v grep | awk '{print $2}'`
echo `date '+%d-%B-%Y_%H:%M:%S'`" - Redémarrage de Mysql..."
sudo service mysql restart
sleep 10
echo `date '+%d-%B-%Y_%H:%M:%S'` " - Nettoyage du cache..."
rm -R /home/fxserver/server-data/cache/
echo `date '+%d-%B-%Y_%H:%M:%S'` " - Démarrage du serveur..."
screen -x fxserver -X stuff 'cd /home/fxserver/server-data/
/home/fxserver/run.sh +exec server.cfg
'
echo `date '+%d-%B-%Y_%H:%M:%S'` " - Fin de la procédure"
```
# Nota:
Vous devez modifier le user 'fxserver'dans le chemin /home/nomuser/ par le user que vous utiliser ainsi que le nom du screen (screen -x nomduscreen)

# Ajouter les créneaux du restart serveur
Accéder au crontab via la commande: 'crontab -e'
*pour cet exemple nous allons restart le serveur tout les jours à 14h et 02h*

00 14 * * * /home/fxserver/reload_fxserver.sh >> /var/log/fxreload/fxreloadlog
00 02 * * * /home/fxserver/reload_fxserver.sh >> /var/log/fxreload/fxreloadlog

*pour vérifier l'enregistrement des tâches*:
fxserver@vps-26798:~$ crontab -l

# Ajouter les droits au compte fxserver pour restart MySQL
Il faut editer le fichier sudoers via le compte root et ajouter la ligne avec le nom du user que vous utiliser
Commande: 'vi /etc/sudoers'
Puis ajouter en dessous de '#Cmnd alias specification' la ligne suivante:

'fxserver ALL= NOPASSWD:/usr/sbin/service mysql restart'

*pour vérifier l'enregistrement cat /etc/sudoers*

# Création du journal de log des restarts:
Via Root, entrer les commandes suivantes:

'mkdir /var/log/fxreload'
'chown -R fxserver:fxserver /var/log/fxreload/'
'vi /etc/logrotate.d/fxreload'

Ajouter dans le fichier:
```
/var/log/fxreload/fxreloadlog
{
        rotate 4
        weekly
        missingok
        notifyempty
        delaycompress
        compress
}
```
*Pour vérifier l'enregistrement: 'cat /etc/logrotate.d/fxreload'*

# Regarder le fichier de log:
'cat /var/log/fxreload/fxreloadlog'




