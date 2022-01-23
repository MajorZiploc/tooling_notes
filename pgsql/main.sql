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
   film_title film.title%type;
   featured_title film_title%type;
begin 
   -- get title of the film id 100
   select title
   from film
   into film_title
   where film_id = 100;
   
   -- show the film title
   raise notice 'Film title id 100: %s', film_title;
end; $$

-- Declare a rowtype variable dynamic
do
$$
declare
	rec record;
begin
	-- select the film 
	select film_id, title, length 
	into rec
	from film
	where film_id = 200;
	
	raise notice '% % %', rec.film_id, rec.title, rec.length;   
	
end;
$$
language plpgsql;

-- Declare a rowtype variable dynamic loop through results
do
$$
declare
	rec record;
begin
	for rec in select title, length 
			from film 
			where length > 50
			order by length
	loop
		raise notice '% (%)', rec.title, rec.length;	
	end loop;
end;
$$

-- Declare a rowtype variable
do $$
declare
   selected_actor actor%rowtype;
begin
   -- select actor with id 10   
   select * 
   from actor
   into selected_actor
   where actor_id = 10;

   -- show the number of actor
   raise notice 'The actor name is % %',
      selected_actor.first_name,
      selected_actor.last_name;
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
