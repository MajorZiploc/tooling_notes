using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

class Program {

  public static void StringPrac() {
    Console.WriteLine("StringPrac");
    string s = "sodac";
    Console.WriteLine("ZZZ".ToLower());
    Console.WriteLine("zzz".ToUpper());
    // Trim chars before and after. defaults to whitespace
    Console.WriteLine(" y\"o\"".Trim('"'));
    Console.WriteLine("y\"o\"".Trim());
    // format string using $ and @ flags in C#
    int x = 1;
    Console.WriteLine($@"{x} \nyo"); // \n will not create a new line since @ treats it as a verbatim string
    // starts_with
    Console.WriteLine("zzz".StartsWith("z"));
    // ends_with
    Console.WriteLine("zzz".EndsWith("z"));
    // contains
    Console.WriteLine("zzz".Contains("z"));
    // regex search (equivalent to Python's re.search)
    Match searchRes = Regex.Match(s, "shake|soda|coke|hot chocolate|cappacino|a[bc]", RegexOptions.IgnoreCase);
    Console.WriteLine(searchRes.Success);
    // get match groups (equivalent to Python's searchRes.groups())
    if (searchRes.Success) {
      Console.WriteLine(searchRes.Value); // capturing matched group
    }
    // string replace with regex
    s = "Wendy's hot dog";
    string foodItem = Regex.IsMatch(s, "Wendy's", RegexOptions.IgnoreCase) ? Regex.Replace(s, "Wendy's", "", RegexOptions.IgnoreCase).Trim() : s;
    Console.WriteLine(foodItem);
    // reverse string
    char[] charArray = s.ToCharArray();
    Array.Reverse(charArray);
    Console.WriteLine(new string(charArray));
    // title case
    string s2 = "hi there";
    Console.WriteLine(System.Globalization.CultureInfo.CurrentCulture.TextInfo.ToTitleCase(s2));
    // string to list by delimiter ' '
    string[] sa = s.Split(' ');
    Console.WriteLine(string.Join(", ", sa));
    // list back to string
    s2 = string.Join(' ', sa);
    Console.WriteLine(s2);
    // string to list of characters
    char[] a = "RealPython".ToCharArray();
    Console.WriteLine(string.Join(", ", a));
    // multi-line string
    string str3 = @"
  multi
  line
  string
  ";
    Console.WriteLine(str3);
    // enumerate string
    string str1 = "Whatsup";
    for (int i = 0; i < str1.Length; i++) {
      Console.WriteLine($"({i}, '{str1[i]}')");
    }
    // padding strings
    Console.WriteLine("generic_pad".PadRight(32, 'a')); // pads 'a' on the right side
    Console.WriteLine("generic_pad".PadLeft(32, 'a')); // pads 'a' on the left side
    // padding numbers with zeros
    int number = 42;
    string paddedString = number.ToString("D32");  // Pad with leading zeros to a total width of 32
    Console.WriteLine(paddedString);
    // pad number with dynamic width (similar to Python's format)
    Console.WriteLine(string.Format("{0}{1:D3}", "bob", 10)); // bob010
    // random UUID
    Guid newGuid = Guid.NewGuid();
    Console.WriteLine(newGuid);
    // UUID as hexadecimal
    Console.WriteLine(newGuid.ToString("N"));
    // repeat 'z' 5 times
    Console.WriteLine(new string('z', 5));
  }

  public static void ListPrac() {
    Console.WriteLine("ListPrac");
    // Simple list declaration
    List<int> l = new List<int> { 1, 2, 3 };
    // Enumerating list (like Python's enumerate)
    var li = l.Select((val, index) => new { Index = index, Value = val });
    // Range equivalent
    List<int> l2 = Enumerable.Range(4, 3).ToList();
    // Zipping lists together
    var l3 = l.Zip(l2, (first, second) => new { first, second }).ToList();
    Console.WriteLine(string.Join(", ", l3.Select(x => $"({x.first}, {x.second})")));
    // List.map (using Select)
    var doubledList = l.Select(ele => ele * 2).ToList();
    Console.WriteLine(string.Join(", ", doubledList));
    // Chunking list (grouping elements into sublists)
    List<int> my_list = new List<int> { 1, 2, 3, 4, 5, 6, 7, 8, 9 };
    var chunked_list = my_list.Select((x, i) => new { Index = i, Value = x })
                  .GroupBy(x => x.Index / 3)
                  .Select(g => g.Select(v => v.Value).ToList())
                  .ToList();
    foreach (var chunk in chunked_list) {
      Console.WriteLine(string.Join(", ", chunk));
    }
    // Flatten nested list 1 level
    var flattened = new List<List<object>> { new List<object> { 1 }, new List<object> { new List<object> { 2 }, 99 } };
    var flat = flattened.SelectMany(sublist => sublist).ToList();
    Console.WriteLine(string.Join(", ", flat));
    // Nested list comprehension equivalent in C#
    var m = Enumerable.Range(0, 4).Select(_ => Enumerable.Range(0, 3).ToList()).ToList();
    var flattenedM = m.SelectMany(sublist => sublist).ToList();
    Console.WriteLine(string.Join(", ", flattenedM));
    // Filtering list
    var filteredList = l.Where(ele => ele > 1).ToList();
    Console.WriteLine(string.Join(", ", filteredList));
    // Reducing list (equivalent to Python's reduce)
    var sum = l.Aggregate(0, (acc, ele) => acc + ele);
    Console.WriteLine(sum);
    // Finding element in list
    int foundElement = l.FirstOrDefault(x => x > 2);
    Console.WriteLine(foundElement != 0 ? foundElement.ToString() : "Not found");
    // Using `Any` and `All`
    bool anyGreaterThan100 = l.Any(x => x > 100);
    bool allGreaterThan100 = l.All(x => x > 100);
    Console.WriteLine(anyGreaterThan100);
    Console.WriteLine(allGreaterThan100);
    // List skip and take
    var skippedList = l.Skip(1).ToList();
    var takenList = l.Take(5).ToList();
    Console.WriteLine(string.Join(", ", skippedList));
    Console.WriteLine(string.Join(", ", takenList));
    // Unpacking elements
    var my_first_list = new List<int> { 1, 2, 3 };
    var my_second_list = new List<int> { 4, 5, 6 };
    var merged_list = my_first_list.Concat(my_second_list).ToList();
    Console.WriteLine(string.Join(", ", merged_list));
    // Slicing (C# version)
    var x = Enumerable.Range(1, 99).ToList();
    var slice1 = x.Where((_, index) => index >= 4 && index < 40 && index % 3 == 1).ToList();
    var slice2 = x.Where((_, index) => index >= 4 && index < 55 && index % 3 == 1).Reverse().ToList();
    Console.WriteLine(string.Join(", ", slice1));
    Console.WriteLine(string.Join(", ", slice2));
    // Max frequency element
    var lst = new List<int> { 1, 2, 3, 4, 2, 2, 3, 1, 4, 4, 4, 5 };
    var maxFreq = lst.GroupBy(ele => ele).OrderByDescending(g => g.Count()).First().Key;
    Console.WriteLine(maxFreq);
    // Shallow copy
    var y = new List<int>(x);
    // Sorting by multiple criteria (then by)
    var sl = new List<Tuple<string, int>> { Tuple.Create("x", 20), Tuple.Create("x", 2), Tuple.Create("z", 2) };
    sl = sl.OrderBy(ele => ele.Item2).ThenBy(ele => ele.Item1).ToList();
    foreach (var ele in sl) {
      Console.WriteLine($"({ele.Item1}, {ele.Item2})");
    }
    // Deep copy (use an external library or manual copying in C#)
  }

  public static void DictionaryPrac() {
    Console.WriteLine("dictionary_prac");
    // Dictionary declaration
    var d = new Dictionary<string, int> { { "a", 1 }, { "b", 2 } };
    // Default value when key doesn't exist
    var v = d.ContainsKey("d") ? d["d"] : 3;
    Console.WriteLine(v);
    // Print dictionary keys
    foreach (var key in d.Keys) {
      Console.WriteLine(key);
    }
    // Iterate over dictionary items
    foreach (var kvp in d) {
      Console.WriteLine($"{kvp.Key}, {kvp.Value}");
    }
    // Check if key exists
    Console.WriteLine(d.ContainsKey("a"));
    // Check if value exists
    Console.WriteLine(d.ContainsValue(1));
    // Update dictionary value
    d["b"] = d["b"] + 1;
    Console.WriteLine(string.Join(", ", d.Select(kvp => $"{kvp.Key}: {kvp.Value}")));
    // Merging dictionaries (similar to **spread in JS)
    var my_first_dict = new Dictionary<string, int> { { "A", 1 }, { "B", 2 }, { "D", 2 } };
    var my_second_dict = new Dictionary<string, int> { { "C", 3 }, { "D", 4 } };
    // NOTE: this path doesnt allow for merging dicts with the same key, will throw an exception
    // var my_merged_dict = my_first_dict.Concat(my_second_dict)
    //                   .ToDictionary(kvp => kvp.Key, kvp => kvp.Value);
    // proly something like this: List of tuples to dictionary
    var my_merged_dict = new List<(string, int)> { ("Sachin", 10), ("MSD", 7), ("Kohli", 18), ("Rohit", 45), ("Sachin", 20000) }
      .GroupBy(t => t.Item1)
      .ToDictionary(g => g.Key, g => g.Last().Item2); // Keeps the last value for duplicate keys
    Console.WriteLine(string.Join(", ", my_merged_dict.Select(kvp => $"{kvp.Key}: {kvp.Value}")));
    // Dictionary comprehension equivalent
    var l = Enumerable.Range(0, 7);
    var cd = l.Where(i => i > 1 && i < 4).ToDictionary(i => i, i => i * 2);
    Console.WriteLine(string.Join(", ", cd.Select(kvp => $"{kvp.Key}: {kvp.Value}")));
    // Swap dictionary keys and values
    var a = new Dictionary<int, int> { { 1, 11 }, { 2, 22 }, { 3, 33 } };
    var b = a.ToDictionary(kvp => kvp.Value, kvp => kvp.Key);
    Console.WriteLine(string.Join(", ", b.Select(kvp => $"{kvp.Key}: {kvp.Value}")));
    // Shallow copy
    var y = new Dictionary<int, int>(a);
    // Deep copy (manual deep copy or using external library)
    var deepCopy = a.ToDictionary(entry => entry.Key, entry => entry.Value);
    // String formatting with a dictionary
    var data = new Dictionary<string, object> { { "name", "Eric" }, { "age", 25 } };
    var s = $"Hi, my name is {data["name"]} and I am {data["age"]} years old";
    Console.WriteLine(s);
    // Dictionary equality check
    var x1 = new Dictionary<string, object> { { "x", 1 }, { "y", new List<int> { 1, 2, 3 } } };
    var x2 = new Dictionary<string, object> { { "x", 1 }, { "y", new List<int> { 1, 2, 3 } } };
    Console.WriteLine(x1.SequenceEqual(x2));  // This won't work if values are complex objects
    // Complex object comparison would require custom equality logic
    // var x1 = new Dictionary<string, object> { { "x", 1 }, { "p", new Person("bob", 26, new List<int> { 1, 2, 3, 4 }) } };
    // var x2 = new Dictionary<string, object> { { "x", 1 }, { "p", new Person("bob", 26, new List<int> { 1, 2, 3, 4 }) } };
    // Console.WriteLine(x1.SequenceEqual(x2)); // False because of object reference comparison
  }

  public static void Main(string[] args) {
    Program.StringPrac();
    Program.ListPrac();
    Program.DictionaryPrac();
  }

}
