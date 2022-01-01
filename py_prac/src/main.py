import functools as ft
import re
from queue import Queue
from queue import LifoQueue
from collections import deque
from heapq import heappop, heappush, heapify

class Person(object):
  def __init__(self, name, age):
    self.name = name
    self.age = age

  def say(self):
    # format string interpolation
    print(f'Hi, my name is {self.name}, and I am {self.age} years old')

def obj_prac():
  print('Object practice')
  p = Person('bob', 24)
  p.say()

def queue_prac():
  # Initializing a queue
  queue = []
  # Adding elements to the queue
  queue.append('a')
  queue.append('b')
  queue.append('c')
  print("Initial queue")
  print(queue)
  # Removing elements from the queue
  print("\nElements dequeued from queue")
  print(queue.pop(0))
  print(queue.pop(0))
  print(queue.pop(0))
  print("\nQueue after removing elements")
  print(queue)

def stack_prac():
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

# py_linq pip package is a great util for list operations with a c# linq like interface
def list_prac():
  print('List operations')
  l = [1, 2, 3]
  # list.map
  print([ele * 2 for ele in l])
  # seq.map - seq only differs from list in that it uses () instead of [] for comprehesions
  print(list((ele * 2 for ele in l)))
  # list.filter
  print([ele for ele in l if ele > 1])
  # list.reduce list.fold
  print(ft.reduce(lambda acc, ele: acc + ele, l, 0))
  for ele in l:
    print(ele)

def set_prac():
  print('Set operations')
  # generate number ranges (include bottom, exclude top of range)
  num_set = set(range(1, 4))
  print(1 in num_set)
  print(4 in num_set)

def conditional_prac():
  print('Conditionals')
  # Ternary Operator
  name = "Bob" if True and True else "Tim"
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

def dictionary_prac():
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
  for k, v in d.items():
    print(k, v)

def regex_prac():
  print('Regex')
  s = 'sodac'
  search_res = re.search('shake|soda|coke|hot chocolate|cappacino|a[bc]', s, re.I)
  print(search_res)
  s = 'Wendy\'s hot dog'
  food_item = re.sub('Wendy\'s', '', s, flags=re.I) if re.search('Wendy\'s', s, re.I) else s
  print(food_item.strip())

def main():
  print('Hello world')
  obj_prac()
  set_prac()
  list_prac()
  queue_prac()
  stack_prac()
  conditional_prac()
  regex_prac()
  dictionary_prac()

main()
