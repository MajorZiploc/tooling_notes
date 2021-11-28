:- initialization main, halt; halt.

last_survivor(Letters, [], Res) :- atom_string(Res, Letters).
last_survivor(Letters, [Coord|Coords], Res) :-
  string_chars(Letters, Chars),
  nth0(Coord, Chars, _, RemChars),
  string_chars(RemLetters, RemChars),
  last_survivor(RemLetters, Coords, Res)
  .

%let lastSurvivor (letters : string) (coords : int list) : string =
  %coords |> List.fold (fun acc i -> acc.Remove(i,1)) letters

last_survivor2(Letters, Coords, Result) :-
  string_chars(Letters, Chars),
  foldl([I, Acc, NewAcc] >> nth0(I, Acc, _ ,NewAcc), Coords, Chars, [Result]).

gen_range_helper(Min, Max, Step, Acc, Res) :-
  write("gen range:"), nl,
  ( Min =< Max
    ->
  write(Min), write(" "),
  write(Max), write(" "),
  write(Step), write(" "),
  write(Res), nl,
   NewMin is Min + Step, gen_range_helper(NewMin, Max, Step, [Min|Acc], Res)
  ; reverse(Acc, Res)
  ).
  
generate_range2(Min, Max, Step, Res) :- gen_range_helper(Min, Max, Step, [], Res).

generate_range(LWR, UPR, DX, R) :-
  findall(R1, generate_range_instance(LWR, UPR, DX, R1), R).

generate_range_instance(LWR, _, _, LWR) :- 
  write("gen range: "), write(LWR), nl
  .
generate_range_instance(LWR, UPR, DX, R) :-
  write("iter:"), 
  write(LWR), write(" "),
  write(UPR), write(" "),
  write(DX), write(" "),
  write(R), nl,
  between(LWR, UPR, R),
  LWR1 is LWR+DX,
  generate_range_instance(LWR1, UPR, DX, R).

vowel_count(S, Vowels) :-
    string_chars(S, Chars),
      foldl([Char, Acc, NewAcc] >> (member(Char, [a,e,i,o,u]) -> NewAcc is Acc + 1; NewAcc is Acc), Chars, 0, Vowels).

prac:-
  generate_range(2,10,3,R)
  , write(R), nl
  , string_chars("abc", SL)
  , nth0(1,SL, _, RL)
  , write(RL), nl
  , string_chars(NewStr, RL)
  , write(NewStr), nl
  , between(10,10,R2)
  , write(R2), nl
  , list_to_ord_set([1,3,2,3], Set1)
  , write(Set1), nl
  % try to convert strings to numbers, then check if thing is an int and square it. Keep successful
  , convlist([X,Y]>>((string(X) -> atom_number(X,N); X=N), integer(N), Y is N^2), [3, 5, foo, "2"], List1)
  , write(List1), nl
  , vowel_count(asedfa, VowelCount)
  , write(VowelCount), nl
  , write("pass"), nl
  .

main :- prac.

