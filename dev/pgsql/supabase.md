view logs:

```bash

curl 'https://<project>.supabase.co/rest/v1/logs?order=created_at.desc&limit=5' \
  -H "apikey: authed_key \
  -H "Authorization: Bearer authed_key

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
