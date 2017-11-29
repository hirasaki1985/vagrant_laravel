vagrant-laravel
====

vagrantでlaravelのdevelop環境を構築する手順

## require
* Virtual Box 5.1.30
* vagrant 2.0

## install
```
$ git clone https://github.com/hirasaki1985/vagrant_laravel.git
$ cd vagrant_laravel
$ rm -rf laravel
$ composer create-project laravel/laravel

$ vagrant box add centos72 https://github.com/CommanderK5/packer-centos-template/releases/download/0.7.2/vagrant-centos-7.2.box
$ vagrant up
$ chmod -R 777 ./laravel
```

## sudo vi /etc/hosts
```
192.168.33.10 develop_server.com
192.168.33.10 other_webserver.com
```
## access
```
http://develop_server.com
http://other_webserver.com
```

## 参考 
* [CentOSにちょっと古いバージョンのNginxをインストールする](https://qiita.com/segawa/items/bb1d0cd78e890a1e4170)
* [PHP Laravelのartisanコマンドのまとめ](https://urashita.com/archives/7174)
* [CentOS7 に nginx導入](https://qiita.com/MuuKojima/items/afc0ad8309ba9c5ed5ee)
* [CentOS7.3 に MySQL5.7 をインストールした時のメモ](https://qiita.com/prgseek/items/7c77d4b14d0afbf84f5c)
* [CentOS7にComposerをインストールする](https://qiita.com/inakadegaebal/items/d370bcb1627fce2b5cd1)

## Licence

[MIT](https://github.com/hirasaki1985/vagrant_laravel/blob/master/LICENSE)

## Author

[m.hirasaki](https://github.com/hirasaki1985)
