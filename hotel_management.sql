---Hotel Management Data Analysis focusing on revenue and loss through canceled bookings.


---showing all columns
Select *
From dbo.Hotel

--- checking for nulls
select *
from dbo.hotel
where [Booking Date] is null
--- No nulls for booking Date

select *
from dbo.hotel
where Hotel is null
---No nulls for column Hotel

select *
from dbo.hotel
where [Arrival Date] is null
---No nulls for Arrival date
 
 select *
from dbo.hotel
where [Booking ID] is null
---No nulls for Booking Id

select *
from dbo.hotel
where [Lead Time] is null
---No null values

select *
from dbo.hotel
where [Nights] is null
---No null values

select *
from dbo.hotel
where [Guests] is null
---No nulls values.

select *
from dbo.hotel
where [Distribution Channel] is null
---No null values

select *
from dbo.hotel
where [Customer Type] is null
---No null values.

select *
from dbo.hotel
where [Deposit type] is null
---No null values.

select *
from dbo.hotel
where [Avg Daily Rate] is null
---No null values.

select *
from dbo.hotel
where [Status] is null
---No null values

select *
from dbo.hotel
where Cancelled is null
---No null values

select *
from dbo.hotel
where Revenue is null
---No null values

select *
from dbo.hotel
where [Revenue loss] is null
---No null values


Select *
from dbo.hotel
where Country is null
--Null values found
Select country, count(*)
From dbo.hotel
group by country
having country is null
--- 488 columns of null values

---Replacing Null Values
update dbo.hotel
Set country = ISNULL(Country,'Portugal')
---Null columns replaced with most used country Portugal..

---Adding column Season
Alter Table dbo.hotel
Add Season varchar(50)

Update dbo.hotel
Set Season = Case
            When month([Booking Date]) in (12, 1, 2 ) then 'Winter'
			When month([Booking Date]) in (3, 4, 5) then 'Spring'
			when month([Booking Date]) in (6, 7, 8) then 'Summer'
			When month([Booking Date]) in (9, 10, 11) then 'Autumn'
			End
---Column Season Added

---Removing irrelevant column.
Alter Table dbo.hotel
Drop column F18

---ANALYSIS

---Customer type with more revenue and loss
select [Customer Type], sum(Revenue) as Revenue, sum([Revenue Loss]) as Loss
From dbo.hotel
Group by [Customer Type]
Order by Revenue Desc
--- Transient

----Distribution Channel with more revenue and loss
select [Distribution Channel], sum(Revenue) as Revenue, sum([Revenue Loss]) as Loss
From dbo.hotel
Group by [Distribution Channel]
Order by Revenue Desc
---Online Travel Agent.


---Country with highest revenue and loss
select country, sum(Revenue) as Revenue, sum([Revenue Loss]) as Loss
From dbo.hotel
Group by Country
Order by Revenue Desc
--- Portugal

--- Season with highest revenue and loss
select Season, sum(Revenue) as Revenue, sum([Revenue Loss]) as Loss
From dbo.hotel
Group by Season
Order by Revenue Desc
---Winter


---Hotel with more revenue
select hotel, sum(Revenue) as Revenue, sum([Revenue Loss]) as Loss
From dbo.hotel
Group by hotel
Order by Revenue Desc
---City Hotel

---monthly Revenue and Loss.
select month([Booking Date])as Booking_Month, sum(Revenue) as Revenue, sum([Revenue Loss]) as Loss
From dbo.hotel
Group by month([Booking Date])
Order by Revenue Desc
---January got the highest revenue and loss.

--- Yearly revenue and loss
select year([Booking Date]) as Booking_Year, sum(Revenue) as Revenue, sum([Revenue loss]) as Loss
from dbo.hotel
group by year([Booking Date])

---Yearly Revenue Increase
WITH yearly_sales As
              (Select year([Booking Date]) as Booking_Year,
               Sum(Revenue) as Total_Revenue
               from dbo.hotel
                group by year([Booking Date]))

  Select *,
         lag(Total_Revenue) over(Order by Booking_Year) As Previous_year,
         Total_Revenue - lag(Total_Revenue) over(Order by Booking_Year) as Yearly_Increase
  from yearly_sales.


       
---BOOKINGS
---%cancelled
Select Count(cancelled) as Bookings, 
        sum(cancelled) As Canceled_Booking,
		(sum(cancelled)/count(cancelled))*100 as Percent_Canceled
from dbo.hotel
--- 37% canceled  hotel bookings.

--- Canceled booking by distribution Channel
  select [Distribution Channel], sum(cancelled) as Canceled_Bookings
  from Hotel
  group by [Distribution Channel]
---- Online Travel Agents canceled the highest number of bookings

---- Canceled Bookings by Customer Type
  select [Customer Type], sum(cancelled) as Canceled_Bookings
  from Hotel
  group by [Customer Type]
---- Transient customers canceled the highest number of bookings.






