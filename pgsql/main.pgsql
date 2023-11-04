-- UUID BEGIN

-- add the libs
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- generate random uuid
select uuid_generate_v4();

-- UUID END

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

-- define Aggregator based on adv function
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

-- string_agg() aggregator function to make a string list
select
  a.sell_date
  , count(distinct a.product) as num_sold
  , string_agg(distinct a.product, ',' order by a.product) as products
from Activities as a
group by a.sell_date
order by a.sell_date
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


In SQL, `CROSS APPLY` is an operator used to apply a table-valued function to each row of a result set produced by another table expression, such as a subquery or a derived table. This operator is especially useful when you want to join or correlate data from two tables in a way that a standard `JOIN` operation cannot achieve. Let me provide you with a basic example and use case to help you understand how `CROSS APPLY` works.

**Example Use Case: Employee Data**

Suppose you have two tables: one containing employee information and another containing a list of skills that employees possess. Heres a simplified representation of these tables:

**Employee Table (`Employees`):**

```
+----+--------+
| ID |  Name  |
+----+--------+
| 1  | Alice  |
| 2  | Bob    |
| 3  | Carol  |
+----+--------+
```

**Skills Table (`Skills`):**

```
+----+--------+
| ID | Skill  |
+----+--------+
| 1  | SQL    |
| 2  | Python |
| 3  | Java   |
+----+--------+
```

You want to find all employees along with the skills they possess, and you have a separate table-valued function that can retrieve the skills for each employee. This is where the `CROSS APPLY` operator comes into play.

**SQL Query Using CROSS APPLY:**

```sql
SELECT e.Name AS EmployeeName, s.Skill
FROM Employees e
CROSS APPLY (
    SELECT Skill
    FROM Skills
) AS s;
```

**Result of the CROSS APPLY Query:**

```
+--------------+--------+
| EmployeeName | Skill  |
+--------------+--------+
| Alice        | SQL    |
| Alice        | Python |
| Alice        | Java   |
| Bob          | SQL    |
| Bob          | Python |
| Bob          | Java   |
| Carol        | SQL    |
| Carol        | Python |
| Carol        | Java   |
+--------------+--------+
```

In this example, the `CROSS APPLY` operator is used to apply a subquery that selects all skills from the `Skills` table to each row of the `Employees` table. As a result, you get a cross join between employees and skills, listing all possible combinations of employees and skills.

This can be useful in various scenarios, such as when you need to generate combinations of data, perform calculations based on each row, or apply a function to each row individually. `CROSS APPLY` is particularly valuable when you want to work with table-valued functions that produce results based on each rows input.

NOTE: that cross join can achieve the same thing for this example:

SELECT e.Name AS EmployeeName, s.Skill
FROM Employees e
CROSS JOIN Skills s;



Another cross apply example:

Heres a slightly more complex example of using `CROSS APPLY` to demonstrate its utility in situations where you need to apply a function or subquery that is row-specific. In this example, well use a hypothetical scenario involving orders and order items:

Suppose you have two tables: `Orders` and `OrderItems`. The `Orders` table contains order information, and the `OrderItems` table contains details about the items in each order.

**Orders Table (`Orders`):**

```
+---------+------------+
| OrderID | OrderDate  |
+---------+------------+
|   1     | 2023-01-15 |
|   2     | 2023-02-20 |
|   3     | 2023-03-10 |
+---------+------------+
```

**OrderItems Table (`OrderItems`):**

```
+---------+------------+---------+--------+
| OrderID | ProductID  |  Quantity | Price  |
+---------+------------+---------+--------+
|   1     |     A      |    2     | 10.00  |
|   1     |     B      |    3     | 5.00   |
|   2     |     A      |    1     | 10.00  |
|   2     |     C      |    2     | 8.00   |
|   3     |     B      |    1     | 5.00   |
|   3     |     D      |    4     | 6.00   |
+---------+------------+---------+--------+
```

You want to retrieve a list of orders along with the total cost of each order, which requires calculating the total cost for each order by multiplying the quantity by the price for each item. This is a great use case for `CROSS APPLY` because you need to apply a row-specific calculation for each order.

**SQL Query Using CROSS APPLY:**

```sql
SELECT
    o.OrderID,
    o.OrderDate,
    oi.TotalCost
FROM Orders o
CROSS APPLY (
    SELECT SUM(Quantity * Price) AS TotalCost
    FROM OrderItems
    WHERE OrderID = o.OrderID
) AS oi;
```

**Result of the CROSS APPLY Query:**

```
+---------+------------+------------+
| OrderID | OrderDate  | TotalCost  |
+---------+------------+------------+
|   1     | 2023-01-15 |   40.00    |
|   2     | 2023-02-20 |   28.00    |
|   3     | 2023-03-10 |   30.00    |
+---------+------------+------------+
```

In this example, the `CROSS APPLY` operator is used to apply a subquery that calculates the total cost for each order by summing the products of `Quantity` and `Price` for that orders items. The key here is the correlation between the `OrderID` in the outer query (`Orders`) and the inner subquery (`OrderItems`). `CROSS APPLY` enables this row-specific calculation and allows you to retrieve the total cost for each order.

NOTE: group by can do this aswell:

SELECT
    o.OrderID,
    o.OrderDate,
    SUM(oi.Quantity * oi.Price) AS TotalCost
FROM Orders o
JOIN OrderItems oi ON o.OrderID = oi.OrderID
GROUP BY o.OrderID, o.OrderDate;


In this GROUP BY query, we join the Orders and OrderItems tables based on the OrderID, and then use the SUM function to calculate the total cost for each order. The result is the same as the previous CROSS APPLY example, but its more efficient and idiomatic for this kind of aggregation.

Using GROUP BY is generally preferred when you want to perform aggregate calculations like sums, averages, or counts, as its optimized for such operations. CROSS APPLY is more valuable when you need to apply row-specific logic or subqueries that depend on the individual rows in your result set.



-- group by hack

--- valid mysql
SELECT employee_id, department_id FROM Employee WHERE primary_flag = 'Y'
UNION
SELECT employee_id, department_id FROM Employee
GROUP BY employee_id
HAVING COUNT(department_id) = 1;

--- equal to this in postgres
SELECT employee_id, department_id
FROM Employee
WHERE primary_flag = 'Y'
UNION
SELECT employee_id, MAX(department_id) AS department_id
FROM Employee
GROUP BY employee_id
HAVING COUNT(department_id) = 1
