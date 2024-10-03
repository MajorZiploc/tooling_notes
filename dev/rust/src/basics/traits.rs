pub trait Summary {
  fn summarize(&self) -> String;
}

pub trait Print {
  fn print(&self) -> String {
    format!("printing...")
  }
}

pub struct NewsArticle {
  pub headline: String,
  pub location: String,
  pub author: String,
  pub content: String,
}

impl Summary for NewsArticle {
  fn summarize(&self) -> String {
    format!("{}, by {} ({})", self.headline, self.author, self.location)
  }
}

impl Print for NewsArticle {}

pub fn show_summaries() {
  let news: NewsArticle = NewsArticle {
    headline: "Penguins Rule!".to_string(),
    location: "New Orleans".to_string(),
    author: "Bob".to_string(),
    content: "Something cool".to_string(),
  };
  println!("{}", news.summarize());
  notify(&news);
}

// fn that takes a trait based param
pub fn notify(item: &(impl Summary + Print)) {
  println!("{}", item.print());
  println!("Breaking news! {}", item.summarize());
}

// fn that takes a trait based param
pub fn notify2<T: Summary + Print>(item: &T) {
  println!("{}", item.print());
  println!("Breaking news! {}", item.summarize());
}

// fn that takes a trait based param
pub fn notify3<T, U>(item: &T, item2: &U)
where
  T: Summary + Print,
  U: Summary,
{
  println!("{}", item.print());
  println!("Breaking news! {}", item.summarize());
  println!("item2: {}", item2.summarize());
}

// Use of explicit life time, not required in this case though
pub fn largest<'a, T>(list: &'a [T]) -> &'a T
where
  T: PartialOrd,
{
  let mut largest = &list[0];
  for item in list {
    if item > largest {
      largest = &item;
    }
  }
  largest
}

use std::fmt::Display;

struct Pair<T> {
  x: T,
  y: T,
}

impl<T> Pair<T> {
  fn new(x: T, y: T) -> Self {
    Self { x, y }
  }
}

impl<T: Display + PartialOrd> Pair<T> {
  fn cmp_display(&self) {
    if self.x >= self.y {
      println!("The largest member is x = {}", self.x);
    } else {
      println!("The largest member is y = {}", self.y);
    }
  }
}
