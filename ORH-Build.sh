#!/bin/bash

#Author Jim Gogarty
#Description : Scrtipt to automate the creation of ORH servers.
#Version 0.01

###################################################
#Change the server hsot name to Cluster name
#get the new server name and asign to var

#edit the host config files to add the new host name
sudo hostname $servername
echo $ip $servername /etc/hosts
eccho $servernaem >> /etc/hostname

#apache tests and config 

sudo apache2ctl configtest
#take return and verify

#curl http://icanhazip.com >> ~/ipaddress.txt

#sudo chown -R ubuntu:www-data /var/www/html

#change the set bit

sudo find /var/www/html -type d -exec chmod g+s {} \;

#####################################################

#MYSQL SETUP
mysql_secure_installation <<<SQL_FILE
#ENTER THE PASSWORD

SQL_FILE
#DROP EXISTING DATABASES
mysql -u root -p <<SQL_FILE
DROP DATABASE wordpress1;
DROP DATABASE wordpress2;
DROP DATABASE wordpress3;
DROP DATABASE wordpress4;
DROP DATABASE wordpress5;
#CREATE NEW DATABASES
CREATE DATABASE wordpress1 DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE DATABASE wordpress2 DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE DATABASE wordpress3 DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE DATABASE wordpress4 DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE DATABASE wordpress5 DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
#GIVE THE WORDPRESS USER ACCESS TO THE NEW DATABASES 
GRANT ALL ON wordpress1.* TO 'wordpress_user'@'localhost' IDENTIFIED BY '$new_wp_pswd';

FLUSH PRIVILEGES;

EXIT

SQL_FILE 

######################################################

#ENABLE .HTACCESS OVERRIDES

sudo nano /etc/apache2/apache2.conf

#ADD THE FOLLOWING 

<Directory /var/www/html/>

    AllowOverride All
	#more to add 
</Directory>





#ENABLE MOD_REWRITE

sudo a2enmod rewrite



#TEST CONFIGURATION OF APACHE 

sudo apache2ctl configtest



############################################################



#CREATE VITTUAL HOSTS before installing wordpress 



sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/example.com.conf

sudo nano /etc/apache2/sits-available/example1.conf



#NEED TO REMOVE OLD SITES FROM THE /etc/apache2/sites-enabled 

#this should fix errors when the server is rebooted



#enabale the change 

sudo a2ensite EXAMPLE.COM.conf



#disable the default conf





#restart the server 

sudo systemctl restart apache2

sudo service apache2 restart



#set the local hosts file 



#NEED TO SEND THE DOMAINS TO THE NEW SITES ON GODADDY

#ALLWAYS CHECK THE DOMAIN FIRST !!!!!

# AND COPY THE CURENT IP BEFORE asigning new IP.





##########################################################



#WORDPRESS INSTALLATION

cd /temp/

curl -O https://wordpress.org/latest.tar.gz

#expand the file 

tar xzvf latest.tar.gz



touch /tmp/wordpress/.htaccess

chmod 600 /tmp/wordpress/.htaccess 

ls -

cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php

mkdir /tmp/wordpress/wp-content/upgrade

mkdir /tmp/wordpress/wp-content/upload



#MOVE THE WORDPRESS DIR TO THE WWW DIR UNDER THE SUB-DIR 

sudo cp -a /tmp/wordpress/. /var/www/html





#THIS SHOULD BE CHANGED FOR EACH VURTUAL HOST 



sudo chown -R ubuntu:www-data /var/www/html



#SET THE SETGID BIT 	

sudo find /var/www/html -type d -exec chmod g+s {} \;



#CHANGE THE PREMISSIONS ON THE FOLLOWING DIRS

sudo chmod g+w /var/www/html/wp-content

sudo chmod -R g+w /var/www/html/wp-content/themes

sudo chmod -R g+w /var/www/html/wp-content/plugins

sudo chmod -R g+w /var/www/html/wp-content/uploads





#NOW YOU CAN COPY THE WPRODPRES INSTALL TO THE OTHE DOMOANS

sudo cp -rp /tmp/wordpress/. /var/www/html/$DOMAIAN_NAME 



#copy the template site to the the html folder 

#sudo cp -rp  ...



#NEED TO ADD LINE TO TEMPLATE functions.php

#update_option( 'siteurl', 'http://example.com' );

#update_option( 'home', 'http://example.com' );

1



##

# secure and config  file edit 

curl -s https://api.wordpress.org/secret-key/1.1/salt/



define('AUTH_KEY',         's*y~kM>>C)J<+B.U9{S1%:2R3n:W[<&<-C!b6_8_O:=an,uA#wxs_BV?-N&_#n5g');

define('SECURE_AUTH_KEY',  '4B?tt0^Mm|:Bk[?w@3@,I*p3#<i{$2Um8[-3$;>r|[8>`]{u?hTG+qgvr-$!%z55');

define('LOGGED_IN_KEY',    '@SVSw?A$[{%p}&Bqxd:)k1p+yVBRiV#O_ijjLpxIq%-^}biYv9|ee:p2]H2<{Yo$');

define('NONCE_KEY',        'm]REX+cCy+AN>`*f-|xHP==fv_KD)JnF9w($&G!=d-f/ii[k&2>>Gp351&BpM+qw');

define('AUTH_SALT',        'q`UA9gBRWo_,I[UT.:]+3qI<ZEyArh:Fzh,BO401EQ|%0dE8<QNl,w;GDY.%|Qe%');

define('SECURE_AUTH_SALT', '03*ZBm:hfjTvKCcBr-`1g6<O1TV*p8Knz:by2Yyl&4WyQtW-Y}.1SH<>bl(I^fc.');

define('LOGGED_IN_SALT',   'Lg=%7VTE$qbQiK+`79u#11=akF|rU-$uD+&Q87R4VxC#P]_b9=p(EKjDtH!O)-Tk');

define('NONCE_SALT',       'dVgnt0^NgCN^YLBGg@dDnn(l`/io%EJzhCA|.BN9,877~D)%7kO;6hJ(|XBG*R%m');







#add this after the salts 

define('FS_METHOD', 'direct');



#ADD THE DB CONNECTION DETAILS TO THE WP-CONFIG.PHP FILE 





#ALSO ADD THIS TO THE WP-CONFIG.PHP FILE AT THE BOTTOM



define('WP_HOME','https://DOMAIN_OF_SITE/');

define('WP_SITEURL','https://DOMAIN_OF_SITE/');



###############################################################################################



#SSL CERT INSTALLATION



#will i hav to do this 5 times or will the cert to for 5 VHosts 

#create a ssl cert for the site useing cert bot on lets crypt



sudo apt-get install software-properties-common

sudo add-apt-repository ppa:certbot/certbot

sudo apt-get update

sudo apt-get install python-certbot-apache -y





sudo certbot --apache -d $ADD_URL -d $ADD_WWW._URL



sudo crontab -e 

15 3 * * * /usr/bin/certbot renew --quiet



sudo certbot --apache

#auto renew the certs 

#test

#sudo certbot renew --dry-run

certbot renew 



###########################################################



define( 'WP_DEFAULT_THEME', 'your-theme-name' );





#WORDPRESS UPDATES 

#Change the premissions to www-data user 

sudo chown -R www-data /var/www/html



#change the premssions back

sudo chown -R ubuntu /var/www/html
