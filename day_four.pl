:- set_prolog_flag(verbose, silent).
:- set_prolog_flag(double_quotes, chars).
:- initialization(main).

:- use_module(library(dcg/basics)).

assignment(A, B) --> integer(A), "-", integer(B).

containing_pair -->
  assignment(A1, B1), ",", assignment(A2, B2),
  % Part one
  %{ (A1 =< A2, B2 =< B1)
  %; (A2 =< A1, B1 =< B2)

  % Part two
  { between(A1, B1, A2)
  ; between(A2, B2, A1)
  }, { write('X') }.
noncontaining_pair -->
  assignment(_, _), ",", assignment(_, _), { write('.') }.

big_list(T) -->
  containing_pair, "\n", big_list(S),
  { T is S + 1 }.
big_list(S) -->
  noncontaining_pair, "\n", big_list(S).
big_list(0) --> "\n".
big_list(0) --> [].

chars_from_file(Chars, File) :-
  open(File, read, In),
  read_string(In, _, Str),
  close(In),
  string_chars(Str, Chars).

solution(File) :-
  write(File), nl,
  chars_from_file(Chars, File),
  ((phrase(big_list(Containments), Chars),
    nl, write(Containments), nl)
  ; (nl, write('whoops!'), nl
  )).

main :-
  current_prolog_flag(argv, Argv),
  nth0(0, Argv, File),
  solution(File),
  halt.
main :-
  write("poop\n"),
  halt(1).
