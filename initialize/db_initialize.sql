CREATE DATABASE develop_database CHARACTER SET utf8mb4;
show databases;
GRANT ALL PRIVILEGES ON develop_database TO root@127.0.0.1;
GRANT ALL PRIVILEGES ON develop_database TO root@192.168.33.10;
FLUSH PRIVILEGES;
