:- set_prolog_flag(verbose, silent).
:- initialization(main).

sep --> [""].
num(N) --> [S], {number_string(N, S)}.

num_list([N|Ns]) --> num(N), num_list(Ns).
num_list([]) --> [].

inventory([Sum|Fs]) -->
  num_list(Ns), { sum_list(Ns, Sum) }, sep, inventory(Fs).
inventory([]) --> [].


solution(List, Calories) :-
  split_string(List, "\n", "", L),
  phrase(inventory(Elves), L),
  max_list(Elves, Calories).

main :-
  current_prolog_flag(argv, Argv),
  nth0(0, Argv, Arg1),
  write(Arg1), nl,
  read_file_to_string(Arg1, List, []),
  solution(List, Cals),
  write(Cals), nl,
  halt.
main :-
  write("poop\n"),
  halt(1).
