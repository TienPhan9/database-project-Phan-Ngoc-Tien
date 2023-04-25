use crawled

select * from restaurant

--check Null and remove null
select *  from priceFix
where address is null

--Xóa duplicate records
--xóa
with cte (duplicate_count, name, address, phone, timOpen, ratingAverage, priceRange, details)
as 
(select row_number() over (partition by name order by name) as duplicate_count, name, address, 
phone, timeOpen, ratingAverage, priceRange, details from restaurant)
delete from cte
where duplicate_count > 1

--cột address

select reverse(substring(reverse(address), 1, 
case when charindex(',', reverse(address)) =0 then len(reverse(address))
else charindex(',', reverse(address)) - 1 end)) as City,
reverse(substring(reverse(address),  
case when charindex(',', reverse(address)) =0 then len(reverse(address))
else charindex(',', reverse(address)) + 1 end, 1000)) as detailAddress
into address_fixed from restaurant

--quận
select detailAddress from address_fixed

--where detailAddress like N'%quận%' or detailAddress like N'%Q%'

--số điện thoại
select isNull(phone, N'Liên hệ trực tiếp qua quầy nhà hàng') from restaurant
update restaurant
set phone = N'Chưa xác thực' where phone is null
--timeOpen
select count(*) from restaurant
where timeOpen = N'Đang đóng cửa:  Xem tất cả giờ'
--đoạn này làm thủ công

--ratingAverage
select cast(replace(ratingAverage, ',','.') as float) from restaurant

--priceRange
--null
select isNull(priceRange, N'Liên hệ với nhà hàng để biết khoảng giá') from restaurant
--check
select priceRange from restaurant
where priceRange != N'Liên hệ với nhà hàng để biết khoảng giá'
or priceRange not like '%[0-9]%'
--sửa
update restaurant
set priceRange = N'Liên hệ với nhà hàng để biết khoảng giá' where priceRange is null

--truy vấn
select *, 
replace(substring(priceRange, 1, case when charindex('-', priceRange) >0 
						then charindex('-', priceRange)-1 
						else charindex('-', priceRange) end), N'₫', '') as minimum  ,
replace(substring(priceRange, case when charindex('-', priceRange) >0 
						then charindex('-', priceRange)+1 
						else charindex('-', priceRange) end, 1000), N'₫', '') as maximum
into priceProcess from restaurant

--truy vấn trên priceProcess
update priceProcess
set minimum = N'Liên hệ với nhà hàng để biết khoảng giá '
where minimum = N'Liên hệ với nhà hàng để biết khoảng giá'

update priceProcess
set maximum = N'Liên hệ với nhà hàng để biết khoảng giá '
where maximum = N'Liên hệ với nhà hàng để biết khoảng giá'
select * from priceProcess



select  *, left(minimum, len(minimum)-1) as minimum_trim, 
left(maximum, len(maximum)-1) as maximum_trim
into priceFix from priceProcess

--xử lý 1 ký tự trước

--đối với kiểu không đồng bộ về min với max

--thêm 1 số 0 cho min
update priceFix
set minimum_trim = minimum_trim +'0'
where minimum_trim != N'Liên hệ với nhà hàng để biết khoảng gi'
and len(minimum_trim) =1 and len(maximum_trim) > 3

select *, len(minimum_trim) from priceFix
where minimum_trim != N'Liên hệ với nhà hàng để biết khoảng gi'
and len(minimum_trim) =6 and len(maximum_trim) =4

update priceFix
set minimum_trim = minimum_trim + '.000'
where minimum_trim != N'Liên hệ với nhà hàng để biết khoảng gi'
and len(minimum_trim) =2 and len(maximum_trim) > 3

update priceFix
set maximum_trim = maximum_trim + '.000'
where minimum_trim != N'Liên hệ với nhà hàng để biết khoảng gi'
and len(minimum_trim) =6 and len(maximum_trim) =4


--
select * from priceFix
where len(minimum_trim) = 1
order by minimum_trim
select *, len(minimum_trim) from priceFix
where minimum_trim != N'Liên hệ với nhà hàng để biết khoảng gi'
and len(minimum_trim) =1

update priceFix
set minimum_trim = minimum_trim + '0.000', maximum_trim = maximum_trim + '0.000'
where len(minimum_trim) = 1


--vấn đề: đồ ăn của các nhà hàng nước ngoài có thể có đơn giá khác nhau 
--xử lý outlier
SELECT name, address, priceRange, minimum_trim, maximum_trim 
FROM priceFix 
where len(minimum_trim) > 9 and minimum_trim != N'Liên hệ với nhà hàng để biết khoảng gi'

update priceFix
set minimum_trim = '83.647', maximum_trim = '883.647'
where len(minimum_trim) > 9 and minimum_trim != N'Liên hệ với nhà hàng để biết khoảng gi'

update priceFix
set minimum_trim = minimum_trim + '0.000', maximum_trim = maximum_trim + '0.000'
where minimum_trim != N'Liên hệ với nhà hàng để biết khoảng gi' and details like N'%Kiểu Mỹ%'
and len(minimum_trim) = 2


update priceFix
set minimum_trim = minimum_trim + '.000', maximum_trim = maximum_trim + '.000'
where minimum_trim != N'Liên hệ với nhà hàng để biết khoảng gi' and len(minimum_trim) = 2


update priceFix
set minimum_trim = minimum_trim + '.000', maximum_trim = maximum_trim + '.000'
where minimum_trim != N'Liên hệ với nhà hàng để biết khoảng gi' and len(minimum_trim) = 3

select minimum_trim, maximum_trim, name  from priceFix
where maximum_trim != N'Liên hệ với nhà hàng để biết khoảng gi' and len(maximum_trim)=6
order by len(maximum_trim) desc
update priceFix
set minimum_trim = '69.240', maximum_trim = '700.000'
where name = N'ZumWhere Đa Kao'

update priceFix
set minimum_trim = '69.240', maximum_trim = '700.000'
where name = N'ZumWhere Đa Kao'

update priceFix
set minimum_trim = '130.000', maximum_trim = '870.000'
where name = N'Bloom Saigon Restaurant (Non-Profit Restaurant)'

update priceFix
set minimum_trim = '300.000', maximum_trim = '7.000.000'
where maximum_trim != N'Liên hệ với nhà hàng để biết khoảng gi' and len(maximum_trim)=6

update priceFix
set minimum_trim = N'80.000', maximum_trim = N'500.000'
where details like N'%Pháp%'
and maximum_trim = N'Liên hệ với nhà hàng để biết khoảng gi'

update priceFix
set minimum_trim = N'80.000', maximum_trim = N'500.000'
where details like N'%Mỹ%'
and maximum_trim = N'Liên hệ với nhà hàng để biết khoảng gi'
order by len(minimum_trim), len(maximum_trim)

update priceFix
set minimum_trim = N'80.000', maximum_trim=N'700.000'
where details like N'%âu%'
and maximum_trim = N'Liên hệ với nhà hàng để biết khoảng gi'
order by len(minimum_trim), len(maximum_trim)

update priceFix
set minimum_trim = N'50.000', maximum_trim=N'250.000'

select * from priceFix
where details like N'%ý%'
and maximum_trim = N'Liên hệ với nhà hàng để biết khoảng gi'
order by len(minimum_trim), len(maximum_trim)

update priceFix
set minimum_trim = N'45.000', maximum_trim = N'243.675'
where maximum_trim = N'Liên hệ với nhà hàng để biết khoảng gi'
or details like N'%kiểu việt%'

select *, concat(minimum_trim, maximum_trim) from priceFix 
update priceFix 
set maximum_trim = ltrim(maximum_trim)

				-------------------------FINAL-----------------------
select name , phone, 
reverse(substring(reverse(address),  
case when charindex(',', reverse(address)) =0 then len(reverse(address))
else charindex(',', reverse(address)) + 1 end, 1000)) as detailAddress,
reverse(substring(reverse(address), 1, 
case when charindex(',', reverse(address)) =0 then len(reverse(address))
else charindex(',', reverse(address)) - 1 end)) as City,
timeOpen, 
cast(replace(ratingAverage, ',','.') as float) as rating,
details,
cast(replace(minimum_trim, '.','') as float) as beginning_price,
cast(replace(maximum_trim, '.','') as float) as ending_price
from priceFix


select avg(cast(replace(ratingAverage, ',','.') as float)) from priceFix
--xong xử lý giá



