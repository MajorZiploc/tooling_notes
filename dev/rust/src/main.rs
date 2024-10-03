use std::io::Read;

use itertools::Itertools;
use leet_code::decompress_string;
use leet_code::fib;
use leet_code::k_freq_words;
use leet_code::open_close::test_open_close_stack;

use crate::basics::main::*;
use crate::basics::results::*;
use crate::basics::traits::*;
use crate::basics::vectors::*;

mod basics;
mod leet_code;
mod utils;

fn rust_book_tutorials() {
  strs();
  nums();
  records();
  enums();
  options();
  mods();
  vecs();
  //stuff(||);
}

fn main() {
  // rust_book_tutorials()
  // test_open_close_stack()
  // fib::test()
  // k_freq_words::test();
  // decompress_string::test();
}
