functor
import
   Tk
   Application
   Compiler
   Open
   System(show:Show)
   Boot_Time at 'x-oz://boot/Time'
export
   play:Play
define

W = 24
H = 24

%  ######   #######  ##     ## ########  ##     ## ######## ########     ######   ########  #### ########   ######  
% ##    ## ##     ## ###   ### ##     ## ##     ##    ##    ##          ##    ##  ##     ##  ##  ##     ## ##    ## 
% ##       ##     ## #### #### ##     ## ##     ##    ##    ##          ##        ##     ##  ##  ##     ## ##       
% ##       ##     ## ## ### ## ########  ##     ##    ##    ######      ##   #### ########   ##  ##     ##  ######  
% ##       ##     ## ##     ## ##        ##     ##    ##    ##          ##    ##  ##   ##    ##  ##     ##       ## 
% ##    ## ##     ## ##     ## ##        ##     ##    ##    ##          ##    ##  ##    ##   ##  ##     ## ##    ## 
%  ######   #######  ##     ## ##         #######     ##    ########     ######   ##     ## #### ########   ######  

fun {Times Rec I Val}
   if I == 0 then Rec
   else
      {Times {AdjoinAt Rec I {Val}} I-1 Val}
   end
end

fun {Repeat Start End Init Fun}
   Res = {Fun Init Start}
in
   if Start == End then
      Res
   else
      {Repeat Start+1 End Res Fun}
   end
end

ObstaclesCGrid0 = {Times obstaclesGrid() W fun{$} {Times col() H fun{$} nil end} end}
ObstaclesGrid0  = {Repeat 1 24 ObstaclesCGrid0 fun{$ G I} {AdjoinAt G I {AdjoinAt G.I 1 wall|G.I.1}} end}
ObstaclesGrid1  = {Repeat 1 24 ObstaclesGrid0 fun{$ G I} {AdjoinAt G I {AdjoinAt G.I W wall|G.I.W}} end}
ObstaclesGrid2  = {Repeat 1 24 ObstaclesGrid1 fun{$ G I} {AdjoinAt G 1 {AdjoinAt G.1 I wall|G.1.I}} end}
ObstaclesGrid3  = {Repeat 1 24 ObstaclesGrid2 fun{$ G I} {AdjoinAt G H {AdjoinAt G.H I wall|G.H.I}} end}
BonusesGrid0    = {Times bonusesGrid() W fun{$} {Times col() H fun{$} nil end} end}

fun {ObstaclesGrid Config}
   fun {BombsGrid Bombs Grid}
      case Bombs of Bomb|Rest then
         if Bomb.explodesIn == 0 then
            X=Bomb.position.x Y=Bomb.position.y
            fun {AddBoom Grid X Y}
               if {HasFeature Grid X} andthen {HasFeature Grid.X Y} then
                  {AdjoinAt Grid X {AdjoinAt Grid.X Y boom|Grid.X.Y}}
               else 
                  Grid 
               end
            end
            Grid1 = {AddBoom Grid X Y}
            Grid2 = {AddBoom Grid1 X-1 Y}
            Grid3 = {AddBoom Grid2 X-2 Y}
            Grid4 = {AddBoom Grid3 X+1 Y}
            Grid5 = {AddBoom Grid4 X+2 Y}
            Grid6 = {AddBoom Grid5 X Y-1}
            Grid7 = {AddBoom Grid6 X Y-2}
            Grid8 = {AddBoom Grid7 X Y+1}
            Grid9 = {AddBoom Grid8 X Y+2}
         in
            {BombsGrid Rest Grid9}
         else
            {BombsGrid Rest Grid}
         end
      [] nil then Grid end
   end
   fun {SpaceGrid Spaceships Grid}
      case Spaceships of Spaceship|Rest then
         fun {SquaresGrid Squares Grid}
            case Squares of Square|Rest then
               X=Square.x Y=Square.y
               NewGrid = if {HasFeature Grid X} andthen {HasFeature Grid.X Y} then
                            {AdjoinAt Grid X {AdjoinAt Grid.X Y Spaceship.team|Grid.X.Y}}
                         else 
                           Grid 
                        end
            in
               {SquaresGrid Rest NewGrid}
            [] nil then 
               Grid 
            end
         end
         NewGrid = {SquaresGrid Spaceship.positions Grid}
      in
         {SpaceGrid Rest NewGrid}
      [] nil then 
         Grid 
      end
   end
   Grid0 = if Config.walls then ObstaclesGrid3 else ObstaclesCGrid0 end
   Grid1 = {SpaceGrid Config.spaceships Grid0}
   Grid2 = {BombsGrid Config.bombs Grid1}
in
   Grid2
end

fun {BonusesGrid Config}
   fun {BonusesGrid Bonuses Grid}
      case Bonuses of Bonus|Rest then
         X=Bonus.position.x Y=Bonus.position.y
         NewGrid = {AdjoinAt Grid X {AdjoinAt Grid.X Y Bonus|Grid.X.Y}}
      in
         {BonusesGrid Rest NewGrid}
      else Grid end
   end
in
   {BonusesGrid Config.bonuses BonusesGrid0}
end


% ######## ##    ## ########      ######   ########  #### ########   ######  
% ##       ###   ## ##     ##    ##    ##  ##     ##  ##  ##     ## ##    ## 
% ##       ####  ## ##     ##    ##        ##     ##  ##  ##     ## ##       
% ######   ## ## ## ##     ##    ##   #### ########   ##  ##     ##  ######  
% ##       ##  #### ##     ##    ##    ##  ##   ##    ##  ##     ##       ## 
% ##       ##   ### ##     ##    ##    ##  ##    ##   ##  ##     ## ##    ## 
% ######## ##    ## ########      ######   ##     ## #### ########   ######  

fun {CheckForKills Config}
   Obstacles_ = {ObstaclesGrid Config}
   Bonuses_ = {BonusesGrid Config}
   fun {Obstacles X Y}
      if {HasFeature Obstacles_ X} andthen {HasFeature Obstacles_.X Y} then
         Obstacles_.X.Y
      else wall end
   end
   fun {Bonuses X Y}
      if {HasFeature Bonuses_ X} andthen {HasFeature Bonuses_.X Y} then
         Bonuses_.X.Y
      else nil end
   end
   fun {BonusesToApply Spaceship Bonuses FunList}
      case Bonuses of Bonus|Rest then
         F = case Bonus.target
         of catcher then
            fun {$ S}
               if S.name == Spaceship.name then
                  {AdjoinAt S effects Bonus.effect|S.effects}
               else S end
            end
         [] others then
            fun {$ S}
               if S.name \= Spaceship.name then
                  {AdjoinAt S effects Bonus.effect|S.effects}
               else S end
            end
         [] allies then
            fun {$ S}
               if S.team == Spaceship.team then
                  {AdjoinAt S effects Bonus.effect|S.effects}
               else S end
            end
         [] opponents then
            fun {$ S}
               if S.team \= Spaceship.team then
                  {AdjoinAt S effects Bonus.effect|S.effects}
               else S end
            end
         [] all then
            fun {$ S}
               {AdjoinAt S effects Bonus.effect|S.effects}
            end
         end
      in
         {BonusesToApply Spaceship Rest F|FunList}
      [] nil then FunList end
   end
   fun {BonusesEffects AllSpaceships Spaceships}
      case Spaceships of Spaceship|Rest then
         X=Spaceship.positions.1.x Y=Spaceship.positions.1.y
         Appliers      = {BonusesToApply Spaceship {Bonuses X Y} nil}
         AllSpaceships1 = {Map AllSpaceships fun{$ Spaceship} {FoldL Appliers fun{$ S A} {A S} end Spaceship} end}
      in
         {BonusesEffects AllSpaceships1 Rest}
      [] nil then AllSpaceships end
   end
   fun {KillSpaceships Spaceships}
      case Spaceships of Spaceship|Rest then
         fun {AnyBoomedSquare Squares}
            case Squares of Square|Rest then
               if {Member boom {Obstacles Square.x Square.y}} then
                  true
               else
                  {AnyBoomedSquare Rest}
               end
            [] nil then false end
         end
         X=Spaceship.positions.1.x Y=Spaceship.positions.1.y
      in
         if {IsDead Spaceship} then
            Spaceship
         else
            if ({Obstacles X Y} \= Spaceship.team|nil orelse {AnyBoomedSquare Spaceship.positions}
               orelse {List.length Spaceship.positions} < 2) andthen {Member invincibility Spaceship.effects} == false then
               {AdjoinAt Spaceship effects death|Spaceship.effects}
            else Spaceship end
         end | {KillSpaceships Rest}
      [] nil then nil end
   end
in
   {AdjoinAt Config spaceships {KillSpaceships {BonusesEffects Config.spaceships Config.spaceships}}}
end

Directions = direction(north: 0#~1
		       south: 0#1
		       west: ~1#0
		       east: 1#0
		      )

fun {InitCells Spaceship I N} % MAY BE UNNECESSARY
   if I == N then nil
   else
      Direction = Directions.(Spaceship.positions.1.to)
   in
      ((Spaceship.positions.1.x - Direction.1*I)#
         (Spaceship.positions.1.y - Direction.2*I)
      ) | {InitCells Spaceship I+1 N} 
   end
end

fun {InitSpaceships Config} % MAY BE UNNECESSARY
   fun {InitSpaceship Spaceship}
      {AdjoinAt Spaceship squares {InitCells Spaceship 0 Spaceship.size}}
   end
   fun {InitSpaceships Spaceships}
      case Spaceships of Spaceship|Rest then
	 {InitSpaceship Spaceship}|{InitSpaceships Rest}
      [] nil then nil
      end
   end
in
   {AdjoinAt Config spaceships {InitSpaceships Config.spaceships}}
end

fun {BonusColor Bonus}
   Bonus.color
end

fun {DropBombs Config} % STUDENT Q3
   fun {TailBombs Spaceships BombList}
      case Spaceships of Spaceship|Rest then
         if {IsAlive Spaceship} andthen Spaceship.seismicCharge.1 then
            BombList1 = bomb(explodesIn:Config.bombLatency
               position:{List.last Spaceship.positions}
            ) | BombList
         in
            {TailBombs Rest BombList1}
	 else
	    {TailBombs Rest BombList}
	 end
      [] nil then BombList end
   end
   fun {EffectBombs Spaceships Effects BombList} % Effects nil => get spaceship
      case Effects of nil then
         case Spaceships of nil then BombList
         [] Spaceship|Rest then
            {EffectBombs Rest {Filter Spaceship.effects fun{$ E} {Label E} == bomb end} BombList}
         end
      [] Bomb|Rest then
         {EffectBombs Spaceships Rest bomb(position:Bomb.position explodesIn:Config.bombLatency)|BombList}
      end
   end
in
   {Adjoin Config
    config(bombs: {TailBombs Config.spaceships Config.bombs} % {EffectBombs Config.spaceships nil {TailBombs Config.spaceships Config.bombs}}
           spaceships: {Map Config.spaceships
                    fun{$ S}
                       {Adjoin S spaceship(seismicCharge:S.seismicCharge.2
                                       % effects:{Filter S.effects fun{$ E} {Label E} \= bomb end}
                                      )
                       }
                    end
                   }
          )
   }
end

fun {UpdateBombs Config}
   fun {UpdateBombs Bombs}
      case Bombs of Bomb|Rest then
	 if Bomb.explodesIn == 0 then
	    {UpdateBombs Rest}
	 else
	    {AdjoinAt Bomb explodesIn
	     Bomb.explodesIn-1
	    }|{UpdateBombs Rest}
	 end
      [] nil then nil end
   end
in
   {AdjoinAt Config bombs
    {UpdateBombs Config.bombs}
   }
end

proc {UseDecision Config}
   Decision = false %{StudentDecideBombing Config}
in
   {Filter Config.spaceships
    fun{$ Spaceship} Spaceship.name == steve end
   }.1.seismicCharge = Decision|_
end

fun {ApplyUpdates Config}
   {Adjoin Config
    config(spaceships:{List.zip Config.spaceships Config.updates
                   fun{$ Spaceship Updates}
                      case Updates of Update|T andthen {IsAlive Spaceship} then
                         {Adjoin Spaceship {Update Spaceship}}
                      else Spaceship end
                   end
                  }
           updates:{Map Config.updates fun{$ UL} case UL of H|T then T else nil end end}
          )
   }
end

fun {ComputeNextConfig Configs}
   fun {ComputeNextConfig Config0}
      Config1 = {AdjoinAt Config0 step Config0.step+1}
      % {UseDecision Config1}
      Config2 = {DropBombs Config1}
      Config3 = {UpdateBombs Config2}
      Config4 = {ApplyUpdates Config3}
      % Config4 = {UpdateBonuses Config3}
      % Config5 = {MoveHeads Config4}
      % Config6 = {UseBonuses Config5}
      % Config7 = {MoveSpaceships Config6}
      Config5 = {CheckForKills Config4}
   in
      Config5
   end
in
   {Map Configs ComputeNextConfig}
end

fun {Distinct L}
   case L of H|T then
      H|{Distinct {Filter T fun{$ X} X \= H end}}
   [] nil then nil end
end

EmptyPresenceGrid = {Times grid() W fun{$} {Times col() H fun{$} n end} end}
fun {GetDiff Configs}
   fun {BuildSquaresGrid Squares Grid}
      case Squares of Square|Rest then
         X=Square.x Y=Square.y
         NewGrid = if {HasFeature Grid X} andthen {HasFeature Grid.X Y} then
                      {AdjoinAt Grid X {AdjoinAt Grid.X Y s}}
                   else Grid 
                   end
      in
         {BuildSquaresGrid Rest NewGrid}
      [] nil then Grid end
   end
   fun {BuildSpaceshipsGrid Spaceships Grid}
      case Spaceships of Spaceship|Rest then
         NewGrid = {BuildSquaresGrid Spaceship.positions Grid}
      in
         {BuildSpaceshipsGrid Rest NewGrid}
      [] nil then Grid end
   end
   fun {GridDiff X Y Grid0 Grid1}
      if X > W then nil
      elseif Y > H then {GridDiff X+1 1 Grid0 Grid1}
      elseif Grid0.X.Y \= Grid1.X.Y then
         X#Y|{GridDiff X Y+1 Grid0 Grid1}
      else
         {GridDiff X Y+1 Grid0 Grid1}
      end
   end
in
   {GridDiff 1 1
    {BuildSpaceshipsGrid Configs.1.  spaceships EmptyPresenceGrid}
    {BuildSpaceshipsGrid Configs.2.1.spaceships EmptyPresenceGrid}
   }
end

% ########  ##          ###    ##    ## 
% ##     ## ##         ## ##    ##  ##  
% ##     ## ##        ##   ##    ####   
% ########  ##       ##     ##    ##    
% ##        ##       #########    ##    
% ##        ##       ##     ##    ##    
% ##        ######## ##     ##    ##    

fun {IsAlive Spaceship} {Member death Spaceship.effects} == false end
fun {IsDead Spaceship}  {Member death Spaceship.effects} end

fun {CanMove Config}
   MoveSpaceships = {List.zip Config.spaceships Config.updates fun{$ S U} S#U end}
   CanMoveSpaceshipsMoves = {Filter MoveSpaceships fun{$ S#U} {IsAlive S} andthen U \= nil end}
in
   {Map CanMoveSpaceshipsMoves fun{$ S#U} S end}
end

fun {Slurp FName}
   File = {New Open.file init(name:FName flags:[read])}
   Content = {File read(list:$ size:all)}
in
   {File close()}
   Content
end

proc {Play ConfigName StudentNext StudentDecodeStrategy Options FinalResult}
KeyDowns = {NewCell keyTimestamps()}
fun lazy {LiveStrategy LastTimer Left Right}
   Next Timer
in
   thread {WaitNeeded Next}
      Keys=@KeyDowns
      L={HasFeature Keys Left} andthen Keys.Left > LastTimer
      R={HasFeature Keys Right} andthen Keys.Right > LastTimer
      U={HasFeature Keys Up} andthen Keys.Up > LastTimer
      D={HasFeature Keys Down} andthen Keys.Down > LastTimer
      Move=if L andthen R then
              if Keys.Left > Keys.Right then go(left) else go(right) end
            elseif L then go(left)
            elseif R then go(right)
            elseif U then go(up)
            elseif D then go(down)  
            else forward end
   in
      Timer = {Boot_Time.getMonotonicTime}
      fun {Next Spaceship}
         {StudentNext Spaceship Move}
      end
   end
   Next | {LiveStrategy Timer Left Right}
end
fun {DecodeStrategy Strategy}
   case Strategy of keyboard(left:Left right:Right intro:Intro) then
      {Append {StudentDecodeStrategy Intro} {LiveStrategy 0 Left Right}}
   else {StudentDecodeStrategy Strategy} end
end
Config = {Compiler.evalExpression {Slurp ConfigName} env _}
CurrentConfigs = {NewCell [%{AdjoinAt {InitSpaceships Config} updates {Map Config.spaceships fun{$ S} {MTUpdates S.moves} end}}
                          {AdjoinAt Config updates {Map Config.spaceships fun{$ S} {DecodeStrategy S.strategy} end}}
                          %{AdjoinAt Config updates {Map Config.spaceships fun{$ S} {DecodeStrategy S.strategy} end}}
                         ]}
fun {Stage Config} % inprogress / win(green) / tie([green blue])
   AliveTeams = {Distinct {Map
                 {Filter Config.spaceships fun{$ S} {IsAlive S} end}
                 fun{$ S} S.team end}}
   MovingSpaceships = {CanMove Config}
   % Check for a spaceship that meets the win condition based on its length
   WinningSpaceships = {Filter Config.spaceships fun{$ S} {List.length S.positions} == 10 end}
in
   % If there's exactly one winning spaceship, declare win for its team
      case {Length WinningSpaceships} % TODO colin check puis remove
      of 1 then win(WinningSpaceships.1.team)
      % If no immediate winner based on length, proceed with existing logic
      else
         case {Length AliveTeams}
         of 1 then win(AliveTeams.1)
         else
            if MovingSpaceships \= nil orelse Config.bombs \= nil then inprogress
            else tie(AliveTeams) end
         end
      end
end

fun {NextConfig}
   CurrentConfigs := {ComputeNextConfig @CurrentConfigs}
   if {Stage @CurrentConfigs.1} \= inprogress andthen {IsDet FinalResult} == false then
      FinalResult = {Stage @CurrentConfigs.1}%#@CurrentConfigs.1
   end
   @CurrentConfigs.1
end
in
if Options.debug then
%  ######   ########     ###    ########  ##     ## ####  ######   ######  
% ##    ##  ##     ##   ## ##   ##     ## ##     ##  ##  ##    ## ##    ## 
% ##        ##     ##  ##   ##  ##     ## ##     ##  ##  ##       ##       
% ##   #### ########  ##     ## ########  #########  ##  ##        ######  
% ##    ##  ##   ##   ######### ##        ##     ##  ##  ##             ## 
% ##    ##  ##    ##  ##     ## ##        ##     ##  ##  ##    ## ##    ## 
%  ######   ##     ## ##     ## ##        ##     ## ####  ######   ######  

RevertLook=revertlook(west:east east:west south:north north:south)
Triangles = tris(west:[~8#~8 ~8#8]
                 east:[8#~8 8#8]
                 north:[~8#~8 8#~8]
                 south:[~8#8 8#8]
)
proc {ShowSpaceships Spaceships}
   case Spaceships of Spaceship|Rest then
      proc {ShowCells Cells IsHead IsAlive}
	 case Cells of Cell|Rest then
          if IsHead then % TODO change
            case Spaceship.positions.1.to of
            north then
               % Central body of the spaceship
               {C tk(create rectangle Cell.x*20-4 Cell.y*20-4 Cell.x*20+4 Cell.y*20+4 tags:@R fill:Spaceship.team)}

               % Wings (symmetric on both sides)
               {C tk(create rectangle Cell.x*20-12 Cell.y*20-2 Cell.x*20-6 Cell.y*20+2 tags:@R fill:'silver')} % Left wing
               {C tk(create rectangle Cell.x*20+6 Cell.y*20-2 Cell.x*20+12 Cell.y*20+2 tags:@R fill:'silver')} % Right wing

               % Thrusters (bottom, but symmetrically designed so orientation doesn't matter)
               {C tk(create rectangle Cell.x*20-2 Cell.y*20+4 
                                      Cell.x*20-6 Cell.y*20+8 
                                      tags:@R fill:if IsAlive then red else black end)} % Left thruster
               {C tk(create rectangle Cell.x*20+2 Cell.y*20+4 
                                      Cell.x*20+6 Cell.y*20+8 
                                      tags:@R fill:if IsAlive then red else black end)} % Right thruster

               % Cockpit (central and circular, making it look the same from all sides)
               {C tk(create oval Cell.x*20-2 Cell.y*20-2 Cell.x*20+2 Cell.y*20+2 tags:@R fill:'blue')}
            [] south then
               % Central body of the spaceship
               {C tk(create rectangle Cell.x*20-4 Cell.y*20-4 Cell.x*20+4 Cell.y*20+4 tags:@R fill:Spaceship.team)}

               % Wings (symmetric on both sides)
               {C tk(create rectangle Cell.x*20-12 Cell.y*20-2 Cell.x*20-6  Cell.y*20+2 tags:@R fill:'silver')} % Left wing
               {C tk(create rectangle Cell.x*20+6  Cell.y*20-2 Cell.x*20+12 Cell.y*20+2 tags:@R fill:'silver')} % Right wing

               % Thrusters (bottom, but symmetrically designed so orientation doesn't matter)
               {C tk(create rectangle Cell.x*20-2 Cell.y*20-8 
                                      Cell.x*20-6 Cell.y*20-4 
                                      tags:@R fill:if IsAlive then red else black end)}
               {C tk(create rectangle Cell.x*20+2 Cell.y*20-8 
                                      Cell.x*20+6 Cell.y*20-4 
                                      tags:@R fill:if IsAlive then red else black end)}
               
               % Cockpit (central and circular, making it look the same from all sides)
               {C tk(create oval Cell.x*20-2 Cell.y*20-2 Cell.x*20+2 Cell.y*20+2 tags:@R fill:'blue')}
            [] east then
               % Central body of the spaceship
               {C tk(create rectangle Cell.x*20-4 Cell.y*20-4 Cell.x*20+4 Cell.y*20+4 tags:@R fill:Spaceship.team)}

               % Thrusters reoriented to the left for eastward propulsion
               {C tk(create rectangle Cell.x*20-8 Cell.y*20-2 
                                      Cell.x*20-4 Cell.y*20+6 
                                      tags:@R fill:if IsAlive then red else black end)} % Upper thruster
               {C tk(create rectangle Cell.x*20-8 Cell.y*20+2 
                                      Cell.x*20-4 Cell.y*20-6 
                                      tags:@R fill:if IsAlive then red else black end)} % Lower thruster

               % Wings adjusted for horizontal (eastward) orientation
               {C tk(create rectangle Cell.x*20 Cell.y*20-6 Cell.x*20+4 Cell.y*20-10 tags:@R fill:'silver')} % Upper wing, repositioned for eastward flight
               {C tk(create rectangle Cell.x*20 Cell.y*20+6 Cell.x*20+4 Cell.y*20+10 tags:@R fill:'silver')} % Lower wing, repositioned for eastward flight

               % Cockpit (central and circular, making it look the same from all sides)
               {C tk(create oval Cell.x*20-2 Cell.y*20-2 Cell.x*20+2 Cell.y*20+2 tags:@R fill:'blue')}
            [] west then
               % Central body of the spaceship
               {C tk(create rectangle Cell.x*20-4 Cell.y*20-4 Cell.x*20+4 Cell.y*20+4 tags:@R fill:Spaceship.team)}

               % Thrusters reoriented to the right for westward propulsion
               {C tk(create rectangle Cell.x*20+4 Cell.y*20-2 
                                      Cell.x*20+8 Cell.y*20+6
                                      tags:@R fill:if IsAlive then red else black end)} % Upper thruster
               {C tk(create rectangle Cell.x*20+4 Cell.y*20+2 
                                      Cell.x*20+8 Cell.y*20-6 
                                      tags:@R fill:if IsAlive then red else black end)} % Lower thruster

               % Wings adjusted for horizontal (westward) orientation
               {C tk(create rectangle Cell.x*20-4 Cell.y*20-10 Cell.x*20 Cell.y*20-6 tags:@R fill:'silver')} % Upper wing, repositioned for westward flight
               {C tk(create rectangle Cell.x*20-4 Cell.y*20+10 Cell.x*20 Cell.y*20+6 tags:@R fill:'silver')} % Lower wing, repositioned for westward flight

               % Cockpit (central and circular, making it look the same from all sides)
               {C tk(create oval Cell.x*20-2 Cell.y*20-2 Cell.x*20+2 Cell.y*20+2 tags:@R fill:'blue')}
            end
         else
            {C tk(create rectangle
               Cell.x*20-8 Cell.y*20-8 Cell.x*20+8 Cell.y*20+8
               tags:@R fill:Spaceship.team 
            )}
          in            
            {C tk(create rectangle
                  Cell.x*20-4 Cell.y*20-4 Cell.x*20+4 Cell.y*20+4
                  tags:@R fill:'lightgrey' % Using a lighter color to represent the content
            )}
         end
	    {ShowCells Rest false IsAlive}
	 [] nil then skip
	 end
      end
      X=Spaceship.positions.1.x Y=Spaceship.positions.1.y
   in
      {ShowCells Spaceship.positions true {IsAlive Spaceship}}
      {ShowSpaceships Rest}
   [] nil then skip end
end

proc {ShowBonuses Bonuses}
   case Bonuses of Bonus|Rest then
      %if Bonus.availableIn == 0 then
	 X=Bonus.position.x Y=Bonus.position.y
      in
         {C tk(create oval
	       X*20-10 Y*20-10 X*20+10 Y*20+10
	       tags:@R fill:{BonusColor Bonus}
	      )}
      %else skip end
      {ShowBonuses Rest}
   [] nil then skip end
end

proc {ShowBombs Bombs}
   case Bombs of Bomb|Rest then
      X=Bomb.position.x 
      Y=Bomb.position.y
   in
      if Bomb.explodesIn == 0 then
	 {C tk(create rectangle
	       (X-2)*20-6 Y*20-3 (X+2)*20+6 Y*20+3
	       tags:@R fill:red outline:red
	      )}
	 {C tk(create rectangle
	       X*20-3 (Y-2)*20-6 X*20+3 (Y+2)*20+6
	       tags:@R fill:red outline:red
	      )}
      else
	 {C tk(create oval
	       X*20-6 Y*20-6 X*20+6 Y*20+6
	       tags:@R fill:black
	      )}
       {C tk(create text
             X*20 Y*20
             text: {IntToString Bomb.explodesIn}
             tags:@R fill:red
            )}
      end
      {ShowBombs Rest}
   [] nil then skip end
end

proc {ShowDiff Diff}
   case Diff of (X#Y)|Rest then
      {C tk(create rectangle
	      X*20-2 Y*20-8 X*20+2 Y*20+2
	      tags:@R fill:red
	     )}
      {C tk(create rectangle
	      X*20-2 Y*20+4 X*20+2 Y*20+8
	      tags:@R fill:red
	     )}
      {ShowDiff Rest}
   [] nil then skip end
end

proc {ShowConfig Configs}
   OldR = @R
in
   if OldR == Rs.1 then R := Rs.2 else R := Rs.1 end
   {ShowBonuses Configs.1.bonuses}
   {ShowSpaceships Configs.1.spaceships}
   {ShowBombs Configs.1.bombs}
   {OldR tk(delete)}
   %{ShowDiff {GetDiff Configs}}
end

proc {RenderAtInterval T}
   {Delay T}
   Config = {NextConfig}
   {ShowConfig @CurrentConfigs}
in
   if {Stage Config} == inprogress then
      {RenderAtInterval T}
   else skip end
end

Win = {New Tk.toplevel tkInit()}
C   = {New Tk.canvas tkInit(parent:Win width:W*20+20 height:H*20+20 bg:white)}
B   = {New Tk.canvasTag tkInit(parent:C)}
Rs  = {New Tk.canvasTag tkInit(parent:C)}#{New Tk.canvasTag tkInit(parent:C)}
R   = {NewCell Rs.1}
{Tk.send pack(C)}

if @CurrentConfigs.1.walls then
   {C tk(create rectangle
         0 0 W*20+20 H*20+20
         tags:B fill:'blue' outline:black
        )}
   {C tk(create rectangle
         30 30 W*20-10 H*20-10
         tags:B fill:lightblue outline:black
        )}
else
   {C tk(create rectangle
         0 0 W*20+20 H*20+20
         tags:B fill:yellow outline:black
        )}
   {C tk(create rectangle
         10 10 W*20+10 H*20+10
         tags:B fill:lightblue outline:black
        )}
end
{ShowConfig @CurrentConfigs}

{Win tkBind(event: '<Key>'
            args: [atom('K')]
            action: proc{$ K}
                       if K == {Value.condSelect Options closeKey unit} then
                          {Win tkClose}
                          {Application.exit 0}
                       elseif K == space then
                          {NextConfig _}
			        {ShowConfig @CurrentConfigs}
		           else
                          KeyDowns := {AdjoinAt @KeyDowns K {Boot_Time.getMonotonicTime}}
                       end
		        end
	     )}
in
   if Options.frameRate > 0 then
      {RenderAtInterval 1000 div Options.frameRate}
   else skip end
else
% ##     ## ########    ###    ########  ##       ########  ######   ######  
% ##     ## ##         ## ##   ##     ## ##       ##       ##    ## ##    ## 
% ##     ## ##        ##   ##  ##     ## ##       ##       ##       ##       
% ######### ######   ##     ## ##     ## ##       ######    ######   ######  
% ##     ## ##       ######### ##     ## ##       ##             ##       ## 
% ##     ## ##       ##     ## ##     ## ##       ##       ##    ## ##    ## 
% ##     ## ######## ##     ## ########  ######## ########  ######   ######  
   proc {PlayTillResult}
      Config = {NextConfig}
   in
      if {Stage Config} == inprogress then
        {PlayTillResult}
      else skip end
   end
in
   {PlayTillResult}
end

end
end
