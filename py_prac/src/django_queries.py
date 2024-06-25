from django.contrib.auth.models import User
from django.contrib.postgres.fields import ArrayField
from django.db import models
from django.db.models import CASCADE, F, Max, TextField, Value, RowRange
from django.db.models.functions import Concat
from django.utils.timezone import now
from django.db.models import F, Sum, Window
from django.db.models.functions import Lag, Round, Coalesce, Lead, RowNumber, Rank, DenseRank, Ntile, FirstValue, LastValue, NthValue
from django.db.models import Subquery, OuterRef, Window
from django.db import connection
from psycopg2.extras import DictCursor

from datetime import date
from django.db import models
from django.db.models import F, Q, QuerySet, Avg, Count, Sum, Value, Case, When
from django.db.models.fields import TextField
from django.db.models.functions import Coalesce, Lower, Concat, Substr, StrIndex

# Convert model to dictionary for things like dictionary like access
from django.forms.models import model_to_dict
# Will show relations
model_to_dict(instance)
# Will only show fields directly on table
instance.__dict__

# MODELS FOR THE EXAMPLES

class Blog(models.Model):
    name = models.CharField(max_length=100)
    tagline = models.TextField()

    def __str__(self):
        return self.name

class Author(models.Model):
    name = models.CharField(max_length=200)
    email = models.EmailField()

    def __str__(self):
        return self.name

class EntryManager(models.Manager):
    def is_published(self):
        raise NotImplemented()

class Entry(models.Model):
    blog = models.ForeignKey(Blog, on_delete=models.CASCADE)
    headline = models.CharField(max_length=255)
    body_text = models.TextField()
    pub_date = models.DateField()
    mod_date = models.DateField(default=date.today)
    authors = models.ManyToManyField(Author)
    number_of_comments = models.IntegerField(default=0)
    number_of_pingbacks = models.IntegerField(default=0)
    rating = models.IntegerField(default=5)

    objects = models.Manager()  # Default Manager, defined implicitly, defined here just to show it
    entries = EntryManager()    # Custom Manager

    class Meta:
        ordering = ['-pub_date']
        indexes = [
            # standard single column index
            models.Index(
                fields=['rating'],
                name='idx_blog_author'
            )
            # composed index
            models.Index(
                fields=['blog_id', 'author_id'],
                name='idx_blog_author'
            )
        ]


    def __str__(self):
        return self.headline

# Manager
# Blog and Entry Models have Managers
# Blog.objects is a Manager
# instance.<model_name>_set is a Manager
  # where b: Blog instance. # b.entry_set is a Manager that returns QuerySets.

# USEFUL: .query.__str__() property of a QuerySet to view the sql query
User.objects.distinct("age", "name").query.__str__()

# QUERYSETS ARE LAZY
# the act of creating a QuerySet doesn’t involve any database activity
# You can stack filters together all day long, and Django won’t actually run the query until the QuerySet is evaluated

# LIMIT BEGIN
# uses python slices
# GOTYA: negative indexing not supported
#   Entry.objects.all()[-1]
# LIMIT END

# NOTE: good for pagination
# (OFFSET 5 LIMIT 5)
Entry.objects.all()[5:10]
# every second object up to 10th entry
Entry.objects.all()[:10:2]


# FILTERING BEGIN
# .filter and .exclude to get a QuerySet back
# .get to get 1 model back

# ID LOOKUPS
# pk can reference the primary key of a table regardless of the primary key name

# FILTERING __ commands BEGIN
# NOTE: they can typically be chained:
Entry.objects.filter(pub_date__year__gte=2005)

# Field lookups
__exact  # implied with just =
__iexact
__contains
__icontains
__startswith
__endswith
__istartswith
__iendswith
__in
__gt
  from datetime import timedelta
  Entry.objects.filter(mod_date__gt=F("pub_date") + timedelta(days=3))
__lt
    Entry.objects.filter(rating__lt=F("number_of_comments") + F("number_of_pingbacks"))
__gte
__lte

__range  # inclusive
start_date = datetime.date(2005, 1, 1)
end_date = datetime.date(2005, 3, 31)
Entry.objects.filter(pub_date__range=(start_date, end_date))
# SELECT ... WHERE pub_date BETWEEN '2005-01-01' and '2005-03-31';
# GOTYA: do not mix date and datetime with __range, will cause weird results. cast to __date first
# TODO: USE_TZ is a thing in django. look into it

__date  # cast a datetime field to date
__year
  Blog.objects.filter(entry__headline__contains="Lennon").filter(
      entry__pub_date__year=2008
  )
__iso_year
__month
__day
__week
__week_day
__iso_week_day
__quarter
__time  # cast a datetime field to time
__hour
__minute
__second
__isnull  # Entry.objects.filter(pub_date__isnull=True)
__regex  # Entry.objects.get(title__regex=r'^(An?|The) +')
__iregex

# FILTERING __ commands END

# find the earliest year an entry was published, we can issue the query:
from django.db.models import Min
Entry.objects.aggregate(first_published_year=Min("pub_date__year"))

# LOOKUPS THAT SPAN RELATIONSHIPS BEGIN

# GOTYA: if any relation in a deep relationship chain is null, the whole thing is null
# Stops null exceptions from being raised
# OK: Fine for this case
Blog.objects.filter(entry__authors__name='Lennon')
# OOPS: can be confusing for this case, can be true if authors or name was null
Blog.objects.filter(entry__authors__name__isnull=True)
# WORKAROUND: if you really only wanted to check if name was null but authors do exist
Blog.objects.filter(entry__authors__isnull=False, entry__authors__name__isnull=True)
# LOOKUPS THAT SPAN RELATIONSHIPS END

# SPANNING MULTI-VALUED RELATIONSHIPS BEGIN
# Filter chaining vs single filter
# same entry must satisfy all entry__* criteria
Blog.objects.filter(entry__headline__contains='Lennon', entry__pub_date__year=2008)

# any entry may satisfy any entry__* criteria
Blog.objects.filter(entry__headline__contains='Lennon').filter(entry__pub_date__year=2008)
# GOTYA multiple filters chains: it performs multiple joins to the primary model, potentially yielding duplicates.

# GOTYA: .exclude doesnt work the same for the above cases
# would exclude blogs that contain both entries with only Lennon headline
# and entries with only pub_date=2008 BUT WILL NOT exclude blogs that meet
# both conditions
Blog.objects.exclude(entry__headline__contains='Lennon', entry__pub_date__year=2008,)
# WORKAROUND: WILL exclude blogs that meet both conditions
Blog.objects.exclude(entry__in=Entry.objects.filter(headline__contains='Lennon', pub_date__year=2008,),)
# SPANNING MULTI-VALUED RELATIONSHIPS END

# F EXPRESSIONS BEGIN
# For referencing different fields on the same model
# useful in things like comparsions
Entry.objects.filter(number_of_comments__gt=F('number_of_pingbacks'))
# supports the use of addition, subtraction, multiplication, division,
# modulo, and power arithmetic with F() objects, both with constants and
# with other F() objects
Entry.objects.filter(number_of_comments__gt=F('number_of_pingbacks') * 2)
Entry.objects.filter(rating__lt=F('number_of_comments') + F('number_of_pingbacks'))
Entry.objects.filter(mod_date__gt=F('pub_date') + timedelta(days=3))
# support bitwise operations by .bitand(), .bitor(), .bitxor(), .bitrightshift(), and .bitleftshift()
F('somefield').bitand(16)
# supports spanning relationships
Entry.objects.filter(authors__name=F('blog__name'))

# Using % in LIKE statement
# django just handles it for you
Entry.objects.filter(headline__contains='ghost')
# SELECT ... WHERE headline LIKE '%\%%';

# F EXPRESSIONS END

# QUERIES OVER RELATIONS
# All are equal
Entry.objects.filter(blog=b)  # Query using object instance
Entry.objects.filter(blog=b.id)  # Query using id from instance
Entry.objects.filter(blog=5)  # Query using id directly

# FILTERING END

# CREATE
b = Blog(name='Beatles Blog', tagline='All the latest Beatles news.')
b.save()
# OR
b = Blog.objects.create(name='Beatles Blog', tagline='All the latest Beatles news.')

# update ForeignKey
entry.blog = cheese_blog
entry.save()

# add ManyToManyFields
joe = Author.objects.create(name="Joe")
paul = Author.objects.create(name="Paul")
entry.authors.add(joe, paul)
entry.save()

# NULL Coalesce BEGIN

 author = Author.objects.annotate(screen_name=Coalesce("alias", "goes_by", Value("name"))).get()

# NULL Coalesce END

# ORDEY_BY BEGIN

# ascending
Entry.objects.order_by(Coalesce('summary', 'headline').desc())
Entry.objects.order_by('summary')
# descending
Entry.objects.order_by(Coalesce('summary', 'headline').desc())
Entry.objects.order_by('-summary')
# random order, can be expensive
Entry.objects.order_by('?')

# ORDEY_BY END

# exists BEGIN
# instead of checking a count for 0, you can use exists()
stuff_count = models.Stuff.objects.filter(id=stuff.id).count()
if stuff_count == 0:
    pass

if models.Stuff.objects.filter(id=stuff.id).exists():
    pass
# exists END

# GROUP BY

# .values and .order_by must have same string
# .annotate in the middle of them

Employee.objects
  .values('department')
  .annotate(
  min_salary=Min('salary'),
  max_salary=Max('salary'),
  avg_salary=Avg('salary')
  )
  .order_by('department')[:21]
# ==
SELECT "hr_employee"."department_id",
       MIN("hr_employee"."salary") AS "min_salary",
       MAX("hr_employee"."salary") AS "max_salary",
       AVG("hr_employee"."salary") AS "avg_salary"
  FROM "hr_employee"
 GROUP BY "hr_employee"."department_id"
 ORDER BY "hr_employee"."department_id" ASC
 LIMIT 21

# reverse a query
# GOTYA: only has an effect on queries with an .order_by()
my_queryset.reverse()

# distinct: will act as 'distinct on' if you do not only select the values you are distincting on
# GOTYA: in general must match your .order_by()
Entry.objects.order_by('author', 'pub_date').distinct('author', 'pub_date')
# GOTYA: must specify full field name. no short cuts in case of relation fields
# WRONG
Entry.objects.order_by('blog').distinct('blog')
# CORRECT
Entry.objects.order_by('blog__id').distinct('blog__id')
# 'distinct on' clause. will still select all data
User.objects.distinct("age", "name")
# a distinct. not a 'distinct on'. Requires selecting the data you want
Team.objects.values('team_id', 'domain_name').distinct()

# QUERYSET CACHEING BEGIN

# NOTE: the entire queryset must be evaluated to populate the cache:
# If slicing occurs, the cacheing does not occur
# GOTYA: Printing a querset does not cache it since __repr__() uses slices

# WHEN CACHE IS USED BEGIN

# Will use the same query results for each print (cacheing)
queryset = Entry.objects.all()
print([p.headline for p in queryset])  # Evaluate the query set.
print([p.pub_date for p in queryset])  # Re-use the cache from the evaluation.

# limiting the queryset using array slices
queryset = Entry.objects.all()
[entry for entry in queryset]  # Queries the database
print(queryset[5])  # Uses cache
print(queryset[5])  # Uses cache

# WHEN CACHE IS USED END

# WHEN CACHE ISNT USED BEGIN

# Will NOT use the same query results for each print
print([e.headline for e in Entry.objects.all()])
print([e.pub_date for e in Entry.objects.all()])

# limiting the queryset using array slices
queryset = Entry.objects.all()
print(queryset[5])  # Queries the database
print(queryset[5])  # Queries the database again

# WHEN CACHE ISNT USED END

# QUERYSET CACHEING END

# select_related is for geting values from related tables in queries
# good for .values() and .values_list
Entry.objects.select_related('related_table1__to_another_table2', 'related_table3')

# MODEL EQUALITY CHECK
some_entry == other_entry
# SAME AS COMPARING THE pk FIELD REGARDLESS OF THE pk FIELD NAME
some_entry.id == other_entry.id

# DELETE BEGIN

# GOTYA: can override the default behavior of .delete() but if you do, you cant do bulk delete
# usually better to use the on_delete property on ForeignKey fields or whatever relation type that supports this
# by default models.CASCADE is used. which deletes all related entries from different tables

b = Blog.objects.get(pk=1)
# This will delete the Blog and all of its Entry objects.
b.delete()
# This cascade behavior is customizable via the on_delete argument to the ForeignKey.
# .delete() is not available on Manager objects
# Bulk delete
Entry.objects.filter(pub_date__year=2005).delete()

# DELETE END

# COPY BEGIN

# for models that do not inherit from other models
blog = Blog(name='My blog', tagline='Blogging is easy')
blog.save()  # blog.pk == 1
blog.pk = None
blog._state.adding = True
blog.save()  # blog.pk == 2

# for models that do inherit from other models
class ThemeBlog(Blog):
    theme = models.CharField(max_length=200)
django_blog = ThemeBlog(name='Django', tagline='Django is easy', theme='python')
django_blog.save()  # django_blog.pk == 3
# GOTYA: Due to how inheritance works, you have to set both pk and id to None, and _state.adding to True:
django_blog.pk = None
django_blog.id = None
django_blog._state.adding = True
django_blog.save()  # django_blog.pk == 4

# GOTYA: relations are not copied
# must set manually
# ManyToManyField example
entry = Entry.objects.all()[0]  # some previous entry
old_authors = entry.authors.all()
entry.pk = None
entry._state.adding = True
entry.authors.set(old_authors)
entry.save()
# OneToOneField example
detail = EntryDetail.objects.all()[0]
detail.pk = None
detail._state.adding = True
detail.entry = entry
detail.save()

# COPY END

# UPDATE BEGIN

# Updating multiple objects at once
# GOTYA: this only works for non-relation fields and ForeignKey
# non-relation example: Update all the headlines with pub_date in 2007.
Entry.objects.filter(pub_date__year=2007).update(headline='Everything is the same')
# ForeignKey example
b = Blog.objects.get(pk=1)
Entry.objects.all().update(blog=b)

# F EXPRESSIONS
Entry.objects.all().update(number_of_pingbacks=F('number_of_pingbacks') + 1)
# GOTYA: cant use relation fields like in filters for F EXPRESSIONS in .update()
# This will raise a FieldError
Entry.objects.update(headline=F('blog__name'))

# UPDATE END

# REVERSE RELATIONSHIP ACCESS BEGIN
# For example, a Blog object b has access to a list of all related Entry objects via the entry_set attribute
b.entry_set.all()
# GOTYA: the <model_name>_set can be renamed in the relation field on the model with related_name
#   ForeignKey(Blog, on_delete=models.CASCADE, related_name='entries')
#   b.entries.all()
# REVERSE RELATIONSHIP ACCESS BEGIN

# Q OBJECT FILTERING BEGIN

# NOT ~ and OR |
Q(question__startswith='Who') | ~Q(pub_date__year=2005)

# GOTYA: All Q objects must precede keyword args to a filter/get
Poll.objects.get(
    Q(pub_date=date(2005, 5, 2)) | Q(pub_date=date(2005, 5, 6)),
    question__startswith='Who',
)
# INVALID QUERY
Poll.objects.get(
    question__startswith='Who',
    Q(pub_date=date(2005, 5, 2)) | Q(pub_date=date(2005, 5, 6))
)

# Q OBJECT FILTERING END

# ANNOTATE BEGIN

polls_json = list(
    Poll.objects.all().annotate(
        dumb_question=F("question"),
    ).values("dumb_question", "pub_date")
)

# get the substring before the first occurence of '-'
Movie.objects.all().annotate(substr=Substr('title', StrIndex('title', Value('-')))).values('title', 'substr')

# annotate is foreach reverse relation aggregation
# GOTYA: annotate only works well when using 1 arg. it can be wrong with multiple args.
# Count(..., distinct=True) fixes this problem for Count

# ANNOTATE END

# CASE STATEMENT BEGIN

recs = Poll.objects.annotate(
    question_comment=Case(
        When(question="", then="No question!"),
        When(question="For real?", then=Concat(F("question"), "is not a real question!", output_field=TextField()),
        default=Value("No Match!"),
        ),
    )
).filter(question_comment="No question!")

# CASE STATEMENT END

# UNION BEGIN

queryset = queryset1.union(queryset2) #queryset will contain all unique records of queryset1 + queryset2
queryset = queryset1.union(queryset2, all=True) #queryset will contain all records of queryset1 + queryset2 including duplicates
queryset = queryset1.union(queryset2,queryset3) # more than 2 queryset union

# UNION END

# SUBQUERY BEGIN

employee_query = Employee.objects.filter(company='Private').only('id').all()
Person.objects.value('name', 'age').filter(id__in=Subquery(employee_query))

newest = Comment.objects.filter(post=OuterRef('pk')).order_by('-created_at')
Post.objects.annotate(newest_commenter_email=Subquery(newest.values('email')[:1]))

# SUBQUERY END

# WINDOW FUNCTIONS BEGIN

# validated example:
q3 = Team.objects.annotate(
    prev_team_id=Window(expression=Lag('team_id', offset=1, default=None), partition_by=[F('is_stub')], order_by=[F('team_id')], frame=RowRange(start=-7, end=1))
).values('team_id', 'prev_team_id')[:5].query.__str__()
# frame=RowRange(start=-7, end=1)) # for ROWS BETWEEN 7 PRECEDING AND 1 FOLLOWING
# frame=RowRange(start=-7, end=0)) # for ROWS BETWEEN 7 PRECEDING AND CURRENT ROW
# frame=RowRange(start=None, end=0)) # for ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
# frame=RowRange(start=0, end=0)) # for ROWS BETWEEN CURRENT ROW AND CURRENT ROW
# frame=RowRange(start=0, end=1)) # for ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING
# EQ
'SELECT "integrations_team"."team_id", LAG("integrations_team"."team_id", 1) OVER (PARTITION BY "integrations_team"."is_stub" ORDER BY "integrations_team"."team_id" ROWS BETWEEN 7 PRECEDING AND 1 FOLLOWING) AS "prev_team_id" FROM "integrations_team" LIMIT 5'


window = {
  'partition_by': [F('b')],
  'frame': RowRange(start=None, end=0),
  'order_by': F('a').asc()
  }
qs = Sample.objects.annotate(
        previous = Window(
           expression=Lag('a', 1, None), **window
         ), 
  next_val = Window(
           expression=Lead('a', 1, None), **window
        ),     
).order_by('b')
for i in qs:
    print(i.row, i.a, i.b, i.previous, i.next_val)

# WINDOW FUNCTIONS END

# CURSOR BEGIN

from django.db import connection

# Define the number of rows for the rolling average
rolling_average_rows = 6

# SQL statement with parameters
sql_statement = """
WITH DayTotals AS (
  SELECT
    c.visited_on,
    SUM(c.amount) AS day_amount
  FROM Customer AS c
  GROUP BY c.visited_on
),
Result AS (
  SELECT
    c.visited_on,
    SUM(c.day_amount)
      OVER (ORDER BY c.visited_on ROWS BETWEEN %s PRECEDING AND CURRENT ROW) AS amount,
    ROUND(
      CAST(
        AVG(c.day_amount)
        OVER (ORDER BY c.visited_on ROWS BETWEEN %s PRECEDING AND CURRENT ROW) AS NUMERIC
      ),
      2
    ) AS average_amount,
    LAG(c.visited_on, %s, NULL) OVER (ORDER BY c.visited_on) AS range_start
  FROM DayTotals AS c
  ORDER BY c.visited_on
)
SELECT
  r.visited_on,
  r.amount,
  r.average_amount
FROM Result AS r
WHERE r.range_start IS NOT NULL
"""

def f():
    # qs = Person.objects.annotate(
    #         w = Window(
    #            expression=RowNumber(), **{}
    #          ), 
    # ).order_by('first')
    # for i in qs:
    #     print(i.w, i.first)
    # Define the number of rows for the rolling average
    limit = 6
    # SQL statement with parameters
    sql_statement = """
    WITH ctebb AS (
      SELECT
          *
      FROM integrations_person AS p
      limit %s
    )
    select
        ctebb.first
        , ctebb.last
    from ctebb
    """
    # Execute the SQL statement with parameters
    # TUPLES
    # with connection.cursor() as cursor:
    #     cursor.execute(sql_statement, [limit])
    #     # Fetch the results if needed
    #     results = cursor.fetchall()
    #     for row in results:
    #         print(row)
    # DICTIONARIES
    with connection.cursor() as cursor:
        cursor.execute(sql_statement, [limit])
        columns = [col[0] for col in cursor.description]
        results = [dict(zip(columns, row)) for row in cursor.fetchall()]
        for row in results:
            print(row)
    # DICTIONARIES 2: FIX THIS: HOW TO USE DictCursor?
    # with connection.cursor(cursor_factory=DictCursor) as cursor:
    #     cursor.execute(sql_statement, [limit])
    #     # Fetch the results if needed
    #     results = cursor.fetchall()
    #     for row in results:
    #         print(row)

# Execute the SQL statement with parameters
with connection.cursor() as cursor:
    cursor.execute(sql_statement, [rolling_average_rows, rolling_average_rows, rolling_average_rows])

    # Fetch the results if needed
    results = cursor.fetchall()
    for row in results:
        print(row)

# sql_statement should be the same as the prev sql_statement: (to remove the CTEs)
# TODO: confirm this is correct. it was from chat gipidy
sql_statement = """
SELECT
  r.visited_on,
  SUM(r.day_amount) OVER (ORDER BY r.visited_on ROWS BETWEEN %s PRECEDING AND CURRENT ROW) AS amount,
  ROUND(
    CAST(
      AVG(r.day_amount) OVER (ORDER BY r.visited_on ROWS BETWEEN %s PRECEDING AND CURRENT ROW) AS NUMERIC
    ),
    2
  ) AS average_amount,
  LAG(r.visited_on, %s, NULL) OVER (ORDER BY r.visited_on) AS range_start
FROM (
  SELECT
    c.visited_on,
    SUM(c.amount) AS day_amount
  FROM Customer AS c
  GROUP BY c.visited_on
) AS r
WHERE LAG(r.visited_on, %s, NULL) OVER (ORDER BY r.visited_on) IS NOT NULL
ORDER BY r.visited_on;
"""

# then convert to django

# TODO: confirm this is correct. it was from chat gipidy
queryset = (
    Customer.objects
    .values('visited_on')
    .annotate(
        day_amount=Sum('amount'),
        # TODO: Which is right? Window outside? or Sum outside?
        amount=Window(expression=Sum('amount'), order_by=F('visited_on'), frame=RowRange(start=rolling_average_rows, end=0))),
        average_amount=Round(Avg('amount', window=Window(order_by=F('visited_on'), frame=RowRange(start=rolling_average_rows, end=0))), 2),
        # it was rows_between instead of frame here. i think frame is right based on source code
        # amount=window=Window(expression=Sum('amount'), order_by=F('visited_on'), rows_between=[rolling_average_rows, 0])),
        # average_amount=Round(Avg('amount', window=Window(order_by=F('visited_on'), rows_between=[rolling_average_rows, 0])), 2),
        # TODO can Lag be called outside of a Window like this?
        range_start=Lag('visited_on', offset=rolling_average_rows)
        # OR is it this? does Window
        # range_start=Window(expression=Lag('visited_on', offset=rolling_average_rows)),
    )
    .filter(range_start__isnull=False)
    .order_by('visited_on')
)

# CURSOR END

# VALUES AND VALUES LIST BEGIN

# .values() returns dictionaries of requested fields
# NOTE: also used to limit what data you are selecting in your sql query
Article.objects.values('comment_id').distinct()

# .values_list() returns tuples, can flatten if 1 field is requested
Article.objects.values_list('comment_id', flat=True).distinct()

# .values() and .values_list() can use functions like so
Blog.objects.values(lower_name=Lower('name'))
Entry.objects.values_list('id', Lower('headline'))  # <QuerySet [(1, 'first entry'), ...]>

# VALUES AND VALUES LIST END

# .update_or_create() defaults explained
obj, created = Person.objects.update_or_create(
    first_name='John', last_name='Lennon',
    defaults={'first_name': 'Bob'},
)
# If person exists with first_name='John' & last_name='Lennon' then update first_name='Bob'
# Else create new person with first_name='Bob' & last_name='Lennon'

# JSONField BEGIN

class Dog(models.Model):
    name = models.CharField(max_length=200)
    data = models.JSONField(null=True)

    def __str__(self):
        return self.name

# GOTYA: NULL is really weird for json data
# use can use sql null or json null
Dog.objects.create(name='Max', data=None)  # SQL NULL.
# <Dog: Max>
Dog.objects.create(name='Archie', data=Value('null'))  # JSON null.
# <Dog: Archie>
Dog.objects.filter(data=None)
# <QuerySet [<Dog: Archie>]>
Dog.objects.filter(data=Value('null'))
# <QuerySet [<Dog: Archie>]>
Dog.objects.filter(data__isnull=True)
# <QuerySet [<Dog: Max>]>
Dog.objects.filter(data__isnull=False)
# <QuerySet [<Dog: Archie>]>
# WORKAROUND: Unless you are sure you wish to work with SQL NULL values,
# consider setting null=False and providing a suitable default for empty
# values, such as default=dict.

# FIELD LOOKUPS, Array, nested, flat
Dog.objects.create(name='Rufus', data={
    'breed': 'labrador',
    'owner': {
        'name': 'Bob',
        'other_pets': [{
            'name': 'Fishy',
        }],
    },
})
# <Dog: Rufus>
Dog.objects.create(name='Meg', data={'breed': 'collie', 'owner': None})
# <Dog: Meg>
Dog.objects.filter(data__breed='collie')
# <QuerySet [<Dog: Meg>]>
# Multiple keys can be chained together to form a path lookup:
Dog.objects.filter(data__owner__name='Bob')
# <QuerySet [<Dog: Rufus>]>
# If the key is an integer, it will be interpreted as an index transform in an array:
Dog.objects.filter(data__owner__other_pets__0__name='Fishy')
# <QuerySet [<Dog: Rufus>]>
# To query for missing keys, use the isnull lookup:
Dog.objects.create(name='Shep', data={'breed': 'collie'})
# <Dog: Shep>
Dog.objects.filter(data__owner__isnull=True)
# <QuerySet [<Dog: Shep>]>

# GOTYA: Due to the way in which key-path queries work, exclude() and
# filter() are not guaranteed to produce exhaustive sets. If you want to
# include objects that do not have the path, add the isnull lookup.

# PostgreSQL users
# On PostgreSQL, if only one key or index is used, the SQL operator -> is
# used. If multiple operators are used then the #> operator is used.

# __contains
Dog.objects.create(name='Rufus', data={'breed': 'labrador', 'owner': 'Bob'})
# <Dog: Rufus>
Dog.objects.create(name='Meg', data={'breed': 'collie', 'owner': 'Bob'})
# <Dog: Meg>
Dog.objects.create(name='Fred', data={})
# <Dog: Fred>
Dog.objects.filter(data__contains={'owner': 'Bob'})
# <QuerySet [<Dog: Rufus>, <Dog: Meg>]>
Dog.objects.filter(data__contains={'breed': 'collie'})
# <QuerySet [<Dog: Meg>]>

# __contained_by
# This is the inverse of the contains lookup
# Returns objects that are a subset of the __contained_by query dict
Dog.objects.create(name='Rufus', data={'breed': 'labrador', 'owner': 'Bob'})
# <Dog: Rufus>
Dog.objects.create(name='Meg', data={'breed': 'collie', 'owner': 'Bob'})
# <Dog: Meg>
Dog.objects.create(name='Fred', data={})
# <Dog: Fred>
Dog.objects.filter(data__contained_by={'breed': 'collie', 'owner': 'Bob'})
# <QuerySet [<Dog: Meg>, <Dog: Fred>]>
Dog.objects.filter(data__contained_by={'breed': 'collie'})
# <QuerySet [<Dog: Fred>]>

# __has_keys and __has_any_keys
Dog.objects.create(name='Rufus', data={'breed': 'labrador'})
# <Dog: Rufus>
Dog.objects.create(name='Meg', data={'breed': 'collie', 'owner': 'Bob'})
# <Dog: Meg>
Dog.objects.filter(data__has_keys=['breed', 'owner'])
# <QuerySet [<Dog: Meg>]>
Dog.objects.filter(data__has_any_keys=['owner', 'breed'])
# <QuerySet [<Dog: Rufus>, <Dog: Meg>]>

# JSONField END

# RELATIONS
# https://docs.djangoproject.com/en/4.0/topics/db/queries/#related-objects

# CACHEING RELATIONS with select_related()
e = Entry.objects.select_related().get(id=2)
print(e.blog)  # Doesn't hit the database; uses cached version.
print(e.blog)  # Doesn't hit the database; uses cached version.

# CUSTOM REVERSE MANAGER BEGIN

# See EntryManager and Entry model for custom manager definition at the beginning

b = Blog.objects.get(id=1)
# Use a customer manager for a query
# Can override methods like .all()
b.entry_set(manager='entries').all()
# Can define custom methods
b.entry_set(manager='entries').is_published()

# CUSTOM REVERSE MANAGER END

# METHODS FOR HANDLING RELATIONS BEGIN

# Adds the specified model objects to the related object set.
add(obj1, obj2, ...)
# Creates a new object, saves it and puts it in the related object set. Returns the newly created object.
create(**kwargs)
# Removes the specified model objects from the related object set.
remove(obj1, obj2, ...)
# Removes all objects from the related object set.
clear()
# Replace the set of related objects.
set(objs)

# METHODS FOR HANDLING RELATIONS END

# MANYTOMANY RELATION BEGIN

e = Entry.objects.get(id=3)
e.authors.all()  # Returns all Author objects for this Entry.
e.authors.count()
e.authors.filter(name__contains='John')
a = Author.objects.get(id=5)
a.entry_set.all()  # Returns all Entry objects for this Author.

# ManyToManyField RELATION END

# OneToOneField RELATION BEGIN

class EntryDetail(models.Model):
    entry = models.OneToOneField(Entry, on_delete=models.CASCADE)
    details = models.TextField()

ed = EntryDetail.objects.get(id=2)
ed.entry  # Returns the related Entry object.
# Reverse lookup returns 1 thing rather than a collection
e = Entry.objects.get(id=2)
e.entrydetail  # returns the related EntryDetail object

# OneToOneField RELATION END

# Push null dates to the end of a desc sort
long_ago = datetime.datetime(year=1980, month=1, day=1)
MyModel.objects.annotate(date_null=Coalesce('date_field', Value(long_ago))).order_by('-date_null')

# Modal options

def default_12_hours_from_now():
    return now() + timedelta(hours=12)

class AuditableModel(models.Model):
    created_date = models.DateTimeField(default=now, editable=False, null=True)
    updated_date = models.DateTimeField(auto_now=True)

    class Meta:
        abstract = True

class Partner(AuditableModel):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4)
    partner_code = models.TextField()
    partner_name = models.TextField()
    partner_short_name = models.TextField()
    logo_location = models.TextField(null=True)
    enabled = models.BooleanField(default=True)
    active = models.BooleanField(default=True)
    file = models.TextField()
    team = models.ForeignKey("path.Team", on_delete=models.CASCADE)
    file_source = models.TextField()
    event_type = models.TextField()
    date = models.DateTimeField(default=now)
    meta = models.JSONField(default=dict)
    expires_at = models.DateTimeField(default=default_12_hours_from_now)
    models.OneToOneField(
        on_delete=django.db.models.deletion.CASCADE,
        to="path.Activity",
    ),
    analyses = models.ManyToManyField(
        to="path.Analysis", through="Analysis"
    )
    duplicates = models.ManyToManyField(
        to="self", through="Duplicate", symmetrical=False
    )

    @property
    def update_count(self):
        from partner_integrations.models import MachineDataFileEventLog


# advanced queries

# with DayTotals as (
# select
#     c.visited_on
#     , sum(c.amount) as total
# from Customer as c
# group by c.visited_on
# order by c.visited_on asc
# )
# , RollingAmounts as (
# select
#     dt.visited_on
#     , sum(dt.total) over (rows between 6 preceding and current row) as amount
#     , lag(dt.visited_on, 6, null) over () as start_of_range
# from DayTotals as dt
# )
# select
#     ra.visited_on
#     , ra.amount
#     , round(ra.amount / 7, 2) as average_amount
# from RollingAmounts as ra
# where
#     ra.start_of_range is not null
# ;

# EQ maybe?

# Subquery to get daily totals
day_totals_subquery = (
    Customer.objects
    .values('visited_on')
    .annotate(total=Sum('amount'))
    .order_by('visited_on')
)
# Main query using Window function and the subquery
result = (
    Customer.objects
    .annotate(
        amount=Sum('amount') - Lag('amount', 6).over(order_by='visited_on'),
        start_of_range=Lag('visited_on', 6).over(order_by='visited_on'),
    )
    .filter(start_of_range__isnull=False)
    .annotate(
        average_amount=Round(
            Coalesce(
                Subquery(day_totals_subquery.filter(visited_on__lte=OuterRef('visited_on')).values('total')[:1]),
                0
            ) / 7, 2
        )
    )
)

