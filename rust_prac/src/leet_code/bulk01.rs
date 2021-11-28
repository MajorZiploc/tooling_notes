use std::{collections::{BinaryHeap, HashMap, HashSet}, ascii::AsciiExt};

fn valid_braces(s: &str) -> bool {
  let opens: HashSet<char> = ['(', '{', '['].into_iter().collect();
  let close_open_map: HashMap<char, char> = vec![(')', '('), (']', '['), ('}', '{')].into_iter().collect();
  let mut stack = vec![];
  for c in s.chars() {
    if opens.contains(&c) {
      stack.push(c);
    } else {
      let top = stack.pop();
      let close = close_open_map.get(&c).map(|c| c.clone());
      if top != close {
        return false;
      }
    }
  }
  stack.is_empty()
}

#[cfg(test)]
mod valid_braces_tests {
  use super::*;

  #[test]
  fn basic_tests() {
    expect_true("()");
    expect_false("[(])");
  }

  fn expect_true(s: &str) {
    assert!(valid_braces(s), "Expected {s:?} to be valid. Got false", s = s);
  }

  fn expect_false(s: &str) {
    assert!(!valid_braces(s), "Expected {s:?} to be invalid. Got true", s = s);
  }
}

fn disemvowel(s: &str) -> String {
  let vowels = vec!['a', 'e', 'i', 'o', 'u'].into_iter().collect::<HashSet<char>>();
  s.chars()
    .into_iter()
    .filter(|c| { !vowels.contains(&c.to_ascii_lowercase()) })
    .collect()
   //c.to_lowercase().collect::<String>().chars().nth.as_ref().map(|c| !vowels.contains(c)).unwrap_or(false)
}

fn disemvowel2(s: &str) -> String {
  s.chars().filter(|&c| !matches!(c.to_ascii_lowercase(), 'a' | 'e' | 'i' | 'o' | 'u')).collect()
}

fn disemvowel3(s: &str) -> String {
  let mut ret = s.to_string();
  ret.retain(|c| !"aeiouAEIOU".contains(c));
  ret
}

#[cfg(test)]
mod disemvowel_tests {
  use super::disemvowel;

  #[test]
  fn example_test() {
    assert_eq!(disemvowel("This website is for losers LOL!"), "Ths wbst s fr lsrs LL!");
  }
}

fn is_substr(sub: &str, sup: &str) -> bool {
  sup.contains(sub)
}

fn in_array(arr_a: &[&str], arr_b: &[&str]) -> Vec<String> {
  let mut res = arr_a
    .into_iter()
    .filter_map(|sub_ele| arr_b.into_iter().find(|&sup_ele| sup_ele.contains(sub_ele)).map(|_| sub_ele))
    .map(|&s| s.to_string())
    .collect::<Vec<String>>();
  res.sort();
  res.dedup();
  res
}

use itertools::Itertools;
fn in_array2(arr_a: &[&str], arr_b: &[&str]) -> Vec<String> {
  arr_a
    .iter()
    .map(|x| x.to_string())
    .filter(|x| arr_b.into_iter().any(|y| y.contains(x.as_str())))
    .unique()
    .sorted()
    .collect()
}

#[cfg(test)]
mod in_array_tests {
  use super::*;

  #[test]
  fn examples() {
    assert_eq!(
      in_array(&["xyz", "live", "strong"], &["lively", "alive", "harp", "sharp", "armstrong"],),
      ["live", "strong"]
    );

    assert_eq!(
      in_array(&["live", "strong", "arp"], &["lively", "alive", "harp", "sharp", "armstrong"],),
      ["arp", "live", "strong"]
    );

    assert_eq!(
      in_array(&["tarp", "mice", "bull"], &["lively", "alive", "harp", "sharp", "armstrong"],),
      [] as [&str; 0]
    );

    assert_eq!(
      in_array(&["live", "strong", "arp", "arp"], &["lively", "alive", "harp", "sharp", "armstrong"],),
      ["arp", "live", "strong"]
    );
  }
}

//Deadfish has 4 commands, each 1 character long:
//i increments the value (initially 0)
//d decrements the value
//s squares the value
//o outputs the value into the return array

fn parse(code: &str) -> Vec<i32> {
  let mut res = vec![];
  let mut v = 0;
  for c in code.chars() {
    match c {
      | 'i' => v += 1,
      | 'd' => v -= 1,
      | 's' => v *= v,
      | 'o' => res.push(v),
      | _ => {}
    }
  }
  res
}

fn parse2(code: &str) -> Vec<i32> {
  return code
    .chars()
    .scan(0, |s, c| {
      Some(match c {
        | 'i' => {
          *s += 1;
          None
        }
        | 'd' => {
          *s -= 1;
          None
        }
        | 's' => {
          *s *= *s;
          None
        }
        | 'o' => Some(*s),
        | _ => None,
      })
    })
    .flatten()
    .collect();
}

#[cfg(test)]
mod dead_fish_parse_tests {
  use super::*;
  #[test]
  fn sample_tests() {
    assert_eq!(parse("iiisdoso"), vec![8, 64]);
    assert_eq!(parse("iiisdosodddddiso"), vec![8, 64, 3600]);
  }
}
