### Apache Installation Notes {#apache}
[Apache](http://apache.org) is a popular and well known web server available on many platforms.

***
#### Configuring Apache for Phalcon
The following are potential configurations you can use to setup Apache with Phalcon. These notes are primarily focused on the configuration of the mod-rewrite module allowing to use friendly urls and the
router component. Commonly an application has the following structure:

    test/
      app/
        controllers/
        models/
        views/
      public/
        css/
        img/
        js/
        index.php

***
#### Directory under the main Document Root
This being the most common case, the application is installed in any directory under the document root. In this case, we use two `.htaccess` files, the first one to hide the application code forwarding all requests to the application's document root `public/`.

    # test/.htaccess
    <IfModule mod_rewrite.c>
        RewriteEngine on
        RewriteRule  ^$ public/    [L]
        RewriteRule  (.*) public/$1 [L]
    </IfModule>
<br />
Now a second `.htaccess` file is located in the `public/` directory, this re-writes all the URIs to the `public/index.php` file:

    # test/public/.htaccess
    <IfModule mod_rewrite.c>
        RewriteEngine On
        RewriteCond %{REQUEST_FILENAME} !-d
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteRule ^(.*)$ index.php?_url=/$1 [QSA,L]
    </IfModule>
<br />
If you do not want to use `.htaccess` files you can move these configurations to the apache's main configuration file:

    <IfModule mod_rewrite.c>
        <Directory "/var/www/test">
            RewriteEngine on
            RewriteRule  ^$ public/    [L]
            RewriteRule  (.*) public/$1 [L]
        </Directory>

        <Directory "/var/www/test/public">
            RewriteEngine On
            RewriteCond %{REQUEST_FILENAME} !-d
            RewriteCond %{REQUEST_FILENAME} !-f
            RewriteRule ^(.*)$ index.php?_url=/$1 [QSA,L]
        </Directory>
    </IfModule>

***
#### Virtual Hosts
And this second configuration allows you to install a Phalcon application in a virtual host:

    <VirtualHost *:80>
        ServerAdmin admin@example.host
        DocumentRoot "/var/vhosts/test/public"
        DirectoryIndex index.php
        ServerName example.host
        ServerAlias www.example.host

        <Directory "/var/vhosts/test/public">
            Options All
            AllowOverride All
            Allow from all
        </Directory>
    </VirtualHost>

|                                      |                |
| :----------------------------------- | -------------: |
| 4. [Configuration](../configuration) |                |
| [Home](../doc)                       | [Top](#apache) |