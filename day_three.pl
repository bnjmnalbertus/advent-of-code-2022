:- set_prolog_flag(verbose, silent).
:- set_prolog_flag(double_quotes, chars).
:- initialization(main).

split_at(0,L,[],L) :- !.
split_at(N,[H|T],[H|L1],L2) :-
  M is N -1,
  split_at(M,T,L1,L2).

string_code_set(Str, Set) :-
  string_codes(Str, Codes), list_to_set(Codes, Set).

in_both(Rucksack, Item) :-
  string_codes(Rucksack, Items),
  length(Items, Length),
  Half is Length / 2,
  split_at(Half, Items, A, B),
  list_to_set(A, S1),
  list_to_set(B, S2),
  intersection(S1, S2, [Item]).

priority(Item, Pri) :- char_type(Item, upper), !,
  Pri is Item - 0'A + 27.
priority(Item, Pri) :- char_type(Item, lower), !,
  Pri is Item - 0'a + 1.

priority_item([], 0).
priority_item(Rucksack, Priority) :-
  in_both(Rucksack, Item)
  -> priority(Item, Priority)
  ;  Priority is 0.

part_one_solution(List, Value) :-
  split_string(List, "\n", "", L),
  maplist(priority_item, L, Items),
  sum_list(Items, Value).

common_items([A, B, C|T], [Group|Gs]) :-
  string_code_set(A, S1), string_code_set(B, S2), string_code_set(C, S3),
  intersection(S1, S2, Ss), intersection(S3, Ss, [Group]),
  common_items(T, Gs).
common_items(_, []).

part_two_solution(Str, Value) :-
  split_string(Str, "\n", "", L),
  common_items(L, Items),
  maplist(priority, Items, Pris),
  sum_list(Pris, Value).

main :-
  current_prolog_flag(argv, Argv),
  nth0(0, Argv, Arg1),
  write(Arg1), nl,
  read_file_to_string(Arg1, List, []),
  %part_one_solution(List, Val),
  part_two_solution(List, Val),
  write(Val), nl,
  halt.
main :-
  write("poop\n"),
  halt(1).
