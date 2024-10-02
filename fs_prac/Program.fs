// Learn more about F# at http://docs.microsoft.com/dotnet/fsharp

open System
open Acadian.FSharp
open System.Text.RegularExpressions
open System.Collections.Generic
open System.Linq

// record
type PersonR = {
  name: string;
  age: int;
}
with
  // string interpolation
  member this.say () = $"Hi, my name is {this.name} and I am {this.age} years old in method form"

module PersonR =
  let say (p: PersonR) = $"Hi, my name is {p.name} and I am {p.age} years old in module function form"

let recordPrac () =
  let p = { name="Bob"; age=24; }
  printfn "%s" (p.say())
  // Update field on record based on old record data
  let p = { p with age=p.age + 10; }
  p |> PersonR.say |> printfn "%s"

// union type
type IPAddressFormat =
  | V4 of (int*int*int*int)
  | V6

module IPAddressFormat =
  // short hand pattern matching
  let show = function
    | V4(nums) -> printfn "V4 of %A" nums
    | V6 -> printfn "V6"

let stringPrac () =
  printfn "stringPrac"
  let s = "sodac"
  // Using interpolation and raw string literals in F#
  let x = 1
  printfn @"%d \nyo" x  // F# doesn't support combining @ (verbatim) with interpolation, so use @""
  printfn "%s" ("ZZZ".ToLower())
  printfn "%s" ("zzz".ToUpper())
  // Starts with
  printfn "%b" ("zzz".StartsWith("z"))
  // Ends with
  printfn "%b" ("zzz".EndsWith("z"))
  // Contains
  printfn "%b" ("zzz".Contains("z"))
  // Regex search
  let pattern = "shake|soda|coke|hot chocolate|cappacino|a[bc]"
  let searchRes = Regex.Match(s, pattern, RegexOptions.IgnoreCase)
  printfn "%A" searchRes
  // Getting capture groups
  if searchRes.Success then
    printfn "%A" searchRes.Groups
  // Substitute "Wendy's" with an empty string
  let s = "Wendy's hot dog"
  let foodItem =
    if Regex.IsMatch(s, "Wendy's", RegexOptions.IgnoreCase) then
      Regex.Replace(s, "Wendy's", "", RegexOptions.IgnoreCase)
    else s
  // Strip removes leading/trailing whitespace
  printfn "%s" (foodItem.Trim())
  // Reverse string
  printfn "%s" (new String(Array.rev (s.ToCharArray())))
  // Title case (F# doesn’t have a built-in TitleCase function)
  let s2 = "hi there"
  printfn "%s" (System.Globalization.CultureInfo.CurrentCulture.TextInfo.ToTitleCase(s2.ToLower()))
  // String to list
  let sa = s.Split([| ' ' |])
  printfn "%A" sa
  // List back to string
  let s2 = String.Join(" ", sa)
  printfn "%s" s2
  // String to character list
  let a = List.ofSeq "RealPython"
  printfn "%A" a
  // Multi-line string
  let str3 = """
  multi
  line
  string
  """
  printfn "%s" str3
  // Enumerate string characters
  let str1 = "Whatsup"
  let l = str1 |> Seq.mapi (fun i c -> (i, c)) |> List.ofSeq
  printfn "%A" l
  // Left and right justify
  printfn "%s" ("generic_pad".PadRight(32, 'a'))
  printfn "%s" ("generic_pad".PadLeft(32, 'a'))
  // Padding numbers with zeros
  let number = 42
  let paddedString = sprintf "%032d" number
  printfn "%s" paddedString
  // Equivalent to f-string dynamic padding
  let paddedString = sprintf "%03d" number
  printfn "%s" paddedString
  printfn "%A" ([1;2;3;4;5] |> List.skip (List.length [1;2;3;4;5] - 3))
  // Dynamic padding with sprintf
  printfn "%s" (sprintf "%s%0*d" "bob" 3 10)
  // Generating a random UUID
  let uuid = Guid.NewGuid()
  printfn "%O" uuid
  // UUID in string format
  printfn "%s" (uuid.ToString())
  // UUID in 32-character hexadecimal form
  printfn "%s" (uuid.ToString("N"))
  // Repeating characters
  printfn "%s" (String.replicate 5 "z")

// Helper function for chunking a sequence
let chunkSequence sequence size =
  sequence
  |> Seq.chunkBySize size

let listPrac () =
    printfn "listPrac"
    let l = [1; 2; 3]
    // Adding index to each element (enumerate)
    let li = List.mapi (fun i x -> (i, x)) l
    printfn "%A" li
    // Create list with a range (F# range excludes upper bound)
    let l2 = [4..6]
    // Zip lists together
    let l3 = List.zip l l2
    printfn "%A" l3
    // Zip trick (transpose lists)
    let padToLength padValue targetLength list =
      list @ List.replicate (targetLength - List.length list) padValue
    let transposeWithPadding lists =
        let maxLength = lists |> List.map List.length |> List.max
        let paddedLists = lists |> List.map (padToLength None maxLength)
        let transposed = List.transpose paddedLists
        // Optionally remove padding after transposing
        transposed |> List.map (List.choose id)
    let mat = [[Some 1; Some 2; Some 3]; [Some 1000; Some 2000; Some 3000; Some 4000]]
    let transposed = transposeWithPadding mat
    printfn "%A" transposed
    // List map (comprehension)
    let doubled = List.map (fun ele -> ele * 2) l
    printfn "%A" doubled
    // Chunk list
    let my_list = [1..9]
    let chunked_list = chunkSequence my_list 3 |> List.ofSeq
    printfn "%A" chunked_list
    // Sequence map (works similarly to Python generators)
    let doubledSeq = Seq.map (fun ele -> ele * 2) l |> Seq.toList
    printfn "%A" doubledSeq
    // Flatten nested data one level
    let flattened = List.concat [[1]; [2; 99]]
    printfn "%A" flattened
    // Nested list comprehension
    let m = [ for i in 0..3 -> [ for j in 0..2 -> j ] ]
    printfn "%A" m
    // Flatten nested list one level
    let flattened_m = [ for sublist in m do for value in sublist -> value ]
    printfn "%A" flattened_m
    // List filter
    let filtered = List.filter (fun ele -> ele > 1) l
    printfn "%A" filtered
    // List fold (reduce)
    let summed = List.fold (fun acc ele -> acc + ele) 0 l
    printfn "%d" summed
    // List.find
    let found = List.find (fun x -> x > 2) l
    printfn "%d" found
    // List.find with default value
    let foundOrDefault = List.tryFind (fun x -> x > 100) l |> Option.defaultValue 5
    printfn "%d" foundOrDefault
    // List.findIndex with default value
    let indexOrDefault = List.tryFindIndex (fun x -> x > 2) l |> Option.defaultValue -1
    printfn "%d" indexOrDefault
    // List.any equivalent (exists)
    let existsAbove100 = List.exists (fun x -> x > 100) l
    printfn "%b" existsAbove100
    // List.all
    let allAbove100 = List.forall (fun x -> x > 100) l
    printfn "%b" allAbove100

let dictionaryPrac() =
  printfn "dictionaryPrac"
  // Create a dictionary
  let d = Dictionary<string, int>()
  d.Add("a", 1)
  d.Add("b", 2)
  // Get value with a default value of 3 if key not found
  let v = if d.ContainsKey("d") then d.["d"] else 3
  printfn "%d" v
  // Print dictionary keys
  printfn "%A" (d.Keys |> Seq.toList)
  // Iterating over keys
  for key in d.Keys do
    printfn "%s" key
  // Iterating over key-value pairs
  for KeyValue(k, v) in d do
    printfn "%s %d" k v
  // Check if a key exists
  printfn "%b" (d.ContainsKey("a"))
  // Check if a key exists (using Keys explicitly)
  printfn "%b" (d.Keys |> Seq.contains "a")
  // Check if a value exists
  printfn "%b" (d.Values |> Seq.contains 1)
  // Modify a value
  d.["b"] <- d.["b"] + 1
  printfn "%A" d
  // Merge two dictionaries (like Python's **unpacking)
  // List of tuples to dictionary
  let mergedDict =
    [ ("Sachin", 10); ("MSD", 7); ("Kohli", 18); ("Rohit", 45); ("Sachin", 20000) ]
    |> List.groupBy fst
    |> List.map (fun (k, v) -> k, v |> List.last |> snd)
    |> dict
  printfn "%A" mergedDict
  // Dictionary comprehension equivalent
  let l = [0..6]
  let cd =
    l
    |> List.filter (fun i -> 1 < i && i < 4)
    |> List.map (fun i -> i, i * 2)
    |> dict
  printfn "%A" cd
  // Swap dictionary keys and values
  let a = dict [ (1, 11); (2, 22); (3, 33) ]
  let b = a |> Seq.map (fun (KeyValue(k, v)) -> v, k) |> dict
  printfn "%A" b
  // Shallow copy
  let y = Dictionary(a)
  // Print values in a dictionary
  let data = dict [ ("name", "Eric"); ("age", "25") ]
  printfn "Hi, my name is %s and I am %s years old" data.["name"] data.["age"]
  // == check works for simple dictionaries
  let x1 = dict [ ("x", 1); ("y", 2) ]
  let x2 = dict [ ("x", 1); ("y", 2) ]
  printfn "%b" (x1 = x2)

let mapPrac() =
  printfn "mapPrac"
  // Create a Map
  let m = Map.ofList [("a", 1); ("b", 2)]
  m |> Map.iter (printfn "%A -> %A")
  // Get value with a default value of 3 if key not found
  let v = Map.tryFind "d" m |> Option.defaultValue 3
  printfn "%d" v
  // Print map keys
  printfn "%A" (Map.keys m)
  // Iterating over keys
  Map.iter (fun key _ -> printfn "%s" key) m
  // Iterating over key-value pairs
  Map.iter (fun k v -> printfn "%s %d" k v) m
  // Check if a key exists
  printfn "%b" (Map.containsKey "a" m)
  // Check if a value exists
  printfn "%b" (Map.exists (fun _ value -> value = 1) m)
  // Modify a value
  let m = m |> Map.add "b" (m.["b"] + 1)
  printfn "%A" m
  // Merge two maps (Map behaves like Python's **unpacking)
  let myFirstMap = Map.ofList [ ("A", 1); ("B", 2); ("D", 2) ]
  let mySecondMap = Map.ofList [ ("C", 3); ("D", 4) ]
  let mergedMap =
    Seq.append (Map.toSeq myFirstMap) (Map.toSeq mySecondMap)
    |> Seq.groupBy fst
    |> Seq.map (fun (k, v) -> k, Seq.last v |> snd)
    |> Map.ofSeq
  printfn "%A" mergedMap
  // Map comprehension equivalent
  let l = [0..6]
  let cd =
    l
    |> List.filter (fun i -> 1 < i && i < 4)
    |> List.map (fun i -> i, i * 2)
    |> Map.ofList
  printfn "%A" cd
  // Swap Map keys and values
  let a = Map.ofList [ (1, 11); (2, 22); (3, 33) ]
  let b = a |> Map.toSeq |> Seq.map (fun (k, v) -> v, k) |> Map.ofSeq
  printfn "%A" b
  // Print values in a map
  let data = Map.ofList [ ("name", "Eric"); ("age", "25") ]
  printfn "Hi, my name is %s and I am %s years old" data.["name"] data.["age"]
  // == check works for simple maps
  let x1 = Map.ofList [ ("x", 1); ("y", 2) ]
  let x2 = Map.ofList [ ("x", 1); ("y", 2) ]
  printfn "%b" (x1 = x2)

let setPrac () =
  let l1 = [1; 2; 3]
  let l2 = [2; 3; 4]
  let _s1 = Set.intersectMany [(Set.ofList l1); (Set.ofList l2)]
  // same as last but only for 2 sets rather than a list
  let s1 = Set.intersect (Set.ofList l1) (Set.ofList l2)
  printfn "%A" s1
  let s2 = Set.union (Set.ofList l1) (Set.ofList l2)
  printfn "%A" s2

let typePrac () =
  let v1 = ""
  let variableType = v1.GetType()
  printfn "The type of myVariable is: %s" (variableType.FullName)


// Define a function to construct a message to print
let from whom =
  sprintf "from %s" whom

let mainAsync _argv = async {
  let a = async { return 1 }
  let xs = [a; a]
  let axs = xs |> Async.Sequential
  let! _axs = axs |> Async.map (printfn "%A")
  IPAddressFormat.show IPAddressFormat.V6
  IPAddressFormat.V4 (1,2,3,4) |> IPAddressFormat.show
  stringPrac ()
  listPrac ()
  dictionaryPrac ()
  mapPrac ()
  setPrac ()
  recordPrac ()
  typePrac ()
  return 0 // return an integer exit code
}

[<EntryPoint>]
let main argv = mainAsync argv |> Async.RunSynchronously

