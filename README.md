Japancakes -- Nginx + PHP-FPM build pack for Heroku
========================

This is a build pack bundling PHP and Nginx for Heroku apps.

- Includes additional extensions: apc, memcache, memcached, mysql, pgsql, phpredis, mcrypt, and sqlite.
- Dependency management handled by [Composer][ch].

[ch]: http://getcomposer.org/

Configuration
-------------

The config files are bundled:

* conf/nginx.conf.erb
* conf/etc.d/01_memcached.ini
* conf/etc.d/02_memcache.ini
* conf/etc.d/03_phpredis.ini
* conf/php.ini
* conf/php-fpm.conf

### Overriding Configuration Files During Deployment

Create a `conf/` directory in the root of the your deployment. Any files with names matching the above will be copied over and overwitten.

This way, you can customize settings specific to your application, especially the document root in `nginx.conf.erb`. (Note the .erb extension.)


Pre-compiling binaries
----------------------

### Preparation
Edit `support/set-env.sh` and `bin/compile` to update the version numbers.
````
$ gem install vulcan
$ export AWS_ID="1BHAJK48DJFMQKZMNV93" # optional if s3 handled manually.
$ export AWS_SECRET="fj2jjchebsjksmMJCN387RHNjdnddNfi4jjhshh3" # as above
$ export S3_BUCKET="heroku-buildpack" # set to your S3 bucket.
$ source support/set-env.sh
````
Edit `bin/compile` and `support/set-env.sh` to reflect the correct S3 bucket.

### Nginx
Run:
````
$ support/package_nginx
````
The binary package will be produced in the current directory. Upload it to Amazon S3.

### libmcrypt
Run:
````
$ support/package_libmcrypt
````
The binary package will be produced in the current directory. Upload it to Amazon S3.

### libmemcached
Run:
````
$ support/package_libmemcached
````
The binary package will be produced in the current directory. Upload it to Amazon S3.

### newrelic
Run:
````
$ support/package_newrelic
````
The binary package will be produced in the current directory. Upload it to Amazon S3.

### PHP
PHP requires supporting libraries to be avaliable when being built. Please have the preceeding packages built and uploaded onto S3 before continuing.

Review the `support/vulcan-build-php.sh` build script and verify the version numbers in `support/set-env.sh`.

Run:
````
$ support/package_php
````
The binary package will be produced in the current directory. Upload it to Amazon S3.

### Bundling Caching
To speed up the slug compilation stage, precompiled binary packages are cached. The buildpack will attempt to fetch `manifest.md5sum` to verify that the cached packages are still fresh.

This file is generated with the md5sum tool:
```
$ md5 *.tar.gz > manifest.md5sum
```

Contents of `manifest.md5sum`:
```
$ cat manifest.md5sum
7d99f732e54f6f53e026dd86de4158ac  libmcrypt-2.5.8.tar.gz
1390676a5df6dc658fd9bce66eedae48  libmemcached-1.0.7.tar.gz
9b861de30f67a66358d58a8f897f6262  nginx-1.2.2-heroku.tar.gz
ca9f712f2dde107f7a0ef44f0b743f1f  php-5.4.4-with-fpm-heroku.tar.gz
```

Remember to upload an updated `manifest.md5sum` to Amazon S3 whenever you upload new precompiled binary packages.

Usage
-----
Read through this whole README file first and decide if you need to make any changes to this buildpack; most customizations do not require editing the buildpack scripts. However, if you do need to make changes, fork this repo and replace the following URLs with yours.

### Deploying
To use this buildpack, on a new Heroku app:
````
heroku create -s cedar -b git://github.com/tjstein/japancakes.git
````

On an existing app:
````
heroku config:add BUILDPACK_URL=git://github.com/tjstein/japancakes.git
heroku config:add PATH="/app/vendor/bin:/app/local/bin:/app/vendor/nginx/sbin:/app/vendor/php/bin:/app/vendor/php/sbin:/usr/local/bin:/usr/bin:/bin"
````

Push deploy your app and you should see Nginx, mcrypt, and PHP being bundled.

### Declaring Dependencies using Composer
[Composer][] is the de fecto dependency manager for PHP, similar to Bundler in Ruby.

- Declare your dependencies in `composer.json`; see [docs][cdocs] for syntax and other details.
- Run `php composer.phar install` *locally* at least once to generate a `composer.lock` file. Make sure both `composer.json` and `composer.lock` files are committed into version control.
- When you push the app, the buildpack will fetch and install dependencies when it detects both `composer.json` and `composer.lock` files.

Note: It is optional to have `composer.phar` within the application root. If missing, the buildpack will automatically fetch the latest version available from <http://getcomposer.org/composer.phar>.

[cdocs]: http://getcomposer.org/doc/00-intro.md#declaring-dependencies
[composer]: http://getcomposer.org/

Credits
-------

Original buildpack adapted and modified for Nginx+PHP support by [Ronald Ip][iht]. Buildpack originally inspired, and forked from <https://github.com/heroku/heroku-buildpack-php>.

Credits to original authors.

[iht]: http://ronaldip.com/