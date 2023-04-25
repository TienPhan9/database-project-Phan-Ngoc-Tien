use crawled

--ratingAverage

--there are two records having null in ratingAverage
update restaurant
set ratingAverage = '4,7'
where name = N'Oslo Club'

update restaurant
set ratingAverage = '3.9'
where name = N'Pasteur Street Brewing Company'

-----
update restaurant
set ratingAverage = cast(replace(ratingAverage, ',','.') as float)

