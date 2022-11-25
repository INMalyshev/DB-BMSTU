create or replace function getClientName(input_client_id int) returns varchar(200) as
'
    select name from client where client_id = input_client_id;
' language sql;


create or replace function getClientInfo(input_client_id int) returns table(client_id int, name varchar(200), total int) as
'
begin
    return query
        select c.client_id, c.name, c.total
        from client as c
        where c.client_id = input_client_id;
end;
' language plpgsql;

create or replace procedure addToClientTotal
(
    toAdd int,
    input_client_id int
)
as '
    begin
        update client
        set total = total + toAdd
        where client_id = input_client_id;
    end;
' language plpgsql;
