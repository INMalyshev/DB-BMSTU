-- CREATE TYPE my_type AS
-- (
-- 	client_id int,
-- 	total int
-- );

-- DROP FUNCTION get_my_type(integer);
CREATE OR REPLACE FUNCTION get_my_type(client_id int)
RETURNS table 
(
    f1 my_type
)
AS $$
	plan = plpy.prepare(" 			\
        select client_id, total	\
        from alpha.client				\
        where client_id < $1;", ["INT"])

	run = plpy.execute(plan, [client_id])
	
	return run
$$ LANGUAGE plpython3u;

select get_my_type(13);

