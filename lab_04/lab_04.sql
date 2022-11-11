-- select * from pg_language;
-- SELECT name, default_version, installed_version FROM pg_available_extensions;
-- create extension plpython3u;



-- Определяемую пользователем скалярную функцию CLR
-- Получить item для позиции с индексом id 
-- CREATE OR REPLACE FUNCTION get_item_position(id INT)
-- RETURNS VARCHAR
-- AS $$
-- res = plpy.execute(f" \
--     SELECT item_id \
--     FROM alpha.item_position  \
--     WHERE position_id = {id};", 2)
-- if res:
--     return res[0]['item_id']
-- $$ LANGUAGE plpython3u;

-- select get_item_position(13);



-- Пользовательскую агрегатную функцию CLR
-- Агрегатные функции получают единственный 
-- результат из набора входных значений.
-- CREATE OR REPLACE FUNCTION count_item_amount(a int, position_id int)
-- RETURNS INT
-- AS $$
-- count_ = 0
-- result_ = plpy.execute(f" \
-- 				select * \
-- 				from alpha.item_position\
--                 where position_id = {position_id};", 2)
-- for i in result_:
-- 	if i["position_id"] == position_id:
-- 		count_ += i["amount"]
-- return count_
-- $$ LANGUAGE plpython3u;

-- CREATE AGGREGATE position_item_amount(Int)
-- (
-- 	sfunc = count_item_amount,
-- 	stype = int
-- );

-- SELECT position_item_amount(13) FROM alpha.item_position;



-- Определяемую пользователем табличную функцию CLR
-- CREATE OR REPLACE FUNCTION best_providers()
-- RETURNS TABLE 
-- (
-- 	provider_id INT,
-- 	rate INT,
-- 	mail VARCHAR
-- )
-- AS $$
-- buf = plpy.execute(f" \
-- select provider_id, rate, mail  \
-- from alpha.provider")
-- result_ = []
-- for i in buf:
-- 	if i["rate"] >= 95:
-- 		result_.append(i)
-- return result_
-- $$ LANGUAGE plpython3u;

-- SELECT * FROM best_providers();



-- Хранимую процедуру CLR
-- Меняет звездность отелей с old_star на new_star
-- CREATE OR REPLACE FUNCTION add_to_total(client_id int, addition int)
-- RETURNS void
-- AS $$
-- 	plan = plpy.prepare("UPDATE alpha.client set total = total + $1 where client_id = $2", ["INT", "INT"])
-- 	plpy.execute(plan, [addition, client_id])
-- $$ LANGUAGE plpython3u;

-- select client_id, total from alpha.client where client_id = 13;
-- select add_to_total(13, 1000);
-- select client_id, total from alpha.client where client_id = 13;



-- Триггер CLR
-- create view client_view AS
-- select * from alpha.client;

-- CREATE OR REPLACE FUNCTION delete_client_view()
-- RETURNS TRIGGER 
-- AS $$
-- del_id = TD["old"]["client_id"]
-- run = plpy.execute(f" \
-- update client_view set total = 0 \
-- where client_view.client_id = {del_id}")

-- return TD["new"]
-- $$ LANGUAGE plpython3u;

-- CREATE TRIGGER delete_client_view_trigger
-- INSTEAD OF DELETE ON client_view
-- FOR EACH ROW 
-- EXECUTE PROCEDURE delete_client_view();

-- select client_id, total from client_view where client_id = 13;
-- DELETE FROM client_view where client_id = 13;
-- select client_id, total from client_view where client_id = 13;



-- Определяемый пользователем тип данных CLR
-- CREATE TYPE my_type AS
-- (
-- 	client_id int,
-- 	total int
-- );

-- CREATE OR REPLACE FUNCTION get_my_type(client_id int)
-- RETURNS my_type
-- AS $$
-- 	plan = plpy.prepare(" 			\
-- 	select client_id, total 	\
-- 	from alpha.client				\
-- 	where client_id = $1;", ["INT"])
-- 	run = plpy.execute(plan, [client_id])
	
-- 	if (run.nrows()):
-- 		return (run[0]["client_id"], run[0]["total"])
-- $$ LANGUAGE plpython3u;

-- SELECT * FROM get_my_type(13);
