/*
Puzzle = [[1,2,3,4,5,6],
          [2,_,4,5,_,1],
          [3,_,_,6,1,_],
          [_,5,6,1,2,_],
          [5,6,1,2,3,4],
          [_,1,_,3,4,_]], str8ts(Puzzle).

Puzzle = [[_,5,"b",2,1],
        [5,_,"b",_,2],
        [3,_,_,1,"b"],
        ["b1",_,2,_,5],
        ["b","b",3,_,4]], str8ts(Puzzle).

Puzzle = [[1,2,3,_,5],
          [2,3,_,5,1],
          [3,_,5,_,_],
          [4,5,"b",_,3],
          [_,_,2,3,_]], str8ts(Puzzle).
*/
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
                writeln('Laenge = '+Laenge),
                writeln('Compartment = '+Compartment),
                writeln('Min = '+Min),
				maximum(Compartment,Max),
                writeln('Max = '+Max),
				Laenge-1 #= Max-Min.

minimum([Min],Min).                            
minimum([X,Y|Tail],Min) :- X #=< Y, minimum([X|Tail],Min).
minimum([X,Y|Tail],Min) :- X #> Y, minimum([Y|Tail],Min).

maximum([Max],Max).                            
maximum([X,Y|Tail],Max) :- X #>= Y, maximum([X|Tail],Max).
maximum([X,Y|Tail],Max) :- X #< Y, maximum([Y|Tail],Max).

magic([]).
magic(Row):-
                
                split_s(Row,ListC),
                writeln('ListC = '+ListC),
                findbnumbers(Row, ListB),
                writeln('ListB = '+ListB),
                
                append(ListC, ListCmerged),
                ListCmerged ins 1..5,
                writeln('ListCmerged = '+ListCmerged),
                
                append(ListB, ListCmerged, List),
                
                all_different(List),
                writeln('opa'),
                maplist(compartment, ListC).

findcompartment([],[]).                        
findcompartment(Row, [Comp|ListC]):-
                split(Row, Comp, Rest),
                findcompartment(Rest, ListC), !.

split_s([],[[]]).
split_s([H|T],[[H|XH]|XR]) :- var(H),!,split_s(T,[XH|XR]).
split_s(["b"|T],[[]|X]) :- !,split_s(T,X).
split_s([H|T],[[H|XH]|XR]) :- split_s(T,[XH|XR]).


findbnumbers([],[]).                           
findbnumbers([X|Tail], [S|Bs]):-
                writeln('X = '+X),
                nonvar(X),
                /*
                is_list(X),
                */
                string_codes(X,N),
                writeln('N = '+N),
                length(N,2),
                N = [A|B],
                writeln('A = '+A),
                writeln('B = '+B),
                A == 98,
                number_codes(S, B),
                number(S),
                writeln('S = '+S),
                writeln('tail = '+Tail),
                writeln('Bs = '+Bs),
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
