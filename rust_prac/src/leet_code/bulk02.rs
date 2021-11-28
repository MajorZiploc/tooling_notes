use itertools::Itertools;
use std::cmp::Ordering;

fn fold_array(arr: &[i32], runs: usize) -> Vec<i32> {
  (0..runs).into_iter().fold(arr.to_owned().into_iter().collect::<Vec<i32>>(), |acc, _| fold_array_helper(acc))
}
fn fold_array_helper(arr: Vec<i32>) -> Vec<i32> {
  let middle = arr.len() / 2;
  let first_half = arr[0..middle].to_owned().into_iter();
  let second_half = arr[middle..arr.len()].to_owned().into_iter().rev();
  first_half
    .zip(second_half)
    .map(|(a, b)| a + b)
    .chain((if arr.len() % 2 != 0 { vec![arr[middle]] } else { vec![] }).into_iter())
    .collect::<Vec<i32>>()
}

#[cfg(test)]
mod fold_array_tests {
  use super::*;

  #[test]
  fn basic() {
    let input = [1, 2, 3, 4, 5];
    assert_eq!(fold_array(&input, 1), [6, 6, 3]);
    assert_eq!(fold_array(&input, 2), [9, 6]);
    assert_eq!(fold_array(&input, 3), [15]);

    let input = [-9, 9, -8, 8, 66, 23];
    assert_eq!(fold_array(&input, 1), [14, 75, 0]);
  }
}

fn comp(a: Vec<i64>, b: Vec<i64>) -> bool {
  if a.len() != b.len() {
    return false;
  }
  a.into_iter().map(|e| e * e).sorted().zip(b.into_iter().sorted()).all(|(f, s)| f == s)
}

fn comp2(a: Vec<i64>, b: Vec<i64>) -> bool {
  let mut a1 = a.iter().map(|&x| x * x).collect::<Vec<_>>();
  let mut a2 = b;
  a1.sort();
  a2.sort();
  a1 == a2
}

fn testing(a: Vec<i64>, b: Vec<i64>, exp: bool) -> () {
  assert_eq!(comp(a, b), exp)
}

#[test]
fn tests_comp() {
  let a1 = vec![121, 144, 19, 161, 19, 144, 19, 11];
  let a2 = vec![11 * 11, 121 * 121, 144 * 144, 19 * 19, 161 * 161, 19 * 19, 144 * 144, 19 * 19];
  testing(a1, a2, true);
  let a1 = vec![121, 144, 19, 161, 19, 144, 19, 11];
  let a2 = vec![11 * 21, 121 * 121, 144 * 144, 19 * 19, 161 * 161, 19 * 19, 144 * 144, 19 * 19];
  testing(a1, a2, false);
}

use std::ops::Add;
fn new_weight(w: &str) -> u32 {
  w.chars().into_iter().map(|c| c.to_string().parse::<u32>().unwrap_or(0)).fold(0_u32, u32::add)
}

fn weights_sorter(&w1: &&str, &w2: &&str) -> Ordering {
  match new_weight(w1).cmp(&new_weight(w2)) {
    | Ordering::Equal => w1.cmp(w2),
    | order => order,
  }
}

fn order_weight(s: &str) -> String {
  s.split(' ').into_iter().sorted_by(weights_sorter).join(" ")
}

fn testing1(s: &str, exp: &str) -> () {
  assert_eq!(order_weight(s), exp)
}

#[test]
fn basics_order_weight() {
  testing1("103 123 4444 99 2000", "2000 103 123 4444 99");
  testing1("2000 10003 1234000 44444444 9999 11 11 22 123", "11 11 2000 10003 22 123 1234000 44444444 9999");
}

fn choose_best_sum(t: i32, k: i32, ls: &Vec<i32>) -> i32 {
  let x =
    ls.into_iter().permutations(k.try_into().unwrap()).into_iter().map(|c| c.into_iter().sum()).collect::<Vec<i32>>();
  0
}

fn perm_count(num_of_eles: u32) -> u32 {
  if num_of_eles == 0 {
    return 0;
  }
  let increment = (num_of_eles - 1) * 2;
  increment + perm_count(num_of_eles - 1)
}

fn choose_best_sum_research() {
  let a = [1, 2, 3];
  let v: Vec<_> = a
    .iter()
    .scan(1, |state, &x| {
      dbg!(&state);
      // each iteration, we'll multiply the state by the element
      *state = *state * x;
      // If some, the ele will be added to the resulting iter
      Some(-*state)
    })
    .collect();
  dbg!(&v);
  dbg!((5..6).permutations(2).count());
  dbg!((5..7).permutations(2).count());
  dbg!((5..8).permutations(2).count());
  dbg!((5..9).permutations(2).count());
  dbg!((5..10).permutations(2).count());
  dbg!((5..11).permutations(2).count());
  dbg!((5..12).permutations(2).count());
  dbg!(perm_count(1));
  dbg!(perm_count(2));
  dbg!(perm_count(3));
  dbg!(perm_count(4));
  dbg!(perm_count(5));
  dbg!(perm_count(6));
  dbg!(perm_count(10));
  dbg!(perm_count(40));
  dbg!(perm_count(400));
  dbg!(3_u32.pow(3));
  dbg!(3_u32.pow(4));
  dbg!(3_u32.pow(5));
  dbg!(3_u32.pow(6));
}

fn testing2(t: i32, k: i32, ls: &Vec<i32>, exp: i32) -> () {
  // assert_eq!(choose_best_sum(t, k, ls), exp)
}

#[test]
fn basics_choose_best_sum() {
  let ts = &vec![50, 55, 56, 57, 58];
  testing2(163, 3, ts, 163);
  let ts = &vec![50];
  testing2(163, 3, ts, -1);
  let ts = &vec![91, 74, 73, 85, 73, 81, 87];
  testing2(230, 3, ts, 228);
  testing2(331, 2, ts, 178);
}

fn rot13_helper(uc: u32) -> Option<char> {
  let offset = 13;
  if uc >= 65 && uc <= 90 {
    let v = uc + offset;
    let v = if v > 90 { v - 26 } else { v };
    return Some(v as u8 as char);
  }
  if uc >= 97 && uc <= 122 {
    let v = uc + offset;
    let v = if v > 122 { v - 26 } else { v };
    return Some(v as u8 as char);
  }
  Some(uc as u8 as char)
}

fn rot13(message: &str) -> String {
  message.chars().filter_map(|c| u32::try_from(c).ok().filter(|&u| u <= 255)).filter_map(rot13_helper).collect()
}

#[cfg(test)]
mod tests {
  use super::*;

  #[test]
  fn test_fixed() {
    assert_eq!(rot13("test"), "grfg");
    assert_eq!(rot13("Test"), "Grfg");
  }
}
