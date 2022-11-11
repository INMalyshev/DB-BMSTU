-- по client_id сформировать строку содержащую первые 5 элементов event.name

drop function alpha.make_string;

CREATE OR REPLACE FUNCTION alpha.make_string(input_client_id INT)
RETURNS VARCHAR
AS '
	DECLARE
	    s VARCHAR(1500) = '''';
        elem RECORD;
        input_count int = 5;
        input_index int = 1;
	BEGIN
	    FOR elem IN
            SELECT p.name as addition
            FROM alpha.client c
            join alpha.event e on c.client_id = e.client_id
            join alpha.position p on e.position_id = p.position_id
            WHERE c.client_id = input_client_id
            limit input_count
	    LOOP
                s = s || elem.addition;
                if input_index < input_count then
                    s = s || '', '';
                end if;
                input_index = input_index + 1;
                -- raise notice ''index = %'', input_index;
	    END LOOP;
        

        return s;
	END;
' LANGUAGE plpgsql;

select alpha.make_string(13);
