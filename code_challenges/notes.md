# Tips

## High level

break problem into small units
  sometimes better to think of a set of actions as 1 action
    ex: matrix spiral - right,down,left,up is 1 action (or the body) of the while loop

try to do it by hand or quickly mentally

make sure you understand all of the rules. also consider heuristics that you can add to the rule set given

how much data do you have access to for each decision? if all, then you can do quite a bit more than if you can just see the next step

## Practical

consider the bounds of the problem. does complexity matter? dont be over general - consider heuristics that work for the problem

common variable names:
  matrix: [cy, cx];
  curI, cache(or memo)/seen, curN, prevI, prevN, nextI, nextN
  idx (index)

work in the smallest units for your problem
  if the problem wants hours, minutes, seconds, work in seconds as long as possible

dynamic programming - save (many) partial results along the way. usually mutating the data structure
  go through a maze backwards
    questions can be worded to make you think of going down. try going up

caching (usually a dictionary or a set):
  up front cacheing
  cacheing as you go - seen

stack:
  good for parsing validation - matching open/close
  building basic calculator parser

priority queue:
  for quick location of either min or max value for mutation
    ex: customers queued at a grocery store waiting for a teller to open up

scheduling:
  if goal is to minimize diff between values then schedule the highest weights first

numbers:
  mod 2 or 10 or 60 or 256
    mod can be used to aggregate from 1 number into another. just remember to floor/integer division the source number each iteration
  think of equations
    compliment: c = a + b or b = c - a
  TODO: bitwise notes

regex:
  consider. greedy vs non-greedy matching
    usually used to match the 'rest'
  positive look ahead assertion to check if a pattern is contained in the string
    can be useful to simplify a regex. where you have a general pattern and then extra checks to see if the string contains something
    ex: does the string contain a digit? where the string containes _'s and s's (or the general pattern)
      ^(?=.*\d)[_s]*$
  negative look ahead assertion to check if a pattern is NOT contained in the string
    ex: does the string NOT contain a digit? where the string containes _'s and s's (or the general pattern)
      ^(?!.*\d)[_s]*$
  back reference: check if the same pattern that was matched earlier occurs again
    ex: ^(\w+)\s+\1$
      matches: apple apple
      doesnt match apple banana
  non-capture group: (?:<pattern>)

while loop:
  typical to have to repeat a step after a while loop is done

### Minor things to remember

lists:
  chunking

strings:
  padding

## SQL

consider if a union of simple queries will solve your problem

when records of 1 table need to do something with other records of the same table. its a self join or window (frame) functions. not a custom agg function

  window functions:

    lead() to get data from the next row into current row (doesnt remove next row)

    lag() does the same but gets data from the prev row. its syntax is the exact same as lead

    row_number(): assigns a unique integer to each row within the result set, based on the specified ordering.

    rank(): assigns a unique rank to each row within the result set, with the same rank given to rows with equal values. it leaves gaps in case of ties.

    sum(): accumulates prev rows into a partial sum for each row. the last row will have the total sum

    dense_rank(): similar to rank, but it does not leave gaps in the ranking for tied values.

    ntile(n): divides the result set into "n" roughly equal parts and assigns a tile number to each row based on the specified ordering.

    first_value(): returns the value of a specified column for the first row in each window frame.

    last_value(): returns the value of a specified column for the last row in each window frame.

    nth_value(): returns the value of a specified column for the nth row within the window frame.

    NOTE: the over clause could be blank if the order and groupings of the root query are what you want in the sub window query
      ex: dense_rank() over() as rank

window frame rolling aggregator:
  rolling average/aggregator with preceding and current row
    also use lag to remove entries without preceding rows after work is done
    ex: rolling_average_pgsql in main.pgsql

string_agg(distinct a.product, ',' order by a.product): aggregator to make string list

UNION vs UNION ALL
  UNION - removes dups
  UNION ALL - keeps dups

creating list of records can be done with selects tied together with unions. or you create a temp table and load the temp table
  example:
    SELECT 'Low Salary' AS type
    UNION
    SELECT 'Average Salary'
    UNION
    SELECT 'High Salary'
  OR:
    CREATE TABLE my_table (
      column_name CHAR(1)
    );
    INSERT INTO my_table (column_name) VALUES ('a');
    INSERT INTO my_table (column_name) VALUES ('b');
    INSERT INTO my_table (column_name) VALUES ('c');

cross join when you need all occurences even when they dont exist. cartensian product. use when you want even more partial data than left join

count(1) != count(something) sometimes it does, but if you want to count a thing, its better to think about counting said thing than 1

find the last usually means find the max

find the first usually means find the min

can use alias in order by and group by instead of copy pasting the whole expression from the select statement

distinct can be used on an individal field in a select clause if a group by is involved

round(cast(<expr> as numeric)) -- numeric is key if you have issues

groupby can exist in subquery/cte without being annoy.

ctes can be used to precalcuate subqueries given the subquery does not depend on the root query

in expr can do checks on lists of tuples

to push nulls to the end: order by field desc nulls last

'partition by' with lag/lead is a group by in that subquery so that you dont need to group by the the whole query
  used if you need non agged data that cant be grouped by

if multiple of a field and you expect single for each value of the field, throw a distinct query earlier in the join chain (proly as the first query)

common complex join order: (left join distinct query or cartensian product query) to (cte) to (actual tables)

optimizations:

  sometimes doing multiple simple queries that pass through the same table is faster than using group bys,ctes,joins

Features to look into:

There are several less common but highly useful SQL features and techniques that can be powerful tools for specific tasks. Here are some of them:

  Common Table Expressions (CTEs): CTEs are temporary result sets that you can reference within a SELECT, INSERT, UPDATE, or DELETE statement. They can make your SQL queries more readable and modular, especially when dealing with complex queries.

  Recursive Queries: Recursive queries are used to work with hierarchical or tree-structured data. They allow you to traverse and manipulate hierarchical data using a recursive common table expression (CTE).

  PIVOT and UNPIVOT: These operations allow you to transform rows into columns (PIVOT) and columns into rows (UNPIVOT). They are particularly useful for generating summary reports from normalized data.

  Full-Text Search: Full-text search capabilities are provided by some database systems like SQL Server and PostgreSQL. They allow you to search for text patterns within textual data efficiently.

  Regular Expressions: Some database systems support regular expression functions (e.g., REGEXP or RLIKE) for pattern matching within text data. These are powerful for text data analysis.

  Array and JSON Data Types: Modern database systems like PostgreSQL and MongoDB support array and JSON data types. These are useful for storing and querying structured and semi-structured data within a single column.

  Materialized Views: Materialized views are precomputed tables that store the results of a query. They can be refreshed periodically and are useful for improving query performance when dealing with complex joins or aggregations.

  Temporary Tables: Temporary tables are useful for storing intermediate results during complex data processing. They are temporary in nature and can be used in the context of a single session or transaction.

  Analytic Functions: Analytic functions, like SUM() OVER () or AVG() OVER (), are different from aggregate functions and provide cumulative or running totals, averages, and other windowed calculations.

  Cross Apply and Outer Apply: These are advanced join operators that allow you to apply a table-valued function to each row of another table. They are not as common as standard joins but can be very powerful.

  Database Partitioning: Partitioning is a technique used to divide large tables into smaller, more manageable pieces. It can improve query performance for large datasets.

  Geospatial and GIS Functions: Some databases have built-in functions for working with geospatial data, making it easier to perform operations like distance calculations and geographic data analysis.

### PGSQL

  groupby: every non aggregated value used in the select clause needs to be in the group by.
    1 option: if you need it, just add it to the group by, dont think to hard about it
    2 option: if you cant add the thing to the group by. adding it to the having based on an aggregator and the select based on an aggregator could be it
      example: to get employees with 1 single dept in the table and get the dept value
        SELECT employee_id, department_id
        FROM Employee
        WHERE primary_flag = 'Y'
        UNION
        SELECT employee_id, MAX(department_id) AS department_id
        FROM Employee
        GROUP BY employee_id
        HAVING COUNT(department_id) = 1
        ;
      this is the same as this in mysql:
        SELECT employee_id, department_id FROM Employee WHERE primary_flag = 'Y'
        UNION
        SELECT employee_id, department_id FROM Employee
        GROUP BY employee_id
        ;
## mongodb

typical aggregate step order:

  group (aggregator/prep table prior to join) (for more complex queries)
  lookup (left join)
  match (where)
  group (aggregator)
  project (fields to select)
  sort (order by)
