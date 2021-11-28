from django.db import migrations, models, connection
from django.db.models import F, Value, Func, CharField
from django.db.models.functions import Concat

class Migration(migrations.Migration):

    dependencies = [
        ('movies', '0001_initial'),
    ]
    
    # required for RunPython code
    # postgres specific implementation
    def disable_triggers(self):
        with connection.cursor() as cursor:
            cursor.execute("""
                ALTER TABLE movies_movie
                DISABLE TRIGGER ALL;
            """)

    # required for RunPython code
    # postgres specific implementation
    def enable_triggers(self):
        with connection.cursor() as cursor:
            cursor.execute("""
                ALTER TABLE movies_movie
                ENABLE TRIGGER ALL;
            """)

    # up
    def combine_title_and_genre_up(apps, schema_editor):
        # Change to your specific migration name
        migration = Migration('movies', '0002_auto_20230101')
        migration.disable_triggers()
        # load the original Model before it was modified to the desired state
        Movie = apps.get_model('movies', 'Movie')
        Movie.objects.all().update(title_genre=Concat(F('title'), Value(' - '), F('genre')))
        migration.enable_triggers()

    # down
    def combine_title_and_genre_down(apps, schema_editor):
        # Change to your specific migration name
        migration = Migration('movies', '0002_auto_20230101')
        migration.disable_triggers()
        # load the original Model before it was modified to the desired state
        Movie = apps.get_model('movies', 'Movie')
        Movie.objects.exclude(title_genre__isnull=True).update(title_genre=F('title_genre'))
        with connection.cursor() as cursor:
            cursor.execute("""
                UPDATE movies_movie
                SET title = split_part(title_genre, ' - ', 1),
                    genre = split_part(title_genre, ' - ', 2);
            """)
        migration.enable_triggers()


    operations = [
        # needed for the down script
        migrations.AlterField(
            model_name='movie',
            name='title',
            field=models.CharField(max_length=10, null=True),
        ),
        # needed for the down script
        migrations.AlterField(
            model_name='movie',
            name='genre',
            field=models.CharField(max_length=10, null=True),
        ),
        # null at first so we can then load the data into it
        migrations.AddField(
            model_name='movie',
            name='title_genre',
            field=models.CharField(max_length=200, null=True),
        ),
        migrations.RunPython(combine_title_and_genre_up, reverse_code=combine_title_and_genre_down),
        migrations.RemoveField(
            model_name='movie',
            name='title',
        ),
        migrations.RemoveField(
            model_name='movie',
            name='genre',
        ),
        migrations.AlterField(
            model_name='movie',
            name='title_genre',
            field=models.CharField(max_length=200, null=False),
        ),
    ]
