import functools as ft
# groupby is pretty terrible from itertools: it depends on order of the items. it will only add to a collection if the prev item was added to the same collection. else it will create a new entry
from itertools import permutations, count, chain, groupby
import re
import os
import time
import sys
from time import sleep, strftime
from datetime import datetime
from queue import Queue
from queue import LifoQueue
from collections import defaultdict, deque, OrderedDict, Counter, namedtuple
# minpriortyqueue # NOTE: can be a maxpriortyqueue if you negate the priorty number
# or can use tuples if you need to track data along with priorty in the form (priorty_number, data)
    # NOTE: using a dict only works if the queue times are uniq
    # recommend using a str (id of the object) as the second arg of the tuple and then mapping the id to the object after the work is done
# or can use Objects and override __lt__, __eq__, and __gt__ to track more than just the priorty number
from heapq import heappop, heappush, heapify
import copy
import random
import math
import timeit
# shell scripts and bash commands
# import sh
from enum import Enum
import gzip
# serialization and deserialization
import pickle
# for abstract classes
from abc import ABC, abstractmethod
from dataclasses import dataclass
from typing import Generic, Callable, Generator, Iterator, Union, Optional, Any, cast, Mapping, MutableMapping, Sequence, Iterable, Match, AnyStr, IO, TypeVar, List, Set, Dict, Tuple
# https://docs.python.org/3/library/asyncio-task.html
import asyncio
from collections import OrderedDict
import uuid

T = TypeVar('T')

# A coroutine is typed like a normal function
async def countdown_async(tag: str, count: int) -> str:
    while count > 0:
        print('T-minus {} ({})'.format(count, tag))
        await asyncio.sleep(0.1)
        count -= 1
    return "Blastoff!"

# / install virtualenv
# pip install virtualenv
# / create a named venv
# virtualenv env_name
# / activate virtualenv
# activate env_name
# / deactivate virtualenv
# deactivate

# https://holypython.com/100-python-tips-tricks/
# typing guide
# https://mypy.readthedocs.io/en/stable/cheat_sheet_py3.html#functions

class Person(object):
    # slots can be used to reduce size of class members and speed of class member access
    __slots__ = ['name', 'age', 'l']

    def __init__(self, name, age, l):
        self.name = name
        self.age = age
        self.l = l

    def say(self):
        # format string interpolation
        print(f'Hi, my name is {self.name}, and I am {self.age} years old. Here\'s a list {self.l}')
        
    def __hash__(self):
        # Define a custom hash based on name and age
        return hash((self.name, self.age))

    def __eq__(self, other):
        # Define custom equality based on name and age
        return (self.name, self.age) == (other.name, other.age)

# Extend Exception
class FileStoreError(Exception):
    """ Base exception for when anything goes wrong with the file store."""

class FileExists(FileStoreError):
    """ An attempt was made to create an already existant file. """

    def __init__(self, sha1, debug_info=None, *args):
        self.sha1 = sha1
        self.debug_info = debug_info
        super(FileExists, self).__init__(*args)

    def __str__(self):
        return "FileExists <sha1: {}, debug_info: {}>".format(self.sha1, self.debug_info)

class FileNotFound(FileStoreError):
    """ A searched for file does not exist in the file store."""

def decorator_prac():
    print('decorator_prac')

    def times10(func):
        def wrapper(fn_arg_1, fn_arg_2):
            return func(fn_arg_1 * 10, fn_arg_2 * 10)
        return wrapper

    @times10
    def adder(a, b):
        return a + b
    print(adder(2, 3))  # 50

    def print_argument(func):
        def wrapper(fn_arg_1):
            print("Argument for", func.__name__, "is", fn_arg_1)
            return func(fn_arg_1)
        return wrapper

    @print_argument
    def add_one(x):
        return x + 1
    print(add_one(1))

    def repeat(times, prefix='The goods'):
        # decorator with arguments
        ''' call a function a number of times '''
        def decorate(fn):
            # extra sauce for update_wrapper
            # @ft.wraps(fn)
            def wrapper(*args, **kwargs):
                result = None
                for _ in range(times):
                    print(prefix, end='|')
                    result = fn(*args, **kwargs)
                return result
            return wrapper
        return decorate
    # This is like a nested for loops with (outer loop)i=2;(inner loop)j=5

    @repeat(times=2, prefix='Yo goods please')
    @repeat(times=5)
    def say(message):
        ''' print the message
        Arguments
            message: the message to show
        '''
        print(message)
    say('Hello')

def dataclass_prac():
    print('dataclass_prac')
    # compare data classes because __eq__ is implemented for you
    # easily print a data class for debugging because __repr__ is implemented as well

    # frozen and eq for hashable to use sets
    @dataclass(frozen=True, eq=True)
    class Card:
        rank: str
        suit: str
    card = Card("Q", "hearts")
    print(card.rank)  # 'Q'
    print(card)  # dataclass_prac.<locals>.Card(rank='Q', suit='hearts')
    # OR
    # print(card.__repr__)  # dataclass_prac.<locals>.Card(rank='Q', suit='hearts')
    print(card == card)  # True
    card2 = Card(rank='Q', suit='hearts')
    card3 = Card(rank='Q', suit='hearts')
    print(card == card2)  # True
    card3 = Card(rank='K', suit='hearts')
    print(card == card3)  # False
    print(set([card, card2, card3]))

def eclipse_ex1():
    # `...` is an alternative to using `pass`
    ...

def misc_prac():
    print('misc_prac')
    # show library path
    print(os)
    x = 1
    # show size of variable in memory
    print(sys.getsizeof(x))
    # the number of references to x
    print(sys.getrefcount(x))
    # access all env vars on os
    print(os.environ)
    str1 = "bluemoon"
    str2 = "geemayl.com"
    print(str1, str2, sep="@", end='|')
    print()
    # for else
    for i in range(5):
        x = i
    else:
        print('no break in loop occurred, will occur even if the loop is not entered')
    # check if objects are exactly the same object or not
    a = ["Antarctica"]
    b = ["Antarctica"]
    c = a
    print(a is b)  # False
    print(a is c)  # True
    print(a is not b)  # True
    # work on open file
    # with open('research.csv') as f:
    # data = csv.reader(f)  # type: ignore
    # for i in data:
    # print(i)
    try:
        assert 1 in [2, 3, 4]
    except (AssertionError, Exception) as err:
        info = {'error': str(err), 'exception_type': str(err.__class__.__name__)}
        print('1 is not in list. error: %(error)s exception_type: %(exception_type)s' % info)

def obj_prac():
    print('obj_prac')
    p = Person('bob', 24, [1, 2, 3])
    p.say()
    # deepcopy works on standard classes aswell
    p2 = copy.deepcopy(p)
    p2.l.append(4)
    p.say()
    p2.say()

def abstract_class_prac():
    print('abstract_class_prac')

    class ClassAbstract(ABC):
        __slots__ = ['value1']

        def __init__(self, val1):
            self.value1 = val1

        @abstractmethod
        def under_construction(self):
            pass

    class ClassImpl(ClassAbstract):
        __slots__ = ['value2']

        def __init__(self, val1, val2):
            super().__init__(val1)
            self.value2 = val2

        def under_construction(self):
            return self.value1 + self.value2
    data1 = ClassImpl(10, 11)
    print(data1.under_construction())

def queue_prac():
    print('queue_prac')
    # Initializing a queue
    queue = []
    # Adding elements to the queue
    queue.append('a')
    queue.append('b')
    queue.append('c')
    print('Initial queue')
    print(queue)
    # Removing elements from the queue
    print('\nElements dequeued from queue')
    print(queue.pop(0))
    print(queue.pop(0))
    print(queue.pop(0))
    print('\nQueue after removing elements')
    print(queue)
    print("minpriortyqueue")
    # NOTE: using a dict only works if the queue times are uniq
    # recommend using a str (id of the object) as the second arg of the tuple and then mapping the id to the object after the work is done
    emps = [
        (1, {'name', 'bob'}),
        (3, {'name', 'sara'}),
        (2, {'name', 'sam'}),
    ]
    heapify(emps)
    heappush(emps, (2, {'name', 'jon'}))
    print('max of queue: ', max(emps, key=lambda e: e[0]))
    for _ in range(0, len(emps)):
        # index 0 to get the min/max value of the heap without removing it
        emp = emps[0]
        print(emp)
        emp = heappop(emps)
        print(emp)
  # maxpriortyqueue (negate number)
    emps = [
        (-1, {'name', 'bob'}),
        (-3, {'name', 'sara'}),
        (-2, {'name', 'sam'}),
    ]
    heapify(emps)
    heappush(emps, (-2, {'name', 'jon'}))
    print('max of queue: ', max(emps, key=lambda e: e[0]))
    for _ in range(0, len(emps)):
        emp = heappop(emps)
        print(emp)

def stack_prac():
    print('stack_prac')
    stack = []
    # append() function to push
    # element in the stack
    stack.append('a')
    stack.append('b')
    stack.append('c')
    print('Initial stack')
    print(stack)
    # pop() function to pop
    # element from stack in
    # LIFO order
    print('\nElements popped from stack:')
    print(stack.pop())
    print(stack.pop())
    print(stack.pop())
    print('\nStack after elements are popped:')
    print(stack)

def groupby2(l: Iterable[Any], key_supplier: Callable):
    def reducer(acc, ele):
        key = key_supplier(ele)
        acc[key] = acc.get(key, [])
        acc[key].append(ele)
        return acc
    return ft.reduce(reducer, l, {})

def type_convert():
    print('type_convert')
    # Function	Converting what to what
    # int()	string, floating point → integer
    # float()	string, integer → floating point number
    # str()	integer, float, list, tuple, dictionary → string
    # list()	string, tuple, set, dictionary → list
    n = 1
    ns = str(n)
    ni = int(ns)
    print(ni)

def type_info():
    print('type_info')
    x = 'hi'  # str
    d = {x: 'stuff'}  # dict
    l = []  # list
    t = (1,)  # tuple
    for ele in [x, d, l, t]:
        print(type(ele).__name__)

def rethrow_exception():
    print('rethrow_exception')
    try:
        x: str = None  # type: ignore
        return x.split('-')
    except Exception as e:
        print('Oops')
        # rethrow the exception
        raise

def tuple_prac():
    print('tuple_prac')
    names = ('Jeff', 'Bill', 'Steve', 'Yash')
    # unpack tuple
    a, b, c, d = names
    # unpack and forget the third ele
    a, b, _, d = names
    # unpack tuple
    first, *middle_eles, last = names
    # unpack and forget the middle eles
    first, *_, last = names
    z = 1, 2
    # list comprehesion on tuple
    print([x + 2 for x in z])
    # * is required to expand the tuple
    print((lambda _, y: y)(*z))
    # reverse tuple
    print(z[::-1])
    # named tuples
    flights = namedtuple("flight", "price, distance")
    US = flights(2000, 5000)
    Iceland = flights(500, 500)
    France = flights(1000, 1001)
    print(France.distance)  # 1001

def chunk_sequence(input_sequence: Sequence[T], chunk_size: int) -> Generator[List[T], None, None]:
    return (list(input_sequence[i:i + chunk_size]) for i in range(0, len(input_sequence), chunk_size))

# py_linq pip package is a great util for list operations with a c# linq like interface
def list_prac():
    print('list_prac')
    l = [1, 2, 3]
    # adds index to each element
    li = enumerate(l)  # [(0, 1), (1, 2), (2, 3)]
    # range includes lower bound and excludes upper bound
    l2 = list(range(4, 7))
    # zip together lists
    l3 = list(zip(l, l2))
    # zip trick
    mat = [[1, 2, 3], [1000, 2000, 3000, 4000]]
    zip(*mat)  # [(1, 1000), (2, 2000), (3, 3000)]
    print(l3)
    # list.map
    print([ele * 2 for ele in l])
    #list.chunk
    my_list = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    chunked_list = list(chunk_sequence(my_list, 3))
    print(chunked_list)
    # seq.map - seq only differs from list in that it uses () instead of [] for comprehesions
    # seq is known as generator
    print(list((ele * 2 for ele in l)))
    # flatten nested data 1 level
    print(list(chain.from_iterable([[1], [[2], 99]])))  # [1, [2], 99]
    # nested list comprehesion
    m = [[j for j in range(3)] for i in range(4)]  # [[0, 1, 2], [0, 1, 2], [0, 1, 2], [0, 1, 2]]
    # flattened a nested list 1 level with list comprehesion
    [value for sublist in m for value in sublist]  # [0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2]
    # list.filter
    print([ele for ele in l if ele > 1])
    # list.reduce list.fold
    print(ft.reduce(lambda acc, ele: acc + ele, l, 0))
    # list.find will throw StopIteration exception if no ele is found
    print(next(x for x in l if x > 2))  # 3
    # list.find will use default value if no ele is found
    print(next((x for x in l if x > 100), 5))  # 5
    # list.findIndex will use default value if no ele is found
    print(next((i for i, x in enumerate(l) if x > 2), -1))  # 2
    # lazy some/every/forall/forany
    # list.any is above 100
    print(next((True for x in l if x > 100), False))  # False
    # OR BETTER
    print(any((x > 100 for x in l)))
    # list.all is above 100
    print(next((False for x in l if not x > 100), True))  # False
    # OR BETTER
    print((not x > 100 for x in l))
    any((False, False, True))  # True
    all((True, True, True))  # True
    # greedy some/every/forall/forany
    any([False, False, True])  # True
    all([True, True, True])  # True
    # list.skip. skip 1 ele
    print(list(range(1, 10))[1::])  # [2, 3, 4, 5, 6, 7, 8, 9]
    # list.take. take first 5 elements
    print(list(range(1, 10))[0:5])  # [1, 2, 3, 4, 5]
    print(groupby2(range(1, 10), lambda ele: ele % 2))  # {1: [1, 3, 5, 7, 9], 0: [2, 4, 6, 8]}
    # itertools groupby depends on order
    for k, c in groupby([1,2,3,4], lambda i: i % 2 == 0):
        print(k, list(c))
    for k, c in groupby([1,2,3,4], lambda i: i > 2):
        print(k, list(c))
    # keep unique list entries and preserve order
    print(OrderedDict.fromkeys([2, 1, 1, 3]).keys())
    # list sorting - creates new list
    print(sorted([{'x': 1}, {'x': 5}, {'x': -1}], key=lambda ele: ele['x']))  # [{'x': -1}, {'x': 1}, {'x': 5}]
    # list sorting - inplace
    sl = [{'x': 1}, {'x': 5}, {'x': -1}]
    sl.sort(key=lambda ele: ele['x'])
    print(sl)  # [{'x': -1}, {'x': 1}, {'x': 5}]
    # sorting with then by (multi level sorting); reverse will apply to all tuple values, so you need to unreverse on a key level. converting things to numbers then negate the number is easiliest
    sl = [('x', 20), ('x', 2), ('z', 2)]
    # ord()/ascii(): ord(c: char) -> int; ascii(i: int) -> char
    sl.sort(key=lambda ele: (-ele[1], -ord(ele[0])), reverse=True)
    print(sl)  # [('x', 2), ('z', 2), ('x', 20)]
    for ele in l:
        print(ele)
    # unpacking lists to merge into 1 list. like spread in js
    my_first_list = [1, 2, 3]
    my_second_list = [4, 5, 6]
    # concat
    my_merged_list = [*my_first_list, *my_second_list]
    # or
    # my_merged_list = my_first_list + my_second_list
    print(my_merged_list)
    # unpacking pattern match to get first and last ele of list, and rest in between
    l = range(1, 10)
    first, *b, last = l
    # unpack and forget the middle elements
    first, *_, last = l
    print(first, last)
    # reverse list
    print(l[::-1])
    # OR
    # l=list(l)
    # l.reverse()
    # print(l)
    # slicing
    # start(not-inclusive),end(inclusive),step
    x = list(range(1, 100))
    print(x[4:40:3])  # 5, 8, ... , 35, 38
    print(x[55:4:-3])  # 56, 53, ... , 11, 8
    # make list immutable
    fx = frozenset(x)
    lst = [1, 2, 3, 4, 2, 2, 3, 1, 4, 4, 4, 5]
    # max frequency in list
    print(max(set(lst), key=lst.count))
    # make shallow copy
    y = x.copy()
    y = x[:]
    # make deep copy
    y = copy.deepcopy(x)

    def odd_list(my_iterable):
        odd_numbers = []
        for x in my_iterable:
            if x % 2 == 1:
                odd_numbers.append(x)
        return odd_numbers

    # better memory use than the previous
    def odd_generator(my_iterable):
        for x in my_iterable:
            if x % 2 == 1:
                yield x
    print(odd_list(range(1, 14)))
    print(list(odd_generator(range(1, 14))))

def args_kwargs_prac():
    print('args_kwargs_prac')
    # args and kwargs are just names, they can be any name you want

    def my_f(a, b, *args, **kwargs):
        c = a + b
        argsStr = ''
        for a in args:
            argsStr += f'{a}'
        kwargsStr = ''
        for k, v in kwargs.items():
            kwargsStr += f'{k}: {v}'
        print(f'c: {c}')
        print(f'argsStr: {argsStr}')
        print(f'kwargsStr: {kwargsStr}')
    my_f(1, 2, [1, 'hi', 'there'], yo='say', z=1)

def set_prac():
    print('set_prac')
    # generate number ranges (include bottom, exclude top of range)
    num_set = set(range(1, 4))
    print(1 in num_set)
    print(4 in num_set)
    # comprehesion to create set
    num_set2 = { x for x in [1, 1, 2, 1 ,4] }
    print(num_set2)
    # Create a list of people (objects)
    people = [
        Person('Alice', 30, []),
        Person('Bob', 25, []),
        Person('Charlie', 35, []),
        Person('Charlie', 35, []),
        Person('David', 25, []),
        Person('Eve', 40, [])
    ]
    print('filter list to uniq person objects: ignoring l param')
    print('using tuples for the basic types')
    uniq_people = [Person(name, age, []) for name, age in {(p.name, p.age) for p in people}]
    # Access the filtered set
    for person in uniq_people:
        # print(person)
        print(f"Name: {person.name}, Age: {person.age}")
    print('using built in hash and eq methods of object')
    uniq_people = set(people)
    # Access the filtered set
    for person in uniq_people:
        # print(person)
        print(f"Name: {person.name}, Age: {person.age}")

def conditional_prac():
    print('conditional_prac')
    # Ternary Operator
    name = 'Bob' if True and True else 'Tim'
    print(name)
    x = 0
    if True or False:
        x += 1
    print(x)
    # switch/case
    # use a dictionary for this
    d = {'a': 1, 'b': 2}
    v = d.get('d', 3)
    print(v)
    # elvis operator, not recommended to be used because of the truthyness concept
    e = v or 'default'  # 3
    # like bash alternative operation. use alternative if thing exists
    e = 0 and 2  # 0
    e = 1 and 2  # 2
    # null coalescing
    x = 'no good way of doing this yet'

def dictionary_prac():
    print('dictionary_prac')
    d = {'a': 1, 'b': 2}
    # default value of 3
    v = d.get('d', 3)
    print(v)
    print(d.keys())
    for key in d.keys():
        print(key)
    for k, v in d.items():
        print(k, v)
    print('a' in d)
    print('a' in d.keys())
    print(1 in d.values())
    d['b'] = d['b'] + 1
    print(d)
    # unpacking dictionaries to merge. like spread in js
    # NOTE: keeps last. so 'D': 4 will be in the merged dict
    my_first_dict = {'A': 1, 'B': 2, 'D': 2}
    my_second_dict = {'C': 3, 'D': 4}
    my_merged_dict = {**my_first_dict, **my_second_dict}
    print(my_merged_dict)
    l = range(0, 7)
    # dictionary comprehesion
    # with use of comparison chaining
    cd = {i: i * 2 for i in l if 1 < i < 4}
    print(cd)
    # swap dictionary values and keys
    a = {1: 11, 2: 22, 3: 33}
    b = {v: k for k, v in a.items()}
    # OR
    # b = dict(zip(a.values(), a.keys()))
    print(b)
    # make shallow copy
    y = a.copy()
    # make deep copy
    y = copy.deepcopy(a)
    # print values in a dictionary
    data = {'name': 'Eric', 'age': 25}
    s = 'Hi, my name is %(name)s and I am %(age)i years old' % data
    print(s)
    # == check on dictionary works for dictionaries with simple values
    x1 = {'x': 1, 'y': [1, 2, 3]}
    x2 = {'x': 1, 'y': [1, 2, 3]}
    print(x1 == x2)  # True
    x1 = {'x': 1, 'y': [1, 2, 3], 'p': Person('bob', 26, [1, 2, 3, 4])}
    x2 = {'x': 1, 'y': [1, 2, 3], 'p': Person('bob', 26, [1, 2, 3, 4])}
    print(x1 == x2)  # False
    # list of tuples to dictionary
    td = dict([('Sachin', 10), ('MSD', 7), ('Kohli', 18), ('Rohit', 45), ('Sachin', 20000)])
    print(td)  # {'Sachin': 20000, 'MSD': 7, 'Kohli': 18, 'Rohit': 45}

def string_prac():
    print('string_prac')
    s = 'sodac'
    # format string using r and f flags. rf and fr are both valid
    x = 1
    print(rf'{x} \nyo') # \n will not print a new line since its a regex string
    # starts_with
    'zzz'.startswith('z')
    # ends_with
    'zzz'.endswith('z')
    # contains, substring, includes
    'z' in 'zzz'
    search_res = re.search('shake|soda|coke|hot chocolate|cappacino|a[bc]', s, re.I)
    print(search_res)
    # OR (re.search and re.match are the same)
    search_res = re.match('shake|soda|coke|hot chocolate|cappacino|a[bc]', s, re.I)
    # get match groups. starts at index 1 (for capture group 1)
    if search_res: print(search_res.groups())
    s = 'Wendy\'s hot dog'
    food_item = re.sub('Wendy\'s', '', s, flags=re.I) if re.search('Wendy\'s', s, re.I) else s
    # WARNING: strip is more than just a trim. It will remove quite a number of special characters
    print(food_item.strip())
    # reverse string
    print(s[::-1])
    # title case a string
    s2 = 'hi there'.title()
    # string to list by delimiter ' '
    sa: List[str] = s.split(' ')
    # list back to string
    s2 = ' '.join(sa)
    # string_to_list
    a = [*'RealPython']  # ['R', 'e', 'a', 'l', 'P', 'y', 't', 'h', 'o', 'n']
    print(a)
    *a, = 'RealPython'
    print(a)
    str3 = '''
  multi
  line
  string
  '''
    print(str3)
    str1: str = 'Whatsup'
    l: List[Tuple[int, str]] = list(enumerate(str1))
    print('generic_pad'.ljust(32, 'a')) # pads a on the right side of the string. so pushing the string left
    print('generic_pad'.rjust(32, 'a')) # pads a on the left side of the string so pushing the string right
    print(l)  # [(0, 'W'), (1, 'h'), (2, 'a'), (3, 't'), (4, 's'), (5, 'u'), (6, 'p')]
    number = 42
    padded_string = "{:032d}".format(number)  # Pad with leading zeros to a total width of 32
    print(padded_string)  # Output: "042"
    # Using f-strings (Python 3.6 and later):
    padded_string = f"{number:03d}"  # Pad with leading zeros to a total width of 3
    print([1,2,3,4,5][-3:])
    print(padded_string)  # Output: "042"
    # can use .format to add a dynamic padding value (the {2})
    print('{0}{1:0{2}}'.format('bob', 10, 3)) # bob010
    # make a random UUID
    print(uuid.uuid4())
    # Convert a UUID to a string of hex digits in standard form
    print(str(uuid.uuid4()))
    # Convert a UUID to a 32-character hexadecimal string
    print(uuid.uuid4().hex)
    # repeat z 5 times: 'zzzzz'
    print('z' * 5)

def unpacking_prac():
    print('unpacking_prac')
    # unpack collections with 1 star notation: *
    # unpack named collections with 2 star notation: **
    # unpacking/spread

    def declare_defaults(p1=None, p2=None, p3=None):
        print([p1, p2, p3])

    def positional_arguments(*args):
        print(args)

    def key_word_arguments(**kwargs):
        print(kwargs)
    ps: Dict[str, int] = {'p1': 1, 'p2': 2, 'p3': 3}
    declare_defaults(p1=1, p2=2, p3=3)  # [1,2,3]
    positional_arguments(1, 2, 3)  # [1,2,3]
    key_word_arguments(p1=1, p2=2, p3=3)  # {'p1': 1, 'p2': 2, 'p3': 3}
    # sends dictionary keys
    declare_defaults(*ps)  # ['p1', 'p2', 'p3']
    declare_defaults(**ps)  # [1,2,3]
    key_word_arguments(**ps)  # {'p1': 1, 'p2': 2, 'p3': 3}

def cacheing_prac():
    print('cacheing_prac')

    @ft.lru_cache(maxsize=None)
    def fibo(x):
        if x <= 1:
            return x
        else:
            return fibo(x - 1) + fibo(x - 2)
    for i in range(50):
        print(fibo(i), end="|")
    print("\n\n", fibo.cache_info())

def enum_prac():
    print('enum_prac')

    class sports(Enum):
        skiing = 0
        soccer = 1
        running = 2
        football = 3
        golf = 4
        swimming = 5
        # can be complex values aswell
        # soccer = {'x': 1}
    print(sports.golf)  # sports.golf
    print(sports.golf.value)  # 4
    print(repr(sports.golf))  # <sports.golf: 4>
    for i in sports.__iter__():
        print(i)


async def main():
    obj_prac()
    abstract_class_prac()
    dataclass_prac()
    enum_prac()
    set_prac()
    list_prac()
    queue_prac()
    stack_prac()
    conditional_prac()
    string_prac()
    dictionary_prac()
    args_kwargs_prac()
    tuple_prac()
    # rethrow_exception()
    type_info()
    type_convert()
    unpacking_prac()
    misc_prac()
    decorator_prac()
    cacheing_prac()
    bo = await countdown_async('tag', 2)
    print(bo)
    GEOJSON_AGGREGATOR = "GEOJSON_AGGREGATOR"
    AGI_BOUNDARY = "AGI_BOUNDARY"
    CHOICES = [
        (GEOJSON_AGGREGATOR, "Use Geojson Aggregator"),
        (AGI_BOUNDARY, "Use AGI Boundary"),
    ]
    boundary_method = 'AGI_BOUNDARY'
    print(boundary_method in [k for k, _ in CHOICES])
    file_name = "hithere"
    invalid_symbols = "|".join(["#", ";"])
    # print(any([sym in file_name for sym in invalid_symbols]))
    # print(next((True for invalid_symbol in invalid_symbols if invalid_symbol in file_name), False))
    # print(file_name.replace("#", "").replace(";", ""))
    if re.search(invalid_symbols, file_name):
        print(re.sub(invalid_symbols, "", file_name))
    else:
        print('no sub!')
    print(f'{CHOICES, file_name}')

asyncio.run(main())
