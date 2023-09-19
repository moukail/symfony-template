rm -rf ./*

echo "-------------------------------------------------------------------"
echo "-                create symfony project                           -"
echo "-------------------------------------------------------------------"
symfony self:version

export APP_ENV=dev
symfony new web --no-git --version=5.4 --php=8.2 --docker=false

echo "-------------------------------------------------------------------"
echo "-                   require packages                              -"
echo "-------------------------------------------------------------------"
cd ./web
cp .env .env.local

#symfony composer config extra.symfony.allow-contrib true
#symfony composer config allow-plugins.symfony/runtime true
symfony composer require php:^8.2.0
symfony composer require twig
symfony composer require --no-interaction doctrine/orm doctrine/doctrine-migrations-bundle:^3.2.4

#symfony/amqp-pack ramsey/uuid-doctrine symfony/mailgun-mailer symfony/mercure-bundle
#symfony composer require --no-interaction -W sensio/framework-extra-bundle
#symfony composer require --no-interaction nelmio/cors-bundle gesdinet/jwt-refresh-token-bundle sentry/sentry-symfony
#symfony composer require --no-interaction moukail/mailgun-mail-status-bundle moukail/password-reset-mail-bundle moukail/verification-mail-bundle
#symfony composer require --no-interaction dompdf/dompdf nyholm/psr7
#symfony composer require --no-interaction league/flysystem-aws-s3-v3:2.0.* league/flysystem-bundle #league/flysystem-cached-adapter

#symfony/messenger
#twig/extra-bundle

#mkdir -p config/secrets
#openssl genpkey -out config/secrets/private.pem -aes256 -algorithm rsa -pkeyopt rsa_keygen_bits:4096
#openssl pkey -in config/secrets/private.pem -out config/secrets/public.pem -pubout

echo "-------------------------------------------------------------------"
echo "-               require dev packages                              -"
echo "-------------------------------------------------------------------"
symfony composer require --dev debug symfony/profiler-pack symfony/maker-bundle
symfony composer require --no-interaction --dev doctrine/doctrine-fixtures-bundle
#symfony composer require --dev codeception/codeception codeception/specify codeception/verify ericmartel/codeception-email-mailhog
#symfony composer require --dev league/factory-muffin league/factory-muffin-faker
#symfony composer require --dev flow/jsonpath phpbench/phpbench
#symfony composer require --dev vimeo/psalm

rm -rf .git
cd ..

chmod -R a+rw web

rsync -a web/ ./
rm -rf web
