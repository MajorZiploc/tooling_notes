pub fn fib(n: u32) -> u32 {
  if n < 2 {
    n
  } else {
    let (f, s) = (2..n).into_iter().fold((0, 1), |(first, second), _| (second, first + second));
    f + s
  }
}

use std::collections::HashMap;
fn f() {
  let mut h = HashMap::new();
  h.insert(1, 1);
  h.insert(2, 2);
}

fn fib_store_helper(n: u32, store: &mut HashMap<u32, u32>) -> u32 {
  let value1: u32;
  match store.get(&n) {
    | Some(v) => {
      value1 = *v;
    }
    | None => {
      value1 = fib_in(n, store);
      store.insert(n, value1);
    }
  }
  value1
}

fn fib_in(n: u32, store: &mut HashMap<u32, u32>) -> u32 {
  if n < 2 {
    n
  } else {
    fib_store_helper(n - 1, store) + fib_store_helper(n - 2, store)
  }
}

pub fn fib_mem(n: u32) -> u32 {
  let mut store = HashMap::new();
  fib_in(n, &mut store)
}

pub fn test() {
  (0..15).into_iter().for_each(|i| {
    dbg!(&i);
    dbg!(fib(i));
  })
}
