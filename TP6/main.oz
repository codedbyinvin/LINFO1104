/* TP 6 - Iñaki Darville
*/

% Fin des exos de lambda calcul dans TP6.pdf

% Syntaxe de la boucle for :

for X in Xs do instruction end %(avec une liste)
for I in A..B do instruction end %(avec des entiers)

%  Exercice 1
% ------------

fun {Reverse Xs}
    fun {ReverseAux Xs Ys}
        case Xs of nil then Ys
        [] X|Xr then {ReverseAux Xr X|Ys}
    end
    end
in
    {ReverseAux Xs nil}
    end

declare
fun {Reverse Xs}
    C = {NewCell nil}
in
    for X in Xs do
        C := X|@C
    end
    @C
end

{Browse {Reverse [a b c d e]}}

% Exercice 2
%------------

declare 
    fun {NewStack} 
        {NewCell nil} 
    end
    proc {Push S X} 
        S := X|@S 
    end
    fun {Pop S} 
        if {IsEmpty S} then nil
        else
            X in
            X= @S.1
            S := @S.2
            X
        end
    end
    fun {IsEmpty W}  @W == nil end

declare 
fun {Eval Calc} 
    Stack = {NewStack} in
    for Op in Calc do 
        local X Y in
        case Op 
        of '+' then
            X={Pop Stack} Y={Pop Stack}
            {Push Stack X+Y}
        [] '-' then
            X={Pop Stack} Y={Pop Stack}
            {Push Stack X-Y}
        [] '*' then
            X={Pop Stack} Y={Pop Stack}
            {Push Stack X*Y}
        else
            {Push Stack Op}
        end
    end
    end
    {Pop Stack}
end


{Browse {Eval [1 2 '+' 3 4 '+' '*']}}
{Browse {Eval [4 1 '-' 3 2 '-' '*']}}

% Exercice 3
%------------

declare
fun {NewStack}
    C = {NewCell nil}
    fun {IsEmpty} @C == nil end
    proc {Push X} C := X|@C end
    fun {Pop} 
        S = @C 
    in 
        C := S.2
        S.1
    end
in 
    stack(isEmpty:IsEmpty push:Push pop:Pop)
end

declare
Stack1={NewStack} % pile 1
Stack2={NewStack} % pile 2
{Browse {Stack1.isEmpty}} % affiche true; la pile 1 est vide
{Stack1.push 13} % empile 13 sur la pile 1
{Browse {Stack1.isEmpty}} % affiche false; la pile 1 n'est pas vide
{Browse {Stack2.isEmpty}} % affiche true; la pile 2 est toujours vide
{Stack1.push 45} % empile 45 sur la pile 1
{Stack2.push {Stack1.pop}} % enlève 45 de la pile 1 et l'empile sur la pile 2
{Browse {Stack2.isEmpty}} % affiche false; la pile 2 n'est pas vide
{Browse {Stack1.pop}} % enlève 13 de la pile 1 et l'affiche

declare 
fun {Eval Calc} 
    Stack = {NewStack} in
    for Op in Calc do 
        local X Y in
        case Op 
        of '+' then
            X={Stack.pop} Y={Stack.pop}
            {Stack.push X+Y}
        [] '-' then
            X={Stack.pop} Y={Stack.pop}
            {Stack.push X-Y}
        [] '*' then
            X={Stack.pop} Y={Stack.pop}
            {Stack.push X*Y}
        else
            {Stack.push Op}
        end
    end
    end
    {Stack.pop}
end

{Browse {Eval [1 2 '+' 3 4 '+' '*']}}
{Browse {Eval [4 1 '-' 3 2 '-' '*']}}

% C'est une abstraction de type objet
% Oui ADT, functional objects & statefull ADT

% Exercice 4 (@evandieren)
%------------

declare
fun {Shuffle Xs} Len A I Head Tail in
   Len = {Length Xs}
   I = {NewCell 0}
   A = {NewArray 0 Len 0}
   for X in Xs do
      A.@I := X
      I := @I+1
   end
   Tail = {NewCell Head}
   for N in 0..(Len-1) do Idx Range Next in
      Range = Len - 1 - N
      Idx = {OS.rand} mod (Range+1)
      @Tail = A.Idx|Next
      Tail := Next
      A.Idx := A.Range
   end
   @Tail = nil
   Head
end
{Browse {Shuffle [0 1 2 3 4 5 6 7 8]}}

% Exercice 5
%------------

declare
L1= {NewCell 0}|{NewCell 1}|{NewCell 2}|nil
{Browse {IsList L1}} % affiche true
L2= 0|{NewCell 1|{NewCell 2|{NewCell nil}}}
{Browse {IsList L2}} % affiche false

% L1
declare
fun {Add Elem S}
    {NewCell Elem}|S
end

declare
fun {Append Elem S}
    case S of nil then Elem|nil
    [] H|T then H|{Append Elem T}
    end
end

declare
fun {Swap S}
    case S 
    of H1|H2|T then H2|H1|T
    end 
end
declare 
L1={NewCell 0}|{NewCell 1}|{NewCell 2}|nil
{Browse @({Swap L1}.1)} % affiche 1
% L2
declare 
fun {Add Elem S}
    Elem | {NewCell S}
end

declare
fun {Append Elem S}
    case S of H|T
        case @T of nil then Elem|{NewCell nil}
        else H|{Append Elem @T}
        end
    end
end

%--------pas bon----------%
declare
fun {Swap S}
    case S
    of H|T then  X1 X2 in
        X1 = H
        X2 = (@T).1
        X2|{NewCell X1|T.2}
    end
end
%--------pas bon----------%
declare
L2=0|{NewCell 1|{NewCell 2|{NewCell nil}}}

% Programmation orienté objet

declare
class Counter
    attr value
    meth init % (re)initialise le compteur
        value:=0
    end
    meth inc % incremente le compteur
        value:=@value+1
    end
    meth get(X) % renvoie la valeur courante du compteur dans X
        X=@value
    end
end

MonCompteur={New Counter init}
for X in [65 81 92 34 70] do {MonCompteur inc} end
{Browse {MonCompteur get($)}} % == local X in {MonCompteur get(X)} X end


% Exercice 6
%------------

declare
class Collection
    attr elements
    meth init % initialise la collection
        elements:=nil
    end
    meth put(X) % insere X
        elements:=X|@elements
    end
    meth get($) % extrait un element et le renvoie
        case @elements 
        of X|Xr then elements:=Xr X 
        end
    end
    meth isEmpty($) % renvoie true ssi la collection est vide
        @elements==nil
    end
    meth union(C)
        if {Not {C isEmpty($)}} then
            {self put({C get($)})}
            {self union(C)}
        end
    end
    meth showCollection()
        {Browse @elements}
    end
end

declare
class SortedCollection from Collection
    meth get($)
        local Sorted in
            {List.sort @elements Value.'<' Sorted}
            elements := Sorted
            Sorted.1
        end
    end
end


% Exercice 7
%------------

declare
VarX={New Variable init(0)}
VarY={New Variable init(0)}
local
    ExprX2={New Puissance init(VarX 2)}
    Expr3={New Constante init(3)}
    Expr3X2={New Produit init(Expr3 ExprX2)}
    ExprXY={New Produit init(VarX VarY)}
    Expr3X2mXY={New Difference init(Expr3X2 ExprXY)}
    ExprY3={New Puissance init(VarY 3)}
in
    Formule={New Somme init(Expr3X2mXY ExprY3)}
end

{VarX set(7)}
{VarY set(23)}
{Browse {Formule evalue($)}} % affiche 12153
{VarX set(5)}
{VarY set(8)}
{Browse {Formule evalue($)}} % affiche 547

% Exercice 8
%------------

declare 
class Sequence
    attr sequence
    meth init
        sequence := nil
    end
    meth isEmpty($)
        @sequence == nil
    end
    meth first($)
        @sequence.1
    end
    meth last($)
        local LastHelper in
            fun {LastHelper L}
                case L of H|nil then H
                else {LastHelper L.2}
                end
            end
            {LastHelper @sequence}
        end
    end
    meth insertFirst(X)
        sequence := X|@sequence
    end
    meth insertLast(X)
        local In in 
            fun {In L X}
                case L of nil then X|nil
                else L.1|{In L.2 X}
                end
            end
        end
    end
    meth removeFirst
        sequence := @sequence.2
    end
    meth removeLast
        local RemHelper in
            fun {RemHelper L}
                case L of nil then nil
                [] H|nil then nil
                [] H|T then H|{RemHelper T}
                end
            end
        end
    end
end

declare
fun {Palindrome Xs}
    S={New Sequence init}
    fun {Check} 
        %% si S est vide, alors Xs est un palindrome
        %% sinon, on compare les premier et dernier elements de S:
        %% - s'ils sont egaux, on les retire de S et on continue
        %% - sinon, Xs n'est pas un palindrome
        if {S first($)} == nil then palindrome end
        if {S first($)} /= {S last($)} then false end
        {S removeFirst()} 
        {S removeLast()}
        {Check}
    end
in
    %% mettre tous les elements de Xs dans S (dans l'ordre)
    for X in Xs do
        {S insertLast(X)}
    end
    {Check}
end

{Browse {Palindrome [k a y a k]}}