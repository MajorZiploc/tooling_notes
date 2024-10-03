// try google tech guide heap question for finding k most freq words in word list

// 1. load eles into hashmap from word to freq of word time. O(n); space: O(n)
// 2. load hashmap kv pairs into max heap. time: O(nlogn); space O(n)
// 3. pop k eles off heap and put into an array to return. time: O(klogn), space: O(k)
//
// algo order time complex: O(nlogn); space O(n)

use std::cmp::{Ordering, Reverse};
use std::collections::{BinaryHeap, HashMap};

#[derive(Debug, PartialEq, Eq)]
struct WordFreq {
  word: String,
  freq: i16,
}

impl Ord for WordFreq {
  fn cmp(&self, other: &Self) -> Ordering {
    other.freq.cmp(&self.freq).then_with(|| self.word.cmp(&other.word))
  }
}

impl PartialOrd for WordFreq {
  fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
    Some(self.cmp(other))
  }
}

pub fn k_freq(words: &Vec<String>, k: i8) -> Vec<String> {
  let mut word_freq_map: HashMap<String, i16> = HashMap::new();
  words.iter().for_each(|word| {
    let entry = word_freq_map.get(word).map(|i| *i);
    word_freq_map.insert(word.clone(), entry.unwrap_or(0) + 1);
  });

  let mut heap: BinaryHeap<_> =
    BinaryHeap::from_iter(word_freq_map.into_iter().map(|(w, f)| WordFreq { word: w, freq: f }));
  (0..k).into_iter().filter_map(|_| heap.pop().map(|ele| ele.word.clone())).collect()
  // .filter_map = .choose in F#
}

pub fn test() {
  let words: Vec<_> = vec!["I", "I", "love", "l", "l", "l"].into_iter().map(|s| String::from(s)).collect();
  let res = k_freq(&words, 10);
  dbg!(&res);
  // let mut bh = BinaryHeap::from_iter(vec![1, 4, 32, -1].into_iter().map(Reverse));
}
