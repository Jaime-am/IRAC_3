#!/bin/bash

user=$1
key_vid=$(openssl rand -hex 16)
key_aud=$(openssl rand -hex 16)
key_dec_vid=$(echo $key_vid | xxd -r -p | base64)
key_dec_aud=$(echo $key_aud | xxd -r -p | base64)

sudo mkdir /var/www/html/fragments/
bash -c "/Bento4-SDK-1-6-0-639.x86_64-unknown-linux/bin/mp4encrypt --method MPEG-CENC --key 1:$(echo $key_vid):random --property 1:KID:$(echo $key_aud) --global-option mpeg-cenc.eme-pssh:true /var/www/html/videos/low_config_fragment /var/www/html/fragments/low-config-fragment-$(echo $user)"
bash -c "/Bento4-SDK-1-6-0-639.x86_64-unknown-linux/bin/mp4encrypt --method MPEG-CENC --key 1:$(echo $key_vid):random --property 1:KID:$(echo $key_aud) --global-option mpeg-cenc.eme-pssh:true /var/www/html/videos/med_config_fragment /var/www/html/fragments/med-config-fragment-$(echo $user)"
bash -c "/Bento4-SDK-1-6-0-639.x86_64-unknown-linux/bin/mp4encrypt --method MPEG-CENC --key 1:$(echo $key_vid):random --property 1:KID:$(echo $key_aud) --global-option mpeg-cenc.eme-pssh:true /var/www/html/videos/high_config_fragment /var/www/html/fragments/high-config-fragment-$(echo $user)"

