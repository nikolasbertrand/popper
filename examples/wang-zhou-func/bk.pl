/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 Primitives for logical operations
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
and([], [], []).
and([A|As], [B|Bs], [C|Cs]) :-
    C is A /\ B,
    and(As, Bs, Cs).

or([], [], []).
or([A|As], [B|Bs], [C|Cs]) :-
    C is A \/ B,
    or(As, Bs, Cs).

neg([], []).
neg([A|As], [B|Bs]) :-
    B is 1 - A,
    neg(As, Bs).

xor([], [], []).
xor([A|As], [B|Bs], [C|Cs]) :-
    C is A xor B,
    xor(As, Bs, Cs).

xnor(A, B, C) :-
    xor(A, B, D),
    neg(C, D).

%% shift
shl([_A|As], B) :-
    append(As, [0], B).
shr(A, [0|B]) :-
    append(B, [_], A).

%% rotate
rol([A|As], B) :-
    append(As, [A], B).
ror(A, [B|Bs]) :-
    append(Bs, [B], A).

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 Primitives for control flows
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
is_zero([0]).
is_zero([0|X]) :-
    is_zero(X).

is_not_zero(X) :-
    \+is_zero(X).


equal(A,A).


:-['exs'].

non_functional(Atom1):-
    Atom1=..[P,A,B,X],
    Atom2=..[P,A,B,Y],
    call(Atom2),
    X \= Y.

popper_program_validation(_Prog):-
    catch(call_with_time_limit(0.1,forall(pos(Atom),\+non_functional(Atom))),time_limit_exceeded,false),!.