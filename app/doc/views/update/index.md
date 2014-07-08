### 7. Update {#update}
- [Working with git](#git)
- [Manual update](#manual)
***

#### Working with git
To update your local repository to the newest commit, execute:
```bash
# in your working directory to fetch and merge remote changes
cd /srv/www/las
git pull
```
***

#### Manual update
You need to download and overwrite all files manually:
```bash
# download tarball
cd /srv/www
wget https://github.com/mruz/las/archive/master.tar.gz

# extract the archive
tar zxf master.tar.gz

# overwrite all files except config
rsync -a --exclude=config.ini las-master/ las/
```

|                           |               |
| :------------------------ | ------------: |
| 6. [Examples](./examples) |               |
| [Home](../doc)            | [Top](#update) |