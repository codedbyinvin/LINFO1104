% Higher Order Functions

/*
Les fonctions d'ordre supérieur sont des fonctions qui prennent des fonctions en paramètre ou qui retournent des fonctions en résultat. A function is order N+1 if its inputs and output contain a function of maximum order N (On regarde uniquement la fonction d'ordre le plus élevé)
 */


% Généricité
% On peut définir des fonctions qui prennent des fonctions en paramètre 
declare
fun {Map F L} % F est une fonction, L est une liste
    case L of nil then nil
    [] H|T then {F H}|{Map F T}
    end
end
{Browse {Map fun {$ X} X*X end [7 8 9]}} % la fonction donnée en entrée ici est d'ordre 1

% La fonction Map est donc d'ordre 2

% Cette fonction est aussi récursive terminale car elle ne fait pas de calcul après l'appel récursif
% Map est bien la dernière opération de la fonction, visible en langage noyau

declare
proc {Map F L R} % F est une fonction, L est une liste, R est le résultat
    case L of nil then R = nil
    [] H|T then 
        local R1 R2 in 
            R = R1|R2
            {F H R1}
            {Map F T R2}
    end
end

% Instatiation

declare
fun {MakeAdd A} % Environement de la fonction MakeAdd {A -> ...} uniquement
    fun {$ X} X+A end % la fonction MakeAdd retourne une fonction qui elle retourne X+A
end
Add5={MakeAdd 5} % Add5 est une fonction qui retourne X+5
Add10 = {MakeAdd 10} % Add10 est une fonction qui retourne X+10
{Browse {Add5 100}} % 105
{Browse {Add10 100}} % 110

% On peut aussi définir des fonctions qui retournent des fonctions


%Function composition

declare
fun {Compose F G}
    fun {$ X} {F {G X}}
    end
end
Fnew={Compose fun {$ X} X*X end fun {$ X} X+1 end} 
{Browse {Fnew 2}} % 9

% On peut cacher l'accumulateur de la fonction grâce aux fonctions d'ordre supérieur

declare
fun {FoldL L F U}
    case L
    of nil then U
    [] H|T then {FoldL T F {F U H}} % On applique la fonction F à l'accumulateur U et à la tête de la liste
    end
end
S={FoldL [5 6 7] fun {$ X Y} X+Y end 0}
R = {FoldL [5 6 7] fun {$ X Y} X*Y end 1}
{Browse S} % 18
{Browse R} % 210

% fonction qui trouve le maximum d'une liste
declare
fun {Max L}
    {FoldL L fun {$ X Y} if X>Y then X else Y end end 0}
end

{Browse {Max [5 6 7 8 9]}} % 9

declare 
F = {FoldL [fun {$ X} X*X end
            fun {$ X Y} X+Y end
            fun {$ X Y} X*Y end
            fun {$ X Y} if X>Y then X else Y end] 
            Compose 
            fun {$ X} X end}
{Browse {F 2}}
