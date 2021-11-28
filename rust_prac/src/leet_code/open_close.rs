use std::collections::{HashMap, HashSet};

pub fn is_valid(s: String) -> bool {
  let open_chars: HashSet<char> = vec!['[', '{', '('].into_iter().collect();
  let close_open_map: HashMap<char, char> = vec![('}', '{'), (')', '('), (']', '[')].into_iter().collect();
  let mut stack: Vec<char> = Vec::new();
  let mut is_correct = false;
  for c in s.chars() {
    if open_chars.contains(&c) {
      stack.push(c);
    } else {
      let head = stack.pop();
      let closing_match = close_open_map.get(&c);
      is_correct = match (head, closing_match) {
        | (Some(h), Some(&cm)) if h == cm => true,
        | _ => false,
      };
      if !is_correct {
        break;
      }
    }
  }
  is_correct && stack.len() == 0
}

pub fn test_open_close_stack() {
  let r = is_valid("([]){".to_string());
  dbg!(&r);
}

pub fn xo(string: &'static str) -> bool {
  let xo_map: HashMap<char, i16> = vec![('x', -1), ('o', 1)].into_iter().collect();
  string
    .chars()
    .into_iter()
    .flat_map(|c| c.to_lowercase())
    .fold(0i16, |count, c| count + xo_map.get(&c).unwrap_or(&0i16))
    == 0
}

#[test]
fn xo_tests() {
  assert_eq!(xo("xo"), true);
  assert_eq!(xo("Xo"), true);
  assert_eq!(xo("xxOo"), true);
  assert_eq!(xo("xxxm"), false);
  assert_eq!(xo("Oo"), false);
  assert_eq!(xo("ooom"), false);
}
