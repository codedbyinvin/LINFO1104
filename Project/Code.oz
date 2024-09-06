local 
   % Vous pouvez remplacer ce chemin par celui du dossier qui contient LethOzLib.ozf
   % Please replace this path with your own working directory that contains LethOzLib.ozf

   % Dossier = {Property.condGet cwdir '/home/max/FSAB1402/Projet-2017'} % Unix example
   Dossier = {Property.condGet cwdir '/Users/inaki/Library/CloudStorage/OneDrive-UCL/BAC 2/Q4/Concepts des languages de programmation/LINFO1104/Project'} 
   % Dossier = {Property.condGet cwdir 'C:\\Users\Thomas\Documents\UCL\Oz\Projet'} % Windows example.
   LethOzLib

   % Les deux fonctions que vous devez implémenter
   % The two function you have to implement
   Next
   DecodeStrategy
   
   % Hauteur et largeur de la grille
   % Width and height of the grid
   % (1 <= x <= W=24, 1 <= y <= H=24)
   W = 24
   H = 24

   Options
in
   % Merci de conserver cette ligne telle qu'elle.
   % Please do NOT change this line.
   [LethOzLib] = {Link [Dossier#'/'#'LethOzLib.ozf']}
   {Browse LethOzLib.play}

%%%%%%%%%%%%%%%%%%%%%%%%
% Your code goes here  %
% Votre code vient ici %
%%%%%%%%%%%%%%%%%%%%%%%%

   local
      % Déclarez vos functions ici
      % Declare your functions here
      Move
      RemoveTail
   in
      % La fonction qui renvoit les nouveaux attributs du serpent après prise
      % en compte des effets qui l'affectent et de son instruction
      % The function that computes the next attributes of the spaceship given the effects
      % affecting him as well as the instruction
      % 
      % instruction ::= forward | turn(left) | turn(right)
      % P ::= <integer x such that 1 <= x <= 24>
      % direction ::= north | south | west | east
      % spaceship ::=  spaceship(
      %               positions: [
      %                  pos(x:<P> y:<P> to:<direction>) % Head
      %                  ...
      %                  pos(x:<P> y:<P> to:<direction>) % Tail
      %               ]
      %               effects: [scrap|revert|wormhole(x:<P> y:<P>)|... ...]
      %            )
      fun {Next Spaceship Instruction}
         local Pos Dir NewDir in
            % cette fonction renvoie la position du vaisseau après avoir effectué l'instruction
            {Browse Instruction}

            % On récupère la direction du vaisseau
            Pos = Spaceship.positions
            Dir = Pos.1.to

            % test va vers la droite
            if Instruction == go(right) then
               if Dir == north then
                  NewDir = east
               elseif Dir == south then
                  NewDir = east
               elseif Dir == west then
                  NewDir = west
               elseif Dir == east then
                  NewDir = east
               end
            % test va vers la gauche
            elseif Instruction == go(left) then
               if Dir == north then
                  NewDir = west
               elseif Dir == south then
                  NewDir = west
               elseif Dir == west then
                  NewDir = west
               elseif Dir == east then
                  NewDir = east
               end
            
            % test va vers le haut
            elseif Instruction == go(up) then
               if Dir == north then
                  NewDir = north
               elseif Dir == south then
                  NewDir = south
               elseif Dir == west then
                  NewDir = north
               elseif Dir == east then
                  NewDir = north
               end
            % test va vers le bas
            elseif Instruction == go(down) then
               if Dir == north then
                  NewDir = north
               elseif Dir == south then
                  NewDir = south
               elseif Dir == west then
                  NewDir = south
               elseif Dir == east then
                  NewDir = south
               end
            % test avance
            elseif Instruction == forward then
               NewDir = Dir
            end
            % On met à jour la position de tout le vaisseau
            {Move Spaceship NewDir}
         end
      end
      fun {RemoveTail Positions}
         % remove the tail of the spaceship
         case Positions
         of nil then
            nil
         [] Head | Tail then
            if Tail == nil then
               nil
            else
               Head | {RemoveTail Tail}
            end
         end
      end

      
      % La fonction qui décode la stratégie d'un serpent en une liste de fonctions. Chacune correspond
      % à un instant du jeu et applique l'instruction devant être exécutée à cet instant au spaceship
      % passé en argument
      % The function that decodes the strategy of a spaceship into a list of functions. Each corresponds
      % to an instant in the game and should apply the instruction of that instant to the spaceship
      % passed as argument
      %
      % strategy ::= <instruction> '|' <strategy>
      %            | repeat(<strategy> times:<integer>) '|' <strategy>
      %            | nil
      fun {DecodeStrategy Strategy}
         
         local Out Function in
            % iterate over the different cases of the strategy
            % and return the corresponding list of functions
   
   
            % for each strategy case
            case Strategy
            of nil then
               % if the strategy is empty, return an empty list
               Out = nil
            [] Instruction | Strategy1 then
               % if the strategy is an instruction followed by a strategy
               % return a list containing the function that applies the instruction
               % and the functions that apply the rest of the strategy
               Function = fun {$ Spaceship} {Next Spaceship Instruction} end
               Out = Function | {DecodeStrategy Strategy1}
            [] repeat(Strategy2 times:N) | Strategy1 then
               % if the strategy is a repetition of another strategy
               % return a list containing the functions that apply the repeated strategy
               % N times and the functions that apply the rest of the strategy
               Out = {DecodeStrategy Strategy2} | {DecodeStrategy repeat(Strategy2 times:N-1) | Strategy1}
            end
            
            % return the list of functions
            Out
         end

      end


      fun {Move Spaceship Dir}
         local X Y Head NewPos in
            % move the spaceship forward according to its direction and return the new spaceship
            % position
            if Dir == north then
               X = Spaceship.positions.1.x
               Y = Spaceship.positions.1.y - 1
            elseif Dir == south then
               X = Spaceship.positions.1.x
               Y = Spaceship.positions.1.y + 1
            elseif Dir == west then
               X = Spaceship.positions.1.x - 1
               Y = Spaceship.positions.1.y
            else
               X = Spaceship.positions.1.x + 1
               Y = Spaceship.positions.1.y
            end
            Head = pos(x:X y:Y to:Dir)
            % new position = head + the rest of the spaceship without the tail
            NewPos = Head | {RemoveTail Spaceship.positions}
            % return the new spaceship
            spaceship(positions:NewPos effects: Spaceship.effects)
         end
      end

      % Options
      Options = options(
		   % Fichier contenant le scénario (depuis Dossier)
		   % Path of the scenario (relative to Dossier)
		   scenario:'scenario/scenario_crazy.oz'
		   % Utilisez cette touche pour quitter la fenêtre
		   % Use this key to leave the graphical mode
		   closeKey:'Escape'
		   % Visualisation de la partie
		   % Graphical mode
		   debug: true
		   % Instants par seconde, 0 spécifie une exécution pas à pas. (appuyer sur 'Espace' fait avancer le jeu d'un pas)
		   % Steps per second, 0 for step by step. (press 'Space' to go one step further)
		   frameRate: 5
		)
   end

%%%%%%%%%%%
% The end %
%%%%%%%%%%%
   
   local 
      R = {LethOzLib.play Dossier#'/'#Options.scenario Next DecodeStrategy Options}
   in
      {Browse R}
   end
end
