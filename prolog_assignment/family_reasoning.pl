parentOf(A,B) :- hasChild(A,B).

motherOf(A, B) :- female(A), parentOf(A,B).

fatherOf(A, B) :- male(A), parentOf(A,B).

grandparentOf(A, B) :- parentOf(A,C), parentOf(C,B).

grandmotherOf(A, B) :- female(A), parentOf(A,C), parentOf(C,B).

grandfatherOf(A, B) :- male(A), parentOf(A,C), parentOf(C,B).

greatgrandparentOf(A, B) :- parentOf(A,C), parentOf(C,D), parentOf(D,B).

greatgrandmotherOf(A, B) :- female(A), parentOf(A,C), parentOf(C,D), parentOf(D,B).    
               
greatgrandfatherOf(A, B) :- male(A), parentOf(A,C), parentOf(C,D), parentOf(D,B).    
                       
childOf(A, B):- parentOf(B,A).

daughterOf(A, B) :- female(A), parentOf(B,A).

sonOf(A, B) :- male(A), parentOf(B,A).

grandchildOf(A, B):- grandparentOf(B,A).

granddaughterOf(A, B):- female(A), grandparentOf(B,A).

grandsonOf(A, B):- male(A), grandparentOf(B,A).

greatgrandchildOf(A, B):-grandparentOf(C,A), parentOf(B,C).

greatgranddaughterOf(A, B):- female(A), grandparentOf(C,A), parentOf(B,C).

greatgrandsonOf(A, B):- male(A), grandparentOf(C,A), parentOf(B,C).

ancestorOf(A, B) :- parentOf(A, B).
ancestorOf(A, B) :- parentOf(A,C),ancestorOf(C,B).

ancestorOf(A, A ,0).
ancestorOf(A, B, N) :-
  parentOf(A,C), 
  ancestorOf(C,B,X),
  N is X +1. 


descendantOf(A,B) :- childOf(A,B).
descendantOf(A,B) :- childOf(A,C),descendantOf(C,B).

descendantOf(A, A, 0).
descendantOf(A, B, N) :-
            childOf(A,C).
            descendantOf(C,B,X).
            N is X - 1.

related(A,A).
related(A,B):-
	setof((A,B),(descendantOf(A,B);ancestorOf(A,B)), Person),
	member((A,B), Person).

parent(A) :- 
  setof(A, C^hasChild(A, C), Par), 
  member(A, Par).

childless(A) :- (male(A) ; female(A)), \+ parent(A).

hasChildren(A, L) :- 
	(\+ hasChild(A,C) -> L = [] ; setof(C, hasChild(A, C), L)).
	

countChildren(A, N) :- hasChildren(A, L), length(L, N).

sibling(X, Y):- sisterOf(X,Y);brotherOf(X,Y).
sisterOf(A, B):-fatherOf(C,A), fatherOf(C,B),motherOf(D,A),motherOf(D,B),female(A),\+(A=B).
brotherOf(A, B):-fatherOf(C,A), fatherOf(C,B),motherOf(D,A),motherOf(D,B),male(A),\+(A=B).

stepSibling(A, B) :-parentOf(Z,A),parentOf(Z,B),parentOf(P,A),\+parentOf(P,B),\+owns(_,A),\+owns(_,B).
 
stepSisterOf(A, B) :- stepSibling(A,B),female(A).

stepBrotherOf(A, B):- stepSibling(A,B),male(A).


cousin(A, B) :- parentOf(Z,A),sibling(Z,P), parentOf(P,B).

getSpecies(A, B):-species(A, B).
getSpecies(A, B):-descendantOf(C,A),ancestorOf(D,C),hasChild(D,F),hasChild(E,F),species(E, B).
getSpecies(A, B):-ancestorOf(C,A),species(C, B).
getSpecies(A, B):-ancestorOf(C,A),stepSibling(D,C),hasChild(E,D),species(E,B).

pet(A):-
  setof(A, B^(owns(B,A), (male(A);female(A))), Animal), 
  member(A, Animal).

feral(A):-(male(A);female(A)),\+owns(_,A),\+getSpecies(A,human).
