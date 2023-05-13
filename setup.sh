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
          CREATE TABLE usuarios (nombre VARCHAR(30), apellido VARCHAR(30), user VARCHAR(30) PRIMARY KEY UNIQUE,password VARCHAR(100),decoder_vid VARCHAR(32),decoder_aud VARCHAR(32));
          INSERT INTO usuarios (user, password) VALUES ('test@test.es', 'test');
          INSERT INTO usuarios (user, password) VALUES ('test2@test.es', 'test2');
EOF
wget https://www.bok.net/Bento4/binaries/Bento4-SDK-1-6-0-639.x86_64-unknown-linux.zip
unzip Bento4-SDK-1-6-0-639.x86_64-unknown-linux.zip
sudo mv IRAC_3/* /var/www/html/
sudo echo "<IfModule mod_dir.c>
        DirectoryIndex login.html login.php
</IfModule>" > /etc/apache2/mods-enabled/dir.conf
sudo chmod 777 /var/www/html
sudo service apache2 start
sudo mkdir /var/www/html/videos
cd /var/www/html/videos && curl -o videos_mp4.zip -s -L 'https://drive.google.com/uc?export=download&confirm=yes&id=1fGXgKqXMKosBTkoGDpN0pgNj_8ngvjOP' && unzip videos_mp4.zip && rm videos_mp4.zip
sudo chmod +sx /var/www/html/gen_code.sh
sudo mkdir /var/www/html/fragments
sudo bash -c "/Bento4-SDK-1-6-0-639.x86_64-unknown-linux/bin/mp4fragment /var/www/html/videos/low_config.mp4 /var/www/html/fragments/low-config-fragment.mp4"
sudo bash -c "/Bento4-SDK-1-6-0-639.x86_64-unknown-linux/bin/mp4fragment /var/www/html/videos/med_config.mp4 /var/www/html/fragments/med-config-fragment.mp4"
sudo bash -c "/Bento4-SDK-1-6-0-639.x86_64-unknown-linux/bin/mp4fragment /var/www/html/videos/high_config.mp4 /var/www/html/fragments/high-config-fragment.mp4"

sudo systemctl restart apache2
