use std::error::Error;
use std::fs::File;
use std::io::Read;

pub fn read_fake_file() -> Result<(), Box<dyn Error>> {
  let mut content = String::new();
  File::open("fake.txt")?.read_to_string(&mut content);
  dbg!(content);
  Ok(())
}
