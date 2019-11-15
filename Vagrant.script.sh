#!/bin/bash

### Aprovisionamiento de software ###

# curl repo de node
sudo curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -

# Actualizo los paquetes de la maquina virtual
sudo apt-get update

# Instalo un servidor web
sudo apt-get install -y nodejs build-essential npm

sudo npm install -g serve
### Configuración del entorno ###

##Genero una partición swap. Previene errores de falta de memoria
if [ ! -f "/swapdir/swapfile" ]; then
	sudo mkdir /swapdir
	cd /swapdir
	sudo dd if=/dev/zero of=/swapdir/swapfile bs=1024 count=2000000
	sudo mkswap -f  /swapdir/swapfile
	sudo chmod 600 /swapdir/swapfile
	sudo swapon swapfile
	echo "/swapdir/swapfile       none    swap    sw      0       0" | sudo tee -a /etc/fstab /etc/fstab
	sudo sysctl vm.swappiness=10
	echo vm.swappiness = 10 | sudo tee -a /etc/sysctl.conf
fi

# ruta raíz del servidor web
WEB_ROOT="/home/vagrant";
# ruta de la aplicación
APP_PATH="$WEB_ROOT/grupo1-react-practica1";


## configuración servidor web
#copio el archivo de configuración del repositorio en la configuración del servidor web
# if [ -f "/tmp/devops.site.conf" ]; then
# 	echo "Copio el archivo de configuracion de apache";
# 	sudo mv /tmp/devops.site.conf /etc/apache2/sites-available
# 	#activo el nuevo sitio web
# 	sudo a2ensite devops.site.conf
# 	#desactivo el default
# 	sudo a2dissite 000-default.conf
# 	#refresco el servicio del servidor web para que tome la nueva configuración
# 	sudo service apache2 reload
# fi
	
## aplicación

# descargo la app del repositorio
if [ ! -d "$APP_PATH" ]; then
	echo "clono el repositorio";
	cd $WEB_ROOT;
	sudo git clone https://github.com/fpunta/grupo1-react-practica1.git;
	cd $APP_PATH;
	sudo CHOKIDAR_USEPOLLING=true serve -s build -l 8080;
fi

