-- -- 1. Получить названия поставщиков, которые поставляют продукт и индексом 129

-- select 
--     distinct p.name
-- from 
--     alpha.item as i
--     inner join alpha.provider as p on p.provider_id = i.provider_id
-- where 
--     i.product_id = 129
-- order by 
--     p.name;

-- -- 2. Получить имена клиентов рожденных с 1991-12-26 по 1992-12-26

-- select 
--     c.name
-- from 
--     alpha.client as c
-- where 
--     c.date_birth between '1991-12-26' and '1992-12-26'
-- order by
--     c.name;


-- -- 3. Получить имена и общий чек клиентов, чьи имена и фамилии начинаются с S

-- select 
--     c.name, c.total
-- from 
--     alpha.client as c
-- where 
--     c.name like 'S% S%'
-- order by 
--     c.name, c.total;

-- -- 4. Получить названия поставщиков, которые поставляют продукт и индексом 129 

-- select
--     p.name
-- from 
--     alpha.provider as p
-- where
--     p.provider_id in (
--         select
--             distinct p.provider_id
--         from 
--             alpha.provider as p
--             inner join alpha.item as i on p.provider_id = i.provider_id
--         where
--             i.product_id = 129
--     )
-- order by 
--     1;

-- -- 5. Получить названия поставщиков, которые поставляют продукт и индексом 129 

-- select
--     p.name
-- from 
--     alpha.provider as p
-- where
--     exists (
--         select
--             p.provider_id
--         from 
--             alpha.provider as p
--             inner join alpha.item as i on p.provider_id = i.provider_id
--         where
--             i.product_id = 129 and p.provider_id = 134
--     ) and p.provider_id > 995
-- order by 
--     1 desc;

-- -- 6. Выбрать клиентов дата рождения которых in 1990-01-01 and 2000-01-01 и total > чем any у клиентов дата рождения которых in 1980-01-01 and 1990-01-01

-- select 
--     c.name, c.total
-- from 
--     alpha.client c 
-- where 
--     c.total > any (
--         select
--             c.total
--         from 
--             alpha.client c
--         where 
--             date_birth between '1980-01-01' and '1990-01-01'
--     )
--     and date_birth between '1990-01-02' and '2000-01-01'
-- limit 10;

-- -- 7. Для каждого пользователя посчитать количество закозов

-- select
--     c.name, 
--     count(distinct bill_id)
-- from 
--     alpha.client as c
--     inner join alpha.event as e on c.client_id = e.client_id
-- group by 
--     c.client_id, 
--     c.name
-- order by 
--     1
-- limit
--     10;

-- -- 8. Получить общее количество продуктов каждого вида на складе

 select 
    p.name,
    (
        select  
            sum(i.amount)
        from 
            alpha.item as i
        where
            i.product_id = p.product_id
    ) as amount
from
    alpha.product as p
    inner join alpha.item as i on p.product_id = i.product_id
group by
    p.product_id, 
    p.name
order by
    2 desc, 1
limit
    10;

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

-- -- 10. Вывести поставщика, его рейтинг и комментарий к нему

-- select
--     p.name,
--     p.rate,
--     case
--         when p.rate between 0 and 10 then 'no good'
--         when p.rate between 11 and 70 then 'good'
--         else 'so good'
--     end as preference
-- from 
--     alpha.provider as p
-- order by
--     2 desc,
--     1
-- limit
--     10;

-- -- 11. Создать копию client без поля total

-- select
--     c.client_id,
--     c.name,
--     c.date_birth,
--     c.date_entry
-- into 
--     new_table
-- from
--     alpha.client as c;

-- -- drop table new_table;

-- -- 12.

-- select 
--     p.name,
--     count(distinct q.item_id)
-- from 
--     alpha.position as p 
--     join (
--         select
--             i_p.position_id,
--             i_p.item_id
--         from
--             alpha.item_position as i_p
--         where
--             i_p.position_id < 10     
--     ) as q on p.position_id = q.position_id
-- group by
--     p.name
-- order by
--     1
-- limit
--     10;

-- -- 13 Выбрать клиентов с максимальным total

-- select
--     c.name,
--     c.date_birth,
--     c.total
-- from 
--     alpha.client as c
-- where
--     c.client_id in (
--         select
--             c.client_id
--         from
--             alpha.client as c
--         where
--             c.total = (
--                 select max(c.total) from alpha.client as c
--             )
--     );

-- -- 14 вывести название продукта и количество поставщиков для него

-- select
--     p.name,
--     count(distinct i.provider_id)
-- from 
--     alpha.product as p
--     inner join alpha.item as i on p.product_id = i.product_id
-- group by
--     p.product_id,
--     p.name
-- order by 
--     1
-- limit
--     10;

-- -- 15 ывести название продукта и количество поставщиков для него (количество поставщиков больше 5)

-- select
--     p.name,
--     count(distinct i.provider_id)
-- from 
--     alpha.product as p
--     inner join alpha.item as i on p.product_id = i.product_id
-- group by
--     p.product_id,
--     p.name
-- having
--     count(distinct i.provider_id) > 5
-- order by 
--     1
-- limit
--     10;

-- -- 16 вставлю себя в new_table

-- insert into new_table (name, date_birth, date_entry)
-- values ('Ilya Malyshev', '2002-06-11', '2022-06-11');

-- -- drop table new_table;

-- -- 17

-- insert into new_table (name, date_birth, date_entry)
-- select
--     c.name,
--     c.date_birth,
--     c.date_entry
-- from 
--     alpha.client as c;

-- drop table new_table;

-- -- 18

-- update alpha.position
-- set cost_price = cost_price * 1.1;

-- -- 19

-- update alpha.position
-- set cost_price = (select avg(cost_price) from alpha.position)
-- where cost_price < (select avg(cost_price) from alpha.position);

-- -- 20

-- delete from alpha.event
-- where amount > 7;

-- -- 21

-- delete from alpha.event
-- where client_id in (select client_id from alpha.client where client_id % 2 = 0);

-- -- 22

-- with t1 (name, rate, mail) as (
--     select
--         name,
--         rate,
--         mail
--     from 
--         alpha.provider
--     where
--         rate > 10
-- )
-- select name, mail
-- from t1
-- limit 10;

-- 23

-- with recursive pr(n) as
-- (
--     select 1
--     union all
--     select cast(pow(sqrt(n) + 1, 2) as int) from pr
--     where n < 20
-- )
-- select n from pr;

-- 24

-- select
--     bill_id,
--     sum(amount) over (partition by bill_id),
--     max(amount) over (partition by bill_id),
--     min(amount) over (partition by bill_id)
-- from 
--     alpha.event
-- limit
--     10;

-- -- 25

-- create table tbl (
--     f1 int,
--     f2 int
-- );

-- insert into tbl(f1, f2)
-- values 
-- (1, 1),
-- (1, 1),
-- (2, 2),
-- (2, 2),
-- (2, 2),
-- (3, 3),
-- (3, 1);

-- select * from tbl;

-- create table tbl2 as
--     (with t1 as
--               (select row_number() over (partition by f1, f2) as rn,
--                       f1,
--                       f2
--                from tbl)
--      select *
--      from t1
--      where rn = 1);

-- drop table public.tmp_table;
-- select * from tbl2;


