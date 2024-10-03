pub fn build_string(stack: &mut Vec<char>) -> String {
  let mut co = stack.pop();
  let mut open_brackets = vec![];
  let mut str_to_repeat = "".to_string();
  let mut times_to_repeat_as_str = "".to_string();
  while co.is_some() {
    let c = co.unwrap();
    if c == ']' {
      str_to_repeat += &build_string(stack)
    }
    if c == '[' {
      open_brackets.push(c);
    }
    if open_brackets.len() == 2 {
      stack.push(c);
      break;
    }
    if open_brackets.len() == 0 && c != ']' {
      str_to_repeat += &c.to_string();
    }
    if open_brackets.len() == 1 && c != '[' && c != ']' {
      times_to_repeat_as_str += &c.to_string();
    }
    co = stack.pop();
  }
  str_to_repeat = str_to_repeat.chars().rev().collect();
  times_to_repeat_as_str = times_to_repeat_as_str.chars().rev().collect();
  let mut rs = "".to_string();
  if times_to_repeat_as_str != "".to_string() {
    let times_to_repeat = times_to_repeat_as_str.parse::<i32>().unwrap();
    for _ in 0..times_to_repeat {
      rs += &str_to_repeat;
    }
  }
  rs
}

pub fn decompress(s: &String) -> String {
  let mut balanced = 0;
  let mut flag = false;
  let mut stack = vec![];
  let mut res = "".to_string();
  for c in s.chars() {
    if c == '[' {
      balanced -= 1;
      flag = true;
    }
    if c == ']' {
      balanced += 1;
      flag = true;
    }
    if balanced == 0 && flag {
      res += &build_string(&mut stack);
      flag = false;
    }
    stack.push(c);
  }
  res
}

pub fn test() {
  dbg!(decompress(&"5[abc]".to_string()));
  dbg!(decompress(&"3[abc]2[5[y]z]".to_string()));
}
