fn unique_in_order<T>(sequence: T) -> Vec<T::Item>
where
  T: std::iter::IntoIterator,
  T::Item: std::cmp::PartialEq + std::fmt::Debug,
{
  let mut v = vec![];
  let mut sequence = sequence.into_iter();
  if let Some(prev) = sequence.next() {
    v.push(prev);
    let mut prev = &v[0];
    while let Some(next) = sequence.next() {
      if prev != &next {
        v.push(next);
        prev = v.last().unwrap();
      }
    }
  }
  v
}

fn unique_in_order2<T>(sequence: T) -> Vec<T::Item>
where
  T: std::iter::IntoIterator,
  T::Item: std::cmp::PartialEq + std::fmt::Debug,
{
  let mut v: Vec<_> = sequence.into_iter().collect();
  v.dedup();
  v
}

fn unique_in_order3<T>(seq: T) -> Vec<T::Item>
where
  T: std::iter::IntoIterator,
  T::Item: std::cmp::PartialEq + std::fmt::Debug,
{
  let mut res: Vec<T::Item> = vec![];
  for i in seq {
    if res.is_empty() || Some(&i) != res.last() {
      res.push(i);
    }
  }
  res
}

#[cfg(test)]
mod tests {
  use super::*;

  #[test]
  fn sample_test() {
    assert_eq!(unique_in_order("AAAABBBCCDAABBB".chars()), vec!['A', 'B', 'C', 'D', 'A', 'B']);
  }
}
