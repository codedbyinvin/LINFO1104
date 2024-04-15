/* TP 2 - Iñaki Darville
*/

% Exercice 1
% ----------

declare 
L1 = a|nil % totalement équivalent à écrire [a]
{Browse L1} % [a]
L2 = a|(b|c|nil)|d|nil
{Browse L2} % [a [b c] d]
L3 = proc {$} {Browse oui} end| proc {$} {Browse non} end|nil
{Browse L3} % [proc {$} {Browse oui} end proc {$} {Browse non} end]
{L3.1} % oui
{L3.2.1} % non
L4 = est|une|liste|nil
{Browse L4} % [est,une,liste]
L5 = (a|p|nil)|nil
{Browse L5} % [[a p]]

declare 
L4 = est|une|liste|nil
{Browse L4} % [est,une,liste]
NewL = ceci|L4
{Browse NewL} % [ceci est une liste]
NewL2 = L2.2
{Browse NewL2} % [[b c] d]

declare 
fun {Tail L} 
   case L of H|T then T end
end
fun {Head L} 
   case L of H|T then H end
end
{Browse {Head [a b c]}} % affiche a
{Browse {Tail [a b c]}} % affiche [b c]

% Exercice 2
% ----------

declare
fun {LengthAux L Acc}
    case L 
    of H|T  then {LengthAux T Acc + 1 }
    [] nil then Acc
    end
end
fun {Length L}
    {LengthAux L 0}
end
{Browse {Length [r a p h]}} % affiche 4
{Browse {Length [[b o r] i s]}} % affiche 3
{Browse {Length [[l u i s]]}} % affiche 1

% Exercice 3
% ----------

declare 
fun {Append L1 L2}
    case L1 of nil then L2
    else
    L1.1|{Append L1.2 L2}
    end
end


{Browse {Append [r a] [p h]}} % affiche [r a p h]
{Browse {Append [b [o r]] [i s]}} % affiche [b [o r] i s]
{Browse {Append nil [l u i s]}} % affiche [l u i s

% Exercice 4
% ----------

declare 
fun {PatternMatching L}
    case L 
    of nil then empty
    [] H|T then nonempty
    else other
    end
end
{Browse {PatternMatching nil}} % affiche empty
{Browse {PatternMatching 1|2|nil}} % affiche nonempty
{Browse {PatternMatching nul}} % affiche other

% Exercice 5
% ----------
declare
fun {Take Xs N} 
    case Xs 
    of nil then nil
    else 
        case N 
        of 1 then Xs.1|nil
        else Xs.1|{Take Xs.2 N-1}
        end
    end
end
{Browse {Take [r a p h] 2}} % affiche [r a]
{Browse {Take [r a p h] 7}} % affiche [r a p h]
{Browse {Take [r [a p] h] 2}}
declare 
fun {Drop Xs N}
    case Xs 
    of nil then nil 
    else
        case N
        of 1 then Xs.2
        else {Drop Xs.2 N-1}
        end
    end
end
{Browse {Drop [r a p h] 2}} % affiche [p h]
{Browse {Drop [r a p h] 7}} % affiche nil
{Browse {Drop [r [a p] h] 2}} % affiche [h]

% Exercice 6
% ----------
declare 
fun {MultListAux L Acc}
    case L 
    of nil then Acc
    [] H|T then {MultListAux T Acc*H}
    end
end
fun {MultList L}
    {MultListAux L 1}
end
{Browse {MultList [1 2 3 4]}} % affiche 24


% Exercice 7
% ----------

declare
{Browse [5 6 7 8]}
{Browse 5|[6 7 8]}
{Browse 5|6|7|8|nil}
A=5
B=[6 7 8]
{Browse A|B}
L1 = [1 2 3]
L2 = [4 5 6]
{Browse [L1 L2]} % affiche [[1 2 3] [4 5 6]]
L1 = 1|2|3|nil
L2 = 4|5|6|nil
{Browse L1|L2|nil} % affiche [[1 2 3] [4 5 6]]

% Exercice 8
% ----------

declare 
fun {Prefix L1 L2} 
    case L1 of nil then true
    [] H1|T1 then
        case L2 of nil then false
        [] H2|T2 then
            if H1==H2 then {Prefix T1 T2}
            else false
            end
        end
    end
end
{Browse {Prefix [1 2 3] [1 2 3 4 5]}} % affiche true
{Browse {Prefix [1 2 3] [1 2 4 5]}} % affiche false

declare 
fun{FindStringCount S L Index}
    case L 
    of H|T then 
        if {Prefix S L} then Index|{FindStringCount S L.2 Index+1}
        else {FindStringCount S L.2 Index+1}
        end
    [] nil then nil
    end
end

declare 
fun {FindString S L}
    {FindStringCount S L 1}
end
{Browse {FindString [1 2 3] [1 2 3 1 2 4 5 1 2 3]}} % affiche [1 8]
{Browse {FindString [1 2] [1 2 3 1 2 4 5 1 2 3]}} % affiche [1 4 8]

% Exercice 9
% ----------

declare                            % =arrity  nommées implicitement de 1 à n
% carte label du record -> possède 3 champs -> 1 : menu() 2 : menu() 3 : menu() qui sont d'autres records
Carte = carte(menu(entree: 'salade verte aux lardons' % entree du premier menu
                   plat: 'steak frites'
                   prix: 10)
              menu(entree: 'salade de crevettes grises'
                   plat: 'saumon fume et pommes de terre' % plat du second menu
                   prix: 12)  % second menu, 2eme champ de carte
              menu(plat: 'choucroute garnie'
                   prix: 9))
            % le type du champ entree et plat est string

% N1*10 + N2*12 + N3*9
N1 = 5
N2 = 3
N3 = 2
{Browse Carte.1.prix*N1 + Carte.2.prix*N2 + Carte.3.prix*N3} % affiche 10*5 + 12*3 + 9*2 =104

% Exercice 10
% -----------

% <btree T> ::= empty | btree(T left:<btree T> right:<btree T>) arbre binaire
declare

fun {PromenadeBis BT}
    case BT 
    of btree(T left:L right:R) then T|{Append {PromenadeBis L} {PromenadeBis R}}
    [] empty then nil
    end
end


fun {Promenade BT} 
    case BT 
    of btree(T left:L right:R) then T|{Append {Promenade L} {Promenade R}}
    [] empty then nil
    else nil
    end
end

BT = btree(42 
left: btree(26
    left: btree(54
        left: empty 
        right: btree(18
            left: empty 
            right: empty))
    right: empty)
right: btree(37
    left: btree(11
        left: empty
        right: empty)
    right: empty))
{Browse {Promenade BT}} % affiche [42 26 54 18 37 11]

% Somme des valeurs d'un arbre binaire avec FoldL

{Browse  {FoldL {Promenade BT} fun {$ X Y} X+Y end 0}} % affiche 42+26+54+18+37+11 = 188

fun {PromenadeSum BT} 
    case BT 
    of btree(T left:L right:R) then  T+{PromenadeSum L}+{PromenadeSum R}
    [] empty then 0
    end
end

{Browse {PromenadeSum BT}} % affiche 42+26+54+18+37+11 = 188


% Exercice 11
% -----------

declare
fun {DictionaryFilter D F}
    case D 
    of dict(key:K info:Info left:L right:R) then
        if {F Info} then K#Info|{Append {DictionaryFilter L F} {DictionaryFilter R F}}
        else {Append {DictionaryFilter L F} {DictionaryFilter R F}}
        end
    [] leaf then nil
    end
end

% Exemple d'utilisation de DictionaryFilter
local Old Class Val in
    Class = dict(key:10
        info:person('Christian' 19)
        left:dict(key:7
        info:person('Denys' 25)
        left:leaf
        right:dict(key:9
        info:person('David' 7)
        left:leaf
        right:leaf))
        right:dict(key:18
        info:person('Rose' 12)
        left:dict(key:14
        info:person('Ann' 27)
        left:leaf
        right:leaf)
        right:leaf))
    fun {Old Info}
        Info.2 > 20
    end
    Val = {DictionaryFilter Class Old}

    {Browse Val} % affiche [7#person('Denys' 25) 14#person('Ann' 27)]
    % Val --> [7#person('Denys' 25) 14#person('Ann' 27)]
end

% Exercice 12
% -----------

% isTuple(X) = X est un tuple
% isList(X) = X est une liste

'|'(a b)            % tuple
'|'(a '|'(b nil))   % liste 
'|'(2:nil a)        % liste
state(1 a 2)        % tuple
state(1 3:2 2:a)    % tuple
tree(v:a T1 T2)     % record
a#b#c               % tuple  # expliqué dans l'exo 14 m#i#6 = '#'(m i 6) = '#'(1:m 2:i 3:6)
[a b c]             % liste
m|n|o               % tuple        

% Exercice 13
% -----------

declare

fun {Applique L F}  % fonction existant déjà dans l'environnement de base de Mozart (Map , List.map )
    case L 
    of nil then nil 
    [] H|T then {F H}|{Applique T F}
    end
end

fun {Lol X} 
    lol(X) 
end
{Browse {Applique [1 2 3] Lol}} % Affiche [lol(1) lol(2) lol(3)]

declare
fun {MakeAdder N} 
    fun {$ X} X+N end
end
Add5 = {MakeAdder 5} % Add5 est une fonction qui ajoute 5 à un nombre
{Browse {Add5 13}}

declare 

fun {AddAll L N}
    case L 
    of nil then nil
    [] H|T then {Applique L {MakeAdder N}}
    end
end

{Browse {AddAll [1 2 3] 2}}



% Exercice 14
% -----------

{Browse {Label a#b#c}}
{Browse {Width un#tres#long#tuple#tres#tres#long}}
{Browse {Arity 1#4#16}}

fun {SameLength Xs Ys} 
    case Xs#Ys              % on prend un tuple de 2 listes
    of nil#nil then true    % si les 2 sont nil en meme temps c'est bon
    [] (X|Xr)#(Y|Yr) then {SameLength Xr Yr}  % si on a bien 2 liste on renvoie les tails
    else false
    end
end
    

% Exercices supplémentaires
% -------------------------


% Exos sur les listes
% -------------------

% Exercice 1
% ----------
declare 

fun {Flatten L}
    case L 
    of nil then nil
    [] H|T then 
        case H 
        of H1|T1 then {Flatten H}|{Flatten T}
        else {Append H {Flatten T}}
        end
    end
end

{Browse {Flatten [a [b [c d]] e [[[f]]]]}} % affiche [a b c d e f]

declare
fun {Flatten L}
   case L
   of nil then nil
   [] H|T then                              % on a une liste
      case H                                % on regarde le premier élément
      of H1|nil then {Flatten H1|T}         % si c'est une liste d'un seul élément on le sort de sa liste
      [] H2|T2 then {Flatten (H2|nil)|T2|T} % si c'est une liste de plusieurs éléments on la décompose
      else H|{Flatten T}                    % sinon on garde l'élément tel quel
      end
   end
end

% Exemple d'utilisation
{Browse {Flatten [a [b [c d]] e [[[f]]]]}}

% Exercice 2
% ----------

declare 
fun {AddDigits A B C}
    case A#B#C
    of 0#0#0 then 0|0
    [] 0#1#0 then 0|1
    [] 1#0#0 then 0|1
    [] 1#1#0 then 1|0
    [] 0#0#1 then 0|1
    [] 0#1#1 then 1|0
    [] 1#0#1 then 1|0
    [] 1#1#1 then 1|1
    end
end

declare
fun {Add B1 B2}
    local 
    fun {AddAux B1 B2 C}
        {Browse C}
        case B1#B2 
        of nil#nil then         % si les 2 listes sont terminées
            if C == 0 then nil  % si on a une retenue nulle on termine la liste
            else 1|nil          % sinon on rajoute un 1 à la liste et on la termine
            end
        [] (H1|T1)#(H2|T2) then {AddDigits H1 H2 C}.2|{AddAux T1 T2 {AddDigits H1 H2 C}.1} % on ajoute la somme des 2 et on continue avec les reste des 2 binaires et la retenue
        end
    end
    in
    {Reverse {AddAux {Reverse B1} {Reverse B2} 0}} % on reverse les listes pour les additionner, on reverse le résultat pour l'afficher
    end
end

{Browse {Add [1 1 0 1 1 0] [0 1 0 1 1 1]}} % affiche [1 0 0 1 1 0 1]

% Exercice 3
% ----------

% calcul de la moyenne d'une liste de nombres
declare
fun{Average L}
    fun{AverageAcc L S N}
        case L
        of nil then S / N
        [] H|T then {AverageAcc T H+S N+1.}
        end
    end
in
    {AverageAcc L 0. 0.}
end
{Browse {Average [42. 17. 25. 61. 9.]}}

% calcul de la variance d'une liste de nombres (Utilisez la formule: σ2 = (∑(x2i ))/n − ((∑ xi)/n)2)

declare
fun {Variance L}
    fun {VarianceAcc L S S2 N}
        case L
        of nil then S2/N - (S/N)*(S/N)
        [] H|T then {VarianceAcc T H+S S2+H*H N+1.}
        end
    end
in 
    {VarianceAcc L 0. 0. 0.}
end

{Browse {Variance [42. 17. 25. 61. 9.]}}

% Exercice 4
% ----------

declare
fun {Fact N}
    fun {FactAcc N Acc}
        if N == 1 then Acc
        else {FactAcc N-1 N*Acc}
        end
    end
in  
    if N == 1 then 1|nil
    else {FactAcc N 1}|{Fact N-1}
    end
end

{Browse {Fact 4}} % en ordre décroissant [24 6 2 1]

% Programmation sur les records
% -----------------------------

% Exercice 1
% ----------

declare 
fun {Recompose L}
    fun {RecomposeAux L N}
        case L
        of nil then N
        [] H|T then {RecomposeAux T N*10 + H}
        end
    end
in
    {RecomposeAux L 0}
end
declare
fun {AppendDigit Num Digit}
    Num*10 + Digit
end
fun {Recompose L}
    {FoldL L AppendDigit 0} % ca va faire ...{AppendDigit {AppendDigit 0 L[0]} L[1]}...
end

{Browse {Recompose [1 3 3]}} % Affiche 133
{Browse {AppendDigit 1234 5}} % Affiche 12345

% Exercice 2
% ----------

declare
fun {FiFib}
    local
    fun {F N Prev}
        if N == 5 then
            stopped
        elseif  N == 1
            then fib(1 {F 1 1})
        else
            {Browse fib(Prev+N {F Prev+N N})}
        end
    end
    in 
        {F 1 1}
    end
end

{Browse {FiFib}} % OOPS FATAL: The active memory (732096623) after a GC is over the maximal heap size threshold: 732096600

declare 
fun {Fib Acc Prev}
    fib(Acc fun{$} {Fib Acc+Prev Acc} end)
end
fun {FiFib}
    fib(1 fun {$} {Fib 1 1} end)
end

proc {Consume N F}
    if (N == 0) then skip
    else
        {Browse F}
        {Consume N-1 {F.2}}
    end
end

{Consume 10 {FiFib}}

% Exercice 3
% ----------
declare
fun {Guinness Label Features Values}
    {List.toRecord Label {List.zip Features Values  fun {$ X Y} X#Y end}}
end

{Browse {Guinness record [jean jack pierre inaki] [12 9 6 20]}} % affiche record(inaki:20 jack:9 jean:12 pierre:6) ça trie en ordre alphabétique

% Programmation sur les arbres
% ----------------------------

% Exercice 1
% ----------

declare 
fun {InsertElements L T}
    fun {Insert X T}
        case T
        of leaf then tree(key:X value:X leaf leaf)
        [] tree(key:K value:V left:L right:R) 
        andthen K>X
        then tree(key:K value:V left:{Insert X L} right:R)
        [] tree(key:K value:V left:L right:R)
        andthen K<X 
        then tree(key:K value:V left:L right:{Insert X R})
        [] tree(key:K value:V left:L right:leaf) 
        andthen K>X 
        then tree(key:K value:V left:L right:{Insert X leaf})
        [] tree(key:K value:V left:L right:leaf) 
        andthen K<X 
        then tree(key:K value:V left:L right:{Insert X leaf})
        [] tree(key:K value:V left:leaf right:R) 
        andthen K>X 
        then tree(key:K value:V left:{Insert X leaf} right:R)
        [] tree(key:K value:V left:leaf right:R) 
        andthen K<X
        then tree(key:K value:V left:leaf right:{Insert X leaf})
        [] tree(key:K value:V left:leaf right:leaf) 
        andthen K>X 
        then tree(key:K value:V left:{Insert X leaf} right:leaf)
        [] tree(key:K value:V left:leaf right:leaf) 
        andthen K<X
        then tree(key:K value:V left:leaf right:{Insert X leaf})
        end
    end
in
    {FoldL L fun {$ X T} {Insert X T} end T}
end
{Browse {InsertElements [0] tree(key:31 value:31 leaf leaf)}}

