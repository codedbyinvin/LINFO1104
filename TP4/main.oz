/* TP 4 - Iñaki Darville
 */

% Exercice 1
% ----------

% Lorsqu'on définie une procédure, on crée une variable qui a 
% une valeur de procédure en mémoire accompagnée de son 
% environnement contextuel

% Lorsqu'on appelle cette procédure on va remplacer la procédure
% par les instructions de sa valeur et ajouter son environnement 
% contextuel à l'environnement

local P in
    local Z in
        Z=1
        proc {P X Y} Y=X+Z end
    end
    local B A in
        A=10
        {P A B}
        {Browse B}
    end
end

% Développement dans Exo1.pdf

% Exercice 2
% ----------

declare
fun {MakeMulFilter N}
    fun {$ I}
        if I mod N == 0 then true
        else false
        end
    end
end

Div3 = {MakeMulFilter 3}
{Browse {Div3 9}} % affiche true
{Browse {Div3 10}} % affiche false

declare
fun {Filter L F}
    case L 
    of nil then nil
    [] H|T then 
        if {F H} == true then H|{Filter T F}
        else {Filter T F}
        end
    end
end

declare 
L = [1 2 3 4 5 6 7 10 12 12 3093 293 02]
{Browse {Filter L {MakeMulFilter 2}}} % affiche que les nombres pairs dans L
{Browse {Filter L {MakeMulFilter 3}}} % affiche les multiples de 3 dans L

% Pour filtrer les nombres premiers on va filtrer de 2 à N/2

declare 
fun {FiltrePremierAcc M K N}
    if K == M-1 then true
    else
        if ((N mod K) == 0) then false
        else {FiltrePremierAcc M K-1 N }
        end
    end
end

declare 
fun {FiltrePremier N}
    if N == 1 then
        true
    else
        {FiltrePremierAcc 2 N-1 N}
    end
    
end

{Browse {Filter L FiltrePremier}}

% Exercice 3
% ----------

declare
fun {FoldL L F S}
    case L of nil then S 
    [] H|T then {FoldL T F {F S H}}
    end
end

{Browse {FoldL [1 2 3 4 5] fun {$ X Y} X*Y end 1}} % affiche 120
{Browse {FoldL [1 2 3 4 5] fun {$ X Y} X-Y end 0}} % affiche -15

% Exercice 4
% ----------

declare

fun {Applique L F}  % fonction existant déjà dans l'environnement de base de Mozart (Map , List.map )
    case L 
    of nil then nil 
    [] H|T then {F H}|{Applique T F}
    end
end

fun {PowerNumber E}
    fun {$ N}
        {Pow N E}
    end
end


{Browse {Applique [1 2 3 4 5] {PowerNumber 2}}}

% Exercice 5
% ----------

declare
fun {Convertir T V}
    T*V 
end

% on crée des fonction plus haut niveau qui ont le coef V adéquat
fun {ConvMaker T}
    fun {$ V}
        {Convertir T V}
    end
end

CmEnPied = {ConvMaker 1.6} % jsp c quoi et flemme d'aller voir
{Browse {CmEnPied 10.}}


declare
fun {ConvComplex T V}
    case T

    of [A B] then   %  @AntoninOswald
        A*V + B

    [] A then 
        A*V

    end
end

fun {ConvMaker2 T}
    fun {$ V}
        
        {ConvComplex T V}
    end
end

FarToCelsius = {ConvMaker2  [0.56 ~17.78]}
{Browse {FarToCelsius 100.}}

% Exercice 6
% ----------

% Calcul de la somme des carrés des nombres impaires de 0 à N
fun {SumSquare N}
    fun{SumSquareAux N Acc}
        if N =< 0 then Acc
        elseif N mod 2 == 0 then {SumSquareAux N-1 Acc}
        else {SumSquareAux N-1 Acc + (N*N)} 
        end
    end
in
{SumSquareAux N 0}
end

fun {PipeLine N}
    P1 P2 P3 in
    P1 = {GenerateList N}
    P2 = {MyFilter P1 fun {$ X} X mod 2 \= 0 end}
    P3 = {MyMap P2 fun {$ X} X * X end}
    
    {MyFoldL P3 fun {$ Acc X} X + Acc end 0}
end


%          +---------+               +---------+
%          |         |               |         |
%          |Generate | [0 1 2 ... N] | Even    |
%N +----->+ List     +--------------->+Filter  +-----+
%          |         |               |         |     |
%          |         |               |         |     |
%          +---------+               +---------+     |
%                      [1 3 5 ... N]                 |
%    +-----------------------------------------------+
%    |
%    |   +--------+                  +--------+
%    |   |        |                  |        |
%    |   |        | [1 9 25 ... N*N] |        |
%    +--->+ Pow2  +----------------->+  Sum   +---->Output
%        |        |                  |        |
%        |        |                  |        |
%        +--------+                  +--------+

declare
fun {GenerateList N}
    fun {GenerateListAux N Max}
        if N == Max+1  then
            nil
        else
           N|{GenerateListAux N+1 Max}
        end 
    end
in
    {GenerateListAux 0 N}
end

{Browse {GenerateList 10}}

declare % repris de l'ex 2
fun {MyFilter L F}
    case L 
    of nil then nil
    [] H|T then 
        if {F H} == true then H|{MyFilter T F}
        else {MyFilter T F}
        end
    end
end

declare
fun{MyMap L F} % fonction Applique (Map sur oz directement)
    case L 
    of nil then nil 
    [] H|T then {F H}|{MyMap T F}
    end
end

declare  % repris de l'ex 3
fun {MyFoldL L F S}
    case L of nil then S 
    [] H|T then {MyFoldL T F {F S H}}
    end
end

declare 
fun {PipeLine N}
    P1 P2 P3 in
    P1 = {GenerateList N}
    P2 = {MyFilter P1 fun {$ X} X mod 2 \= 0 end}
    P3 = {MyMap P2 fun {$ X} X * X end}
    
    {MyFoldL P3 fun {$ Acc X} X + Acc end 0}
end

{Browse {PipeLine 10}} % affiche 165

% Exercice 7
% ----------

local Y LB in
    Y=10
    proc {LB X ?Z}
        if X>=Y then Z=X
        else Z=Y end
    end

    local Y=15 Z in
        {LB 5 Z}
        {Browse Z}
    end
end
% affiche 10 Voir Exo7.pdf

