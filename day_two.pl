:- set_prolog_flag(verbose, silent).
:- set_prolog_flag(double_quotes, chars).
:- initialization(main).

:- use_module(library(dcg/basics)).

elf_move(rock) --> "A".
elf_move(paper) --> "B".
elf_move(scissors) --> "C".

my_move(rock) --> "X".
my_move(paper) --> "Y".
my_move(scissors) --> "Z".

round(r(X, Y)) -->
  elf_move(X), " ", my_move(Y), "\n".

match([]) --> [].
match([H|T]) -->
  round(H),
  { format("Found round ~w\n", [H]) },
  match(T).

round_outcome(r(rock, paper), 6) :- !.
round_outcome(r(paper, scissors), 6) :- !.
round_outcome(r(scissors, rock), 6) :- !.
round_outcome(r(X, X), 3) :- !.
round_outcome(_, 0).

play_score(r(_, rock), 1).
play_score(r(_, paper), 2).
play_score(r(_, scissors), 3).

round_score(Round, Score) :-
  round_outcome(Round, Outcome),
  play_score(Round, S),
  Score is S + Outcome.

solution(File) :-
  write(File), nl,
  chars_from_file(Chars, File),
  phrase(match(Match), Chars),
  maplist(round_score, Match, Scores),
  sum_list(Scores, Total),
  write(Total), nl.

chars_from_file(Chars, File) :-
  open(File, read, In), read_string(In, _, Str), close(In), string_chars(Str, Chars).

main :-
  current_prolog_flag(argv, Argv),
  nth0(0, Argv, File),
  solution(File),
  halt.
main :-
  write("poop\n"),
  halt(1).
