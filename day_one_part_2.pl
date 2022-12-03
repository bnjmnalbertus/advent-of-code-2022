:- set_prolog_flag(verbose, silent).
:- initialization(main).

:- use_module(library(dcg/basics)).

num_list([N|Ns]) --> integer(N), eol, num_list(Ns).
num_list([]) --> eol.

inventory([]) --> eos.
inventory([Sum|Fs]) -->
  num_list(Ns), { sum_list(Ns, Sum) }, inventory(Fs).

solution(Elves, Calories) :-
  sort(Elves, Sorted),
  append(_, [A, B, C], Sorted),
  sum_list([A, B, C], Calories).

main :-
  current_prolog_flag(argv, Argv),
  nth0(0, Argv, File),
  write(File), nl,
  phrase_from_file(inventory(Elves), File),
  solution(Elves, Cals),
  write(Cals), nl,
  halt.
main :-
  write("poop\n"),
  halt(1).
