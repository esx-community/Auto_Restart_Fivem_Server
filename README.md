# RestartFivemServer

Ce script va vous permettre de redémarrer votre serveur FiveM aux horaires définis tout en prenant en compte le screen crée.

Nous verrons aussi la création d'un journal pour loguer les restarts du serveur Fivem.

# Script
```bash
#!/bin/bash
echo "***********************************************************"
echo `date '+%d-%B-%Y_%H:%M:%S'` " - Arrêt du serveur..."
kill -9 `ps -ef | grep "/home/fxserver/proot" | grep -v grep | awk '{print $2}'`
sleep 2
echo `date '+%d-%B-%Y_%H:%M:%S'`" - Redémarrage de mysql..."
sudo service mysql restart
sleep 10
echo `date '+%d-%B-%Y_%H:%M:%S'` " - Nettoyage du cache..."
rm -R /home/fxserver/server-data/cache/
sleep 2
echo `date '+%d-%B-%Y_%H:%M:%S'` " - Démarrage du serveur..."
screen -x fxserver -X stuff 'cd /home/fxserver/server-data/
/home/fxserver/run.sh +exec server.cfg
'
sleep 10
echo `date '+%d-%B-%Y_%H:%M:%S'` " - Fin de la procédure"
```
# Nota
- Vous devez modifier le user 'fxserver'dans le chemin /home/nomuser/ 
- Vous devez modifier le nom du screen (screen -x nomduscreen).

Pour information la commande 'screen -x nomscreen -X stuff' va permettre de lancer une commande dans le screen.

Le fichier script est disponible ici => 'https://github.com/tracid56/restartFivemserver/blob/master/reload_fxserver.sh'

Mettre le script dans votre /home/nomuser

# Ajout des horaires et log
En root, accéder au crontab via la commande: 'crontab -e'

*Pour cet exemple nous allons restart le serveur tout les jours à 14h et 02h*

```bash
00 14 * * * /home/fxserver/reload_fxserver.sh >> /var/log/fxreload/fxreloadlog
00 02 * * * /home/fxserver/reload_fxserver.sh >> /var/log/fxreload/fxreloadlog
```

*Pour vérifier l'enregistrement:* 'crontab -l'

# Ajout des droits au compte User pour restart MySQL
En root, il faut editer le fichier sudoers via:

vi /etc/sudoers

Et ajouter en dessous de '#Cmnd alias specification' la ligne suivante:
```
NomUser ALL= NOPASSWD:/usr/sbin/service mysql restart
````
*Pour vérifier l'enregistrement: cat /etc/sudoers*

# Création du journal de log
En Root, entrer les commandes suivantes qui permettront de créer un fichier de log, mettre les droits, paramétrer les logs.
```
mkdir /var/log/fxreload
chown -R fxserver:fxserver /var/log/fxreload/ (ici modifier le user fxserver par votre user)
vi /etc/logrotate.d/fxreload
```

Ajouter dans le fichier fxreload:
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
*Pour vérifier l'enregistrement:' cat /etc/logrotate.d/fxreload'*

# Regarder le fichier de log:
```
cat /var/log/fxreload/fxreloadlog
```




