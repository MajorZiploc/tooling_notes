from datetime import date
from django.db import models
from django.db.models import F, Q, QuerySet, Avg, Count, Sum, Value
from django.db.models.functions import Coalesce, Lower

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

    def __str__(self):
        return self.headline

# Manager
# Blog and Entry Models have Managers
# Blog.objects is a Manager
# instance.<model_name>_set is a Manager
  # where b: Blog instance. # b.entry_set is a Manager that returns QuerySets.

# USEFUL: .query property of a QuerySet to view the sql query

# QUERYSETS ARE LAZY
# the act of creating a QuerySet doesn’t involve any database activity
# You can stack filters together all day long, and Django won’t actually run the query until the QuerySet is evaluated

# LIMIT BEGIN
# uses python slices
# GOTYA: negative indexing not supported
#   Entry.objects.all()[-1]
# LIMIT END

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

__exact # implied with just =
__iexact
__contains
__icontains
__startswith
__endswith
__istartswith
__iendswith
__in
__gt
__lt
__gte
__lte

__range # inclusive
start_date = datetime.date(2005, 1, 1)
end_date = datetime.date(2005, 3, 31)
Entry.objects.filter(pub_date__range=(start_date, end_date))
# SELECT ... WHERE pub_date BETWEEN '2005-01-01' and '2005-03-31';
# GOTYA: do not mix date and datetime with __range, will cause weird results. cast to __date first
# TODO: USE_TZ is a thing in django. look into it

__date # cast a datetime field to date
__year
__iso_year
__month
__day
__week
__week_day
__iso_week_day
__quarter
__time # cast a datetime field to time
__hour
__minute
__second
__isnull # Entry.objects.filter(pub_date__isnull=True)
__regex # Entry.objects.get(title__regex=r'^(An?|The) +')
__iregex

# FILTERING __ commands END

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
# would exclude blogs that contain both entries with only Lennon headline and entries with only pub_date=2008 BUT WILL NOT exclude blogs that meet both conditions
Blog.objects.exclude(entry__headline__contains='Lennon', entry__pub_date__year=2008,)
# WORKAROUND: WILL exclude blogs that meet both conditions
Blog.objects.exclude(entry__in=Entry.objects.filter(headline__contains='Lennon', pub_date__year=2008,),)
# SPANNING MULTI-VALUED RELATIONSHIPS END

# F EXPRESSIONS BEGIN
# For referencing different fields on the same model
# useful in things like comparsions
Entry.objects.filter(number_of_comments__gt=F('number_of_pingbacks'))
# supports the use of addition, subtraction, multiplication, division, modulo, and power arithmetic with F() objects, both with constants and with other F() objects
Entry.objects.filter(number_of_comments__gt=F('number_of_pingbacks') * 2)
Entry.objects.filter(rating__lt=F('number_of_comments') + F('number_of_pingbacks'))
Entry.objects.filter(mod_date__gt=F('pub_date') + timedelta(days=3))
# support bitwise operations by .bitand(), .bitor(), .bitxor(), .bitrightshift(), and .bitleftshift()
F('somefield').bitand(16)
# supports spanning relationships
Entry.objects.filter(authors__name=F('blog__name'))

# Using % in LIKE statement
# django just handles it for you
Entry.objects.filter(headline__contains='%')
# SELECT ... WHERE headline LIKE '%\%%';

# F EXPRESSIONS END

# QUERIES OVER RELATIONS
# All are equal
Entry.objects.filter(blog=b) # Query using object instance
Entry.objects.filter(blog=b.id) # Query using id from instance
Entry.objects.filter(blog=5) # Query using id directly

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

Entry.objects.order_by(Coalesce('summary', 'headline').desc())

# NULL Coalesce END

# ORDEY_BY BEGIN

# ascending
Entry.objects.order_by(Coalesce('summary', 'headline').desc())
Entry.objects.order_by('sumary')
# descending
Entry.objects.order_by(Coalesce('summary', 'headline').desc())
Entry.objects.order_by('-sumary')
# random order, can be expensive
Entry.objects.order_by('?')

# ORDEY_BY END

# reverse a query
# GOTYA: only has an effect on queries with an .order_by()
my_queryset.reverse()

# distinct
# GOTYA: general must match your .order_by()
Entry.objects.order_by('author', 'pub_date').distinct('author', 'pub_date')
# GOTYA: must specify full field name. no short cuts in case of relation fields
# WRONG
Entry.objects.order_by('blog').distinct('blog')
# CORRECT
Entry.objects.order_by('blog__id').distinct('blog__id')

# QUERYSET CACHEING BEGIN

# NOTE: the entire queryset must be evaluated to populate the cache:
# If slicing occurs, the cacheing does not occur
# GOTYA: Printing a querset does not cache it since __repr__() uses slices

# WHEN CACHE IS USED BEGIN

# Will use the same query results for each print (cacheing)
queryset = Entry.objects.all()
print([p.headline for p in queryset]) # Evaluate the query set.
print([p.pub_date for p in queryset]) # Re-use the cache from the evaluation.

# limiting the queryset using array slices
queryset = Entry.objects.all()
[entry for entry in queryset] # Queries the database
print(queryset[5]) # Uses cache
print(queryset[5]) # Uses cache

# WHEN CACHE IS USED END

# WHEN CACHE ISNT USED BEGIN

# Will NOT use the same query results for each print
print([e.headline for e in Entry.objects.all()])
print([e.pub_date for e in Entry.objects.all()])

# limiting the queryset using array slices
queryset = Entry.objects.all()
print(queryset[5]) # Queries the database
print(queryset[5]) # Queries the database again

# WHEN CACHE ISNT USED END

# QUERYSET CACHEING END

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

# DELETE END

# COPY BEGIN

# for models that do not inherit from other models
blog = Blog(name='My blog', tagline='Blogging is easy')
blog.save() # blog.pk == 1
blog.pk = None
blog._state.adding = True
blog.save() # blog.pk == 2

# for models that do inherit from other models
class ThemeBlog(Blog):
    theme = models.CharField(max_length=200)
django_blog = ThemeBlog(name='Django', tagline='Django is easy', theme='python')
django_blog.save() # django_blog.pk == 3
# GOTYA: Due to how inheritance works, you have to set both pk and id to None, and _state.adding to True:
django_blog.pk = None
django_blog.id = None
django_blog._state.adding = True
django_blog.save() # django_blog.pk == 4

# GOTYA: relations are not copied
# must set manually
# ManyToManyField example
entry = Entry.objects.all()[0] # some previous entry
old_authors = entry.authors.all()
entry.pk = None
entry._state.adding = True
entry.save()
entry.authors.set(old_authors)
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
# TODO: unsure if you need to call .save() on each model after doing this

# F EXPRESSIONS
Entry.objects.all().update(number_of_pingbacks=F('number_of_pingbacks') + 1)
# GOTYA: cant use relation fields like in filters for F EXPRESSIONS in .update()
# This will raise a FieldError
Entry.objects.update(headline=F('blog__name'))

# UPDATE BEGIN

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

# annotate is foreach reverse relation aggregation
# GOTYA: annotate only works well when using 1 arg. it can be wrong with multiple args.
# Count(..., distinct=True) fixes this problem for Count

# ANNOTATE END

# VALUES AND VALUES LIST BEGIN

# .values() returns dictionaries of requested fields
Article.objects.values('comment_id').distinct()

# .values_list() returns tuples, can flatten if 1 field is requested
Article.objects.values_list('comment_id', flat=True).distinct() # <QuerySet [{'name__lower': 'beatles blog'}]>

# .values() and .values_list() can use functions like so
Blog.objects.values(lower_name=Lower('name'))
Entry.objects.values_list('id', Lower('headline')) # <QuerySet [(1, 'first entry'), ...]>

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
# WORKAROUND: Unless you are sure you wish to work with SQL NULL values, consider setting null=False and providing a suitable default for empty values, such as default=dict.

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

# GOTYA: Due to the way in which key-path queries work, exclude() and filter() are not guaranteed to produce exhaustive sets. If you want to include objects that do not have the path, add the isnull lookup.

# PostgreSQL users
# On PostgreSQL, if only one key or index is used, the SQL operator -> is used. If multiple operators are used then the #> operator is used.

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

## See EntryManager and Entry model for custom manager definition at the beginning

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
e.authors.all() # Returns all Author objects for this Entry.
e.authors.count()
e.authors.filter(name__contains='John')
a = Author.objects.get(id=5)
a.entry_set.all() # Returns all Entry objects for this Author.

# ManyToManyField RELATION END

# OneToOneField RELATION BEGIN

class EntryDetail(models.Model):
    entry = models.OneToOneField(Entry, on_delete=models.CASCADE)
    details = models.TextField()

ed = EntryDetail.objects.get(id=2)
ed.entry # Returns the related Entry object.
# Reverse lookup returns 1 thing rather than a collection
e = Entry.objects.get(id=2)
e.entrydetail # returns the related EntryDetail object

# OneToOneField RELATION END

# Push null dates to the end of a desc sort
long_ago = datetime.datetime(year=1980, month=1, day=1)
MyModel.objects.annotate(date_null=
    Coalesce('date_field', Value(long_ago))).order_by('-date_null')
