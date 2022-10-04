select
    name,
    total,
    cast((select avg(total) from alpha.client) as int)
from 
    alpha.client
where
    total > (select avg(total) from alpha.client)
order by 
    1, 2 desc
limit 
    10;