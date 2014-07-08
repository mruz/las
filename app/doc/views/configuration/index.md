### 4. Configuration {#configuration}
- [Nginx configuration](#nginx)
- [PHP configuration](#php)
- [MySQL configuration](#mysql)
- [Las configuration](#las)
***

#### Nginx configuration {#nginx}
Edit `/etc/nginx/nginx.conf` config file:

```nginx
# run nginx as a particular user
user wwwrun www;

# uncomment php location and set document root
location ~ \.php$ {
    root           /srv/www/htdocs/;
    fastcgi_pass   127.0.0.1:9000;
    fastcgi_index  index.php;
    fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include        fastcgi_params;
}
```
<br />
Create directory and config for the nginx vhost:
```bash
# nginx vhosts
mkdir /etc/nginx/vhosts.d
touch /etc/nginx/vhosts.d/las.conf
```
<br />
Paste the following config to `/etc/nginx/vhost.d/las.conf` vhost config file:
```nginx
server {
    listen      81;
    server_name _;
    set         $root_path '/var/www/$host/public';
    root        $root_path;

    access_log  /var/log/nginx/$host-access.log;
    error_log   /var/log/nginx/$host-error.log error;

    index index.php index.html index.htm;

    try_files $uri $uri/ @rewrite;

    location @rewrite {
        rewrite ^/(.*)$ /index.php?_url=/$1;
    }

    location ~ \.php {
        fastcgi_index  /index.php;
        fastcgi_pass   127.0.0.1:9000;

        include fastcgi_params;
        fastcgi_split_path_info       ^(.+\.php)(/.+)$;
        fastcgi_param PATH_INFO       $fastcgi_path_info;
        fastcgi_param PATH_TRANSLATED $document_root$fastcgi_path_info;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }

    location ~* ^/(css|fonts|img|js|min)/(.+)$ {
        root $root_path;
    }

    location ~ /\.ht {
        deny all;
    }
}
```
<br />
Enable web server service (you can use the systemctl or yast's runlevels):
```bash
# enable nginx
systemctl start nginx.service
systemctl enable nginx.service
```
<br />
>If you have any trouble, please read:

>1. [Nginx Installation Notes](configuration/nginx)
>2. [Apache Installation Notes](configuration/apache)

#### PHP configuration {#php}
Copy php's default config:
```bash
# copy php-fpm config
cp /etc/php5/fpm/php-fpm.conf.default /etc/php5/fpm/php-fpm.conf
```
<br />
Edit `/etc/php5/fpm/php-fpm.conf` config file:
```ini
; change the user and group values from nobody to nginx
user = wwwrun
group = www

; uncomment and set the path to `error_log`
error_log = /var/log/php-fpm.log
```
<br />
Copy php.ini from cli to fpm
```bash
cp /etc/php5/cli/php.ini /etc/php5/fpm/
```
<br />
Enable php service:
```bash
# enable php
systemctl start php-fpm.service
systemctl enable php-fpm.service
```
<br />
Restart the web server:
```bash
# restart nginx
systemctl restart nginx.service
```
***

#### MySQL configuration {#mysql}
Start the mysql server
```bash
systemctl start mysql.service
```
<br />
Create user with root access to the server:
```bash
mysql_secure_installation
# mostly `Yes` answer
```
or
```bash
# just add `root` user
mysqladmin -u root password new_password
```
<br />
Enable database service:
```bash
# enable mysql
systemctl enable mysql.service
```
<br />
Create database:
```bash
cd /srv/www/las
mysql -u root -p
Enter password:[just enter root password]
```

```sql
mysql> CREATE DATABASE las CHARACTER SET utf8 COLLATE utf8_general_ci;
mysql> GRANT USAGE ON las.* TO las@localhost;
mysql> GRANT ALL ON las.* TO las@localhost IDENTIFIED BY '[your_password]';
mysql> flush privileges;
mysql> use las;
mysql> source las.sql;
```
***

#### Las configuration {#las}
Ignore local configuration files that are edited, but should never be committed upstream. Git lets you ignore those files by assuming they are unchanged.
```bash
# ignore config file to easily merge future changes
git update-index --assume-unchanged app/common/config/config.ini
```
<br />
Edit `/app/common/config/config.ini` config file:
```ini
[app]
domain = "example.com"
base_uri = "/"
static_uri = "/"
admin = "admin@example.com"
```
<br />
Enter the settings to connect to the database:
```ini
[database]
host     = "localhost"
username = "las"
password = "password"
dbname   = "las"
```
<br />
Change default hash keys. It is **very important** for safety reasons:
```ini
[auth]
hash_key = "secret_key"

[crypt]
key = "secret_key"
```
<br />
Prepare the application for the first run:
```bash
cd /srv/www/las/private
php index.php prepare chmod
```

After this step you should be able to enter your system without any problems. Run some web browser and just write an URL `localhost:81/admin` for your Las installation. If there's no user account (first run), you'll be prompted with form to add username and some personal data. When you enter correct admin personal details Las will move you to login page, where you can use newly created account.

|                                   |                           |
| :-------------------------------- | ------------------------: |
| 3. [Installation](./installation) | 5. [Admin panel](./admin) |
| [Home](../doc)                    |     [Top](#configuration) |