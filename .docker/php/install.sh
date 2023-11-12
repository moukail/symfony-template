rm -rf ./*
rm -rf ./.*

echo "-------------------------------------------------------------------"
echo "-                create symfony project                           -"
echo "-------------------------------------------------------------------"
symfony self:version

symfony new my_project --no-git --version=6.4 --php=8.2 --docker=false

echo "-------------------------------------------------------------------"
echo "-                   require packages                              -"
echo "-------------------------------------------------------------------"
cd ./my_project
cp .env .env.local

symfony composer require php:^8.2.0
symfony composer require twig symfony/webpack-encore-bundle
symfony composer require --no-interaction doctrine/orm doctrine/doctrine-migrations-bundle ramsey/uuid-doctrine

echo "-------------------------------------------------------------------"
echo "-               require dev packages                              -"
echo "-------------------------------------------------------------------"
symfony composer config config.allow-plugins.phpstan/extension-installer true
symfony composer config config.allow-plugins.dealerdirect/phpcodesniffer-composer-installer true

symfony composer require --dev debug symfony/profiler-pack symfony/maker-bundle
symfony composer require --dev --no-interaction doctrine/doctrine-fixtures-bundle

symfony composer require --dev --no-interaction codeception/module-symfony codeception/module-doctrine2 \
codeception/module-rest codeception/module-datafactory codeception/module-phpbrowser codeception/module-asserts \
codeception/specify codeception/verify league/factory-muffin league/factory-muffin-faker

# Clean code tools
symfony composer require --dev --no-interaction friendsofphp/php-cs-fixer phpmd/phpmd psalm/plugin-symfony \
nunomaduro/phpinsights phpstan/extension-installer phpstan/phpstan-doctrine phpstan/phpstan-symfony phpmetrics/phpmetrics

symfony composer config scripts.phpcsfixer "./vendor/bin/php-cs-fixer fix ./src --rules=@Symfony,@PHP82Migration --dry-run --diff"
symfony composer config scripts.phpcsfixer-fix "./vendor/bin/php-cs-fixer fix ./src --rules=@Symfony,@PHP82Migration"
symfony composer config scripts.phpmd "./vendor/bin/phpmd ./src text cleancode,codesize,design,naming,controversial"
symfony composer config scripts.phpmd-baseline "./vendor/bin/phpmd ./src text cleancode,codesize,design,naming,controversial --generate-baseline --baseline-file phpmd.baseline.xml"
symfony composer config scripts.phpcpd "phpcpd --fuzzy --min-lines 4 --min-tokens 20 ./src --exclude ./src/Entity"

symfony composer config scripts.phpstan "./vendor/bin/phpstan analyse ./src"
symfony composer config scripts.phpstan-baseline "./vendor/bin/phpstan analyse ./src --generate-baseline"
symfony composer config scripts.psalm "./vendor/bin/psalm"
symfony composer config scripts.phpinsights "./vendor/bin/phpinsights analyse ./src"
symfony composer config scripts.phpinsights-fix "./vendor/bin/phpinsights analyse ./src --fix"

symfony composer config scripts.phpmetrics "./vendor/bin/phpmetrics ./src"
symfony composer config scripts.phpmetrics-report "./vendor/bin/phpmetrics --report-html=.phpmetrics ./src"

symfony composer psalm -- --init
vendor/bin/psalm-plugin enable psalm/plugin-symfony
cp vendor/nunomaduro/phpinsights/stubs/symfony.php phpinsights.php

echo "-------------------------------------------------------------------"
echo "-                   Init Codeception                              -"
echo "-------------------------------------------------------------------"
codecept bootstrap --namespace App\\Tests
codecept generate:suite api

echo "-------------------------------------------------------------------"
echo "-                          Init Yarn                              -"
echo "-------------------------------------------------------------------"
corepack enable
yarn init -2

echo "-------------------------------------------------------------------"
echo "-                          Ready                                  -"
echo "-------------------------------------------------------------------"
rm -rf .git
cd ..

chmod -R a+rw my_project

rsync -a my_project/ ./
rm -rf my_project
