use std::num;

pub fn alphabet_position_first(text: &str) -> String {
  let ascii_nums: Vec<_> = text
    .to_lowercase()
    .chars()
    .filter_map(|c| u32::try_from(c).ok().filter(|&i| i >= 97 && i <= 122).map(|i| i - 96))
    .collect();
  let mut res = "".to_string();
  for n in ascii_nums {
    res += &(n.to_string() + " ");
  }
  if res.len() > 0 {
    res.remove(res.len() - 1);
  }
  res
}

pub fn alphabet_position_second(text: &str) -> String {
  text
    .to_lowercase()
    .chars()
    .filter_map(|c| u32::try_from(c).ok().filter(|&i| i >= 97 && i <= 122).map(|i| (i - 96).to_string()))
    .collect::<Vec<String>>()
    .join(" ")
}

fn alphabet_position(text: &str) -> String {
  text
    .to_lowercase()
    .chars()
    .filter(|c| c >= &'a' && c <= &'z')
    .map(|c| (c as u32 - 96).to_string())
    .collect::<Vec<String>>()
    .join(" ")
}

#[test]
fn returns_expected() {
  assert_eq!(
    alphabet_position("The sunset sets at twelve o' clock."),
    "20 8 5 19 21 14 19 5 20 19 5 20 19 1 20 20 23 5 12 22 5 15 3 12 15 3 11".to_string()
  );
  assert_eq!(
    alphabet_position("The narwhal bacons at midnight."),
    "20 8 5 14 1 18 23 8 1 12 2 1 3 15 14 19 1 20 13 9 4 14 9 7 8 20".to_string()
  );
}

fn printer_error(s: &str) -> String {
  format!("{}/{}", s.chars().filter(|&c| c > 'm').count(), s.len())
}

fn binary_slice_to_number(powers: &[u32]) -> u32 {
  powers
    .iter()
    .rev()
    .enumerate()
    .filter(|(_, &p)| p == 1)
    .map(|(i, _)| i)
    .filter_map(|i| u32::try_from(i).ok())
    .map(|i| 2 << i)
    .sum::<u32>()
}

fn solution(s: &str) -> String {
  if s.len() == 0 {
    return "".to_string();
  }
  let mut res = "".to_string();
  for c in s.chars() {
    if c >= 'A' && c <= 'Z' {
      res = res + " ";
    }
    res = res + &c.to_string();
  }
  res
}
