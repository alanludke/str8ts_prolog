:- use_module(library(clpfd)).

str8ts(Puzzle):-
				maplist(magic, Puzzle),         
				transpose(Puzzle, PuzzleT),     
				maplist(magic, PuzzleT),        
				printstr8ts(Puzzle).            

compartment([]).                               
compartment(Compartment) :-
				length(Compartment,Laenge),
				minimum(Compartment,Min),
				maximum(Compartment,Max),
				Laenge-1 #= Max-Min.

minimum([Min],Min).                            
minimum([X,Y|Tail],Min) :- X #=< Y, minimum([X|Tail],Min).
minimum([X,Y|Tail],Min) :- X #> Y, minimum([Y|Tail],Min).

maximum([Max],Max).                            
maximum([X,Y|Tail],Max) :- X #>= Y, maximum([X|Tail],Max).
maximum([X,Y|Tail],Max) :- X #< Y, maximum([Y|Tail],Max).

magic([]).
magic(Row):-
                split_s(Row, ListC),
                findbnumbers(Row, ListB),
                append(ListC, ListCmerged),
                ListCmerged ins 1..9,
                append(ListB, ListCmerged, List),
                all_different(List),
                maplist(compartment, ListC).

findcompartment([],[]).                        
findcompartment(Row, [Comp|ListC]):-
                split(Row, Comp, Rest),
                findcompartment(Rest, ListC), !.

split_s([],[[]]).
split_s([H|T],[[H|XH]|XR]) :- var(H),!,split_s(T,[XH|XR]).
split_s(A,[[]|X]) :-
                A = [H|T],
                string_codes(H,N),
                N = [K|_],
                K == 98,
                !,split_s(T,X).
split_s([H|T],[[H|XH]|XR]) :- split_s(T,[XH|XR]).


findbnumbers([],[]).                           
findbnumbers([X|Tail], [S|Bs]):-
                nonvar(X),
                string_codes(X,N),
                length(N,2),
                N = [A|B],
                A == 98,
                number_codes(S, B),
                number(S),
                findbnumbers(Tail, Bs), !.
findbnumbers([_|Tail], Bs):-  findbnumbers(Tail, Bs).

printstr8ts(Puzzle):-                          
				maplist(printrow, Puzzle).

printrow(Row):-
                printzeichen(Row),
                writeln('').

printzeichen([]).
printzeichen([X|Tail]):-
                is_list(X),
                length(X,2),
                writef("%s", [X]),
                write(' '),
                printzeichen(Tail), !.

printzeichen([X|Tail]):-
                is_list(X),
                length(X,1),
                writef(" %s", [X]),
                write(' '),
                printzeichen(Tail), !.

printzeichen([X|Tail]):-
                write(' '),
                write(X),
                write(' '),
                printzeichen(Tail).
