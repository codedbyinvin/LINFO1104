local
   NoBomb=false|NoBomb
in
   scenario(bombLatency:3
	    walls:true
	    step: 0
	    spaceships: [
		     spaceship(team:yellow name:jason
			   positions: [pos(x:4 y:3 to:east)]
			   effects: nil
			   strategy: keyboard(left:'Left' right:'Right' intro:nil)
			   seismicCharge: NoBomb
			  )
		     spaceship(team:green name:steve
			   positions: [pos(x:19 y:20 to:west)]
			   effects: nil
			   strategy: keyboard(left:q right:d intro:nil)
			   seismicCharge: NoBomb
			  )
		    ]
	    bonuses: [
			  % Wormholes in both directions
		      bonus(position:pos(x:6 y:6)   color:yellow effect:wormhole(x:17 y:17) target:catcher)
		      bonus(position:pos(x:17 y:17) color:yellow effect:wormhole(x:6 y:6) target:catcher)

			  % Normal bonuses
		      bonus(position:pos(x:11 y:11) color:red effect:revert target:opponents)
		      bonus(position:pos(x:12 y:12) color:black effect:scrap target:catcher)
		     ]
	    bombs: nil
	   )
end