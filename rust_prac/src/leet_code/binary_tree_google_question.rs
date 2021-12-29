pub use std::{borrow::Borrow, rc::Rc};

#[derive(Debug)]
pub enum Node {
  NonLeaf(usize, Rc<Node>, Rc<Node>),
  Leaf(String),
}

pub fn get_char(i: i32, n: &Node) -> Option<char> {
  get_char_helper(i, n, 0).and_then(|(f, _)| f)
}

pub fn get_char_helper(i: i32, n: &Node, curr_i: i32) -> Option<(Option<char>, i32)> {
  match n {
    | Node::NonLeaf(total_length, left_child, right_child) => {
      let tl: i32 = i32::try_from(*total_length).ok()?;
      if i > tl {
        return None;
      }
      let (left_res, new_curr_i) = get_char_helper(i, left_child.borrow(), curr_i)?;
      if left_res.is_none() {
        get_char_helper(i, right_child.borrow(), new_curr_i)
      } else {
        Some((left_res, new_curr_i))
      }
    }
    | Node::Leaf(phrase) => {
      let ipl = i32::try_from(phrase.len()).ok()?;
      let max_i = curr_i + ipl;
      if i < max_i {
        let ui: usize = i.try_into().ok()?;
        let u_curr_i: usize = curr_i.try_into().ok()?;
        Some((phrase.chars().nth(ui - u_curr_i), max_i))
      } else {
        Some((None, max_i))
      }
    }
  }
}

pub fn get_substr(low: i32, high: i32, n: &Node) -> Option<String> {
  get_substr_helper(low, high, n, 0).and_then(|(f, _)| f)
}

pub fn get_substr_helper(low: i32, high: i32, n: &Node, curr_i: i32) -> Option<(Option<String>, i32)> {
  match n {
    | Node::NonLeaf(total_length, left_child, right_child) => {
      let tl: i32 = i32::try_from(*total_length).ok()?;
      if low > tl {
        return None;
      }
      let (left_res, new_curr_i) = get_substr_helper(low, high, left_child.borrow(), curr_i)?;
      if high > new_curr_i {
        let left = left_res.unwrap_or("".to_string());
        let (right_res, new_curr_i2) = get_substr_helper(low, high, right_child.borrow(), new_curr_i)?;
        Some((right_res.map(|s| left + &s), new_curr_i2))
      } else {
        Some((left_res, new_curr_i))
      }
    }
    | Node::Leaf(phrase) => {
      let ipl = i32::try_from(phrase.len()).ok()?;
      let max_i = curr_i + ipl;
      if low <= max_i {
        let slice_low: usize = (if low < curr_i { 0 } else { low - curr_i }).try_into().ok()?;
        let slice_high: usize = (if max_i < high { max_i } else { high - curr_i + 1 }).try_into().ok()?;
        Some((
          Some(phrase.chars().collect::<Vec<char>>()[slice_low..slice_high].to_owned().iter().collect::<String>()),
          max_i,
        ))
      } else {
        Some((None, max_i))
      }
    }
  }
}

#[cfg(test)]
mod get_char_tests {
  use super::*;

  #[test]
  fn tests() {
    let abc = "abc".to_string();
    let _123 = "123".to_string();
    let abc_len = abc.len();
    let _123_len = _123.len();
    let leaf1 = Rc::new(Node::Leaf(abc));
    let leaf2 = Rc::new(Node::Leaf(_123));
    let tree = Node::NonLeaf(_123_len + abc_len, leaf1, leaf2);
    assert_eq!(get_char(1, &tree), Some('b'));
    assert_eq!(get_char(5, &tree), Some('3'));
  }
}

#[cfg(test)]
mod get_substr_tests {
  use super::*;

  #[test]
  fn tests() {
    let abc = "abc".to_string();
    let _123 = "123".to_string();
    let abc_len = abc.len();
    let _123_len = _123.len();
    let leaf1 = Rc::new(Node::Leaf(abc));
    let leaf2 = Rc::new(Node::Leaf(_123));
    let tree = Node::NonLeaf(_123_len + abc_len, leaf1, leaf2);
    assert_eq!(get_substr(1, 2, &tree), Some("bc".to_string()));
    assert_eq!(get_substr(1, 5, &tree), Some("bc123".to_string()));
  }
}
