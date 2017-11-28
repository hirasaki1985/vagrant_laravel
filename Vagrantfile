Vagrant.configure("2") do |config|
  config.vm.box = "centos72"
  config.vm.network "forwarded_port", guest: 80, host: 80
  config.vm.network "forwarded_port", guest: 8000, host: 8000
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 3306, host: 3306
  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.synced_folder "./laravel", "/var/www/develop"
  config.vm.synced_folder "./other_web", "/var/www/other_web"
  config.vm.synced_folder "./configs", "/configs"
  config.vm.synced_folder "./initialize", "/initialize"
  config.vm.synced_folder "./share", "/share"
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "2048"
    vb.name = "laravel-develop"
  end

  config.vm.provision "shell", inline: $setup
  config.vm.provision "shell", run: "always", inline: $start
end

$setup = <<SCRIPT
  ## init & update
  yum update -y
  yum install -y http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
  yum install -y yum-utils
  yum install -y git unzip lsof sendmail sendmail-cf npm gzip vim php-fpm

  ## jpn lang
  yum -y install ibus-kkc vlgothic-* 
  localectl set-locale LANG=ja_JP.UTF-8
  source /etc/locale.conf 
  echo $LANG

  ## timezone
  timedatectl set-timezone Asia/Tokyo

  ## install php 7.0
  yum-config-manager --enable remi-php70
  yum install -y php
  cp -p /configs/php/php.ini /etc/php.ini
  php -v

  ## install composer
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  php composer-setup.php
  php -r "unlink('composer-setup.php');"
  mv composer.phar /usr/local/bin/composer
  su vagrant -c "composer --version"

  ## uninstall mariadb
  yum remove -y mariadb-libs

  ## install mysql 5.5
  yum localinstall -y http://dev.mysql.com/get/mysql57-community-release-el6-7.noarch.rpm
  yum-config-manager --disable mysql57-community
  yum-config-manager --enable mysql55-community
  yum info mysql-community-server
  yum install -y mysql-community-server
  mysqld --version

  service mysqld start

  ## exec sql
  export MYSQL_PWD=
  echo ${MYSQL_PWD}
  mysql -u root < /initialize/db_initialize.sql

  ## auto start
  chkconfig mysqld on

  ## install project
  yum install -y --enablerepo=remi-php70 php-fpm php-mcrypt php-cli php-common php-devel php-gd php-mbstring php-mysqlnd php-opcache php-pdo php-pear php-pecl-apcu php-pecl-zip php-process php-xml
  cd /var/www/develop && \
    su vagrant -c "/usr/local/bin/composer install"
  mkdir -p /share/logs

  ### select local env
  APP_ENV=local php artisan config:cache

  ### exec migrate
  php artisan -n migrate

  ### exec seed
  php artisan -n db:seed
  
  ## install nginx
  rpm -ivh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
  sed -i -e "s/packages\/centos/packages\/mainline\/centos/" /etc/yum.repos.d/nginx.repo
  yum --showduplicates list nginx
  yum -y --enablerepo=nginx install nginx
  nginx -v
  cp -p /configs/nginx/nginx.conf /etc/nginx/nginx.conf
  cp -p -r /configs/nginx/conf.d/* /etc/nginx/conf.d/

  systemctl enable nginx

  ### nginx use php
  sed -i -e "s/^user = apache/user = nginx/" /etc/php-fpm.d/www.conf
  sed -i -e "s/^group = apache/group = nginx/" /etc/php-fpm.d/www.conf
  chkconfig php-fpm on

  ## mail
  cd /etc/mail
  cp -p sendmail.mc sendmail.mc_bkup`date +"%Y%m%d"`
  cp -p sendmail.cf sendmail.cf_bkup`date +"%Y%m%d"`
  sed -i -e "s/.*SMART_HOST.*/define\(\'SMART_HOST\',\'smtp:smtp.mailgun.org\'\)/g" /etc/mail/sendmail.mc
  m4 sendmail.mc > sendmail.cf
SCRIPT

$start = <<SCRIPT
  sudo service mysqld restart
  sudo systemctl restart sendmail.service
  sudo systemctl restart php-fpm
  sudo systemctl restart nginx
  #cd /var/www/develop && \
  #  php artisan serve --host 0.0.0.0 >> /share/logs/access.log &
SCRIPT