-- UUID BEGIN

-- add the libs
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- generate random uuid
select uuid_generate_v4();

-- UUID END

-- PADDING BEGIN

select left('thing here', 5); -- 'thing'
select right('thing here', 4); -- 'here'

select right('000' || 1, 3); -- '001'
select left(1 || '00', 3); -- '100'
-- OR
select lpad(1::text, 3, '0'); -- '001'
select rpad(1::text, 3, '0'); -- '100'

-- PADDING END

-- VARIABLES BEGIN

-- Declare basic variables
do $$
declare
   counter    integer := 1;
   first_name varchar(50) := 'John';
   last_name  varchar(50) := 'Doe';
   payment    numeric(11,2) := 20.5;
begin
   raise notice '% % % has been paid % USD',
       counter,
	   first_name,
	   last_name,
	   payment;
end $$;

-- Declare variable and store from query basic
do $$
declare
  film_title movies_movie.title%type;
  film_genre movies_movie.genre%type;
begin
  -- will only use first record even without limit
  select
  title
  , genre
  from movies_movie
  into film_title, film_genre
  limit 1
  ;
  raise notice 'Film title: %', film_title;
  raise notice 'Film genre: %', film_genre;
end; $$


-- Declare a rowtype variable dynamic
do
$$
declare
	rec record;
begin
	select id, title, genre
	into rec
	from movies_movie
  limit 1
  ;
	raise notice '% % %', rec.id, rec.title, rec.genre;
end;
$$
-- optional
language plpgsql;

-- Declare a rowtype variable dynamic loop through results
do
$$
declare
  rec record;
begin
	for rec in select title, genre
			from movies_movie
			order by genre
	loop
		raise notice '% (%)', rec.title, rec.genre;
	end loop;
end;
$$

-- Declare a rowtype variable
do $$
declare
  selected_movie movies_movie%rowtype;
begin
  select *
  from movies_movie
  into selected_movie
  limit 10
  ;
  raise notice 'The movie info is % %',
    selected_movie.title,
    selected_movie.genre;
end; $$

-- VARIABLES END

-- Necromancing:
-- New in PostgreSQL 9.3:
-- The LATERAL keyword
-- left | right | inner JOIN LATERAL
-- INNER JOIN LATERAL is the same as CROSS APPLY
-- and LEFT JOIN LATERAL is the same as OUTER APPLY
-- Example usage:
SELECT * FROM T_Contacts

--LEFT JOIN T_MAP_Contacts_Ref_OrganisationalUnit ON MAP_CTCOU_CT_UID = T_Contacts.CT_UID AND MAP_CTCOU_SoftDeleteStatus = 1
--WHERE T_MAP_Contacts_Ref_OrganisationalUnit.MAP_CTCOU_UID IS NULL -- 989


LEFT JOIN LATERAL
(
    SELECT
         --MAP_CTCOU_UID
         MAP_CTCOU_CT_UID
        ,MAP_CTCOU_COU_UID
        ,MAP_CTCOU_DateFrom
        ,MAP_CTCOU_DateTo
   FROM T_MAP_Contacts_Ref_OrganisationalUnit
   WHERE MAP_CTCOU_SoftDeleteStatus = 1
   AND MAP_CTCOU_CT_UID = T_Contacts.CT_UID

    /*
    AND
    (
        (__in_DateFrom <= T_MAP_Contacts_Ref_OrganisationalUnit.MAP_KTKOE_DateTo)
        AND
        (__in_DateTo >= T_MAP_Contacts_Ref_OrganisationalUnit.MAP_KTKOE_DateFrom)
    )
    */
   ORDER BY MAP_CTCOU_DateFrom
   LIMIT 1
-- Declare a rowtype variable dynamic
) AS FirstOE

-- null coalesce, ??, ISNULL
coalesce(thing1, thing2) as thing

-- copy to csv

copy (
  <query_here>
) to stdout with csv header;

-- add regular user to all users that dont have a accountType attr

insert into user_attribute -- insert from select example
(name, value, user_id, id)
  select DISTINCT
    'accountType' as name
    , 'REGULAR' as value
    , u.id as user_id
    , uuid_generate_v4() as id
  from user_entity as u
  where
  u.id not in (
    SELECT distinct
    ua.id
    from user_attribute as ua
    where
    ua.name = 'accountType'
  )
;

-- distinct on clause -- multi field distinct rows
select distinct on (group_id, product_code) p.*
from products p
join products e using (product_code) 
where e.group_id <> p.group_id
order by 3, 2 desc, 1 desc;

-- advanced 01
/* Wet Run */
BEGIN TRANSACTION;
WITH cte as (INSERT INTO ticket_crop_variety (field_application_ticket, crop_variety)
SELECT id, crop_variety FROM (
    select ticket.id as id, case when count(*) > 1 then null else MAX(fc.crop_variery) end as crop_variety  from ticket
        inner join field_application_ticket fat on ticket.id = fat.id
        inner join field_crop fc on fat.field = fc.field
            and fat.start_date >= fc.start_date
            and fat.end_date <= fc.end_date
        where ticket.team in (18351)   /*Declare team ids here*/
          and ticket.crop_year=2020    /*Declare Crop year here*/
          and ticket.full_ticket_number like 'FAE%'
          -- OR this which would be faster than the FAE% check
          -- and ticket.ticket_source = 4
          and fat.crop_variety is null GROUP BY ticket.id, ticket.team order by count(*) desc)
as sub where crop_variety is not null RETURNING field_application_ticket as fat_id, crop_variety as cv)

UPDATE field_application_ticket fat2 set crop_variety = cte.cv FROM cte where id = cte.fat_id;
ROLLBACK TRANSACTION ;

-- basic declare of variable
DECLARE var1 varchar;

-- query a sub json with ->> to get the field on the json
-- log.meta ->> 'old_value' is like doing log.meta.old_value
select
  op.id, op.original_id, op.start_date, log.created_date, log.meta
    from partner_integrations_jdfieldoplog log
    join partner_integrations_jdfieldoperation op on log.field_op_id = op.original_id and log.team_id = op.team_id
    where log.event_type = 'field_op_attribute_changed'
      and log.meta ->> 'attribute' = 'uom'
      and log.meta ->> 'new_value' = 'ozm'
      and log.meta ->> 'old_value' != 'ozm'
      -- Date interval
      and log.created_date > current_date - interval '7' day
;


-- CASTING
-- cast a jsonb to text in order to check if its an empty object
select * from test where foo::text <> '{}'::text;



-- BEGIN / END / EXISTS
DO
$$
    BEGIN
        IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'account')
        THEN
            UPDATE
                account a
            SET status = ${user_status}
            WHERE a.account_type = 0
              AND NOT exists(
                    SELECT NULL
                    FROM role_assignment ra
                             JOIN role r on ra.role = r.id
                    WHERE r.code = 'ADMIN'
                      AND ra.account = a.id);
        END IF;
    END
$$;

-- multi cte (like variables) use WITH at the beginning and just separate by commas
-- fix users with multiple accountType entries and set them to REGULAR users
with cte as (select
  ua.user_id as user_id
  , ua.name as attribute_name
  , count(*) as num_of_entries_for_attr_type
from user_attribute as ua
where ua.name = 'accountType'
group by ua.user_id, ua.name
having
  count(*) > 1
order by count(*) desc, ua.user_id
)
, deleted_user_ids as (delete --
  -- select user_id
from user_attribute
where name = 'accountType'
and user_id in (select distinct user_id from cte)
returning user_id
)
, uniq_deleted_user_ids as (select distinct user_id from deleted_user_ids)
, inserted_rows as (insert into user_attribute --
(name, value, user_id, id) --
  select
    'accountType' as name
    , 'REGULAR' as value
    , user_id as user_id
    , uuid_generate_v4() as id
  from uniq_deleted_user_ids
returning user_id, name, value --
)
select
  ue.username
  , ir.*
from inserted_rows as ir
inner join user_entity as ue on ue.id = ir.user_id
order by ue.username
;

-- define function that returns a table
create or replace function country(text)
returns table (id integer, first_name varchar, last_name varchar) as $$
begin
  return query
    select customer_id, customer.first_name, customer.last_name
    from customer
    inner join address on customer.address_id = address.address_id
    inner join city on address.city_id = city.city_id
    inner join country on city.country_id = country.country_id
    where country = $1;
end;
$$ language plpgsql;

-- define basic function
drop function if exists lowest_user_type;
CREATE FUNCTION lowest_user_type(varchar, varchar) RETURNS varchar
    AS 'select $1'
    LANGUAGE SQL
    IMMUTABLE
    RETURNS NULL ON NULL INPUT;

-- '

select lowest_user_type('first', 'second');

-- define adv function
drop function if exists lowest_user_type;
CREATE FUNCTION lowest_user_type(first varchar, second varchar) RETURNS varchar
    LANGUAGE plpgsql
    as
    $$
    declare
      res varchar;
    begin
    select
      case
        when (first = 'SALES') OR (second = 'SALES') then 'SALES'
        when (first = 'REGULAR') OR (second = 'REGULAR') then 'REGULAR'
        else 'SUPPORT'
      end as res
    into res
    ;
    return res;
    end;
    $$
    RETURNS NULL ON NULL INPUT;

select lowest_user_type('first', 'second');

-- define custom aggregator based on adv function
drop AGGREGATE if exists lowest_user_type_agg(varchar);
CREATE AGGREGATE lowest_user_type_agg (varchar)
(
    sfunc = lowest_user_type,
    stype = varchar,
    initcond = 'default'
);

-- mega amazing Aggregator, function, multi cte thing
drop function if exists lowest_user_type;
CREATE FUNCTION lowest_user_type(first varchar, second varchar) RETURNS varchar
    LANGUAGE plpgsql
    as
    $$
    declare
      res varchar;
    begin
    select
      case
        when (first = 'SALES') OR (second = 'SALES') then 'SALES'
        when (first = 'REGULAR') OR (second = 'REGULAR') then 'REGULAR'
        else 'SUPPORT'
      end as res
    into res
    ;
    return res;
    end;
    $$
    RETURNS NULL ON NULL INPUT;
-- select lowest_user_type('first', 'second');
drop AGGREGATE if exists lowest_user_type_agg(varchar);
CREATE AGGREGATE lowest_user_type_agg (varchar)
(
    sfunc = lowest_user_type,
    stype = varchar,
    initcond = 'default'
);
-- select lowest_user_type_agg('second');
with cte as (select
  ua.user_id as user_id
  , ua.name as attribute_name
  , count(*) as num_of_entries_for_attr_type
from user_attribute as ua
where ua.name = 'croptrackerAccountType'
group by ua.user_id, ua.name
having
  count(*) > 1
order by count(*) desc, ua.user_id
)
, deleted_user_entries as (-- delete
  select user_id, value --
from user_attribute
where name = 'croptrackerAccountType'
and user_id in (select distinct user_id from cte)
-- returning user_id
)
, uniq_deleted_users_entries as (
  select distinct
    due.user_id
    , lowest_user_type_agg(value) as lower_ut
  from deleted_user_entries as due
  group by due.user_id
)
, inserted_rows as (-- insert into user_attribute
-- (name, value, user_id)
  select
    'croptrackerAccountType' as name
    , lower_ut as value
    , user_id as user_id
  from uniq_deleted_users_entries
-- returning user_id, name, value
)
select
  ue.username
  , ir.*
from inserted_rows as ir
inner join user_entity as ue on ue.id = ir.user_id
order by ue.username
;
drop AGGREGATE if exists lowest_user_type_agg(varchar);
drop function if exists lowest_user_type;

-- for loop
DO $$ 
DECLARE
  value INT;
BEGIN
  FOR value IN (SELECT genre FROM movies_movie)
  LOOP
    RAISE NOTICE 'Value: %', value;
  END LOOP;
END $$;

-- while loop
DO $$ 
DECLARE
  counter INT := 1;
BEGIN
  WHILE counter <= 10 LOOP
    RAISE NOTICE 'Counter: %', counter;
    counter := counter + 1;
  END LOOP;
END $$;


-- avg fn cant take a condition directly like mysql. use a case statement
-- fines the ratio of confirmed to all confirmation requests
select
  su.user_id
  , round(coalesce(avg(case when action = 'confirmed' then 1 else 0 end), 0), 2) as confirmation_rate
from Signups as su
left join Confirmations as c on su.user_id = c.user_id
group by su.user_id
;

-- string_agg() aggregator function to make a string list-like
select
  a.sell_date
  , count(distinct a.product) as num_sold
  , string_agg(distinct a.product, ',' order by a.product) as products
from Activities as a
group by a.sell_date
order by a.sell_date
;

-- array_agg() aggregator function to make a list; array() to create an array out of a select result
-- a parameterized sql query to find other groups that have the same employees
prepare find_groups_with_matching_employees(text) as
select
  g.group_name
  , array_agg(g.employee_id order by g.employee_id) as employees
from groups g
where
  g.group_name <> $1
group by g.group_name
having
  array(
    select employee_id
    from groups
    where group_name = $1
    order by employee_id
  ) = array_agg(g.employee_id order by g.employee_id)
order by g.group_name;

-- rolling_average_pgsql
-- rolling average/aggregator with preceding and current row
-- also use lag to remove entries without preceding rows after work is done
-- https://leetcode.com/problems/restaurant-growth/submissions/?envType=study-plan-v2&envId=top-sql-50
with DayTotals as (
  select
    c.visited_on
    , sum(c.amount) as day_amount
  from Customer as c
  group by c.visited_on
)
, Result as (
select
  c.visited_on
  , sum(c.day_amount)
    over(order by c.visited_on rows between 6 preceding and current row)
    as amount
  , round(
      cast(
        avg(c.day_amount)
        over(order by c.visited_on rows between 6 preceding and current row)
      as numeric)
    , 2)as average_amount
  , lag(c.visited_on, 6, null) over (order by c.visited_on) as range_start
from DayTotals as c
order by c.visited_on
)
select
  r.visited_on
  , r.amount
  , r.average_amount
from Result as r
where r.range_start is not null
;

-- optimization of the last query
with DayTotals as (
select
    c.visited_on
    , sum(c.amount) as total
from Customer as c
group by c.visited_on
order by c.visited_on asc
)
, RollingAmounts as (
select
    dt.visited_on
    , sum(dt.total) over (rows between 6 preceding and current row) as amount
    , lag(dt.visited_on, 6, null) over () as start_of_range
from DayTotals as dt
)
select
    ra.visited_on
    , ra.amount
    , round(ra.amount / 7, 2) as average_amount
from RollingAmounts as ra
where
    ra.start_of_range is not null
;

select
    ra.visited_on
    , ra.amount
    , round(ra.amount / 7, 2) as average_amount
from (
  select
      dt.visited_on
      , sum(dt.total) over (rows between 6 preceding and current row) as amount
      , lag(dt.visited_on, 6, null) over () as start_of_range
  from (
      select
          c.visited_on
          , sum(c.amount) as total
      from Customer as c
      group by c.visited_on
      order by c.visited_on asc
  ) as dt
) as ra
where
    ra.start_of_range is not null
;

-- tuple used in 'in' check
Select 
    round(avg(order_date = customer_pref_delivery_date)*100, 2) as immediate_percentage
from Delivery
where (customer_id, order_date) in (
  Select customer_id, min(order_date) 
  from Delivery
  group by customer_id
);

-- TODO: look into this query window filter() and group every()
-- https://www.codewars.com/kata/642ed28eb8c5c206120581a9/sql
select
  customer_id,
  first_name || ' ' || last_name as customer_name,
  count(*) filter (where rental_date >= date '2005-04-01' and rental_date < date '2005-08-01') as num_rentals,
  string_agg(title || ': ' || rental_date::date, ' || ' order by rental_date::date desc, title) filter (where rental_date >= date '2005-04-01' and rental_date < date '2005-08-01') as films_rented
from customer
join rental using (customer_id)
join inventory using (inventory_id)
join film using (film_id)
group by customer_id
having 
  every(return_date is not null or rental_date::date + rental_duration >= date '2005-08-01') and
  count(*) filter (where rental_date >= date '2005-04-01' and rental_date < date '2005-08-01') >= 10
order by num_rentals desc, last_name


select '2019-07-27'::date - interval '30' day as day;


-- lead() example to get data from the next row into current row (doesnt remove next row)
-- lag() does the same but gets data from the prev row. its syntax is the exact same as lead
with sept_orders as (select
    o.customer_id
    , sum(o.order_amount) as total_orders
  from orders as o
  where
    date_part('MONTH', o.order_date) = 9
    and date_part('YEAR', o.order_date) = 2023
  group by o.customer_id
  order by o.customer_id desc
),
rebates_with_next as (
  select
    r.id,
    r.rebate_percentage,
    r.min_purchase,
    lead(r.min_purchase, 1, null) over (order by r.min_purchase) as next_min_purchase
  from rebates r
)
select
  so.customer_id
  , so.total_orders
  , r.rebate_percentage
from sept_orders as so
inner join
  rebates_with_next as r
    on so.total_orders between r.min_purchase and (r.next_min_purchase - 1)
       or (r.next_min_purchase is null and so.total_orders >= r.min_purchase)
;


-- conditional lag/lead data with case statement based on another lag/lead
select
  l.book_id
  , l.borrower_name
  , case 
    when l.book_id = lag(l.book_id) over (order by l.book_id, l.return_date)
      then lag(l.return_date, 1, null) over (order by l.book_id, l.return_date)
    else null
    end
    as start_date
  , l.return_date as return_date
from books as b
inner join loans as l on l.book_id = b.book_id
order by l.book_id, l.return_date
;


-- https://www.codewars.com/kata/64c0fd3bb57ecf0058e101dd/train/sql
-- partition with lag/lead is a group by in that subquery so that you dont need to group by the the whole query
-- used if you need non agged data that cant be grouped by
with ranked_loans as (
  select
    b.book_id
    , b.title
    , b.author
    , l.loan_id
    , l.borrower_name
    , l.return_date
    , lag(l.return_date) over (partition by l.book_id order by l.return_date) as previous_return_date
    , coalesce(l.return_date, current_date)
        - lag(l.return_date) over (partition by l.book_id order by l.return_date)
    as borrow_interval
  from books b
  join loans l on b.book_id = l.book_id
)
select
  book_id
  , title
  , author
  , loan_id
  , borrower_name
  , concat(borrow_interval, ' Days') as longest_borrow_interval
from ranked_loans
where borrow_interval = (
  select max(borrow_interval)
  from ranked_loans
)
order by loan_id
;

-- how to push nulls to the end of a query
order by days desc nulls last

# cast to an integer
select 1.0::integer;

-- Define the custom aggregate function
CREATE OR REPLACE FUNCTION weighted_avg_finalfunc(state numeric, weight_sum numeric) RETURNS numeric AS $$
BEGIN
  IF weight_sum = 0 THEN
    RETURN NULL;  -- Handle division by zero
  ELSE
    RETURN state / weight_sum;  -- Calculate the weighted average
  END IF;
END;
$$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION weighted_avg_sfunc(state numeric, value numeric, weight numeric, weight_sum numeric) RETURNS numeric AS $$
BEGIN
  state := state + (value * weight);
  weight_sum := weight_sum + weight;
  RETURN state;
END;
$$ LANGUAGE plpgsql;
-- Register the custom aggregate function
CREATE OR REPLACE AGGREGATE weighted_avg(numeric, numeric) (
  sfunc = weighted_avg_sfunc,
  stype = numeric,
  finalfunc = weighted_avg_finalfunc
);
-- Use the custom aggregate function in your SQL queries
-- For example:
SELECT weighted_avg(value, weight) FROM your_table;

-- pivot explained
In SQL, the `PIVOT` operation is used to transform data from rows into columns, effectively reshaping the result set of a query. This can be very useful when you want to aggregate or summarize data in a more structured form. Let me provide you with a basic example and use case to help you understand how `PIVOT` works.

**Example Use Case: Sales Data**

Suppose you have a table that contains sales data, and each row represents a sale with the following columns:

- `Product`: The name of the product sold.
- `Month`: The month in which the sale occurred.
- `Revenue`: The revenue generated from the sale.

Heres a simplified table called `Sales`:

```
+---------+---------+---------+
| Product |  Month  | Revenue |
+---------+---------+---------+
|   A     | January |   100   |
|   B     | January |   200   |
|   A     | February|   150   |
|   B     | February|   250   |
|   A     | March   |   120   |
|   B     | March   |   220   |
+---------+---------+---------+
```

You might want to transform this data to show the total revenue for each product in each month in a pivoted format. This is where the `PIVOT` operation comes into play.

**SQL Query Using PIVOT:**

```sql
SELECT *
FROM (
    SELECT Product, Month, Revenue
    FROM Sales
) AS SourceTable
PIVOT (
    SUM(Revenue)   -- Aggregation function
    FOR Month IN ('January', 'February', 'March') -- Values to pivot into columns
) AS PivotTable;
```

**Result of the PIVOT Query:**

```
+---------+---------+---------+---------+---------+
| Product | January | February| March   | April   |
+---------+---------+---------+---------+---------+
|   A     |   100   |   150   |   120   |   NULL  |
|   B     |   200   |   250   |   220   |   NULL  |
+---------+---------+---------+---------+---------+
```

In this example, the `PIVOT` operation has transformed the original row-based data into a column-based format, making it easier to see the total revenue for each product in each month. The `SUM(Revenue)` function is used to aggregate the revenue for each combination of `Product` and `Month`. The `FOR Month IN (...)` clause specifies the unique months that you want to pivot into columns.

This is just a basic example, and in real-world scenarios, you may have more complex data and aggregation requirements. `PIVOT` is a powerful tool for summarizing and restructuring data to make it more accessible for analysis and reporting.






CREATE TABLE Movies (
  movie_id serial PRIMARY KEY,
  title VARCHAR(255) NOT NULL
);

-- Create the Users table
CREATE TABLE Users (
  user_id serial PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

-- Create the MovieRating table
CREATE TABLE MovieRating (
  movie_id INT REFERENCES Movies(movie_id),
  user_id INT REFERENCES Users(user_id),
  rating INT,
  created_at DATE
);

-- Insert sample data into the Movies table
INSERT INTO Movies (title) VALUES ('Rebecca');

-- Insert sample data into the Users table
INSERT INTO Users (name) VALUES ('Rebecca');

-- Insert sample data into the MovieRating table
INSERT INTO MovieRating (movie_id, user_id, rating, created_at)
VALUES (1, 1, 5, '2020-02-12');



with NumOfRatings as (
  select
    mr.user_id
    , count(mr.movie_id) as num_of_ratings
  from MovieRating as mr
  group by mr.user_id
  order by num_of_ratings desc
)
, RankedRatings as (
  select
    r.user_id
    , r.num_of_ratings
    , rank() over (order by r.num_of_ratings desc) as rank
  from NumOfRatings as r
)
, UserResult as (
select
  u.name as results
from RankedRatings as rr
inner join Users as u on u.user_id = rr.user_id
where rr.rank = 1
order by u.name
limit 1
)
, RantedMovies as (
select
  m.movie_id
  , avg(m.rating) as avg_rating
from MovieRating as m
where
  m.created_at >= '2020-02-01'
  and m.created_at <= '2020-02-29'
group by m.movie_id
order by avg_rating desc
)
, RankedMovies as (
select
  m.movie_id
  , rank() over (order by avg_rating desc) as rank
from RantedMovies as m
)
, MovieResult as (
select
  m.title as results
from RankedMovies as rm
inner join Movies as m on m.movie_id = rm.movie_id
where rm.rank = 1
order by m.title
limit 1
)
select
  ur.results
from UserResult as ur
union all
select
  mr.results
from MovieResult as mr
;



-- for uuid_generate_v4
create EXTENSION if not exists "uuid-ossp";
with actionable_rows as (
  select distinct
    case
      when (IIF(1, UPPER(t1.title) = 'ADMIN', 'this path if 0/false')) or regexp_replace('We keep this stuff -delete everthing after the first occurence of "-"-also this stuff is deleted', '[|-][^|-]*$', '') = 'We keep this stuff -' then 'ADMIN'
      when (initcase(t2.name) = 'Title Case') or (lower(t2.name) = 'bob') then 'REGULAR'
      else 'DEFAULT_VALUE'
    end as name
    , coalesce (null, 'new_value', 'COALESCE selects the first non null value') as value
    , t2.id as table2_id
    , uuid_generate_v4() as id
  from table2 as t2
  where
  t2.id not in (
    select distinct
    t1.id
    from table1 as t1
    where
    t1.type = 'account'
    and t1.json_data ->> 'old_value' != 'junk'
    and t1.created_date > '12/01/23'::date - interval '7' day
    and t1.name in ('Bob', 'Ross')
    and t1.int_string::integer > 100,
  )
)
-- INSERT
-- INSERT INTO table1
-- (
--   name
--   , value
--   , table2_id
--   , id
-- )
select
  name
  , value
  , table2_id
  , id
from actionable_rows
;
-- OR UPDATE
--  update table1
--  set name=ar.name
--      , value=ar.value
--      , table2_id=ar.table2_id
--  from (
--   select
--     name
--     , value
--     , table2_id
--     , id
--   from actionable_rows
--   ) as ar
--  where table1.id=ar.id;
-- ;
-- OR DELETE
-- delete from table1
-- where
--   id in (select id from actionable_rows)
-- ;

CREATE TABLE Person (
  id serial PRIMARY KEY,
  email VARCHAR(255) NOT NULL
);
-- Insert sample data into the Person table
INSERT INTO Person (email) VALUES ('john@gmail.com');
INSERT INTO Person (email) VALUES ('john2@gmail.com');
INSERT INTO Person (email) VALUES ('john@gmail.com');

select
  min(p.id) as id
  , p.email
from Person as p
group by p.email
;

select
  *
from Person as p
;


delete from Person
  where
id in (
  select
    max(p.id) as id
  from Person as p
  group by p.email
  having count(p.email) > 1
)
;

delete from Person
  where
id not in (
  select
    min(p.id)
  from Person as p
  group by p.email
)
;


CREATE TABLE Employee (
  id serial PRIMARY KEY,
  salary integer NOT NULL
);
INSERT INTO Employee (salary) VALUES (50);
INSERT INTO Employee (salary) VALUES (500);
INSERT INTO Employee (salary) VALUES (5000);

with RankedSalaries as (
  select
    dense_rank() over (order by e.salary desc) as rank
    , e.salary
  from Employee as e
)
, Result as (
  select
    rs.salary
    , rs.rank
  from RankedSalaries as rs
  where rs.rank = 2
  limit 1
)
select
  r.salary as SecondHighestSalary
from (
  select 2 as rank, null as salary
) as t
left join Result as r on r.rank = t.rank
;


CREATE TABLE Insurance (
    pid serial PRIMARY KEY,
    tiv_2015 numeric(8, 2),
    tiv_2016 numeric(8, 2),
    lat numeric(5, 1),
    lon numeric(5, 1)
);

INSERT INTO Insurance (tiv_2015, tiv_2016, lat, lon) VALUES
    (224.17, 952.73, 32.4, 20.2),
    (224.17, 900.66, 52.4, 32.7),
    (824.61, 645.13, 72.4, 45.2),
    (424.32, 323.66, 12.4, 7.7),
    (424.32, 282.9, 12.4, 7.7),
    (625.05, 243.53, 52.5, 32.8),
    (424.32, 968.94, 72.5, 45.3),
    (624.46, 714.13, 12.5, 7.8),
    (425.49, 463.85, 32.5, 20.3),
    (624.46, 776.85, 12.4, 7.7),
    (624.46, 692.71, 72.5, 45.3),
    (225.93, 933, 12.5, 7.8),
    (824.61, 786.86, 32.6, 20.3),
    (824.61, 935.34, 52.6, 32.8);



-- roughly 708 to high atm
-- expect
-- | tiv_2016 |
-- | -------- |
-- | 4220.72  |


with UniqLocs as (
  select
    max(i.lat) as lat
    , max(i.lon) as lon
  from Insurance as i
  group by concat(i.lat::varchar(255), i.lon::varchar(255))
  having count(concat(i.lat::varchar(255), i.lon::varchar(255))) = 1
)
select distinct on (i1.pid)
  round(
    cast(
      sum(i1.tiv_2016)
    as numeric)
  , 2) as tiv_2016
from Insurance as i1
inner join Insurance as i2 on i1.tiv_2015 = i2.tiv_2015 and i1.pid <> i2.pid
where
  (i1.lat, i1.lon) in (
    select
      ul.lat
      , ul.lon
    from UniqLocs as ul
  )
;

with UniqLocs as (
  select
    max(i.lat) as lat
    , max(i.lon) as lon
  from Insurance as i
  group by concat(i.lat::varchar(255), i.lon::varchar(255))
  having count(concat(i.lat::varchar(255), i.lon::varchar(255))) = 1
)
, Pids as (
  select distinct
    i1.pid
  from Insurance as i1
  inner join Insurance as i2 on i1.tiv_2015 = i2.tiv_2015 and i1.pid <> i2.pid
  where
    (i1.lat, i1.lon) in (
      select
        ul.lat
        , ul.lon
      from UniqLocs as ul
    )
)
select
  round(
    cast(
      sum(i.tiv_2016)
    as numeric)
  , 2) as tiv_2016
from Insurance as i
inner join Pids as p on p.pid = i.pid
;

-- OR BETTER:

with UniqLocs as (
  select
    max(i.lat) as lat
    , max(i.lon) as lon
  from Insurance as i
  group by concat(i.lat::varchar(255), i.lon::varchar(255))
  having count(concat(i.lat::varchar(255), i.lon::varchar(255))) = 1
)
, Recs as (
    select distinct on (i1.pid)
        i1.*
    from Insurance as i1
    inner join Insurance as i2 on i1.tiv_2015 = i2.tiv_2015 and i1.pid <> i2.pid
    inner join UniqLocs as ul on ul.lat = i1.lat and ul.lon = i1.lon
)
select
  round( cast( sum(i.tiv_2016) as numeric) , 2) as tiv_2016
from Recs as i
;

CREATE TABLE Department (
    id serial PRIMARY KEY,
    name varchar(255)
);

CREATE TABLE Employee (
    id serial PRIMARY KEY,
    name varchar(255),
    salary numeric(10, 2),
    departmentId integer REFERENCES Department(id)
);

INSERT INTO Department (id, name) VALUES
    (1, 'IT'),
    (2, 'Sales');

INSERT INTO Employee (id, name, salary, departmentId) VALUES
    (1, 'Joe', 85000, 1),
    (2, 'Henry', 80000, 2),
    (3, 'Sam', 60000, 2),
    (4, 'Max', 90000, 1),
    (5, 'Janet', 69000, 1),
    (6, 'Randy', 85000, 1),
    (7, 'Will', 70000, 1);

with RankedEmps as (
  select
    e.id
    , e.name
    , e.salary
    , e.departmentId
    , dense_rank() over (partition by e.departmentId order by e.salary desc) as dept_rank
  from Employee as e
)
select
  d.name as Department
  , re.name as Employee
  , re.salary as Salary
from RankedEmps as re
inner join Department as d on d.id = re.departmentId
where
  re.dept_rank < 4
order by re.departmentId, re.salary desc
;


select
case when extract(year from
age(now(), (now() - interval '2 year' - interval '10 day'))
) between 1 and 2
then 'ya'
else '100'
end as t
;
