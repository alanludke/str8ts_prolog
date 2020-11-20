/*
Importação da biblioteca clpfd - Constraint Logic Programming over Finite Domains.
*/
:- use_module(library(clpfd)).

/*
Mapeia a função 'solve' para linha e coluna do tabuleiro e imprime a matriz resultante
com a função 'print_matrix'.
*/
str8ts(Puzzle):-
                maplist(solve, Puzzle),
                transpose(Puzzle, PuzzleT),
                maplist(solve, PuzzleT),
                print_matrix(Puzzle).

/*
Verifica se os números presentes na lista, caso fossem ordenados, formam uma sequência.
Analisa a igualdade da subtração entre o maior e o menor valor da lista com a quantidade 
total de valores presentes.
*/
compartment([]).
compartment(Compartment) :-
                length(Compartment,Tam),
                minimum(Compartment,Min),
                maximum(Compartment,Max),
                Tam-1 #= Max-Min.

/*
Encontra o valor mínimo de uma lista recebida
*/
minimum([Min],Min).
minimum([X,Y|Tail],Min) :- X #=< Y, minimum([X|Tail],Min).
minimum([X,Y|Tail],Min) :- X #> Y, minimum([Y|Tail],Min).

/*
Encontra o valor máximo de uma lista recebida
*/
maximum([Max],Max).
maximum([X,Y|Tail],Max) :- X #>= Y, maximum([X|Tail],Max).
maximum([X,Y|Tail],Max) :- X #< Y, maximum([Y|Tail],Max).

/*
Resolve os elementos da linha respeitando as regras do jogo.
Inicialmente divide-se a linha em sublistas, caso tenha campos pretos, através da função 'split_s'.
Então encontra-se os números dos campos pretos caso existam (através de 'findbnumbers').
Completam-se os campos vazios com valores no intervalo 1 a N, onde N é a dimensão do tabuleiro.
Verifica se todos os elementos são diferentes e, por fim, averigua se os números formam uma sequência.
*/
solve([]).
solve(Row):-
                split_s(Row, ListC),
                findbnumbers(Row, ListB),
                append(ListC, ListCmerged),
                length(Row,N),
                ListCmerged ins 1..N,
                append(ListB, ListCmerged, List),
                all_different(List),
                maplist(compartment, ListC).

/*
A partir do argumento passado, divide a lista em sublistas.
*/
split_s([],[[]]).
split_s([H|T],[[H|XH]|XR]) :- var(H),!,split_s(T,[XH|XR]).
split_s(A,[[]|X]) :-
                A = [H|T],
                string_codes(H,N),
                N = [K|_],
                K == 98,
                !,split_s(T,X).
split_s([H|T],[[H|XH]|XR]) :- split_s(T,[XH|XR]).

/*
Encontra os campos pretos que apresentam números em uma lista.
Verifica se o campo tem dois caracteres e, a partir disso, retorna o número presente.
*/
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

/*
Imprime a matriz do tabuleiro resolvida no terminal do usuário
*/
print_matrix([]).
print_matrix([H|T]) :- write(H), nl, print_matrix(T).