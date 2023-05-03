use crawled

									/*preprocessing*/
--remove duplicate records
with cte (duplicate_count, name, address, phone, timOpen, ratingAverage, priceRange, details)
as 
(select row_number() over (partition by name order by name) as duplicate_count, name, address, 
phone, timeOpen, ratingAverage, priceRange, details from restaurant)
delete from cte
where duplicate_count > 1

--remove null
delete from restaurant
where name is null or address is null
