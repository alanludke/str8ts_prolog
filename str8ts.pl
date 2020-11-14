?- use_module(library(clpfd)).

problem([[_,_,_,_,_,4],
         [_,_,_,_,_,1],
         [_,_,3,_,_,_],
         [5,_,_,_,_,_],
         [6,_,4,_,_,_],
         [_,1,_,_,_,_]]).

main :-
        solve_problems.

solve_problems :-
        problem(Rows),
    	str8ts(Rows),
    	maplist(label, Rows),
        maplist(portray_clause, Rows).

str8ts(Rows) :-
        /* list of lenght nine*/
        length(Rows, 6),
        /* map each of the rows to have the same lenght as the list Rows*/
        maplist(same_length(Rows), Rows), 
        /* concatena todos os elementos */
        append(Rows, Vs),
         /* delimita o escopo dos numeros*/
        Vs ins 1..6,
        /* declaração basica do jogo acaba aqui*/

        /*mapeia todas as rows para serem distintas*/
        maplist(all_distinct, Rows),
        /*transpoe a matriz e faz a mesma verificacao (agora ve se todas as colunas sao distintas)*/
        transpose(Rows, Columns),
        maplist(all_distinct, Columns).