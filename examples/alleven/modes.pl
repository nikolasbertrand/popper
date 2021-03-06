max_vars(3).
max_body(4).
max_clauses(2).

%%:-
%%    #count{Clause,Literal : body_literal(Clause,Literal,P,A)} > 5.

%% ALL EVEN
%% f(A):-empty(A).
%% f(A):-head(A,B),tail(A,C),even(B),f(C).

%% NEED TO EVENTUALLY ADD THIS CONSTRAINT TO THE MAIN ALAN ENCODING
%% PREVENT RECURSION IN THE FIRST CLAUSE
%:-
%    modeh(P,A),
%    body_literal(0,_,P,A).

%% IF YOU UNCOMMENT THESE LINES THERE THERE ARE ONLY THREE MODELS INCLUDING THE TARGET ONE
%%:-
%%    #count{Clause,P,Args : body_literal(Clause,P,A,Args)} != 5.
%%:-
%%    not body_literal(0,empty,1,(0,)).
%%:-
%%    not body_literal(1,_,f,1).
%%:-
%%    not body_literal(1,_,even,1).
%%:-
%%    not body_literal(1,_,head,2).
%%:-
%%    not body_literal(1,_,tail,2).
%:-
%    body_literal(_,1,last,2).
%:-
%    body_literal(_,2,last,2).
%:-
%    body_literal(_,3,last,2).
%%:-
%%    body_literal(_,4,last,2).

modeh(f,1).
type(f,0,list).
direction(f,0,in).
modeb(f,1).

modeb(tail,2).
type(tail,0,list).
type(tail,1,list).
direction(tail,0,in).
direction(tail,1,out).

modeb(head,2).
type(head,0,list).
type(head,1,element).
direction(head,0,in).
direction(head,1,out).

%% works without this
modeb(last,2).
type(last,0,list).
type(last,1,element).
direction(last,0,in).
direction(last,1,out).

modeb(length,2).
type(length,0,list).
type(length,1,int).
direction(length,0,in).
direction(length,1,out).

modeb(sum,3).
type(sum,0,int).
type(sum,1,int).
type(sum,2,int).
direction(sum,0,in).
direction(sum,1,in).
direction(sum,2,out).

%modeb(cons,3).
%type(cons,0,element).
%type(cons,1,list).
%type(cons,2,list).
%direction(cons,0,in).
%direction(cons,1,in).
%direction(cons,2,out).

modeb(empty,1).
type(empty,0,list).
direction(empty,0,in).

modeb(zero,1).
type(zero,0,element).
direction(zero,0,in).

modeb(even,1).
type(even,0,element).
direction(even,0,in).
