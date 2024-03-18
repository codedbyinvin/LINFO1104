/* TP 2
*/
% Exercice 1
% ----------

declare 
L1 = a|nil
{Browse L1} % [a]
L2 = a|(b|c|nil)|d|nil
{Browse L2} % [a [b c] d]
L3 = proc {$} {Browse oui} end| proc {$} {Browse non} end|nil
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
    case L of H|T  then {LengthAux T Acc + 1 }
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
{Browse {PatternMatching nil}}
{Browse {PatternMatching 1|2|nil}}
{Browse {PatternMatching nul}}

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
{Browse {Drop [r [a p] h] 2}}

% Exercice 6
% ----------
declare 
fun {MultListAux L Acc}
    case L 
    of nil then Acc
    [] H|T then {T Acc*H}
    end
end
fun {MultList L}
    {MultListAux L 1}
end
{Browse {MultList [1 2 3 4]}}





% Exercice 9
% ----------

Carte = carte(menu(entree: 'salade verte aux lardons'
                   plat: 'steak frites'
                   prix: 10)
              menu(entree: 'salade de crevettes grises'
                   plat: 'saumon fume et pommes de terre'
                   prix: 12)
              menu(plat: 'choucroute garnie'
                   prix: 9))

