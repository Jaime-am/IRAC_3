#!/bin/bash

user=$1
key_vid=$(openssl rand -hex 16)
key_aud=$(openssl rand -hex 16)
key_dec_vid=$(echo $key_vid | xxd -r -p | base64 | tr -d "=")
key_dec_aud=$(echo $key_aud | xxd -r -p | base64 | tr -d "=")

sudo mysql -u jaime <<-EOF
          use irac;
          UPDATE usuarios SET decoder_vid = '$(echo $key_dec_vid)' WHERE user = '$(echo $user)';
          UPDATE usuarios SET decoder_aud = '$(echo $key_dec_aud)' WHERE user = '$(echo $user)';
EOF

sudo rm -r /var/www/html/$(echo $user)
sudo mkdir /var/www/html/$(echo $user)
sudo bash -c "/Bento4-SDK-1-6-0-639.x86_64-unknown-linux/bin/mp4encrypt --method MPEG-CENC --key 1:$(echo $key_vid):random --property 1:KID:$(echo $key_aud) --global-option mpeg-cenc.eme-pssh:true /var/www/html/videos/low_config.mp4 /var/www/html/$(echo $user)/low-config-enc.mp4"
sudo bash -c "/Bento4-SDK-1-6-0-639.x86_64-unknown-linux/bin/mp4encrypt --method MPEG-CENC --key 1:$(echo $key_vid):random --property 1:KID:$(echo $key_aud) --global-option mpeg-cenc.eme-pssh:true /var/www/html/videos/med_config.mp4 /var/www/html/$(echo $user)/med-config-enc.mp4"
sudo bash -c "/Bento4-SDK-1-6-0-639.x86_64-unknown-linux/bin/mp4encrypt --method MPEG-CENC --key 1:$(echo $key_vid):random --property 1:KID:$(echo $key_aud) --global-option mpeg-cenc.eme-pssh:true /var/www/html/videos/high_config.mp4 /var/www/html/$(echo $user)/high-config-enc.mp4"

cd /var/www/html/$(echo $user) && sudo bash -c "/Bento4-SDK-1-6-0-639.x86_64-unknown-linux/bin/mp4dash /var/www/html/$(echo $user)/high-config-enc.mp4 /var/www/html/$(echo $user)/med-config-enc.mp4 /var/www/html/$(echo $user)/low-config-enc.mp4"
