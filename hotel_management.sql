---Hotel Management Data Analysis focusing on revenue and loss through canceled bookings.

---create database hotel management
create database hotel_management;

---use database 
use hotel_management;

---showing all columns
Select *
From SHG_Booking_Data;

--- checking for nulls
select *
from SHG_Booking_Data
where Booking_Date is null;
--- No nulls for booking Date

select *
from SHG_Booking_Data
where Hotel is null;
---No nulls for column Hotel

select *
from SHG_Booking_Data
where Arrival_Date is null;
---No nulls for Arrival date
 
 select *
from SHG_Booking_Data
where Booking_ID is null;
---No nulls for Booking Id

select *
from SHG_Booking_Data
where Lead_Time is null;
---No null values

select *
from SHG_Booking_Data
where Nights is null;
---No null values

select *
from SHG_Booking_Data
where Guests is null;
---No nulls values.

select *
from SHG_Booking_Data
where Distribution_Channel is null;
---No null values

select *
from SHG_Booking_Data
where Customer_Type is null;
---No null values.

select *
from SHG_Booking_Data
where Deposit_type is null;
---No null values.

select *
from SHG_Booking_Data
where Avg_Daily_Rate is null;
---No null values.

select *
from SHG_Booking_Data
where Status is null;
---No null values

select *
from SHG_Booking_Data
where Cancelled is null;
---No null values

select *
from SHG_Booking_Data
where Revenue is null;
---No null values

select *
from SHG_Booking_Data
where [Revenue loss] is null;
---No null values


Select *
from SHG_Booking_Data
where Country is null;
--Null values found
	
Select country, count(*)
From SHG_Booking_Data
group by country
having country is null;
--- 488 null values found in country column

---Replacing Null Values
update SHG_Booking_Data
Set country = ISNULL(Country,'Portugal')
---Null values replaced with Nigeria.

---Adding column Season
Alter Table SHG_Booking_Data
Add Season varchar(50);

Update SHG_Booking_Data
Set Season = Case
                        When month(Booking_Date) in (12, 1, 2 ) then 'Winter'
			When month(Booking_Date) in (3, 4, 5) then 'Spring'
			when month(Booking_Date) in (6, 7, 8) then 'Summer'
			When month(Booking_Date) in (9, 10, 11) then 'Autumn'
			End;
---Column Season Added

---- Rename Season to Booking_Season
EXEC sp_rename 'SHG_Booking_Data.Season', 'Booking_Season', 'COLUMN';

---Adding column Arrival_Season
Alter Table SHG_Booking_Data
Add Arrival_Season varchar(50);

Update SHG_Booking_Data
Set Arrival_Season = Case
                        When month(Arrival_Date) in (12, 1, 2 ) then 'Winter'
			When month(Arrival_Date) in (3, 4, 5) then 'Spring'
			when month(Arrival_Date) in (6, 7, 8) then 'Summer'
			When month(Arrival_Date) in (9, 10, 11) then 'Autumn'
			End;

---ANALYSIS

---Customer type with more revenue and loss
select Customer_Type, sum(Revenue) as Revenue, sum(Revenue_Loss) as Loss
From SHG_Booking_Data
Group by Customer_Type
Order by Revenue Desc
--- Transient

----Distribution Channel with more revenue and loss
select Distribution_Channel, sum(Revenue) as Revenue, sum(Revenue_Loss) as Loss
From SHG_Booking_Data
Group by Distribution_Channel
Order by Revenue Desc;
---Online Travel Agent.


---Country with highest revenue and loss
select country, sum(Revenue) as Revenue, sum(Revenue_Loss) as Loss
From SHG_Booking_Data
Group by Country
Order by Revenue Desc;
--- Portugal

--- Booking Season with highest revenue and loss
select Booking_Season, sum(Revenue) as Revenue, sum(Revenue_Loss) as Loss
From SHG_Booking_Data
Group by Arrival_Season
Order by Revenue Desc;
---Winter

--- Arrival Season with highest revenue and loss
select Arrival_Season, sum(Revenue) as Revenue, sum(Revenue_Loss) as Loss
From SHG_Booking_Data
Group by Arrival_Season
Order by Revenue Desc;
---Summer

---Hotel with more revenue
select hotel, sum(Revenue) as Revenue, sum(Revenue_Loss) as Loss
From SHG_Booking_Data
Group by hotel
Order by Revenue Desc;
---City Hotel

---monthly Revenue and Loss.
select month(Booking_Date) as Booking_Month, sum(Revenue) as Revenue, sum(Revenue_Loss) as Loss
From SHG_Booking_Data
Group by month(Booking_Date)
Order by Revenue Desc;
---January got the highest revenue and loss.

---Yearly revenue and loss
select year(Booking_Date) as Booking_Year, sum(Revenue) as Revenue, sum(Revenue_loss) as Loss
from SHG_Booking_Data
group by year(Booking_Date);
---2016 got the highest revenue and loss.

---Yearly Revenue Increase
WITH yearly_sales As
              (Select year(Booking_Date) as Booking_Year,
               Sum(Revenue) as Total_Revenue
               from SHG_Booking_Data
                group by year(Booking_Date))

  Select *,
         lag(Total_Revenue) over(Order by Booking_Year) As Previous_year,
         Total_Revenue - lag(Total_Revenue) over(Order by Booking_Year) as Yearly_Increase
  from yearly_sales.
---Revenue increased annually from 2014 to 2016, followed by a significant decline in 2017.
   
---BOOKINGS
---%cancelled
Select Count(cancelled) as Bookings, 
        sum(cancelled) As Canceled_Booking,
		(sum(cancelled)/count(cancelled))*100 as Percent_Canceled
from SHG_Booking_Data
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
	
---- Rename Season to Booking_Season
EXEC sp_rename 'SHG_Booking_Data.Season', 'Booking_Season', 'COLUMN';



---Removing irrelevant column.
Alter Table  SHG_Booking_Data
Drop column18;
