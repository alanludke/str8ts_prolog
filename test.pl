split([],[],[]).                               
split([X|Tail], [], Rest):-
                is_list(X),
                X = [A|_],
                [A] == -1,
                Rest = Tail, !.
split([X|Tail], [X|Start], Rest):-
                split(Tail, Start, Rest).