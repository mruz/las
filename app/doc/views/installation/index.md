### 3. Installation {#installation}
- [Update your system first](#prepare)
- [Install web server, php, database and phalcon module](#install)
- [Install Las](#las)
***

#### Update your system first {#prepare}
*The installation procedure is performed on openSUSE, the commands may be vary slightly:
```php
# refresh repositories
zypper ref

# update your system
zypper up

# remove SuSEfirwall2 initscripts from boot process and stop
SuSEfirewall2 off
```
***

#### Install web server, php, database, mail and phalcon module {#install}
You can use default version of packages available in the default repository:
```bash
# install web server, php, database and mail
zypper in nginx php5 mariadb postfix

# add openSUSE 13.1 phalcon repo
zypper ar http://download.opensuse.org/repositories/home:mruz/openSUSE_13.1/home:mruz.repo
zypper ref

#install phalcon and other php modules
zypper in php5-devel php5-fpm php5-json php5-mbstring php5-mcrypt php5-mysql php5-pdo php5-pear php5-zlib php5-phalcon
```
or use the latest version of packages available in the server repository:
```bash
# add repo with the latest version of web server, php, database and email
zypper ar http://download.opensuse.org/repositories/server:http/openSUSE_13.1/server:http.repo
zypper ar http://download.opensuse.org/repositories/server:php/openSUSE_13.1/server:php.repo
zypper ar http://download.opensuse.org/repositories/server:database/openSUSE_13.1/server:database.repo
zypper ar http://download.opensuse.org/repositories/server:mail/openSUSE_13.1/server:mail.repo
zypper ref

# install web server, php, mysql and mail server from the server repo
zypper in server_http:nginx server_php:php5 server_database:mariadb server_mail:postfix

# add server:php/openSUSE 13.1 phalcon repo
zypper ar http://download.opensuse.org/repositories/home:mruz:server:php/openSUSE_13.1/home:mruz:server:php.repo
zypper ref

#install phalcon and other php modules
zypper in php5-devel php5-fpm php5-json php5-mbstring php5-mcrypt php5-mysql php5-pdo php5-pear php5-zlib php5-phalcon
```
<br />
> For more details about Phalcon please read [Phalcon README](installation/phalcon).

#### Install Las {#las}
Las in tarball (.tar.gz) archive can be downloaded from gitHub page [master](https://github.com/mruz/las/archive/master.tar.gz), which should be extracted and placed in chosen directory (eg `/srv/www/las`):
```bash
# download tarball
cd /srv/www
wget https://github.com/mruz/las/archive/master.tar.gz

# extract the archive and move to las/ directory
tar zxf master.tar.gz
mv las-master/ las
```

or using `git` (preferred way):

```bash
# install `git` if it is not installed
zypper in git

# clone las from gitHub
cd /srv/www
git clone https://github.com/mruz/las
```


|                                   |                                     |
| :-------------------------------- | ----------------------------------: |
| 2. [Requirements](./requirements) | 4. [Configuration](./configuration) |
| [Home](../doc)                    |                [Top](#installation) |