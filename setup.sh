#!/bin/bash

sudo apt install -y mysql-server wget apache2 php php-mysqli unzip
sudo mv 20-mysqli.ini /etc/php/8.1/apache2/conf.d/
sudo service mysql start
sudo rm -r /var/www/html/*
sudo mysql -u root <<-EOF
          CREATE USER 'jaime'@'localhost' IDENTIFIED BY ''; #crea usuario en mysql
          GRANT ALL PRIVILEGES ON * . * TO 'jaime'@'localhost'; #da maximos privilegios al usuario creado
          flush privileges; #reinicia todos los permisos para aplicar cambios
EOF
sudo mysql -u jaime <<-EOF
          create database irac; #crea DB para el login web
          use irac;
          CREATE TABLE usuarios (nombre VARCHAR(30), apellido VARCHAR(30), user VARCHAR(30) PRIMARY KEY UNIQUE,password VARCHAR(100),decoder VARCHAR(30));
          INSERT INTO usuarios (user, password, decoder) VALUES ('test@test.es', 'test', 'INSERTAR');
          INSERT INTO usuarios (user, password, decoder) VALUES ('test2@test.es', 'test2', 'INSERTAR');
EOF
wget https://www.bok.net/Bento4/binaries/Bento4-SDK-1-6-0-639.x86_64-unknown-linux.zip
unzip Bento4-SDK-1-6-0-639.x86_64-unknown-linux.zip
sudo mv IRAC_3/* /var/www/html/
sudo echo "<IfModule mod_dir.c>
        DirectoryIndex login.html login.php
</IfModule>" > /etc/apache2/mods-enabled/dir.conf
sudo service apache2 start
sudo mkdir /var/www/html/videos
cd /var/www/html/videos && curl -o fragments.zip -s -L 'https://drive.google.com/uc?export=download&confirm=yes&id=13wVhSHmDHc8wtTzdACIZVfWIz2LnnnzQ' && unzip fragments.zip && rm fragments.zip
sudo mv fragments/* /var/www/html/videos
sudo systemctl restart apache2
