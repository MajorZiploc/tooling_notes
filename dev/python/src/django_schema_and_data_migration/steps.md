NOTE: for django-react: <app_name> = movies

change the <app_name> to your app

# Up

1. Alter the models.py model to your desired state

2. Create an empty migration so we can deal with data migration

  docker exec -i -t "$container_name" python manage.py makemigrations --empty <app_name>

3. Add content to the created migration file like in ./example_migration_file.py

4. Run migration

  docker exec -i -t "$container_name" python manage.py migrate


# Down

1. (Optional) Revert Migration

  // replace 0001_initial with the migration before the migration you want to revert

  docker exec -i -t "$container_name" python manage.py migrate <app_name> 0001_initial
