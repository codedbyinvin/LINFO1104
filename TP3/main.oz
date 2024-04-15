/* TP 3 - Iñaki Darville
*/

%------------Exemple-----------
fun {Fact N}
    if N==0 then 1
    else N*{Fact N-1} 
    end
end

%----Devient en langage noyau:--

declare Fact in
proc {Fact N ?R}
    local B Zero in
        Zero = 0
        B = (N == Zero)
        if B then
            R = 1
        else
            local R1 N1 One in
                One = 1
                N1 = N - One
                {Fact N1 R1}
                R = N * R1
            end
        end
    end
end

% Il y a deux façons de récup la valeur de retour
declare R % déclarer l'identificateur 
{Fact 5 R}
{Browse R}

{Browse {Fact 5}} % directement récuperer la valeur de retour

%Exercice 1
%----------

%a)

% Somme des carrés des N premiers Naturels

declare
fun {Sum N}
    if N == 1 then 1
    else N*N + {Sum N-1} 
    end
end

% Traduction en langage noyau

declare Sum in
Sum = proc {$ N ?R}
    local One B in
        One = 1
        B = (N == One)
        if B then 
            R = One
        else
            local R1 N1 in
                N1 = N-One
                {Sum N1 R1}
                R = N*N + R1
            end
        end
    end
end

declare R in 
{Sum 3 R}
{Browse R}


%b) Version avec accumulateur
declare
fun {SumAux N Acc}
    if N == 1 then Acc + 1
    else {SumAux N-1 N*N+Acc} 
    end
end
fun {Sum N}
    {SumAux N 0}
end

% Traduction en langage noyau
declare SumAux in
SumAux = proc {$ N Acc ?R}
    local B One in
        One = 1
        B = (N == One)
        if B then
            R = Acc + One
        else
            local N1 Acc1 in
                N1 = N-One
                Acc1 = N*N+Acc
                {SumAux N1 Acc1 R}
            end
        end
    end
end

declare Sum in 
Sum = proc{$ N ?R}
    local Zero R1 in
        Zero = 0
        {SumAux N Zero R1}
        R = R1
    end
end
declare R in
{Sum 3 R}
{Browse R}

% Exercice 2
%-----------

declare L L2 L3 L4 in
L = '|'(1:1 2:nil)
L2 = '|'(1:1 2:'|'(1:2 2:'|'(1:3 2:nil )))
L3 = nil
L4 = state(1:4 2:f 3:3)
{Browse L}
{Browse L2}
{Browse L3}
{Browse L4}

% Exercice 3
%-----------

proc {Q A} 
    {P A+1} end % E = {P -> p}  la proc Q doit avoir une fonction qui lie P à la mémoire car P n'est pas dans les arguments de la Q

proc {P} {Browse A} end % E = {A -> a}

local P Q in
    proc {P A R} R=A+2 end % E = {}
    local P R in
        fun {Q A}          % E = {P -> p}
            {P A R}
            R
        end
        proc {P A R} R=A-2 end
    end
{Browse {Q 4}} % affiche 2 car le P dans le scope de Q est A-2
end

% Exercice 4
% ----------

% Voir Exo4.pdf

local Res in
    local Arg1 Arg2 in
        Arg1 = 7
        Arg2 = 6
        Res = Arg1 * Arg2
    end
    {Browse Res} % affiche 42
end

local Res in
    local Arg1 Arg2 in
        Arg1 = 7
        Res = Arg1 * Arg2
        Arg2 = 6
    end
    {Browse Res} % affiche rien
end

% Exercice 5
% ----------

local MakeAdd Add1 Add2 in
    proc {MakeAdd X Add} % procédure qui "renvoie" est une procédure
        proc {Add Y Z}
            Z=X+Y     % X vaut 1|2 quand on appel Add1|Add2
        end
    end
    {MakeAdd 1 Add1}
    {MakeAdd 2 Add2}

    local V in
        {Add1 42 V} {Browse V} 
    end

    local V in
        {Add2 42 V} {Browse V}
    end
end
