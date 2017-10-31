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
