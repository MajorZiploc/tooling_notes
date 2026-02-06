view logs:

```bash

GET

curl 'https://<project>.supabase.co/rest/v1/logs?order=created_at.desc&limit=5' \
  -H "apikey: authed_key \
  -H "Authorization: Bearer authed_key

POST -- no return value

curl -X POST "https://ujeuobupuwucujvhyeou.supabase.co/rest/v1/logs" \
  -H "apikey: sb_publishable_GHOfzjQdZYoZUIl8dXCRfw_pJL_eIdr" \
  -H "Authorization: Bearer sb_publishable_GHOfzjQdZYoZUIl8dXCRfw_pJL_eIdr" \
  -H "Content-Type: application/json" \
  -d '{
    "content": "Learn Supabase"
  }'

    POST -- if you have select policy that allows you to get the representation back

    curl -X POST "https://ujeuobupuwucujvhyeou.supabase.co/rest/v1/logs" \
      -H "apikey: sb_publishable_GHOfzjQdZYoZUIl8dXCRfw_pJL_eIdr" \
      -H "Authorization: Bearer sb_publishable_GHOfzjQdZYoZUIl8dXCRfw_pJL_eIdr" \
      -H "Content-Type: application/json" \
      -H "Prefer: return=representation" \
      -d '{
        "content": "Learn Supabase"
      }'

```


view all policies in supabase

```sql

SELECT
  nspname AS schemaname
  , relname AS tablename
  , pol.polname AS policynameo
  , pol.polpermissive
  , pg_get_userbyid(pol.polroles[1]) AS policyrole
  , pol.polcmd
  , pg_get_expr(pol.polqual
  , pol.polrelid) AS policyqual
  , pg_get_expr(pol.polwithcheck, pol.polrelid) AS policywithcheck
FROM pg_policy pol
INNER JOIN pg_class cls ON pol.polrelid = cls.oid
INNER JOIN pg_namespace nsp ON cls.relnamespace = nsp.oid
;

-- delete/drop a policy in supabase by name (policynameo)

DROP POLICY "Public Logs are updatable only by authenticated users" ON Logs;

```
