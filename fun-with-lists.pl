
% param 1 - INPUT  - list
% param 2 - OUTPUT - a permutation
permutation([], []) .
permutation(Xs, [Z|Zs]) :- 
	select(Z, Xs, Ys),
	permutation(Ys, Zs) .


% param 1 - INPUT  - elem to remove
% param 2 - INPUT  - list
% param 3 - OUTPUT - lista w/ elem
select(X, [X|Xs], Xs) .
select(Y, [X|Xs], [X|Ys]) :- 
	select(Y, Xs, Ys) .


% param 1 - INPUT  - list
% param 2 - OUTPUT - lenght of the list
lengthof([], 0) .
lengthof([H|T], L) :-
	lengthof(T, L1),
	L is 1 + L1 .


% checks if elem is in list
% param 1 - INPUT  - elem 
% param 2 - OUTPUT - list
member(X, [X|T]) .
member(X, [H|T]) :-
	member(X, T) .


% remove first instance of a elem
% param 1 - INPUT  - elem
% param 2 - INPUT  - list
% param 3 - OUTPUT - list w/ elem
remove(X, [], []) .
remove(X, [X|T], T) .
remove(X, [H|T], [H|Ys]) :-
	remove(X, T, Ys) .


% TO FIX
% param 1 - INPUT  - elem to remove
% param 2 - INPUT  - list
% param 3 - OUTPUT - list w/out all occurences of elem
removeall(X, [], []) .
removeall(X, [X|T], R) :- 
	removeall(X, T, R) .
removeall(X, [H|T], [H|Ys]) :- 
	removeall(X, T, Ys) .


% TO FIX
% param 1 - INPUT  - position to remove
% param 2 - INPUT  - list
% param 3 - OUTPUT - list w/out elem in that position
removepos(P, Xs, Ys) :- 
	removepos_acc(P, 0, Xs, Ys) .

% accumulator version of above
removepos_acc(P, Acc, [], []) :- ! .
removepos_acc(P, Acc, [X|Xs], Xs) :-
	P = Acc, ! .
removepos_acc(P, Acc, [X|Xs], [X|Ys]) :-
	P > Acc,
	Acc1 is Acc + 1,
	removepos_acc(P, Acc1, Xs, Ys) .


% param 1 - INPUT  - list1
% param 2 - INPUT  - list2
% param 3 - OUTPUT - [ lista1 | lista2 ]
concat([], Ys, Ys) :- ! .
concat([X|Xs], Ys, [X|Zs]) :-
	concat(Xs, Ys, Zs) .
	

% param 1 - INPUT  - elem to add in first place
% param 2 - INPUT  - list
% param 3 - OUTPUT - [ elem | list ]
add(X, Ys, [X|Ys]) .


% param 1 - INPUT  - elem to add in last place
% param 2 - INPUT  - list
% param 3 - OUTPUT - [ list | elem ]
tailadd(X, [], [X]) .
tailadd(X, [Y|Ys], [Y|Zs]) :-
	tailadd(X, Ys, Zs) .


% length with tail recursion
% param 1 - INPUT  - list
% param 2 - OUTPUT - length of the list
len(Xs, L) :-
	len_acc(Xs, 0, L) .

% accumulator version
len_acc([], Acc, Acc) :- ! .
len_acc([X|Xs], Acc, L) :-
	Acc1 is Acc + 1,
	len_acc(Xs, Acc1, L) .


% TO FIX bound value
% add in some position
% param 1 - INPUT  - elem
% param 2 - INPUT  - position
% param 3 - INPUT  - list
% param 4 - OUTPUT - list w/ that elem  in that position
insert(E, P, Xs, Ys) :-
	insert_acc(E, P, 0, Xs, Ys) .

% accumulator version of above
insert_acc(E, P, Acc, Ys, [E|Ys]) :-
	P = Acc .
insert_acc(E, P, Acc, [Y|Ys], [Y|Zs]) :-
	P > Acc,
	Acc1 is Acc + 1 ,
	insert_acc(E, P, Acc1, Ys, Zs) .


% param 1 - INPUT  - new elem e
% param 2 - INPUT  - position p
% param 3 - INPUT  - list
% param 4 - OUTPUT - list w/ old elem in position p overwrited with e
update(E, P, Xs, Ys) :-
	update_acc(E, P, 0, Xs, Ys) .

% accumulator version of above
update_acc(E, P, Acc, [X|Xs], [E|Xs]) :- 
	P = Acc .
update_acc(E, P, Acc, [X|Xs], [X|Ys]) :- 
	P > Acc,
	Acc1 is Acc + 1,
	update_acc(E, P, Acc1, Xs, Ys) .


% param 1 - INPUT  - position p
% param 2 - INPUT  - list
% param 3 - OUTPUT - elem of the list in position p
eleminpos(P, Xs, E) :-
	eleminpos_acc(P, 0, Xs, E) .

% accumulator version of above
eleminpos_acc(P, Acc, [X|Xs], X) :-
	P = Acc .
eleminpos_acc(P, Acc, [X|Xs], E) :-
	P > Acc,
	Acc1 is Acc + 1,
	eleminpos_acc(P, Acc1, Xs, E) .


% param 1 - INPUT  - 1st elem
% param 2 - INPUT  - 2nd elem
% param 3 - OUTPUT - min elem
min(X, Y, X) :- 
	X < Y, ! .
min(X, Y, Y) .


% param 1 - INPUT  - list
% param 2 - OUTPUT - min elem of the list
findmin([X|Xs], E) :- 
	findmin_acc(Xs, X, E) .

% accumulator version of above
findmin_acc([], MinTemp, MinTemp) .
findmin_acc([X|Xs], MinTemp, E) :-
	min(MinTemp, X, Y),
	findmin_acc(Xs, Y, E) .


% param 1 - INPUT  - list
% param 2 - OUTPUT - position of the min elem of the list
findminpos([X|Xs], MinPos) :- 
	findminpos_acc([X|Xs], X, 0, 0, MinPos) .

% accumulator version of above
findminpos_acc([], MinTemp, MinTempPos, Acc, MinTempPos) :- ! .
findminpos_acc([X|Xs], MinTemp, MinTempPos, Acc, P) :- 
	MinTemp =< X,
	Acc1 is Acc + 1,
	findminpos_acc(Xs, MinTemp, MinTempPos, Acc1, P), ! .
findminpos_acc([X|Xs], MinTemp, MinTempPos, Acc, P) :- 
	MinTemp > X,
	Acc1 is Acc + 1,
	findminpos_acc(Xs, X, Acc, Acc1, P) .
	

% ====================================================================
% ====================================================================

%                      SORTING ALGORITHM

% ====================================================================
% ====================================================================


% check if a list of integers is ordered
% param 1 - INPUT  - check if a list is ordered
isord([]) .
isord([_]) .
isord([X, Y|Ys]) :-
	X =< Y,
	isord([Y|Ys]) .


% tells if 2nd is a permutation a the 1st
% generate all possible permutations of a list
% param 1 - INPUT  - list
% param 2 - OUTPUT - list permuted
permute([], []) .
permute(Xs, [Z|Zs]) :- 
	remove(Z, Xs, Ys),
	permute(Ys, Zs) .


% Generate and test sorting algorithm --------------------------------
% it generates a permutation and tests if it's ordered
% param 1 - INPUT  - list
% param 2 - OUTPUT - sorted list
naivesort(Xs, Ys) :-
	permutation(Xs, Ys),
	isord(Ys) .


% param 1 - INPUT  - posizione P1
% param 2 - INPUT  - posizione P2
% param 3 - INPUT  - list
% param 4 - OUTPUT - list with elem in P1 and P2 swapped
swap(P1, P2, Xs, Zs) :-
	eleminpos(P1, Xs, E1),
	eleminpos(P2, Xs, E2),
	update(E1, P2, Xs, Ys),
	update(E2, P1, Ys, Zs), ! .


% selection sort -----------------------------------------------------
% param 1 - INPUT  - list
% param 2 - OUTPUT - sorted list
selectionsort([], []) :- !.
selectionsort(Xs, [Y|Zs]) :- 
	findminpos(Xs, P),
	swap(0, P, Xs, [Y|Ys]),
	selectionsort(Ys, Zs) .


% swap things until max is at the end
% param 1 - INPUT  - list
% param 2 - OUTPUT - list w/ its max at last position
bubble([X], []) :- ! .
bubble([X, Y|Ys], [Y|Zs]) :- 
	X > Y,
	bubble([X|Ys], Zs), ! .
bubble([X, Y|Ys], [X|Zs]) :- 
	X =< Y,
	bubble([Y|Ys], Zs) .


% Goes swapping until remains a list w/ length-1 elems
% and max elem apart
% param 1 - INPUT  - list
% param 2 - OUTPUT - list w/ lentgth-1 elems
% param 3 - OUTPUT - max elem of the list
restandmax([X], [], X) :- ! .
restandmax([X, Y|Ys], [Y|Zs], Max) :- 
	X > Y,
	restandmax([X|Ys], Zs, Max), ! .
restandmax([X, Y|Ys], [X|Zs], Max) :- 
	X =< Y,
	restandmax([Y|Ys], Zs, Max) .
	

% Bubble sort --------------------------------------------------------
% param 1 - INPUT  - list
% param 2 - OUTPUT - sorted list
bubblesort(Xs, Ys) :-
	bubblesort_acc(Xs, [], Ys) .

% acumulator version
bubblesort_acc([], Acc, Acc) :- ! .
bubblesort_acc(Xs, Acc, Ys) :-
	restandmax(Xs, Rest, Max),
	bubblesort_acc(Rest, [Max|Acc], Ys) .


% Merge sort ---------------------------------------------------------
% param 1 - INPUT  - list
% param 2 - OUTPUT - sorted list
mergesort([], []) :- ! .
mergesort([X], [X]) :- ! .
mergesort(Xs, Sorted) :-  
	divide(Xs, Y1s, Y2s),
	mergesort(Y1s, Z1s), 
	mergesort(Y2s, Z2s), 
	merge(Z1s, Z2s, Sorted) .


% It divides the list but it doesn't keep the same order
% param 1 - INPUT  - list
% param 2 - OUTPUT - 1st half of the list 
% param 3 - OUTPUT - 2nd half of the list 
divide([], [], []) :- ! .
divide([X], [], [X]) :- ! .
divide([X, Y|Ys], [X|T1], [Y|T2]) :- 
	divide(Ys, T1, T2) .


% It merges 2 lists by choosing always the min elem
% between the 2 heads
% param 1 - INPUT  - list
% param 2 - INPUT  - 1st half of the list 
% param 3 - OUTPUT - 2nd half of the list 
merge([], Ys, Ys) :- ! .
merge(Xs, [], Xs) :- ! .
merge([X|Xs], [Y|Ys], [X|Zs]) :- 
	X < Y,
	merge(Xs, [Y|Ys], Zs), ! .
merge([X|Xs], [Y|Ys], [Y|Zs]) :- 
	X >= Y,
	merge([X|Xs], Ys, Zs), ! .


% middle pos in the list
% param 1 - INPUT  - list
% param 2 - OUTPUT - middle pos of the list 
middlepos([X], 0) :- ! .
middlepos(Xs, Mid) :- 
	len(Xs, L),
	Mid is L // 2 .

% choosing pivot as middle elem
% param 1 - INPUT  - list
% param 2 - OUTPUT - 1st half of the list 
pivot(Xs, Pos, Elem) :-
	middlepos(Xs, Pos),
	eleminpos(Pos, Xs, Elem), ! .


% split a list in 2 lists
% param 1 - INPUT  - list
% param 2 - INPUT  - elem e of the list
% param 3 - OUTPUT - part of the list w/ elem =< e
% param 4 - OUTPUT - part of the list w/ elem  > e 
partition([], Pivot, [], []) :- ! .
partition([X|Xs], Pivot, [X|Ys], Zs) :- 
	X =< Pivot,
	partition(Xs, Pivot, Ys, Zs) , ! .
partition([X|Xs], Pivot, Ys, [X|Zs]) :- 
	X > Pivot,
	partition(Xs, Pivot, Ys, Zs) .
	

% Quick sort ---------------------------------------------------------
% param 1 - INPUT  - list
% param 2 - OUTPUT - sorted list
quicksort([], []) :- ! .
quicksort(Xs, Sorted) :- 
	pivot(Xs, Pos, Pivot),
	removepos(Pos, Xs, X1s),
	partition(X1s, Pivot, Ys, Zs),
	quicksort(Ys, Y1s),
	quicksort(Zs, Z1s),
	concat(Y1s, [Pivot|Z1s], Sorted) .


% ====================================================================
% ====================================================================

%                      STUFF

% ====================================================================
% ====================================================================


bubblesort2(List, Sorted) :- 
	bsort2(List, [], Sorted).

bsort2([], Acc, Acc). :- ! .
bsort2([H|T], Acc, Sorted) :- 
	bubble2(H, T, NT, Max), 
	bsort2(NT, [Max|Acc], Sorted) .
   
bubble2(X, [], [], X) :- ! .
bubble2(X, [Y|T], [Y|NT], Max) :- 
	X > Y, 
	bubble2(X, T, NT, Max), !.
bubble2(X, [Y|T], [X|NT], Max) :- 
	X =< Y, 
	bubble2(Y, T, NT, Max) .

pivoting(H, [], [], []) .
pivoting(H, [X|T], [X|L], G) :- 
	X =< H, 
	pivoting(H, T, L, G) .
pivoting(H, [X|T], L, [X|G]) :- 
	X > H, 
	pivoting(H, T, L, G) .

quick_sort([], []) .
quick_sort([H|T], Sorted) :- 
	pivoting(H, T, L1, L2), 
	quick_sort(L1, Sorted1), 
	quick_sort(L2, Sorted2), 
	concat(Sorted1, [H|Sorted2], Sorted) .
