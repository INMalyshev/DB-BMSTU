# Лабораторная работа № 1

## 1. Ставим DOCKER

## 2. Как поднять базу данных в Docker-е на примере PostgreSQL?

- Пользуемся этим

  `docker run --name my_test_pg -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres`

## 3. Как подключиться к PostgreSQL в контейнере?

- Один раз устанавливаем:

  `sudo apt install postgresql-client`

- При подключении:

  `psql -h 127.0.0.1 -U postgres -d postgres`

  > пароль: `postgres`

- Затестим:

  `postgres=# create table cities (name varchar(80));`

  > CREATE TABLE

  `postgres=# insert into cities values ('Moscow');`

  > INSERT 0 1

  `postgres=# select * from cities;`

  > name
  >
  > Moscow
  > (1 row)

## 4. Запуск sql-скрипта:

`selectel=# \i <абсолютный путь до скрипта>`

## Схема

![schema](./schema.svg)
