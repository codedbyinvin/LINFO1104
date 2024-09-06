/* TP 8 - Iñaki Darville
*/

% Exercice 1
% ----------
declare A B C D
thread D = C+1 end % le thread attend que C soit défini en mémoire
thread C = B+1 end % le thread attend que B soit défini en mémoire
thread A = 1 end   % 
thread B = A+1 end % le thread 
{Browse A}

% création  -> D>C>A>B
% execution -> A>B>C>D
% Dessin dans Exo1.pdf

% Exercice 2
% ----------

declare
local X Y Z in
    thread 
        if X==1 then Y=2 
        else Z=2 
        end
    end
    thread 
        if Y==1 then X=1 
        else Z=2 
        end 
    end
    X=1
    {Browse X} % affiche 1
    {Browse Y} % affiche 2
    {Browse Z} % affiche 2
end

local X Y Z in
    thread if X==1 then Y=2 else Z=2 end end
    thread if Y==1 then X=1 else Z=2 end end
    X=2
    {Browse X} % affiche 2
    {Browse Y} % affiche rien
    {Browse Z} % affiche 2
end

% Exercice 3
% ----------

%(1)
declare 
fun {ProduceInts N}
    fun {ProduceIntsAux N M}
        {Delay 1000}
        if M == N+1 then nil
        else M|{ProduceIntsAux N M+1}
        end
    end
in
    {ProduceIntsAux N 1}
end


%(2)
declare 
fun {Sum Str}
    {Delay 1000}
    case Str of H|T then H+{Sum T} % Attention en utilisant FoldL on ne profite pas de l'avantage du multithread
    else 0
    end
end
declare
L1 = {ProduceInts 4}


%(3)

declare Xs S
thread Xs = {ProduceInts 10} end
thread S = {Sum Xs} end
{Browse S}

declare Xs S
Xs = {ProduceInts 10}
S = {Sum Xs}
{Browse S}

%(4) 

% sans thread : 1*N + 1*N (on attend de créer toute la liste avant d'additionner)
% avec thread : N + 1 (le temps de créer la liste on additionne déjà)

% Exercice 4
% ----------

%(1)

declare 
fun {ProduceInts N}
    fun {ProduceIntsAux N M}
        {Delay 1000}
        if M == N+1 then nil
        else M|{ProduceIntsAux N M+1}
        end
    end
in
    {ProduceIntsAux N 1}
end

declare 
fun {Filter L F}
    case L 
    of nil then nil
    [] H|T then 
        if {F H} == 1 then H|{Filter T F}
        else {Filter T F}
        end
    end
end
declare 
fun {Sum Str}
    {Delay 1000}
    case Str of H|T then H+{Sum T} % Attention en utilisant FoldL on ne profite pas de l'avantage du multithread
    else 0
    end
end

declare Xs XFiltred S
thread Xs = {ProduceInts 10} end
thread XFiltred = {Filter Xs fun {$ X} X mod 2 end} end
thread S = {Sum XFiltred} end
{Browse S}

Xs = [1 2 3 4 5 6 7 8 9 10 _]

%(2)

declare 
fun {Barman N}
    fun {BarmanAux N M}
        {Delay 3000}
        if M == N+1 then nil
        else M|{BarmanAux N M+1}
        end
    end
in
    {BarmanAux N 1}
end

declare
fun {ServeBeer}
    local R Max in 
        {OS.randLimits 0 Max}
        {OS.rand R}
        if R > (Max div 2) then trappist
        else beer 
        end
    end
end

declare
fun {SmellTrappist Beer}
    Beer == trappist
end


declare
fun {Charlotte Beers ScoreCharlotte ScoreAmi}
    case Beers 
    of nil then 0
    [] H|T then
        local Beer in
        Beer = {ServeBeer}
        if {SmellTrappist Beer} then ScoreCharlotte = ScoreCharlotte+1
        else ScoreAmi = ScoreAmi + 1
        end
        end 
    end
end
declare Beers ScoreCharlotte ScoreAmi
thread 
    Beers = {Barman 10} 
end
thread
    {Charlotte Beers ScoreCharlotte ScoreAmi}
end
{Browse ScoreCharlotte}
{Browse ScoreAmi}

% Exercice 5
% ----------

