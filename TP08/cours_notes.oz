/* Notes Cours S9 - Iñaki Darville
 */

Dataflow fonctionnel
---------------------

les threads 

   Y=X+1(Wait for X to be bound)  {Browse Y}
----|-------------------------------|------------------> A's progress

------------------------|------------------------------> B's progress  
                     X= 20

interleaving semantics : rien n'est simultané mais on peut avoir l'impression que c'est le cas
En réalité chaque exécution est séquentielle 

Les threads peuvent communiquer en partageant une variable 
 - C'est la seul interaction possible

declare X
thread {Browse X+1} end
thread X=1 end

On a l'exécution principale qui est le thread principal et les autres threads qui sont des threads secondaires

declare X0 X1 X2 X3 in
thread X1=1+X0 end
thread X3=X1+X2 end
{Browse [X0 X1 X2 X3]} % dans le thread principal
--> Browse n'attend pas avant d'afficher les valeurs


--------------{Browse [X0 X1 X2 X3]}----------------------> main thread's progress

-----------------|----------------------------------------> B's progress
                X1=1+X0

-----------------|----------------------------------------> C's progress
                X3=X1+X2

création d'un thread =/= attente d'un thread

browse à un thread qui attend pour afficher les valeurs liées (ca va update)
Pour chaque variable qui n'est pas lié dans browse il va créer un thread qui va attendre

X0 = 100 % en lancant ceci on a la liste qui passe de [_ _ _ _] à [100 101 _ _]
X2 = 50 % en lancant ceci on a la liste qui passe de [100 101 _ _] à [100 101 50 151]

Les Streams
------------

Les streams sont des listes qui terminent par une variable non liée

S = [1 2 3 4 _] % S est un stream

S = a|b|c|d|S2 
S2 = e|f|g|h|S3
S3 = i|j|k|l|S4
S4 = m|n|o|p|S5 

un stream est "une liste qu'on peut étendre"

il peut être utiliser comme canal de communication entre threads

declare 
proc {Disp S}
    case S of X|S2 then {Browse X} {Disp S2} end % case aussi applique les règles de dataflow si S n'est pas encore lié, il va attendre
end
declare S

thread {Disp S} end % on a un thread qui va afficher les valeurs de S 


declare S2 in S=a|b|c|S2 % quand on run ceci on a : a b c
declare S3 in S2=d|e|f|S3 % quand on run ceci on a : d e f qui s'ajoutent

Producer / consumer 

On a un qui crée des valeurs et un autre qui les consomme

declare 
proc {Disp S}
    case S of X|S2 then {Browse X} {Disp S2} end
end

declare 
fun {Producer N}
    {Delay 1000} 
    N|{Producer N+1}
end
declare S in

thread S={Producer 1} end
thread {Disp S} end

% cela affiche les valeurs de 1 à l'infini toutes les secondes

On a aussi les transformations de streams

fun {Trans S}
    case S of X|S2 then X*X|{Trans S2} end
end

Un agent est une activité qui lit et écrit des streams

exemple : producer / consumer

Thread semantics
----------------

Dans le langage noyau, on a une nouvelle instruction :
thread <s> end

There is one sequence of execution states,
and threads take turns executing instructions

(MST1,σ1) → (MST2,σ2) → (MST3,σ3) → ...
MST -> plusieurs threads {ST1,ST2,ST3,...}
On doit a chaque étape exécuter uniquement un seul thread (on ne peut pas exécuter plusieurs threads en même temps)
c'est le scheduler qui va se charger de choisir quel thread exécuter
({ST1,ST2,ST3,...},σ1) → ({ST1,ST2,ST3,...},σ2) → ({ST1,ST2,ST3,...},σ3) → ...
                    (ST1,σ1)                   (ST3,σ2)   défini par le scheduler
le thread reste tant qu'il n'a pas fini d'exécuter

Quand on exécute un thread dans la machine abstraite 
Cela va créer une nouvelle branche dans la machine abstraite

-------------

Sequential programming

un seul thread

-------> -------------> -------------> -------------> ----------------> Sequential execution
-------> One execution step


concurrent programming

plusieurs threads

1 seul ordre partiel
--------------------
S1 -------> S1'-------> S1''------->s1'''
  \
   \S2 -------> S2' -------> S2'' -------> S2''''
                 \
                  \
                   \-------> S3 -------> S3' -------> S3'' 



Possibilitées d'exécutions de la machine abstraite énorme (exponentiel)
==> ordre total 
--------> ------------> ------------> ------------> ------------> ------------> 

Non déterminisme 
----------------

possibilité d'un systeme de prendre des choix indépendemment du programmeur

le scheduler peut choisir n'importe quel thread à n'importe quel moment (il peut choisir un thread qui n'a pas encore fini d'exécuter ou qui n'est pas en train d'attendre) 

exemple de non déterminisme :

declare X
thread X=1 end
thread X=2 end

le premier thread est créé en premier mais n'est cependant pas exécuté en premier


declare X={NewCell 0}
thread X:=2 end
thread X:=1 end

{Delay 1000}
{Browse @X} %On ne saura jamais si X vaut 1 ou 2

declare X={NewCell 0}
thread X:=1 end
thread X:=1 end

Meme si on a d'office le meme résultat, cela reste du non déterminisme  /!\
Deterministic dataflow has a major advantage
-> The result of a program is always the same (except if there is a
program error, that is, if a thread raises an exception)
-> The nondeterminism of the scheduler does not affect the result

Fonctionnement du scheduler
----------------------------

il ne décide pas d'une seule exécution à la fois mais on lui donne un thread 
pendant un petit temps et il va l'exécuter pendant ce temps si le thread n'a 
pas fini d'exécuter il va le mettre en attente et passer à un autre thread, 
si il a fini on passe à un autre thread

un thread peut être runnable ou blocked, le scheduler va choisir un thread runnable

une propriété que tous les schedulers doivent avoir :
- Fairness : chaque thread doit avoir la possibilité d'être exécuté

On a aussi le concept de priorité de thread
Mozart has 3 levels of priority
- High >= 90%
- Medium >= 9%
- Low >= 1%
