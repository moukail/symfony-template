# Symfony
```bash
echo | symfony server:ca:install
symfony serve --p12=/var/www/certs/localhost.p12

symfony self:update --no-interaction
symfony self:version
symfony self:cleanup
```

# Composer packages
```bash
symfony composer require --no-interaction symfony/amqp-pack ramsey/uuid-doctrine symfony/mailgun-mailer symfony/mercure-bundle
symfony composer require --no-interaction -W sensio/framework-extra-bundle
symfony composer require --no-interaction nelmio/cors-bundle gesdinet/jwt-refresh-token-bundle sentry/sentry-symfony
symfony composer require --no-interaction moukail/mailgun-mail-status-bundle moukail/password-reset-mail-bundle moukail/verification-mail-bundle
symfony composer require --no-interaction dompdf/dompdf nyholm/psr7
symfony composer require --no-interaction league/flysystem-aws-s3-v3:2.0.* league/flysystem-bundle #league/flysystem-cached-adapter
#symfony/messenger
#twig/extra-bundle

#dev
symfony composer require --dev codeception/codeception codeception/specify codeception/verify ericmartel/codeception-email-mailhog
symfony composer require --dev league/factory-muffin league/factory-muffin-faker
symfony composer require --dev flow/jsonpath phpbench/phpbench
symfony composer require --dev vimeo/psalm
```

### Configuration
```bash
symfony composer config extra.symfony.allow-contrib true
symfony composer config allow-plugins.symfony/runtime true
```

# Doctrine
```bash
symfony console doctrine:database:drop --if-exists --force
symfony console doctrine:database:create --if-not-exists
symfony console doctrine:migrations:up-to-date
symfony console doctrine:migrations:migrate --allow-no-migration --no-interaction
symfony console doctrine:schema:update --force
symfony console doctrine:schema:validate
symfony console doctrine:fixtures:load --no-interaction
```

# Nodejs
```bash
npm audit fix
npm install --global browser-sync
npm run dev
symfony run -d npm run watch
```

# Vagrant
```
sudo apt-get install virtualbox
sudo apt install vagrant
vagrant up --provision
vagrant up
vagrant reload
vagrant ssh
```

#### Virtualbox Guest Additions

```
vagrant plugin install vagrant-vbguest
vagrant vbguest --do install --no-cleanup
vagrant vbguest --status
```

```
Vagrant was unable to mount VirtualBox shared folders. This is usually
because the filesystem "vboxsf" is not available. This filesystem is
made available via the VirtualBox Guest Additions and kernel module.
Please verify that these guest additions are properly installed in the
guest. This is not a bug in Vagrant and is usually caused by a faulty
Vagrant box. For context, the command attempted was:

mount -t vboxsf -o uid=1000,gid=1000,_netdev var_www_ /var/www

The error output from the command was:

/sbin/mount.vboxsf: mounting failed with the error: No such device
```

# Xdebug
## Install with Dockerfile
Xdebug =<3.1 support PHP 7.4
```bash
RUN pecl install xdebug-3.1.6 && docker-php-ext-enable xdebug
```

## Using Xdebug in CLI
To check if xdebug is working add a breakpoint in `./bin/console`.

### in Docker container with PHPStorm
#### Option 1
Click on Start listening For PHP Debug Connections button
```bash
export PHP_IDE_CONFIG="serverName=symfony-web"
export XDEBUG_CONFIG="remote_host=host.docker.internal idekey=PHPSTORM"
symfony console
````
#### Option 2
Use idekey
```bash
export PHP_IDE_CONFIG="serverName=symfony-web"
export XDEBUG_CONFIG="remote_host=172.17.0.1 idekey=13233"
symfony console
```

### in Vagrant with PHPStorm
Click on Start listening For PHP Debug Connections button
```bash
export PHP_IDE_CONFIG="serverName=symfony-web"
symfony console
```

# TLS
```bash
mkdir -p config/secrets
openssl genpkey -out config/secrets/private.pem -aes256 -algorithm rsa -pkeyopt rsa_keygen_bits:4096
openssl pkey -in config/secrets/private.pem -out config/secrets/public.pem -pubout
```

# ngrok
### install ngrok
https://ngrok.com/docs/getting-started/
https://dashboard.ngrok.com/get-started/setup
```bash
sudo snap install ngrok
ngrok config add-authtoken <YOUR_TOKEN>
ngrok http --domain=noted-shad-flexible.ngrok-free.app 8000
ngrok tunnel --label edge=edghts_2W8TyJQmPfk5xw5pp6mxcPcENN5 http://localhost:8000
```

https://theboroer.github.io/localtunnel-www/