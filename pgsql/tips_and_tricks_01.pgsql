-- https://pgdash.io/blog/postgres-tips-and-tricks.html
-- tips and tricks are from the above

-- Insert Multiple Rows In One Statement
-- The INSERT statement can insert more than one row in a single statement:
INSERT INTO planets (name, gravity)
     VALUES ('earth',    9.8),
            ('mars',     3.7),
            ('jupiter', 23.1);

-- Insert If Not Existing, Update Otherwise (UPSERT)
-- In Postgres 9.5 and later, you can upsert directly using the ON CONFLICT construct:
CREATE TABLE parameters (
    key   TEXT PRIMARY KEY,
    value TEXT
);
-- when "key" causes a constraint violation, update the "value"
INSERT INTO parameters (key, value) 
     VALUES ('port', '5432')
ON CONFLICT (key) DO
            UPDATE SET value=EXCLUDED.value;

-- Copy Rows From One Table Into Another
-- The INSERT statement has a form where the values can be supplied by a SELECT statement. Use this to copy rows from one table into another:
-- copy between tables with similar columns 
  INSERT INTO pending_quests
SELECT * FROM quests
        WHERE progress < 100;
-- supply some values from another table, some directly
  INSERT INTO archived_quests
       SELECT now() AS archival_date, *
         FROM quests
        WHERE completed;

-- Update a Few Random Rows and Return The Updated Ones
-- Here’s how you can choose a few random rows from a table, update them and return the updated ones, all in one go:
WITH lucky_few AS (
    SELECT id
      FROM players
  ORDER BY random()
     LIMIT 5
)
   UPDATE players
      SET bonus = bonus + 100 
    WHERE id IN (SELECT id FROM lucky_few)
RETURNING id;

-- Create a Table Just Like Another Table
-- Use the CREATE TABLE .. LIKE construct to create a table with the same columns as another:
CREATE TABLE to_be_audited (LIKE purchases);
-- By default this does not create similar indexes, constraints, defaults etc. To do that, ask Postgres explicitly:
CREATE TABLE to_be_audited (LIKE purchases INCLUDING ALL);
-- See the full syntax here.

-- Create a Table From a Select Query
-- You can use the CREATE TABLE .. AS construct to create the table and populate it from a SELECT query, all in one go:
CREATE TABLE to_be_audited AS
      SELECT *
        FROM purchases
 TABLESAMPLE bernoulli(10)
       WHERE transaction_date = CURRENT_DATE;
-- The resultant table is like a materialized view without a query associated with it. Read more about CREATE TABLE .. AS here.

-- Create Unlogged Tables
-- Unlogged tables are not backed by WAL records. This means that updates and deletes to such tables are faster, but they are not crash-tolerant and cannot be replicated.
CREATE UNLOGGED TABLE report_20200817 (LIKE report_v3);

-- Create Temporary Tables
-- Temporary tables are implicitly unlogged tables, with a shorter lifetime. They automatically self-destruct at the end of a session (default), or at the end of the transaction.
-- Data within temporary tables cannot be shared across sessions. Multiple sessions can create temporary tables with the same name.
-- temp table for duration of the session
CREATE TEMPORARY TABLE scratch_20200817_run_12 (LIKE report_v3);
-- temp table that will self-destruct after current transaction
CREATE TEMPORARY TABLE scratch_20200817_run_12
                      (LIKE report_v3)
                      ON COMMIT DROP;
-- temp table that will TRUNCATE itself after current transaction
CREATE TEMPORARY TABLE scratch_20200817_run_12
                       (LIKE report_v3)
                       ON COMMIT DELETE ROWS;
-- Add Comments
-- Comments can be added to any object in the database. Many tools, including pg_dump, understand these. A useful comment might just avoid a ton of trouble during cleanup!
COMMENT ON INDEX idx_report_last_updated
        IS 'needed for the nightly report app running in dc-03';
COMMENT ON TRIGGER tgr_fix_column_foo
        IS 'mitigates the effect of bug #4857';

-- Advisory Locks
-- Advisory locks can be used to co-ordinate actions between two apps connected to the same database. You can use this feature to implement a global, distributed mutex for a certain operation, for example. Read all about it here in the docs.
-- client 1: acquire a lock 
SELECT pg_advisory_lock(130);
-- ... do work ...
SELECT pg_advisory_unlock(130);
-- client 2: tries to do the same thing, but mutually exclusive
-- with client 1
SELECT pg_advisory_lock(130); -- blocks if anyone else has held lock with id 130
-- can also do it without blocking:
SELECT pg_try_advisory_lock(130);
-- returns false if lock is being held by another client
-- otherwise acquires the lock then returns true

-- Aggregate Into Arrays, JSON Arrays or Strings
-- Postgres provides aggregate functions that concatenate values in a GROUP to yield arrays, JSON arrays or strings:
-- get names of each guild, with an array of ids of players that
-- belong to that guild
  SELECT guilds.name AS guild_name, array_agg(players.id) AS players
    FROM guilds
    JOIN players ON players.guild_id = guilds.id
GROUP BY guilds.id;
-- same but the player list is a CSV string
  SELECT guilds.name, string_agg(players.id, ',') -- ...
-- same but the player list is a JSONB array
  SELECT guilds.name, jsonb_agg(players.id) -- ...
-- same but returns a nice JSONB object like so:
-- { guild1: [ playerid1, playerid2, .. ], .. }
SELECT jsonb_object_agg(guild_name, players) FROM (
  SELECT guilds.name AS guild_name, array_agg(players.id) AS players
    FROM guilds
    JOIN players ON players.guild_id = guilds.id
GROUP BY guilds.id
) AS q;
-- Aggregates With Order
-- While we’re on the topic, here’s how to set the order of values that are passed to the aggregate function, within each group:
-- each state with a list of counties sorted alphabetically
  SELECT states.name, string_agg(counties.name, ',' ORDER BY counties.name)
    FROM states JOIN counties
    JOIN states.name = counties.state_name
GROUP BY states.name;
-- Yes, there is a trailing ORDER BY clause inside the function call paranthesis. Yes, the syntax is weird.

-- Array and Unnest
-- Use the ARRAY constructor to convert a set of rows, each with one column, into an array. The database driver (like JDBC) should be able to map Postgres arrays into native arrays and might be easier to work with.
-- convert rows (with 1 column each) into a 1-dimensional array
SELECT ARRAY(SELECT id FROM players WHERE lifetime_spend > 10000);
-- The unnest function does the reverse – it converts each item in an array to a row. They are most useful in cross joining with a list of values:
    SELECT materials.name || ' ' || weapons.name
      FROM weapons
CROSS JOIN UNNEST('{"wood","gold","stone","iron","diamond"}'::text[])
           AS materials(name);
-- returns:
--     ?column?
-- -----------------
--  wood sword
--  wood axe
--  wood pickaxe
--  wood shovel
--  gold sword
--  gold axe
-- (..snip..)

-- Combine Select Statements With Union
-- You can use the UNION construct to combine the results from multiple similar SELECTs:
-- Use CTEs to further process the combined result:
WITH fight_equipment AS (
    SELECT name, damage FROM weapons
    UNION
    SELECT name, damage FROM tools
)
  SELECT name, damage
    FROM fight_equipment
ORDER BY damage DESC
   LIMIT 5;
-- TODO: There are also INTERSECT and EXCEPT constructs, in the same vein as UNION. Read more about these clauses in the docs.

-- Quick Fixes in Select: case, coalesce and nullif
-- The CASE, COALESCE and NULLIF to make small quick “fixes” for SELECTed data. CASE is like switch in C-like languages:
SELECT id,
       CASE WHEN name='typ0' THEN 'typo' ELSE name END
  FROM items;
SELECT CASE WHEN rating='G'  THEN 'General Audiences'
            WHEN rating='PG' THEN 'Parental Guidance'
            ELSE 'Other'
       END
  FROM movies;
-- COALESCE can be used to substitute a certain value instead of NULL.
-- use an empty string if ip is not available
SELECT nodename, COALESCE(ip, '') FROM nodes;
-- try to use the first available, else use '?'
SELECT nodename, COALESCE(ipv4, ipv6, hostname, '?') FROM nodes;
-- NULLIF works the other way, letting you use NULL instead of a certain value:
-- use NULL instead of '0.0.0.0'
SELECT nodename, NULLIF(ipv4, '0.0.0.0') FROM nodes;

-- Generate Random and Sequential Test Data
-- Various methods of generating random data:
-- 100 random dice rolls
SELECT 1+(5 * random())::int FROM generate_series(1, 100);
-- 100 random text strings (each 32 chars long)
SELECT md5(random()::text) FROM generate_series(1, 100);
-- 100 random text strings (each 36 chars long)
SELECT uuid_generate_v4()::text FROM generate_series(1, 100);
-- 100 random small text strings of varying lengths
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
SELECT gen_random_bytes(1+(9*random())::int)::text
  FROM generate_series(1, 100);
-- 100 random dates in 2019
SELECT DATE(
         DATE '2019-01-01' + ((random()*365)::int || ' days')::interval
       )
  FROM generate_series(1, 100);
-- 100 random 2-column data: 1st column integer and 2nd column string
WITH a AS (
  SELECT ARRAY(SELECT random() FROM generate_series(1,100))
),
b AS (
  SELECT ARRAY(SELECT md5(random()::text) FROM generate_series(1,100))
)
SELECT unnest(i), unnest(j)
  FROM a a(i), b b(j);
-- a daily count for 2020, generally increasing over time
SELECT i, ( (5+random()) * (row_number() over()) )::int
  FROM generate_series(DATE '2020-01-01', DATE '2020-12-31', INTERVAL '1 day')
       AS s(i);

-- Use bernoulli table sampling to select a random number of rows from a table:
-- select 15% of rows from the table, chosen randomly  
     SELECT *
       FROM purchases
TABLESAMPLE bernoulli(15)

-- Use generate_series to generate sequential values of integers, dates and other incrementable built-in types:
-- generate integers from 1 to 100
SELECT generate_series(1, 100);
-- call the generated values table as "s" with a column "i", to use in
-- CTEs and JOINs
SELECT i FROM generate_series(1, 100) AS s(i);
-- generate multiples of 3 in different ways
SELECT 3*i FROM generate_series(1, 100) AS s(i);
SELECT generate_series(1, 100, 3);
-- works with dates too: here are all the Mondays in 2020:
SELECT generate_series(DATE '2020-01-06', DATE '2020-12-31', INTERVAL '1 week');

-- Get Approximate Row Count
-- The horrible performance of COUNT(*) is perhaps the ugliest by-product of Postgres’ architecture. If you just need an approximate row count for a huge table, you can avoid a full COUNT by querying the statistics collector:
SELECT relname, n_live_tup FROM pg_stat_user_tables;
-- The result is accurate after an ANALYZE, and will be progressively incorrect as the rows are modified. Do not use this if you want accurate counts.

-- Interval Type
-- The interval type can not only be used as a column datatype, but can be added to and subtracted from date and timestamp values:
-- get licenses that expire within the next 7 days
SELECT id
  FROM licenses
 WHERE expiry_date BETWEEN now() - INTERVAL '7 days' AND now();
-- extend expiry date
UPDATE licenses
   SET expiry_date = expiry_date + INTERVAL '1 year'
 WHERE id = 42;

-- Turn Off Constraint Validation For Bulk Insert
-- add a constraint, set as "not valid"
ALTER TABLE players
            ADD CONSTRAINT fk__players_guilds
                           FOREIGN KEY (guild_id)
                            REFERENCES guilds(id)
            NOT VALID;

-- copy from csv
-- insert lots of rows into the table
COPY players FROM '/data/players.csv' (FORMAT CSV);
-- now validate the entire table
ALTER TABLE players
            VALIDATE CONSTRAINT fk__players_guilds;

-- Dump a Table or Query to a CSV File
-- dump the contents of a table to a CSV format file on the server
COPY players TO '/tmp/players.csv' (FORMAT CSV);
-- "header" adds a heading with column names
COPY players TO '/tmp/players.csv' (FORMAT CSV, HEADER);
-- use the psql command to save to your local machine
\copy players TO '~/players.csv' (FORMAT CSV);
-- can use a query instead of a table name
\copy ( SELECT id, name, score FROM players )
      TO '~/players.csv'
      ( FORMAT CSV );

-- Use More Native Data Types In Your Schema Design
-- Postgres comes with many built-in data types. Representing the data your application needs using one of these types can save lots of application code, make your development faster and result in fewer errors.
-- For example, if you are representing a person’s location using the data type point and a region of interest as a polygon, you can check if the person is in the region simply with:
-- the @> operator checks if the region of interest (a "polygon") contains
-- the person's location (a "point")
SELECT roi @> person_location FROM live_tracking;
Here are some interesting Postgres data types and links to where you can find more information about them:

-- Types
C-like enum types
Geometric types – point, box, line segment, line, path, polygon, circle
IPv4, IPv6 and MAC addresses
Range types – integer, date and timestamp ranges
Arrays that can contain values of any type
UUID – if you need to use UUIDs, or just need to work with 129-byte random integers, consider using the uuid type and the uuid-oscp extension for storing, generating and formatting UUIDs
Date and time intervals using the INTERVAL type
and of course the ever-popular JSON and JSONB
Bundled Extensions
Most Postgres installs include a bunch of standard “extensions”. Extensions are installable (and cleanly uninstallable) components that provide functionality not included in the core. They can be installed on a per-database basis.

-- Extensions
-- Some of these are quite useful, and it is worth spending some time getting to know them:
pg_stat_statements – statistics regarding the execution of each SQL query
auto_explain – log the query execution plan of (slow) queries
postgres_fdw, dblink and file_fdw – ways to access other data sources (like remote Postgres servers, MySQL servers, files on server’s file system) like regular tables
citext – a “case-insensitive text” data type, more efficient than lower()-ing all over the place
hstore – a key-value data type
pgcrypto – SHA hashing functions, encryption
About pgDash
pgDash is a modern, in-depth monitoring solution designed specifically for PostgreSQL deployments. pgDash shows you information and metrics about every aspect of your PostgreSQL database server, collected using the open-source tool pgmetrics.
