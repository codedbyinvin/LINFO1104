declare 
fun {CellProcess S M}
    case M
    of assign(New) then New
    [] access(Old) then Old=S S
    end
end
declare
fun {NewPortObject Init F}
    P Out
in
    thread S in P={NewPort S} Out={FoldL S F Init} end
    P
end

declare Cell
Cell={NewPortObject CellProcess 0}
{Send Cell assign(1)}
local X in {Send Cell access(X)} {Browse X} end