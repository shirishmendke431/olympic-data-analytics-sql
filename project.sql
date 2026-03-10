use 29_oct_weekdays  ;
create table athletes(
	Id int,
    Name varchar(200),
    Sex char(1),
    Age int,
    Height float,
    Weight float,
    Team varchar(200),
    NOC char(3),
    Games varchar(200),
    Year int,
    Season varchar(200),
    City varchar(200),
    Sport varchar(200),
    Event varchar(200),
    Medal Varchar(50));
 
-- View the blank Athletes table
select * from athletes;

-- Location to add the csv
SHOW VARIABLES LIKE "secure_file_priv";

-- Load the data from csv file after saving to above location
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Athletes_Cleaned.csv'
into table athletes
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;

select count(*) from athletes ;

select count(medal) from athletes ; 

/*
Q1. Show how many medal counts present for entire data.

Q2. Show count of unique Sports are present in olympics.

Q3. Show how many different medals won by Team India in data.

Q4. Show event wise medals won by india show from highest to lowest medals won in order.

Q5. Show event and yearwise medals won by india in order of year.

Q6. Show the country with maximum medals won gold, silver, bronze

Q7. Show the top 10 countries with respect to gold medals

Q8. Show in which year did United States won most medals

Q9. In which sports United States has most medals

Q10. Find top 3 players who have won most medals along with their sports and country.

Q11. Find player with most gold medals in cycling along with his country.

Q12. Find player with most medals (Gold + Silver + Bronze) in Basketball also show his country.

Q13. Find out the count of different medals of the top basketball player.

Q14. Find out medals won by male, female each year . Export this data and plot graph in excel. */

/*
Q1. Show how many medal counts present for entire data. */
select distinct(medal) from athletes ;

select medal, count(medal) from athletes 
where medal != 'nomedal'
group by medal ;

truncate table athletes ;

-- medal wise counts
select medal ,  count(medal) from athletes 
where medal != 'nomedal'
group by medal ;


/*Q2. Show count of unique Sports are present in olympics.*/

select count(distinct(sport)) from athletes ;

/*Q3. Show how many different medals won by Team India in data.*/
select count(distinct(medal)) from athletes
where noc = 'ind' and medal != 'nomedal' ;

/* Q4. Show event wise medals won by india show from highest to lowest medals won in order. */
select event , count(medal) as c from athletes 
where noc = 'ind' and medal != 'nomedal'
group by event order by c desc ;


/* Q5. Show event and yearwise medals won by india in order of year. */
select event , year as y , count(medal) as c from athletes 
where noc = 'ind' and medal != 'nomedal'
group by event,y order by y ; 

/*Q6. Show the country with maximum medals won gold, silver, bronze */
select noc , count(medal) c
from athletes
where medal != 'nomedal'
group by noc order by c desc limit 1 ;

-- medal count in usa 
-- that is country with heighest medal count
select medal ,count(Medal)  from athletes 
where noc = 
(select noc from athletes
where medal != 'nomedal'
group by noc order by count(Medal) desc limit 1)
and medal != 'nomedal'
group by medal ;

/* Show the top 10 countries 
with respect to gold medals */

use 29_oct_weekdays ;
select noc ,  count(medal)
from athletes
where Medal = 'gold'
group by noc order by count(medal) desc limit 10 ;

select  noc  , team  ,count(medal) c
from athletes  
where medal  = 'gold' 
group  by  noc , team
order  by  c  desc  limit 10  ;

/* Q8. Show in which year did 
United States won most medals */
select noc,year, count(medal)
from athletes
where noc = 'usa' and
medal != 'nomedal' 
group by year,noc order by count(medal)
desc limit 1 ;

select year  , count(medal) c
from athletes  
where medal  !=  'nomedal' and  noc =  'USA'
group  by year
order  by  c  desc  limit 1  ;


/* 
Q9. In which sports United States has most medals
*/
select sport , count(medal) as c 
from athletes
where medal != 'nomedal' and 
noc = 'usa'
group by Sport order by c 
desc limit 1 ;


/*Q10. Find top 3 players who 
have won most medals along with their
sports and country. */

select name , sport , noc, count(medal) as c
from athletes
where medal != 'nomedal'
group by name,Sport,noc order by c
desc limit 3 ;

/*Q11. Find player with most gold medals in 
cycling along with his country. */

select name , sport, noc,count(medal) as c
from athletes
where medal = 'gold' and sport = 'cycling'
group by name ,sport,noc
order by  c
desc limit 2 ;


with cte as 
(select name , sport, noc,count(medal) as c
from athletes
where medal = 'gold' and sport = 'cycling' 
group by name ,sport,noc
order by  c),
cte2 as
(select * , dense_rank()
over(order by c desc ) as drk from cte ) 
select * from cte2
where drk = 1 ;


/*Q12. Find player with most medals 
(Gold + Silver + Bronze) 
in Basketball also show his country.*/

select name,noc,sport, count(medal) as c
from athletes
where sport = 'basketball' and medal != 'nomedal'
group by name,noc,sport
order by c desc limit 1 ;

-- COUNTRY  WITH HIGHEST MEDAL  FOR  GOLD  , SILVER  ,  BRONZE

with cte as (select medal,noc, count(medal) as c
from athletes
where sport = 'basketball' and medal != 'nomedal'
group by medal,noc
order by c desc),
cte2 as 
(SELECT * , DENSE_RANK()
OVER(PARTITION BY MEDAL  ORDER BY C DESC )AS RK FROM cte)
select * from cte2
where rk = 1 ;

/*Q13. Find out the count 
of different medals of the top basketball player */

select name,medal,count(medal)
from athletes
where name = (select name
from athletes
where sport = 'basketball' and medal != 'nomedal'
group by name
order by count(medal) desc limit 1)
group by name ,medal ;


/* Q14. Find out medals won by male, 
female each year . 
Export this data and plot graph in excel.*/

select sex ,year, count(medal) as c
from athletes
where medal != 'nomedal'
group by sex,year ;
