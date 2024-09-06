/* Notes du cours S10 - Iñaki Darville
 */

Concurrencie for dummies


declare 
fun {Map Xs F}
    case Xs of H|T then {F H}|{Map T F}
    [] nil then nil 
    end
end

declare F in
{Browse {Map [1 2 3 4] F}} 
% Cela n'affiche rien car on est en train d'attendre une valeur pour F
% le thread principal est bloqué
% l'execution de Map est en attente
% le Browse n'est même pas exécuté


% maintenant si on met dans un thread

declare 
fun {CMap Xs F}
    case Xs of H|T then thread {F H} end |{CMap T F}
    [] nil then nil 
    end
end

declare F in
{Browse {CMap [1 2 3 4] F}} 
% maintenant le thread principal n'attent pas la valeur de F ce sont les autres threads qui attendent.
% le Browse est exécuté donc exécuté ==> [_ _ _ _]
% on crée un thread dès qu'on appel F H 

% si mtn on donne une valeur a F

F = fun {$ X} X*X end % en feedant cette région on a mtn la liste qui s'affiche : [1 4 9 16]

% thread ... end est utilisé comme une expression

% Warning Ceci ne fonctionne pas avec les mutable variables => utilisation de cellules

% Tout ce qu'on voit ajd ne fonctionne que en programmation fonctionnelle

Why does it work ?

fun {Fib X}
    if X == 0 then 0
    elseif X == 1 then 1
    else 
        thread {Fib X-1} end + {Fib X-2} % pas vrmt nécessaire car Fib X-1 n'est pas bloquant mais c'est pour créer plein de threads
    end
end

en langage noyau 

fun {Fib X}
    if X == 0 then 0
    elseif X == 1 then 1
    else  F1 F2 in
        F1 = thread {Fib X-1} end
        F2 = {Fib X-2}
        F1 + F2 % ici il attend que F1 soit fini
    end
end

On voit dans la slide 79 l'arbre des threads qui sont créés

Counting threads

% on ne peut pas faire C := @C + 1
X = @C
Y = X+1
C := Y

declare C Inc in
C = {NewCell 0}
proc {Inc C} X Y in
    {Exchange C X Y} Y = X + 1
end

declare
fun {Fib X}
    if X == 0 then 0
    elseif X == 1 then 1
    else
    thread {Inc C} {Delay 100} {Fib X-1} end + {Fib X-2}
    end
end

{Browse @C}
{Browse {Fib 10}}
{Browse @C}

thread {Browse {Fib 30}} end
{Browse @C}

% On crée plein de threads :))


declare
fun {Filter Xs K}
    case Xs 
    of X|Xr then
        if X mod K \= 0 then X|{Filter Xr K}
        else {Filter Xr K} end
    else nil
    end
end

declare Xs Ys K in
K = 2
thread Ys={Filter Xs K} end % on a créé un agent, c'est un thread qui renvoie un stream et prend un stream en argument
{Browse Xs} % browse _ car on n'a pas encore donné de valeur à Xs
{Browse Ys} % browse _ car on a pas encore donné de valeur à Xs

Xs = 1|2|3|4|5|6|7|8|9|10|_ % on donne une valeur à Xs
%{Browse Xs}  browse 1|2|3|4|5|6|7|8|9|10|_
%{Browse Ys}  browse 1|3|5|7|9|_

declare 
fun {Prod K}
    {Delay 100}
    K|{Prod K+1}
end
declare
fun {Sieve Xs}
    case Xs
    of nil then nil
    [] X|Xr then X|{Sieve thread {Filter Xr X} end}
    end
end
declare Xs Ys in
thread Xs={Prod 2} end
thread Ys={Sieve Xs} end
{Browse Ys}

% on peut opti en s'arretant à la racine carrée de X
fun {Sieve2 Xs M}
    case Xs
    of nil then nil
    [] X|Xr then
        if X=<M then
            X|{Sieve2 thread {Filter Xr X} end M}
        else 
            Xs 
        end
    end
end

Sieve était un exemple de concurrent deployment

Digital Logic simulation
------------------------

% la porte logique AND
declare
fun {And A B} 
    if A==1 andthen B==1 
        then 1 
    else 0 
    end 
end
fun {Loop S1 S2}
    case S1#S2 
    of (A|T1)#(B|T2) then {And A B}|{Loop T1 T2} end
end
declare Sa Sb Sc in
thread Sc={Loop Sa Sb} end
{Browse Sc}
Sa = 1|0|1|0|1|0|1|0|_
Sb = 1|1|0|0|1|1|0|0|_

% on veut maintenant créer plein de gates grace au High order
declare
fun {GateMaker F}
    fun {$ Xs Ys}
        fun {GateLoop Xs Ys}
            case Xs#Ys of (X|Xr)#(Y|Yr) then
                {F X Y}|{GateLoop Xr Yr}
            end
        end
    in
    thread {GateLoop Xs Ys} end
    end
end

declare AndG OrG NandG NorG XorG Sa Sb Sc in
AndG={GateMaker fun {$ X Y} X*Y end}
OrG={GateMaker fun {$ X Y} X+Y-X*Y end}
NandG={GateMaker fun {$ X Y} 1-X*Y end}
NorG={GateMaker fun {$ X Y} 1-X-Y+X*Y end}
XorG={GateMaker fun {$ X Y} X+Y-2*X*Y end}
Sc = {AndG Sa Sb}

{Browse Sc}

Sa = 1|0|1|0|1|0|1|0|_
Sb = 1|1|0|0|1|1|0|0|_


% Combinaison logiques (no memory) / Sequential logic (memory)

full adder : calcul une addition à 3 bits (la retenue)
3 inputs : le premier bit de A, le premier bit de B et la retenue de la colonne précédente
2 outputs : le résultat de l'addition et la retenue de la colonne suivante
declare
proc {FullAdder X Y Z C S}
    A B D E F
    in
    A={AndG X Y}
    B={AndG Y Z}
    D={AndG X Z}
    F={OrG B D}
    C={OrG A F}
    E={XorG X Y}
    S={XorG Z E}
end

declare X Y Z C S in
{FullAdder X Y Z C S}
{Browse X}
{Browse Y}
{Browse Z}
{Browse C}
{Browse S}

X = 0|1|1|_
Y = 1|1|1|_
Z = 0|0|1|_

On veut un fulladder de 32 bits

declare
proc {Adder X Y Z Cin Cout}
    case X|Y of (X1|Xr)|(Y1|Yr) then
        {FullAdder X1 Y1 Cm Zn Cout}
        {Adder Xr Yr Zr Cin Cm}
        in
        [] nil|nil|nil then
        Z = nil
        Cout = Cin
    end
    