% Make a cell

declare 
C = {NewCell 4}
{Browse C} % affiche le nom de la cellule (<Cell>)
{Browse @C} % affiche la valeur lorsqu'on accède (@) à la cellule 

C := 5 % change la valeur de la cellule
{Browse @C} % affiche la nouvelle valeur de la cellule

C := C + 1 % incrémente la valeur de la cellule
{Browse @C} % affiche la nouvelle valeur de la cellule

B = C % B est une référence à la cellule C
C := 6 % change la valeur de la cellule C
{Browse @B} % affiche la nouvelle valeur de la cellule B (6) car B est une référence à C