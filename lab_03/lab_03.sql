-- Скалярные пользовательские функции

-- create or replace function alpha.getClientName(input_client_id int) returns varchar(200) as
-- '
--     select name from alpha.client where client_id = input_client_id;
-- ' language sql;

-- create function alpha.getClientName_1(input_client_id int) returns varchar(200) as
-- '
--     begin
--         select name from alpha.client where client_id = input_client_id;
--     end;
-- ' language plpgsql;

-- select alpha.getClientName(13); -- John Wright

-- drop function alpha.getClientName;





-- Подставляемая табличная функция 

-- create or replace function alpha.getClientInfo(input_client_id int) returns table(client_id int, name varchar(200), total int) as
-- '
-- begin
--     return query
--         select c.client_id, c.name, c.total
--         from alpha.client as c
--         where c.client_id = input_client_id;
-- end;
-- ' language plpgsql;

-- select * from alpha.getClientInfo(13);

-- drop function alpha.getClientInfo;





-- Многооператорную табличную функцию

-- create or replace function alpha.getClientsInPeriud(from_date date, to_date date) returns table(client_id int, name varchar(200), total int) as
-- '
-- begin
--     return query
--         select c.client_id, c.name, c.total
--         from alpha.client as c
--         where c.date_birth between from_date and to_date;
-- end;
-- ' language plpgsql;

-- select * from alpha.getClientsInPeriud('1970-01-31', '1970-02-02');

-- drop function alpha.getClientsInPeriud;





--  Рекурсивную функцию или функцию с рекурсивным ОТВ ???

-- -- Числа Фибоначи
-- CREATE OR REPLACE FUNCTION fib(first INT, second INT, max INT)
-- RETURNS TABLE (fibonacci INT)
-- AS '
-- BEGIN
--     RETURN QUERY
--     SELECT first;
--     IF second <= max THEN
--         RETURN QUERY
--         SELECT *
--         FROM fib(second, first + second, max);
--     END IF;
-- END' LANGUAGE plpgsql;

-- SELECT *
-- FROM fib(1, 1, 22);






-- Хранимую процедуру без параметров или с параметрами

-- create or replace procedure addToClientTotal
-- (
--     toAdd int,
--     input_client_id int
-- )
-- as '
--     begin
--         update alpha.client
--         set total = total + toAdd
--         where client_id = input_client_id;
--     end;
-- ' language plpgsql;

-- select * from alpha.getClientInfo(13);

-- call addToClientTotal(1000, 13);

-- select * from alpha.getClientInfo(13);





-- Рекурсивную хранимую процедуру или хранимую процедур с рекурсивным ОТВ

-- числа Фиббоначи начиная с [res] заканчивая индексом [index_]
-- CREATE OR REPLACE PROCEDURE fib_index
-- (
--  res INOUT int,
--  index_ int,
--  start_ int DEFAULT 1, 
--  end_ int DEFAULT 1
-- )
-- AS ' 
-- BEGIN
--  IF index_ > 0 THEN
--   RAISE NOTICE ''elem = %'', res;
--   res = start_ + end_;
--   CALL fib_index(res, index_ - 1, end_, start_ + end_);
--  END IF;
-- END; 
-- ' LANGUAGE plpgsql;

-- CALL fib_index(1, 4);



-- Хранимую процедуру с курсором


-- create or replace procedure find_magnats
-- (
--     startTotal int
-- )
-- as '
-- declare
--     name varchar(200);
--     myCursor cursor for
--         select c.name
--         from alpha.client as c
--         where c.total > startTotal;
-- begin
--     open myCursor;
--     loop
--         fetch myCursor into name;
--         exit when not found;
--         raise notice ''magnat name =  %'', name;
--     end loop;
--     close myCursor;
-- end;
-- ' language plpgsql;

-- call find_magnats(1900000)





-- Хранимую процедуру доступа к метаданным

-- метаданные без курсора
-- CREATE OR REPLACE PROCEDURE access_to_meta(
-- 	tablename VARCHAR(100)
-- )
-- AS ' 
-- DECLARE
-- 	el RECORD;
-- BEGIN
-- 	FOR el IN
-- 		SELECT column_name, data_type
-- 		FROM information_schema.columns
--         WHERE table_name = tablename
-- 	LOOP
-- 		RAISE NOTICE ''el = %'', el;
-- 	END LOOP;
-- END;
-- ' LANGUAGE plpgsql;

-- CALL access_to_meta('client');





-- Триггер AFTER

-- AFTER - оперделяет, что заданная цункция будет вызываться после события.
-- Если изменить id страны для одного города в этой стране, 
-- то надо изменить такие же id для других городов этой страны
-- CREATE OR REPLACE FUNCTION update_trigger()
-- RETURNS TRIGGER 
-- AS '
-- BEGIN
-- 	RAISE NOTICE ''New =  %'', new;
--     RAISE NOTICE ''Old =  %'', old; 
--     RAISE NOTICE ''New =  %'', new;
-- 	UPDATE city_buf
-- 	SET countryid = new.countryid
-- 	WHERE city_buf.countryid = old.countryid;
	
-- 	RETURN new;
-- END;
-- ' LANGUAGE plpgsql;

-- CREATE TRIGGER update_my
-- AFTER UPDATE ON city_buf 
-- FOR EACH ROW 
-- EXECUTE PROCEDURE update_trigger();



-- create or replace function delete_trigger()
-- returns TRIGGER
-- as 
-- '
--     begin
--         RAISE NOTICE ''New =  %'', new;
--         raise notice ''something was updated'';
--         return new;
--     end;
-- ' language plpgsql;

-- create trigger updater
-- after update on alpha.client
-- for each row
-- execute procedure delete_trigger();

-- update alpha.client as c
-- set name = 'Vasia Pupkin'
-- where c.client_id = 7;







-- Триггер INSTEAD OF 

-- CREATE VIEW client_view AS 
-- SELECT *
-- FROM alpha.client;

-- create trigger deleter
-- instead of delete on client_view
-- for each row
-- execute procedure delete_trigger();

-- delete from client_view
-- where client_id = 7;






