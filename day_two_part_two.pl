:- set_prolog_flag(verbose, silent).
:- set_prolog_flag(double_quotes, chars).
:- initialization(main).

:- use_module(library(dcg/basics)).

% Grammar
elf_move(rock) --> "A".
elf_move(paper) --> "B".
elf_move(scissors) --> "C".

my_strat(lose) --> "X".
my_strat(draw) --> "Y".
my_strat(win) --> "Z".

round(r(X, Z)) -->
  elf_move(X), " ", my_strat(Y), {strategy(X, Y, Z)}, "\n".

match([]) --> [].
match([H|T]) -->
  round(H),
  { format("Found round ~w\n", [H]) },
  match(T).

% Logic
beats(paper, rock).
beats(scissors, paper).
beats(rock, scissors).

%strategy(Opponent, Strat, Play).
strategy(X, draw, X).
strategy(X, lose, Y) :- beats(X, Y).
strategy(X, win, Y) :- beats(Y, X).

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
