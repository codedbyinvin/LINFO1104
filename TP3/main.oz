%TP 3

%Exemple
fun {Fact N}
    if N==0 then 1
    else N*{Fact N-1} 
    end
end

%Devient en langage noyau:

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

%Exercice 1
%----------

%a)

declare
fun {Sum N}
    if N == 1 then 1
    else N*N + {Sum N-1} 
    end
end

declare Sum in
proc {Sum N ?R}
    local B Zero in
        Zero = 0
        B = (N == Zero)
        if B then 
            R = 0
        else
            local R1 N1 One in
                One = 1
                N1 = N - One
                {Sum N1 R1}
                R = N*N + R1
            end
        end
    end
end
declare R in 
{Sum 3 R}
{Browse R}

%b)
declare
fun {SumAux N Acc}
    if N == 1 then Acc + 1
    else {SumAux N-1 N*N+Acc} 
    end
end
fun {Sum N}
    {SumAux N 0}
end

declare SumAux in
proc{SumAux N Acc ?R}
    local B Zero in
        Zero = 0
        B = (N == Zero)
        if B then
            R = Acc
        else
            local N1 Acc1 One R1 in
                One = 1
                N1 = N-One
                Acc1 = N*N+Acc
                {SumAux N1 Acc1 R}
            end
        end
    end
end

declare Sum in 
proc{Sum N ?R}
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

proc {Q A} {P A+1} end % E = {A -> A} 

proc {P} {Browse A} end % E = {A -> A}

local P Q in
    proc {P A R} R=A+2 end % E = {A -> A}
    local P R in
        fun {Q A}          % E = {}
            {P A R}
            R
        end
        proc {P A R} R=A-2 end
    end
%% Qu'affiche {Browse {Q 4}} ?
end

