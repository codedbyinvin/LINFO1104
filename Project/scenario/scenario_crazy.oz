local
   NoBomb=false|NoBomb
in
   config(bombLatency:3
	  walls:true
	  step: 0
	  spaceships: [
		   spaceship(team:yellow name:jason
			 positions: [pos(x:4 y:3 to:east) pos(x:3 y:3 to:east) pos(x:2 y:3 to:east)]
			 effects: nil
			 strategy: keyboard(left:'Left' right:'Right' intro:nil)
			 seismicCharge: NoBomb
			)
		   spaceship(team:green name:steve
			 positions: [pos(x:19 y:20 to:west) pos(x:20 y:20 to:west) pos(x:21 y:20 to:west)]
			 effects: nil
			 strategy:  nil % keyboard(left:q right:d intro:nil)
			 seismicCharge: NoBomb
			)
		  ]
	  bonuses: [
			% Wormholes in both directions
		    bonus(position:pos(x:6 y:6)   color:yellow effect:wormhole(x:17 y:17) target:catcher)
		    bonus(position:pos(x:17 y:17) color:yellow effect:wormhole(x:6 y:6)   target:catcher)

			% Reverse the direction of the catcher
		    bonus(position:pos(x:11 y:11) color:red    effect:revert target:catcher)

			% Scrap and grow
		    bonus(position:pos(x:12 y:12) color:orange  effect:scrap target:catcher)

			% Drop a seismic charge if the spaceship passes through the bonus
			bonus(position:pos(x:9 y:9)   color:black   effect:dropSeismicCharge(true|false|true|false|true|nil) target:catcher)
		    bonus(position:pos(x:18 y:18) color:black   effect:dropSeismicCharge(true|false|true|false|true|nil) target:catcher)
		   ]
	  bombs: nil
	 )
end