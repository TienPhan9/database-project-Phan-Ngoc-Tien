use crawled

--detail
update restaurant
set details = N'Món kết hợp'
where details is null

select iif(patindex('%[0-9]%', details)>0, 
substring(details, charindex(',', details)+2, 1000), 
details)
from restaurant

update restaurant
set details = iif(patindex('%[0-9]%', details)>0, 
substring(details, charindex(',', details)+2, 1000), 
details)

--select * from restaurant
--cross apply string_split(details, ',')