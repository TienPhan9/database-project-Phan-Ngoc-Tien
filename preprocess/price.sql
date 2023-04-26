use crawled

								/*price*/

--practice on temp table	
select * into temp from restaurant

--work in temp table

--set id from each item
select row_number() over(order by name) as id, * into restaurant_copy from temp

--
select * from restaurant_copy

select id, name, details, 
replace(substring(priceRange, 1, charindex(N'₫', priceRange)-2), '.', '') as minimum, 
replace(substring(substring(priceRange, charindex(N'₫', priceRange)+4, 1000),1,len(substring(priceRange, charindex(N'₫', priceRange)+4, 1000))-2),'.', '') as maximum,
priceRange
into priceCook
from restaurant_copy
--where priceRange is not null
order by len(priceRange)

-->xong phần outlier
update priceCook
set minimum = right(minimum,5), maximum = right(maximum, 6)
where len(minimum)=10 or len(maximum) =10
--after this command, minimum is cleaned, turning to maximum
update priceCook
set maximum = right(maximum, 7)
where len(maximum) =9
--after this command, maximum is cleaned

--next, handle the distance of minimum and maximum is too large
--with distance = 6
update priceCook
set minimum = minimum + '00000'
where len(maximum) - len(minimum) =6

--with distance = 5
update priceCook
set minimum = minimum + '0000'
where len(maximum) - len(minimum) =5

--with distance = 4
update priceCook
set minimum = minimum + '000'
where len(maximum) - len(minimum) =4
--with distance = 3
/*in this case, there is a record that have minimum = 3 and maximum = 1000, so fix particularly
with each record*/
update priceCook
set minimum = minimum + '00'
where id = 2061

update priceCook
set minimum = minimum + '00000' , maximum = maximum + '0000'
where id = 1288

-------------
--handle data with values are too small
select *, len(maximum) from priceCook
--where len(minimum) =1 and len(maximum)=1
order by len(minimum), len(maximum)

--with minimum has len =1 and maximum has len =1
update priceCook
set minimum = minimum + '0000', maximum = maximum+ '00000'
where len(minimum) =1 and len(maximum)=1

--with minimum has len =1 and maximum has len =2
update priceCook
set minimum = minimum + '0000', maximum = maximum+ '0000'
where len(minimum) =1 and len(maximum)=2

--with minimum has len =1 and maximum has len =3
update priceCook
set minimum = minimum + '0000', maximum = maximum+ '000'
where len(minimum) =1 and len(maximum)=3

--with minimum has len =2 and maximum has len =2
update priceCook
set minimum = minimum + '000', maximum = maximum+ '0000'
where len(minimum) =2 and len(maximum)=2

--with minimum has len =2 and maximum has len =3
update priceCook
set minimum = minimum + '000', maximum = maximum+ '000'
where len(minimum) =2 and len(maximum)=3

--with minimum has len =3 and maximum has len =3

update priceCook
set minimum = minimum + '000', maximum = maximum+ '000'
where len(minimum) =3 and len(maximum)=3

--with minimum has len =3 and maximum has len =4
select *, len(maximum) from priceCook
--where len(minimum) =3 and len(maximum)=4
order by len(minimum), len(maximum)

update priceCook
set minimum = minimum + '00', maximum = maximum+ '00'
where len(minimum) =3 and len(maximum)=4

--with minimum has len =3 and maximum has len =5
update priceCook
set minimum = minimum + '000', maximum = maximum+ '0'
where len(minimum) =3 and len(maximum)=5

--with minimum has len =4 and maximum has len =4
update priceCook
set minimum = minimum + '00', maximum = maximum+ '00'
where len(minimum) =4 and len(maximum)=4

--finish dirty price, turning to null price
--NOTE
--with details like N'%Cà phê%Kiểu Á%Kiểu Việt%Đồ uống%'

update priceCook
set minimum = (select cast(avg(cast(minimum as bigint)) as varchar) from priceCook
where details like N'%Cà phê%Kiểu Á%Kiểu Việt%Đồ uống%' and priceRange is not null)
where details like N'%Cà phê%Kiểu Á%Kiểu Việt%Đồ uống%' and priceRange is null

--with details like N'Kiểu Việt'
update priceCook
set minimum = (select cast(avg(cast(minimum as bigint)) as varchar) from priceCook
where details like N'Kiểu Việt' and priceRange is not null)
where details like N'Kiểu Việt' and priceRange is null

/*where (details like N'%Kiểu Á%Kiểu Việt%'
 and details not like N'%Cà phê%Kiểu Á%Kiểu Việt%'*/

update priceCook
set minimum = (select cast(avg(cast(minimum as bigint)) as varchar) from priceCook
where (details like N'%Kiểu Á%Kiểu Việt%'
 and details not like N'%Cà phê%Kiểu Á%Kiểu Việt%')
and minimum is not null)
where (details like N'%Kiểu Á%Kiểu Việt%'
and details not like N'%Cà phê%Kiểu Á%Kiểu Việt%')
and minimum is null

/*with details like N'%Kiểu Á%' and details not like N'%Kiểu Á%Kiểu Việt%'
and details not like N'%Kiểu Việt%Kiểu Á%'
 and details not like N'%Cà phê%Kiểu Á%Kiểu Việt%'*/
update priceCook
 set minimum = (select cast(avg(cast(minimum as bigint)) as varchar) from priceCook
where (details like N'%Kiểu Á%' and details not like N'%Kiểu Á%Kiểu Việt%'
and details not like N'%Kiểu Việt%Kiểu Á%'
 and details not like N'%Cà phê%Kiểu Á%Kiểu Việt%')
and minimum is not null)
where (details like N'%Kiểu Á%' and details not like N'%Kiểu Á%Kiểu Việt%'
and details not like N'%Kiểu Việt%Kiểu Á%'
 and details not like N'%Cà phê%Kiểu Á%Kiểu Việt%')
and minimum is null
--with Kiểu Mỹ
update priceCook
set minimum = (select cast(avg(cast(minimum as bigint)) as varchar) from priceCook
where (details like N'%Kiểu Mỹ%' and 
details not like N'%Kiểu Á%' and details not like N'%Kiểu Á%Kiểu Việt%'
and details not like N'%Kiểu Việt%Kiểu Á%'
 and details not like N'%Cà phê%Kiểu Á%Kiểu Việt%') and 
minimum is not null)
where (details like N'%Kiểu Mỹ%' and 
details not like N'%Kiểu Á%' and details not like N'%Kiểu Á%Kiểu Việt%'
and details not like N'%Kiểu Việt%Kiểu Á%'
 and details not like N'%Cà phê%Kiểu Á%Kiểu Việt%') and 
minimum is null

--with Kiểu Nhật
update priceCook
set minimum = (select cast(avg(cast(minimum as bigint)) as varchar) from priceCook
where (details like N'%Kiểu Nhật%' and details not like N'%Kiểu Mỹ%' and 
details not like N'%Kiểu Á%' and details not like N'%Kiểu Á%Kiểu Việt%'
and details not like N'%Kiểu Việt%Kiểu Á%'
 and details not like N'%Cà phê%Kiểu Á%Kiểu Việt%') and 
minimum is not null)
where (details like N'%Kiểu Nhật%' and details not like N'%Kiểu Mỹ%' and 
details not like N'%Kiểu Á%' and details not like N'%Kiểu Á%Kiểu Việt%'
and details not like N'%Kiểu Việt%Kiểu Á%'
 and details not like N'%Cà phê%Kiểu Á%Kiểu Việt%') and 
minimum is null

--with 
update priceCook
set minimum = (select cast(avg(cast(minimum as bigint)) as varchar) from priceCook
where (details like N'%Kiểu Âu%' and details not like N'%Kiểu Nhật%' and details not like N'%Kiểu Mỹ%' and 
details not like N'%Kiểu Á%' and details not like N'%Kiểu Á%Kiểu Việt%'
and details not like N'%Kiểu Việt%Kiểu Á%'
 and details not like N'%Cà phê%Kiểu Á%Kiểu Việt%') and 
minimum is not null)
where (details like N'%Kiểu Âu%' and details not like N'%Kiểu Nhật%' and details not like N'%Kiểu Mỹ%' and 
details not like N'%Kiểu Á%' and details not like N'%Kiểu Á%Kiểu Việt%'
and details not like N'%Kiểu Việt%Kiểu Á%'
 and details not like N'%Cà phê%Kiểu Á%Kiểu Việt%') and 
minimum is null

--the rest will be added as rest values
update priceCook
set minimum = (
select cast(avg(cast(minimum as bigint)) as varchar) from priceCook
where minimum is not null)
where minimum is null

-->finish minimum

--maximum
--with details like N'%Cà phê%Kiểu Á%Kiểu Việt%Đồ uống%'
update priceCook
set maximum = (select cast(avg(cast(maximum as bigint)) as varchar) from priceCook
where details like N'%Cà phê%Kiểu Á%Kiểu Việt%Đồ uống%' and priceRange is null)
where details like N'%Cà phê%Kiểu Á%Kiểu Việt%Đồ uống%' and priceRange is null

--with details like N'Kiểu Việt'
update priceCook
set maximum = (select cast(avg(cast(maximum as bigint)) as varchar) from priceCook
where details like N'Kiểu Việt' and priceRange is not null)
where details like N'Kiểu Việt' and priceRange is null

/*where (details like N'%Kiểu Á%Kiểu Việt%'
 and details not like N'%Cà phê%Kiểu Á%Kiểu Việt%'*/

update priceCook
set maximum = (select cast(avg(cast(maximum as bigint)) as varchar) from priceCook
where (details like N'%Kiểu Á%Kiểu Việt%'
 and details not like N'%Cà phê%Kiểu Á%Kiểu Việt%')
and maximum is not null)
where (details like N'%Kiểu Á%Kiểu Việt%'
and details not like N'%Cà phê%Kiểu Á%Kiểu Việt%')
and maximum is null

/*with details like N'%Kiểu Á%' and details not like N'%Kiểu Á%Kiểu Việt%'
and details not like N'%Kiểu Việt%Kiểu Á%'
 and details not like N'%Cà phê%Kiểu Á%Kiểu Việt%'*/
update priceCook
 set maximum = (select cast(avg(cast(maximum as bigint)) as varchar) from priceCook
where (details like N'%Kiểu Á%' and details not like N'%Kiểu Á%Kiểu Việt%'
and details not like N'%Kiểu Việt%Kiểu Á%'
 and details not like N'%Cà phê%Kiểu Á%Kiểu Việt%')
and maximum is not null)
where (details like N'%Kiểu Á%' and details not like N'%Kiểu Á%Kiểu Việt%'
and details not like N'%Kiểu Việt%Kiểu Á%'
 and details not like N'%Cà phê%Kiểu Á%Kiểu Việt%')
and maximum is null
--with Kiểu Mỹ
update priceCook
set maximum = (select cast(avg(cast(maximum as bigint)) as varchar) from priceCook
where (details like N'%Kiểu Mỹ%' and 
details not like N'%Kiểu Á%' and details not like N'%Kiểu Á%Kiểu Việt%'
and details not like N'%Kiểu Việt%Kiểu Á%'
 and details not like N'%Cà phê%Kiểu Á%Kiểu Việt%') and 
maximum is not null)
where (details like N'%Kiểu Mỹ%' and 
details not like N'%Kiểu Á%' and details not like N'%Kiểu Á%Kiểu Việt%'
and details not like N'%Kiểu Việt%Kiểu Á%'
 and details not like N'%Cà phê%Kiểu Á%Kiểu Việt%') and 
maximum is null

--with Kiểu Nhật
update priceCook
set maximum = (select cast(avg(cast(maximum as bigint)) as varchar) from priceCook
where (details like N'%Kiểu Nhật%' and details not like N'%Kiểu Mỹ%' and 
details not like N'%Kiểu Á%' and details not like N'%Kiểu Á%Kiểu Việt%'
and details not like N'%Kiểu Việt%Kiểu Á%'
 and details not like N'%Cà phê%Kiểu Á%Kiểu Việt%') and 
maximum is not null)
where (details like N'%Kiểu Nhật%' and details not like N'%Kiểu Mỹ%' and 
details not like N'%Kiểu Á%' and details not like N'%Kiểu Á%Kiểu Việt%'
and details not like N'%Kiểu Việt%Kiểu Á%'
 and details not like N'%Cà phê%Kiểu Á%Kiểu Việt%') and 
maximum is null

--with 
update priceCook
set maximum = (select cast(avg(cast(maximum as bigint)) as varchar) from priceCook
where (details like N'%Kiểu Âu%' and details not like N'%Kiểu Nhật%' and details not like N'%Kiểu Mỹ%' and 
details not like N'%Kiểu Á%' and details not like N'%Kiểu Á%Kiểu Việt%'
and details not like N'%Kiểu Việt%Kiểu Á%'
 and details not like N'%Cà phê%Kiểu Á%Kiểu Việt%') and 
maximum is not null)
where (details like N'%Kiểu Âu%' and details not like N'%Kiểu Nhật%' and details not like N'%Kiểu Mỹ%' and 
details not like N'%Kiểu Á%' and details not like N'%Kiểu Á%Kiểu Việt%'
and details not like N'%Kiểu Việt%Kiểu Á%'
 and details not like N'%Cà phê%Kiểu Á%Kiểu Việt%') and 
maximum is null

--the rest will be added as rest values
update priceCook
set maximum = (
select cast(avg(cast(maximum as bigint)) as varchar) from priceCook
where maximum is not null)
where maximum is null

-->finish maximum
select * from priceCook
where len(minimum) > len(maximum) --check again

-----------------------------










