-- -- 9. Вывести поставщика, его рейтинг и комментарий к нему

-- select
--     p.name,
--     p.rate,
--     case p.rate
--         when 0 then 'no good'
--         when 1 then 'good'
--         else 'so good'
--     end as preference
-- from 
--     alpha.provider as p
-- order by
--     2 desc,
--     1
-- limit
--     10;




-- create table to_save as 
-- select
--     p.name,
--     p.rate,
--     case p.rate
--         when 0 then 'no good'
--         when 1 then 'good'
--         else 'so good'
--     end as preference
-- from 
--     alpha.provider as p
-- order by
--     2 desc,
--     1
-- limit
--     10; 

select * from to_save;

-- Сохраняем таблицы в файлы
\copy (select row_to_json(c) result from to_save c) to '/home/malyshevin/Documents/data_bases/lab_05/to_save.json';
