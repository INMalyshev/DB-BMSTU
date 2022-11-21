--1. Из таблиц базы данных, созданной в первой лабораторной работе, извлечь
--данные в XML (MSSQL) или JSON(Oracle, Postgres). Для выгрузки в XML
--проверить все режимы конструкции FOR XML

-- SELECT row_to_json(c) result FROM alpha.client c;




--2. Выполнить загрузку и сохранение XML или JSON файла в таблицу.
--Созданная таблица после всех манипуляций должна соответствовать таблице
--базы данных, созданной в первой лабораторной работе.

-- Сохраняем таблицы в файлы
-- \copy (select row_to_json(c) result from alpha.client c) to '/home/malyshevin/Documents/data_bases/lab_05/client.json';

-- Создам новую схему, чтобы в нее положить копии таблиц

create schema if not exists lab_05;

-- CREATE TABLE lab_05.client(
--     client_id                       INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

--     name                            VARCHAR(200),
--     date_birth                      DATE,
--     date_entry                      DATE,
--     total                           INT
-- );

-- Будем записывать в json через промежуточную таблицу

-- drop table lab_05.client;
-- create table if not exists lab_05.client_import(doc json);
-- \copy lab_05.client_import from '/home/malyshevin/Documents/data_bases/lab_05/client.json';
-- select * from lab_05.client_import;

-- Теперь считаем результаты в основные таблицы

-- insert into lab_05.client(name, date_birth, date_entry, total)
-- select
--     cast(doc ->> 'name' as varchar(200)),
--     cast(doc ->> 'date_birth' as date),
--     cast(doc ->> 'date_entry' as date),
--     cast(doc ->> 'total' as int)
-- from lab_05.client_import;

-- Проверяем, что все добавилось

-- select * from lab_05.client;

-- Удаляем промежуточные таблицы

-- drop table if exists lab_05.client_import;




--  ЗАДАНИЕ №3
--  Создать таблицу, в которой будет атрибут(-ы) с типом XML или JSON,
--  или добавить атрибут с типом XML или JSON к уже существующей таблице.
--  Заполнить атрибут правдоподобными данными с помощью команд INSERT или UPDATE.

-- create table if not exists lab_05.persons_json(data json);

-- insert into lab_05.persons_json
-- select * from json_object('{person_id, name, sub_name, pat_name, inp_date, notes}',
--                           '{1, "Хлеб", "Хлебов", "Хлебушкевич", null, null}'
-- );

-- select * from lab_05.persons_json;

-- -- Другой вариант
-- create table if not exists lab_05.person_json_2(
--     id              serial       primary key,
--     note            varchar(64)             ,
--     important_data  json
-- );

-- insert into lab_05.person_json_2(note, important_data) values
-- ('мяу', '{"pet": "кошка", "age": 5}'::json),
-- ('гаф', '{"pet": "собака", "age": 10}'::json),
-- (null, '{"pet": "неизвестный объект", "age": 100}'::json);

-- select * from lab_05.person_json_2;




-- 444444444
-- 4.1

-- create table if not exists lab_05.client_fragment(
--     name     varchar(200),
--     total int
-- );

-- create table if not exists lab_05.client_import(doc json);

-- \copy lab_05.client_import from '/home/malyshevin/Documents/data_bases/lab_05/client.json';

-- select * from lab_05.client_import, json_populate_record(NULL::lab_05.client_fragment, doc);

-- select doc ->> 'name' tname from lab_05.client_import;
-- select doc ->> 'total' total from lab_05.client_import;

-- 4.2

-- create table if not exists lab_5.pets(data json);

-- insert into lab_5.pets values
-- ('{"id": 1, "params": {"type": "cat", "age": 5, "color": "orange"}}'::json),
-- ('{"id": 2, "params": {"type": "dog", "age": 1, "color": "white"}}'::json),
-- ('{"id": 3, "params": {"type": "parrot", "age": 2, "color": "blue"}}'::json),
-- ('{"id": 4, "params": {"type": "parrot", "age": 0.5, "color": "green"}}'::json);

-- select * from lab_5.pets;

-- select data->'params'->'type' from lab_5.pets;

-- 4.3

--  jsonb -- данные хранятся в разложенном двоичном формате, что немного замедляет ввод
--  из-за дополнительных затрат на преобразование, но значительно ускоряет обработку,
--  поскольку повторная обработка не требуется. jsonb также поддерживается индексация,
--  что может быть существенным преимуществом.

-- create table if not exists lab_05.pets_b(data jsonb);

-- insert into lab_05.pets_b values
--     ('{"id": 1, "params": {"type": "cat", "age": 5, "color": "orange"}}'::jsonb),
--     ('{"id": 2, "params": {"type": "dog", "age": 1, "color": "white"}}'::jsonb),
--     ('{"id": 3, "params": {"type": "parrot", "age": 2, "color": "blue"}}'::jsonb),
--     ('{"id": 4, "params": {"type": "parrot", "age": 0.5, "color": "green"}}'::jsonb);

-- create or replace function is_key_exists(some_json jsonb, key text)
-- returns bool as '
--     select some_json::jsonb ? key
-- ' language sql;

-- select 1
-- from lab_05.pets_b
-- where cast(lab_05.pets_b.data -> 'id' as int) = 1;

-- with one_json as
-- (
--     select lab_05.pets_b.data
--     from lab_05.pets_b
--     where cast(lab_05.pets_b.data -> 'id' as int) = 1
-- )
-- select is_key_exists((select * from one_json),'key_a');

-- 4.4 Изменить XML/JSON документ

-- create table if not exists lab_05.for_update(data jsonb);

-- insert into lab_05.for_update values
--    ('{"id": 1, "type": "cat", "age": 5, "color": "orange"}'::jsonb),
--    ('{"id": 2, "type": "dog", "age": 1, "color": "white"}'::jsonb);

-- update lab_05.for_update
-- set data = data || '{"age": 6}'::jsonb
-- where (data->'age')::int = 5;

-- select * from lab_05.for_update;

-- 4.5 Разделить XML/JSON документ на несколько строк по узлам

-- create table lab_5.last_test(doc json);

-- insert into lab_5.last_test values
-- ('[{"id": 1, "type": "cat", "age": 5, "color": "orange"},
--    {"id": 2, "type": "dog", "age": 1, "color": "white"}]');

-- -- Развернуть JSON-массив верхнего уровня в набор значений JSON.
-- select jsonb_array_elements(doc::jsonb) from lab_5.last_test;
-- select * from lab_5.last_test;

-- select * from json_array_elements('[1,true, [2,false]]');

