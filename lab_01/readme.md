# Лабораторная работа № 1

- ### Как поднять базу данных в Docker-е на примере PostgreSQL?

  - Пользуемся этим

    `docker run --name my_test_pg -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres`

- ### Как подключиться к PostgreSQL в контейнере?

  - Один раз устанавливаем:

    `sudo apt install postgresql-client`

  - При подключении:

    `psql -h 127.0.0.1 -U postgres -d postgres`

    > пароль: `postgres`

  - Затестим:

    `selectel=# create table cities (name varchar(80));`

    > CREATE TABLE

    `selectel=# insert into cities values ('Moscow');`

    > INSERT 0 1

    `selectel=# select * from cities;`

    >   name
    >
    > Moscow
    > (1 row)

  - Запуск sql-скрипта:

    `selectel=# \i <абсолютный путь до скрипта>`