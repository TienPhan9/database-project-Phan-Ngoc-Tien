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

--xong phần outlier
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






