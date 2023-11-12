#!/usr/bin/env bash

# create new project if not exists
if [ ! -d "./public" ]; then
  . /home/install.sh
fi

echo "--------------------------------------------------------------------"
echo "-                            composer                              -"
echo "--------------------------------------------------------------------"
composer remove --unused
composer validate
symfony composer install --no-interaction
symfony composer -n check-platform-reqs

echo "-------------------------------------------------------------------"
echo "-                        waiting for DB                           -"
echo "-------------------------------------------------------------------"
while ! nc -z $DATABASE_HOST $DATABASE_PORT; do sleep 1; done

echo "-------------------------------------------------------------------"
echo "-                        prepare the DB                           -"
echo "-------------------------------------------------------------------"
symfony console doctrine:database:create --if-not-exists
symfony console doctrine:migrations:migrate --no-interaction
symfony console doctrine:fixtures:load --no-interaction -vvv

echo "-------------------------------------------------------------------"
echo "-                        php-cs-fixer                             -"
echo "-------------------------------------------------------------------"
symfony composer phpcsfixer-fix

echo "-------------------------------------------------------------------"
echo "-                        phpstan                                  -"
echo "-------------------------------------------------------------------"
symfony composer phpstan

echo "-------------------------------------------------------------------"
echo "-                        psalm                                    -"
echo "-------------------------------------------------------------------"
vendor/bin/psalm-plugin
symfony composer psalm

echo "-------------------------------------------------------------------"
echo "-                    phpinsights                                  -"
echo "-------------------------------------------------------------------"
symfony composer phpinsights

echo "-------------------------------------------------------------------"
echo "-                        phpcpd                                   -"
echo "-------------------------------------------------------------------"
symfony composer phpcpd

echo "-------------------------------------------------------------------"
echo "-                        PHPMD                                    -"
echo "-------------------------------------------------------------------"
symfony composer phpmd

echo "-------------------------------------------------------------------"
echo "-                            benchmarks                           -"
echo "-------------------------------------------------------------------"
#phpbench run --report=default --report=env
#phpbench xdebug:profile
#phpbench xdebug:trace

echo "-------------------------------------------------------------------"
echo "-                        website is ready                         -"
echo "-------------------------------------------------------------------"
chmod -R a+rw ./
symfony local:php:list
symfony local:php:refresh
symfony local:check:requirements
symfony local:check:security
symfony console about

symfony local:server:start --daemon
symfony local:server:status
symfony local:server:list

echo "-------------------------------------------------------------------"
echo "-                        testing                                  -"
echo "-------------------------------------------------------------------"
codecept clean
codecept run --steps --debug -vvv --coverage --coverage-xml --coverage-html

echo "-------------------------------------------------------------------"
echo "-                        yarn watch                               -"
echo "-------------------------------------------------------------------"
yarn install
yarn watch

tail -f /dev/null
