use crawled

								/*price*/

--practice on temp table	
select * into temp from restaurant

--work in temp table

--set id from each item
select row_number() over(order by name) as id, * into restaurant_copy from temp

--
select * from restaurant_copy

select id, name, details, substring(priceRange, 1, charindex(N'₫', priceRange)-2) as minimum, 
substring(substring(priceRange, charindex(N'₫', priceRange)+4, 1000),1,len(substring(priceRange, charindex(N'₫', priceRange)+4, 1000))-2) as maximum,
charindex(N'₫', priceRange),
priceRange from restaurant_copy
--where priceRange is not null
order by len(priceRange)

