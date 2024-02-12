% Exercice 1
% ----------
{Browse 1} % 1
{Browse 2} % 2
{Browse 3} % 3
{Browse 4} % 4

% Exercice 2
% ----------

{Browse (1+5)*(9-2)} % 42
{Browse 19 - 970} % -951
{Browse 192 - 980 + 191 * 967} % 183909
{Browse (192 - 780) * (~3) - 191 * 967} % ~182933
% Attention: l’opérateur de négation se note “~”.

% Exercice 3
% ----------

% {Browse 123 + 456.0} % Erreur : 123 n’est pas un nombre flottant
{Browse 123.0 + 456.0} % 579

% Exercice 4
% ----------

declare % declare permet de créer une variable et de lui assigner une valeur
X = (6+5)*(9-7) % X est l'identificateur de la variable

{Browse X}
{Browse X+5}

local
    X
in
    X=1
    {Browse X} % Affiche 1
end
{Browse X} % ERREUR: X n'est pas accessible

% Exercice 5
% ----------

declare
X=42
Z=~3
{Browse X} % (1)
{Browse Z}

declare
Y=X+5
{Browse Y} % (2)

declare
X=1234567890
{Browse X} % (3) % le X reste en mémoire donc si on run (1) 
                 % même apres le dernier paragraphe on obtient X=1234567890
% cependant lorsqu'on run (2) on obtient Y=47 car malgré que X soit réassigné 
% à 1234567890, Y est déjà déclaré et assigné à X+5 donc il ne change pas


% Exercice 6
% ----------

{Browse 3 == 7} % egaux
{Browse 3 \= 7} % differents
{Browse 3 < 7} % plus petit
{Browse 3 =< 7} % plus petit ou egal
{Browse 3 > 7} % plus grand
{Browse 3 >= 7} % plus grand ou egal

% Exercice 7
% ----------

{Browse {Max 3 7}} % 7
{Browse {Not 3==7}} % true
{Browse {Max {Max 7 5} 6}} 

% Exercice 8
% ----------

% la portée d’une déclaration est la zone d’un programme
% où un identiﬁcateur est déﬁni et correspond à cette déclaration
local P Q X Y Z in % (1)
    fun {P X}
        X*Y+Z % (2) le X est déclaré dans la fonction P et non dans le local
    end
    fun {Q Y}
        X*Y+Z % (3) le X est déclaré dans le local et non dans la fonction Q
    end
    X=1
    Y=2
    Z=3
    {Browse {P 4}}
    {Browse {Q 4}}
    {Browse {Q {P 4}}} % (4)
end

local P Q X Y Z in % (1)
    fun {P X Y}
        X*Y+Z % (2)
    end
    fun {Q Y Z}
        X*Y+Z % (3)
    end
    X=1
    Y=2
    Z=3
    {Browse {P 4 X}}
    {Browse {Q 4 Y}}
    {Browse {Q {P 4 X} Y}} % (4)
end

% Exercice 9
% ----------

declare
X=3
fun {Add2}
    X + 2
end
fun {Mul2 X}
    X * 2
end
{Browse {Add2}} % 5
{Browse {Mul2 X}} % 6
{Browse X+2} % (1)
{Browse X*2} % (2)

% Exercice 10
% ----------

% 1. Somme de carrés
declare
fun{SumAux N Acc}
    if N == 0 then Acc else {SumAux N-1 Acc+N*N} end 
end
fun{Sum N}
    {SumAux N 0}
end
{Browse {Sum 6}} % 91

% 2. Miroir, mon beau miroir...
declare
fun{MirrorAux N Acc}
    if N == 0 then Acc else {MirrorAux N div 10 Acc*10+N mod 10} end % 
end
fun{Mirror N}
    {MirrorAux N 0}
end
{Browse {Mirror 12112334}} % 4321

% 3. Univers parallèle (part. 1)
declare
fun {Foo N}
    if N<10 then 1
    else 1+{Foo (N div 10)}
    end
end % renvoie le nombre de chiffres de N
{Browse {Foo 1234567890}} % 10

% 4. Univers parallèle (part. 2)
declare
local
    fun {FooHelper N Acc}
        if N<10 then Acc+1
        else {FooHelper (N div 10) Acc+1}
        end
    end
in
    fun {Foo N}
        {FooHelper N 0}
    end 
end % renvoie le nombre de chiffres de N avec un accumulateur

% 5. Un, deux, trois, nous irons au bois !

declare
proc {BrowseNumber N}  % proc est une fonction qui ne renvoie rien
    {Browse N}
    {Browse N+1}
end
{BrowseNumber 42} % 42 43

declare
proc {CountDown N}
    if N>=0 then
        {Browse N}
        {CountDown N-1}
    end
end
{CountDown 3}
