pub fn vecs() {
  let mut v: Vec<u8> = Vec::new();
  v.push(1);
  v.push(2);
  v.push(3);
  dbg!(v);
  let v: Vec<u8> = vec![1, 2, 3];
  dbg!(&v);
  for ele in &v {
    println!("ele: {}", ele);
  }
  v.iter().map(|&ele| ele + 1).for_each(|ele| println!("ele after map: {}", ele));
}
