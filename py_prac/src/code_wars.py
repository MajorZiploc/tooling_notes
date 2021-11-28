# # https://www.codewars.com/kata/6329d94bf18e5d0e56bfca77/train/python
# # idfk

# def lru(n, references):
#     memory = []
#     index_queue = []
#     for reference in references:
#         memory_len = len(memory)
#         i, cell = next(((i, cell) for i, cell in enumerate(memory) if reference == cell[1]), (None, None))
#         if cell and i is not None:
#             memory[i] = cell[0] + 1, cell[1]
#             index_queue.remove(i)
#             index_queue.append(i)
#         elif memory_len == n:
#             oldest_index_used = index_queue.pop(0)
#             if oldest_index_used is not None:
#                 memory[oldest_index_used] = 1, reference
#             index_queue.append(oldest_index_used)
#         else:
#             memory.append((1, reference))
#             index_queue.append(len(memory) - 1)
#     values = [value for count, value in memory]
#     num_of_missing_values = n - len(values)
#     if (num_of_missing_values):
#         values.extend([-1 for _ in range(0, num_of_missing_values)])
#     return values



# # [5, 2, 3])
# # print(lru(3, [1, 2, 3, 4, 3, 2, 5]))
# # [-1, -1, -1, -1, -1]
# # print(lru(5, []))
# # [8, 6, 7, 2]
# # print(lru(4, [5, 4, 3, 2, 3, 5, 2, 6, 7, 8]))
# # [8, 6, 7, 2]
# def cycle(direction: int, values: list, search_value):
#     search_value_index = next((idx for idx, v in enumerate(values) if v == search_value), None)
#     if (search_value_index is None):
#         return None
#     len_of_values = len(values)
#     shift = search_value_index + direction
#     idx = shift % len_of_values
#     return values[idx]


# # 7
# # print(cycle(-1,[*range(0,9)],8))

# # print(cycle(10,[*range(0,9)],8))

# from typing import Any

# def pop_blocks(lst: list[Any]):
#   cur_i = 0
#   were_popping = False
#   while cur_i < len(lst) - 1:
#     cur_val = lst[cur_i]
#     next_i = cur_i + 1
#     next_val = lst[next_i]
#     if cur_val == next_val:
#       lst.pop(next_i)
#       were_popping = True
#     else:
#       if were_popping:
#         lst.pop(cur_i)
#         were_popping = False
#         if cur_i:
#           cur_i -= 1
#       else:
#         cur_i += 1
#   return lst

# # ['A']
# # print(pop_blocks(['B', 'B', 'A', 'C', 'A', 'A', 'C']))

# from collections import OrderedDict

# def triangular_range(start, stop):
#     cache = OrderedDict({0: 0})
#     lvl = 1
#     while True:
#         total_stars = lvl + cache[lvl - 1]
#         cache[lvl] = total_stars
#         if total_stars > stop:
#             break
#         lvl += 1
#     tri_range = {}
#     for lvl, total_stars in cache.items():
#         if total_stars > stop:
#             break
#         if total_stars >= start:
#             tri_range[lvl] = total_stars
#     return tri_range

# # {1: 1, 2: 3}
# # print(triangular_range(1, 3))

# # {3: 6, 4: 10, 5: 15})
# # print(triangular_range(5, 16))


# def is_leap_year(year):
#     if (year % 400 == 0):
#         return True
#     if (year % 100 == 0):
#         return False
#     if (year % 4== 0):
#         return True
#     return False

# # True
# # print(is_leap_year(200))

# def elevator_distance(floors):
#     distance = 0
#     num_of_floors = len(floors)
#     if num_of_floors < 2:
#         return distance
#     idx = 0
#     while idx != num_of_floors - 1:
#         distance += abs(floors[idx] - floors[idx + 1])
#         idx += 1
#     return distance

# # 9
# print(elevator_distance([5,2,8]))


# open_to_close = {
#     '[': ']',
#     '{': '}',
#     '(': ')',
# }

# close_to_open = {
#     ']': '[',
#     '}': '{',
#     ')': '(',
# }

# def valid_braces(input_: str):
#     stack = []
#     for c in input_:
#         if c in open_to_close:
#           stack.append(c)
#         else:
#             open_ = close_to_open[c]
#             if open_:
#               if len(stack) == 0:
#                   return False
#               last_char = stack.pop()
#               if last_char != open_:
#                 return False
#     return len(stack) == 0

# def plastic_balance_helper(first, last, eles_sum, eles):
#     target = first + last
#     if target == eles_sum:
#         return [first, *eles, last]
#     len_eles = len(eles)
#     if len_eles == 0: return eles
#     rest = eles[1:len_eles-1]
#     first = eles[0]
#     last = eles[len_eles-1]
#     target = first + last
#     return plastic_balance_helper(first, last, eles_sum - target, rest)


# def plastic_balance(eles):
#     len_eles = len(eles)
#     if len_eles == 0: return eles
#     if eles == [0]: return eles
#     rest = eles[1:len_eles-1]
#     return plastic_balance_helper(eles[0], eles[len_eles-1], sum(rest), rest)


# # []
# print(plastic_balance([1,2,3,4,5]))

# # [104,3,101,0]
# print(plastic_balance([1,2,3,4,5]))

# print(plastic_balance([0]))

# def only_one(*args):
#     return len([a for a in args if a]) == 1

# print(only_one(True, False, True))



# import math
# print(math.gcd(8, 16))


# print(((12 << 24) & (255 << 24)) >> 24)


# def unite_unique(*lsts: list):
#     l = []
#     seen = set()
#     for lst in lsts:
#         for el in lst:
#             if el not in seen:
#                 seen.add(el)
#                 l.append(el)
#     return l

# # [1, 3, 2, 5, 4]
# print(unite_unique([1, 3, 2], [5, 2, 1, 4], [2, 1]))

# print(10 & 1)

# def year_or_step(year: int):
#     cache = {}
#     str_year = str(year)
#     len_year = len(str_year)
#     for idx, i in enumerate(str_year):
#         count = cache.get(i, 0) + 1
#         cache[i] = count
#         if count > 1:
#             power = len_year - 1 - idx
#             max_step: int = 10 ** power
#             left_over = year % max_step
#             step = max_step - left_over
#             return None, step
#     return year, None

# def next_happy_year(year: int):
#     cur_year = year + 1
#     while True:
#         happy_year, step = year_or_step(cur_year)
#         if happy_year:
#             return happy_year
#         if step:
#             cur_year += step
#         else:
#             break


# # 1124 and 100 = 1200
# # 1124 + 76 = 1200
# # 1100 + (100 - 24) = 1200
# # 1100 + (10 ** 2 - 24) = 1200

# # main_chunk + (10 ** power - left_over) = next_year
# # year = main_chunk + left_over
# # 1023
# # print(next_happy_year(1001))
# # 1203
# print(next_happy_year(1123))


# # print('1234'[3:])

#import re

#def alphabet_war(battlefield: str):
#    aftermath = [] 
#    right_count = 0
#    left_count = 0
#    inside_shelter = False
#    cur_shelter = ''
#    on_right_side = False
#    cur_right_side = ''
#    cur_left_side = ''
#    letters_outside_die = False
#    for c in battlefield:
#        if c == '[' and on_right_side:
#            if right_count + left_count > 1:
#                cur_shelter = ''
#            left_count = right_count
#            right_count = 0
#            aftermath.extend([{'data': cur_left_side, 'sheltered': False}, {'data': cur_shelter, 'sheltered': True}, {'data': cur_right_side, 'sheltered': False}])
#            on_right_side = False
#            cur_shelter = ''
#            cur_left_side = ''
#            cur_right_side = ''
#        if c == '[' and not on_right_side:
#            inside_shelter = True
#        if c == ']':
#            inside_shelter = False
#            on_right_side = True
#            cur_shelter += c
#            continue
#        if inside_shelter:
#            cur_shelter += c
#        if not on_right_side and not inside_shelter:
#            if c == '#':
#                letters_outside_die = True
#                left_count += 1
#            if right_count == 0 and left_count == 0:
#                cur_left_side += c
#        if on_right_side and not inside_shelter:
#            if c == '#':
#                letters_outside_die = True
#                right_count += 1
#            if right_count == 0 and left_count == 0:
#                cur_right_side += c
#    if right_count + left_count > 1:
#        cur_shelter = ''
#    aftermath.extend([{'data': cur_left_side, 'sheltered': False}, {'data': cur_shelter, 'sheltered': True}, {'data': cur_right_side, 'sheltered': False}])
#    return re.sub(r'[\[\]]', '', ''.join([el['data'] for el in aftermath if el['sheltered'] or not el['sheltered'] and not letters_outside_die]))

##[[fgh]]ijk

## #abde[fgh]i#jk[mn]op => "mn"

## print(alphabet_war('#abde[fgh]i#jk[mn]op'))
## print(alphabet_war('##a[a]b[c]#'))
## print(alphabet_war('[a][b][c] '))

## ac
#print(alphabet_war('[a]#[b]#[c]'))

## ''
## print(alphabet_war('##abde[fgh]'))

#print(alphabet_war('##abde[fgh]ijk[mn]op'))


# import functools as ft

# left_side = {
#     'w': 4,
#     'p': 3,
#     'b': 2,
#     's': 1,
# }

# right_side = {
#     'm': 4,
#     'q': 3,
#     'd': 2,
#     'z': 1,
# }

# def alphabet_war(battlefield):
#     left, right = ft.reduce(lambda acc, el: (acc[0] + left_side.get(el, 0), acc[1] + right_side.get(el, 0)), battlefield, (0, 0))
#     return "Left side wins!" if left > right else "Right side wins!" if left < right else "Let's fight again!"


# print(alphabet_war("zdqmwpbs")) #, "Let's fight again!")


# def color_2_grey(image):
#     for row in image:
#         for cidx, cell in enumerate(row):
#             v = round(sum(cell) / len(cell))
#             row[cidx] = [v for _ in cell]
#     return image

# # [[[122.0, 122.0, 122.0], [74.33333333333333, 74.33333333333333, 74.33333333333333]], [[102.0, 102.0, 102.0], [132.0, 132.0, 132.0]]]
# # [[74.33333333333333, 74.33333333333333, 74.33333333333333], [132.0, 132.0, 132.0]]
#         # tests = [
#         # (
#         #     [[[123,231,12],[56,43,124]],[[78,152,76],[64,132,200]]],
#         #     [[[122,122,122],[74,74,74]],[[102,102,102],[132,132,132]]],
#         # ),
# print(color_2_grey([[[123,231,12],[56,43,124]],[[78,152,76],[64,132,200]]])) 

# def find_paren_match(text, position):
#     no_match = -1
#     len_text = len(text)
#     if position >= len_text: return no_match
#     c = text[position]
#     is_open = c == '('
#     is_close = c == ')'
#     if not is_open and not is_close: return no_match
#     cur_idx = position if is_open else 0
#     end_idx = position if is_close else len_text - 1
#     opens_stack = []
#     while cur_idx <= end_idx:
#         c = text[cur_idx]
#         if c == '(':
#             opens_stack.append(cur_idx)
#         if c == ')':
#             open_idx = opens_stack.pop()
#             if is_open and position == open_idx: return cur_idx
#             if is_close and position == cur_idx: return open_idx
#         cur_idx += 1
#     return no_match

# print(find_paren_match('((x)', 1))

# l = []
# l.append(1)
# l.append(2)
# l.append(3)
# l.pop()
# print(l)

# from typing import List


# def color_2_grey(image: List[List[List[int]]]):
#     for ridx, row in enumerate(image):
#         for cidx, cell in enumerate(row):
#             gray = round(sum(cell) / len(cell))
#             image[ridx][cidx] = [gray for _ in cell]
#     return image


# # [[[123,231,12],[56,43,124]],[[78,152,76],[64,132,200]]],
# # [[[122,122,122],[74,74,74]],[[102,102,102],[132,132,132]]],
# image = [[[123,231,12],[56,43,124]],[[78,152,76],[64,132,200]]]
# print(color_2_grey(image))

# import re


# def increment_string(text: str):
#     m = re.match(r'^(.*?)(\d*)$', text)
#     if not m: return text
#     g = m.groups()
#     s = g[0]
#     ogDigitStr = g[1] or '0'
#     digit = str(int(ogDigitStr) + 1)
#     newDigitStr = digit.rjust(len(ogDigitStr), '0')
#     return f'{s}{newDigitStr}'

# # test.assert_equals(increment_string("foo"), "foo1")
# # test.assert_equals(increment_string("foobar001"), "foobar002")
# print(increment_string('foo'))
# print(increment_string('foo001'))
# print(increment_string('f99oo99'))


# import heapq
# from heapq import heapify, heappop, heappush
# from typing import Dict, List, Tuple

# def queue_time(customer_times: List[int], num_of_tills: int) -> Tuple[int, int]:
#     tills: List[Tuple[int, int]] = [(0, i) for i in range(0, num_of_tills)]
#     for customer_time in customer_times:
#         time, till_info = heappop(tills)
#         heappush(tills, (time + customer_time, till_info))
#     return max(tills, key=lambda t: t[0])

#         # test.assert_equals(queue_time([2,2,3,3,4,4], 2), 9, "wrong answer for a case with two tills")
# print(queue_time([2,2,3,3,4,4], 2))

# from typing import List


# class Node:
#     def __init__(self, value, left=None, right=None):
#         self.value = value
#         self.left = left
#         self.right = right

#     def __str__(self):
#         return f'{self.value} {self.left} {self.right}'

# def array_to_tree(lst: List[int]):
#     len_lst = len(lst)
#     if len_lst == 0: return None
#     return array_to_tree_helper(lst, Node(lst[0]), 0, len_lst)

# def array_to_tree_helper(lst: List[int], tree: Node, cur_idx: int, len_lst: int):
#     offset_idx = cur_idx << 1
#     first_child_idx = offset_idx + 1
#     second_child_idx = first_child_idx + 1
#     if first_child_idx < len_lst:
#         tree.left = array_to_tree_helper(lst, Node(lst[first_child_idx]), first_child_idx, len_lst)
#     if second_child_idx < len_lst:
#         tree.right = array_to_tree_helper(lst, Node(lst[second_child_idx]), second_child_idx, len_lst)
#     return tree



# # 17 0 3 None None 15 None None -4 None None
# # 17 0 None None -4 None None
# # s_actual = str(array_to_tree([17, 0, -4, 3, 15]))
# # s_expected = str(Node(17, Node(0, Node(3), Node(15)), Node(-4)))
# print(array_to_tree([17, 0, -4, 3, 15]))
# # first_child: idx * 2 + 1
# # idx 1 -> 3, 4
# # idx 0 -> 1, 2


# from typing import Tuple


# def happy_year_check(year: int) -> Tuple[int, bool]:
#     cache = {}
#     year_str = str(year)
#     for idx, digit in enumerate(year_str):
#         cache[digit] = cache.get(digit, 0) + 1
#         digit_freq = cache[digit]
#         if digit_freq > 1:
#             max_step = 10 ** (len(year_str) - idx - 1)
#             step = max_step - (year % max_step)
#             return year + step, False
#     return year, True

# def next_happy_year(year: int) -> int:
#     cur_year = year + 1
#     is_happy_year = False
#     while not is_happy_year:
#         cur_year, is_happy_year = happy_year_check(cur_year)
#     return cur_year

# # 2330 -> 10
# # idx=2; len=4; diff=2; 10 ** diff - 1
# # 2331 -> 9

# # 1023
# print(next_happy_year(1001))
# # print(2331 % 10)

# from abc import ABCMeta, abstractmethod
# from typing import Any, List, TypeVar

# class Comparable(metaclass=ABCMeta):
#     @abstractmethod
#     def __lt__(self, other: Any) -> bool: pass
#     @abstractmethod
#     def __gt__(self, other: Any) -> bool: pass
#     def __le__(self, other: Any) -> bool:
#         return not self > other
#     def __ge__(self, other: Any) -> bool:
#         return not self < other

# T = TypeVar('T', bound=Comparable)

# def pop_blocks(lst: List[T]) -> List[T]:
#     len_lst = len(lst)
#     if len_lst == 1: return lst
#     popping = False
#     cidx = 0
#     while cidx < len_lst - 1:
#         cele = lst[cidx]
#         nele = lst[cidx + 1]
#         are_same = cele == nele
#         if are_same or popping:
#             lst.pop(cidx)
#             len_lst -= 1
#             if popping and not are_same:
#                 cidx = max(cidx - 1, 0)
#             popping = are_same
#         else:
#             cidx += 1
#     if popping:
#         lst.pop(cidx)
#     return lst


# # test.assert_equals(pop_blocks(['B', 'B', 'A', 'C', 'A', 'A', 'C']), ['A'])
# # print(pop_blocks(['B', 'B', 'A', 'C', 'A', 'A', 'C']))
# # test.assert_equals(pop_blocks(['C', 'A', 'A', 'C', 'B']), ['B'])
# print(pop_blocks(['C', 'A', 'A', 'C', 'B']))

# from typing import List


# def highest_rank(lst: List[int]):
#     cache = {}
#     for el in lst:
#         cache[el] = cache.get(el, 0) + 1
#     items = list(cache.items())
#     items.sort(key=lambda kv: kv[1], reverse=True)
#     max_freq = items[0][1]
#     return max((item[0] for item in items if item[1] == max_freq))

# print(highest_rank([1,3,2,2,3]))

# from typing import List


# def fifo(page_size: int, refs: List[int]):
#     page = [-1 for _ in range(0, page_size)]
#     cidx = 0
#     for ref in refs:
#         if ref in page: continue
#         page[cidx] = ref
#         cidx = (cidx + 1) % page_size
#     return page

# # [3, [1, 2, 3, 4, 2, 5], [4, 5, 3]],
# print(fifo(3, [1, 2, 3, 4, 2, 5]))


# from typing import List


# def plastic_balance(lst: List[int]) -> List[int]:
#     len_lst = len(lst)
#     if len_lst <= 1: return lst
#     fidx = 0
#     lidx = len_lst - 1
#     fssum = lst[fidx] + lst[lidx]
#     rest = sum(lst) - fssum
#     while fidx < lidx:
#         if rest == fssum: return lst[fidx:lidx+1]
#         fidx += 1
#         lidx -= 1
#         fssum = lst[fidx] + lst[lidx]
#         rest = rest - fssum
#     return []



# from typing import List


# class Node:
#     def __init__(self, value, left=None, right=None):
#         self.value = value
#         self.left = left
#         self.right = right

# def array_to_tree_helper(arr: List[Node], len_arr: int, root_idx,):
#     if root_idx >= len_arr: return None
#     left_idx = root_idx * 2 + 1
#     return Node(arr[root_idx], array_to_tree_helper(arr, len_arr, left_idx), array_to_tree_helper(arr, len_arr, left_idx + 1))

# def array_to_tree(arr: List[Node]):
#     if not arr: return None
#     return array_to_tree_helper(arr, len(arr), 0)



# from typing import List


# def fifo(page_size: int, refs: List[int]) -> List[int]:
#     page = [-1 for _ in range(0, page_size)]
#     cidx = 0
#     for ref in refs:
#         if ref not in page:
#             page[cidx] = ref
#             cidx = (cidx + 1) % page_size
#     return page

# 1101
# max_step = 100
# idx = 1
# max_step = 10 ** (len(str_year) - 1 - idx)
# 1001
# max_step = 1
# idx = 3
# max_step = 10 ** (len(str_year) - 1 - idx)

# print('a'.rjust(2, 'z'))

# def get_step(year: int):
#     str_year: str = str(year)
#     seen = set()
#     for idx, d in enumerate(str_year):
#         if d in seen:
#             max_step = 10 ** (len(str_year) - 1 - idx)
#             step = max_step - (year % max_step)
#             return step
#         else:
#             seen.add(d)
#     return None

# def next_happy_year(year: int):
#     cur_year = year + 1
#     happy_year = None
#     while not happy_year:
#         step = get_step(cur_year)
#         if step:
#             cur_year += step
#         else:
#             happy_year = cur_year
#     return happy_year

# # 1023
# print(next_happy_year(1001))

# print(1101 % 100)


# import re


# def increment_string(text: str):
#     m = re.match(r'^(.*?)(\d*)$', text)
#     if not m: return None
#     g = m.groups()
#     s = g[0]
#     digit = g[1]
#     next_digit = int(digit or 0) + 1
#     padded_next_digit = str(next_digit).rjust(len(digit), '0')
#     return f'{s}{padded_next_digit}'

# print(increment_string('foo'))
# print(increment_string('foo01'))
# print(increment_string('foo99'))


# from heapq import heapify, heappop, heappush
# from typing import List

# def queue_time(customer_times: List[int], num_of_tills: int):
#     till_times = [0 for _ in range(0, num_of_tills)]
#     for customer_time in customer_times:
#         min_till = heappop(till_times)
#         heappush(till_times, min_till + customer_time)
#     return max(till_times)

# # 9
# print(queue_time([2,2,3,3,4,4], 2))
