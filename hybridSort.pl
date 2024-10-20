% Bubble Sort
% swap/2
/*
Clause 1: Swap the first two elements if they are not in order.
*/
swap([X, Y|T], [Y, X | T]):-
    Y < X.

/*
Clause 2: Swap elements in the tail if the first two elements are in order.
*/
swap([H | T], [H |T1]):-
    swap(T, T1).

% bubbleSort/2
/*
Clause 1: Perform swap on the list L and bubbleSort on the result of the swap.
*/
bubbleSort(L,SL):-
    swap(L, L1), % at least one swap is needed
    !,
    bubbleSort(L1, SL).

/*
Clause 2: If no swap occurs, the list is already sorted.
*/
bubbleSort(L, L). % here, the list is already sorted

% Insertion Sort
% ordered/1
/*
Clause 1: Empty list is already ordered.
*/
ordered([]).

/*
Clause 2: List with a single element is already ordered.
*/
ordered([_X]).

/*
Clause 3: If the first two elements are in order, perform ordered on the list
without the first element.
*/
ordered([H1, H2 | T]):-
    H1 =< H2,
    ordered([H2|T]).

% insert/3
/*
Clause 1: Insert the element to the list if the list is empty.
*/
insert(X, [], [X]).

/*
Clause 2: Insert the element to the start of the list if the list is sorted and
the element is less than or equal to the head of the list.
*/
insert(E, [H | T], [E, H | T]):-
    ordered([H | T]),
    E =< H,
    !.

/*
Clause 3: Insert the element to the tail of the list, if the element is greater
than the head of the list.
*/
insert(E, [H | T], [H | T1]):-
    ordered([H | T]),
    insert(E, T, T1).

% insertionSort/2
/*
Clause 1: Empty list is already sorted.
*/
insertionSort([], []).

/*
Clause 2: Sort the tail of the list recursively and insert the head of the list
to the sorted tail.
*/
insertionSort([H | T], SORTED) :-
    insertionSort(T, T1),
    insert(H, T1, SORTED).

% Merge Sort
% mergeSort/2
/*
Clause 1: Empty list is already sorted.
*/
mergeSort([], []). % The empty list is sorted

/*
Clause 2: List with a single element is already sorted.
*/
mergeSort([X], [X]):-
    !.

/*
Clause 3: Splits the list into two halves, sorts the two lists recursively and
merges the lists in order.
*/
mergeSort(L, SL):-
    splitInHalf(L, L1, L2),
    mergeSort(L1, S1),
    mergeSort(L2, S2),
    merge(S1, S2, SL).

% intDiv/3
/*
Clause 1: Divides N by N1 and stores it in R.
*/
intDiv(N, N1, R):-
    R is div(N, N1).

% splitInHalf/3
/*
Clause 1: Empty list cannot be split, return fail.
*/
splitInHalf([], _, _):-
    !,
    fail.

/*
Clause 2: If the list to split has only one element, then return an empty list
and a list with the single element.
*/
splitInHalf([X], [], [X]).

/*
Clause 3: When a list L is split, the first half of the list must have a length
of half the original list and appending first half and second half should return
the original list.
*/
splitInHalf(L, L1, L2):-
    length(L, N),
    intDiv(N, 2, N1),
    length(L1, N1),
    append(L1, L2, L).

% merge/3
/*
Clause 1: If first list is empty, the merged list is the second list.
*/
merge([], L, L).

/*
Clause 2: If the first list is not empty, but the second list is, the merged
list is the first list.
*/
merge(L, [], L).

/*
Clause 3: If head of list 1 is less than the head of the list 2, put the head of
list 1 at the head of the output list and merge the tail of list 1 with list 2
to get the tail of output list.
*/
merge([H1 | T1], [H2 | T2], [H1 | T]):-
    H1 < H2,
    merge(T1, [H2 | T2], T).

/*
Clause 4: If head of list 1 is greater than or equal to the head of the list 2,
put the head of list 2 at the head of the output list and merge list 1 with the
tail of list 2 to get the tail of output list.
*/
merge([H1 | T1], [H2 | T2], [H2 | T]):-
    H2 =< H1,
    merge([H1 | T1], T2, T).

% Quick Sort
% split/4
/*
Clause 1: If the list to split is empty, return two empty lists.
*/
split(_, [], [], []).

/*
Clause 2: If the head of the list to split is less than or equal to the
partition value X, put the head of the list in the small list and split the
tail of the list.
*/
split(X, [H | T], [H | SMALL], BIG):-
    H =< X,
    split(X, T, SMALL, BIG).

/*
Clause 3: If the partition element is less than the head of the list to split
put the head of the list in the big list and split the tail of the list.
*/
split(X, [H | T], SMALL, [H | BIG]):-
    X < H,
    split(X, T, SMALL, BIG).

% quickSort/2
/*
Clause 1: Empty list is already sorted.
*/
quickSort([], []).

/*
Clause 2: Split the tail of the list with the head as the partition into small
and big list. Recursively sort the small and the big list and append the small,
head and big list together to get the sorted list.
*/
quickSort([H | T], LS):-
    split(H, T, SMALL, BIG),
    quickSort(SMALL, S),
    quickSort(BIG, B),
    append(S, [H | B], LS).

% Hybrid Sort
% hybridSort/5
/*
Clause 1: If the length of the list is less than or equal to the threshold
value, directly apply the small sorting algorithm to get the sorted list.
*/
hybridSort(LIST, SMALLALG, _BIGALG, THRESHOLD, SLIST):-
    member(SMALLALG, [bubbleSort, insertionSort]),
    length(LIST, N),
    N =< THRESHOLD,
    call(SMALLALG, LIST, SLIST).

/*
Clause 2: If the length of the list is greater than the threshold value and the
big sorting algorithm is mergeSort, divide the list to two lists, recursively
apply hybridSort to the split lists and merge them after sort.
*/
hybridSort(LIST, SMALLALG, mergeSort, THRESHOLD, SLIST):-
    member(SMALLALG, [bubbleSort, insertionSort]),
    splitInHalf(LIST, L, R),
    hybridSort(L, SMALLALG, mergeSort, THRESHOLD, SORTED_L),
    hybridSort(R, SMALLALG, mergeSort, THRESHOLD, SORTED_R),
    merge(SORTED_L, SORTED_R, SLIST).

/*
Clause 3: If the length of the list is greater than the threshold value and the
big sorting algorithm is quickSort, divide the list to two lists using the head
of the list as partition, recursively apply hybridSort to the split lists and
merge small list, partition and big list after sort.
*/
hybridSort([H | T], SMALLALG, quickSort, THRESHOLD, SLIST):-
    member(SMALLALG, [bubbleSort, insertionSort]),
    split(H, T, SMALL, BIG),
    hybridSort(SMALL, SMALLALG, quickSort, THRESHOLD, SORTED_SMALL),
    hybridSort(BIG, SMALLALG, quickSort, THRESHOLD, SORTED_BIG),
    append(SORTED_SMALL, [H | SORTED_BIG], SLIST).


% randomList/2
/*
Clause 1: Generate empty list if the length to be generated is 0.
*/
randomList(0, []).

/*
Clause 2: Generate a random number between 1 and 1000 and set it as the head
of the output list, reduce the number of elements to be generated by 1 and
recursively generate the tail of the random list.
*/
randomList(N, [H | T]):-
    random(1, 1000, H),
    N1 is N - 1,
    randomList(N1, T).

% createNLists/1
/*
Clause 1: Creating 0 lists holds true.
*/
createNLists(0).

/*
Clause 2: Generate a random list of 50 elements and store it in list, decrease
the number of list to be generated by 1 and recursively generate the n - 1
lists.
*/
createNLists(N):-
    randomList(50, L),
    assertz(list(L)),
    N1 is N - 1,
    createNLists(N1).

% setup/1
/*
Clause 1: Declare list predicate and create 50 lists.
*/
setup():-
    abolish(list/1),
    dynamic(list/1),
    createNLists(50).

% run/4
/*
Clause 1: Declare time predicate and apply sorting to the lists in list.
*/
run(SMALLALG, BIGALG, THRESHOLD):-
    abolish(time/1),
    dynamic(time/1),
    findall(X, list(X), LISTS),
    applySorting(LISTS, SMALLALG, BIGALG, THRESHOLD).

% applySorting/4
/*
Clause 1: If the list is empty, it holds true.
*/
applySorting([], _SMALLALG, _BIGALG, _THRESHOLD).

/*
Clause 2: Applies hybrid sorting to the list at the head of the lists list and
applies hybrid sorting to the list while storing the time taken to sort in time.
*/
applySorting([HLIST | TLISTS], SMALLALG, BIGALG, THRESHOLD):-
    statistics(cputime, T0),
    hybridSort(HLIST, SMALLALG, BIGALG, THRESHOLD, _SLIST),
    statistics(cputime, T1),
    T is T1 - T0,
    assertz(time(T)),
    format('CPU time: ~w~n', [T]),
    applySorting(TLISTS, SMALLALG, BIGALG, THRESHOLD).

/*
Clause 1: Calculates average by dividing X by N if X is the only element in the
list.
*/
average([X], N, A):-
    A is X / N.

/*
Clause 2: Calculates the sum of the first two elements and recursively calls the
average function with sum and tail of list.
*/
average([E1, E2 | T], N, A):-
    E is E1 + E2,
    average([E | T], N, A).
