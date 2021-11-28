use crate::utils;

// for better printing for structures
#[derive(Debug)]
struct Rectangle {
  width: u32,
  length: u32,
}

impl Rectangle {
  pub fn square(size: u32) -> Rectangle {
    Rectangle {
      width: size,
      length: size,
    }
  }

  pub fn area(&self) -> u32 {
    self.length * self.width
  }
}

// multiple impl blocks for the same type is supported
impl Rectangle {
  pub fn can_hold(&self, other: &Rectangle) -> bool {
    // rust has auto dereferencing for methods. No need for (*other)
    self.width > other.width && self.length > other.length
  }
}

enum MyIpAddr {
  V4(u8, u8, u8, u8),
  V6(String),
}

impl MyIpAddr {
  // enum pattern matching
  pub fn say(&self) {
    match self {
      | MyIpAddr::V4(_, _, _, _) => {
        println!("ip addr 4 says hi")
      }
      | MyIpAddr::V6(_s) => {
        println!("ip addr 6 says bye")
      }
    }
  }
}

pub fn mods() {
  utils::my_mod::say();
}

pub fn options() {
  let x = Some(5);
  if let Some(v) = x {
    println!("syntax sugar for one case match statements with value: {}", v);
  }
  // and_then = bin
  let x = x.map(|v| v + 1).and_then(|v| Some(v + 1));
  dbg!(x);
  let s = String::from("hi there");
  // to_owned creates a copy of the referenced data
  let x = Some(&s).map(|x| x.to_owned() + "!");
  dbg!(s);
  // ref is like & but is ignored in the pattern match. just used to stop move of ownership
  if let Some(ref v) = x {
    println!("Action on some case: {}", v)
  }
  dbg!(x);
}

pub fn enums() {
  let ip_a = MyIpAddr::V4(0, 1, 2, 3);
  ip_a.say();
  let ip_a = MyIpAddr::V6(String::from("wow"));
  ip_a.say();
}

pub fn records() {
  let rec = Rectangle {
    width: dbg!(3 * 2),
    length: 3,
  };
  let square = Rectangle::square(2);
  dbg!(&rec.area());
  dbg!(&rec);
  dbg!(&square);
  dbg!(&rec.can_hold(&square));
  println!("{:#?}", rec);
}

pub fn strs() {
  let s = "string literals are string slices";
  let big_s = String::from(s);
  let sliced_s = &big_s[1..4];
  println!("{}~{}~{}", s, big_s, sliced_s);
}

pub fn nums() {
  let _x = f(); // get that five
  let ar = [_x, if _x > 4 { f2() } else { -7 }];
  let [_x, _y] = ar.map(|ele| ele + 1);
  let mut rest = ar.iter().filter(|ele| **ele > 0);
  // OR
  // let mut rest = ar.iter().filter(|&ele| *ele > 0);
  // OR
  // let mut rest = ar.iter().filter(|&&ele| ele > 0);
  let v = rest.next().unwrap_or(&-1);
  println!("first of the filtered items: {}", v);

  let y = {
    let (x, y): (i32, i32) = (_x, 1);
    x + y
  };
  println!("The value of y is: {}", y);

  let mut counter = 0;
  let result = loop {
    counter += 1;
    if counter == 10 {
      break counter * 2;
    }
  };

  println!("The result is {}", result);
}

// Returns 5
pub fn f() -> i32 {
  5
}

pub fn f2() -> i32 {
  6
}
