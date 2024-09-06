local
   NoBomb=false|NoBomb
in
   scenario(bombLatency:3
	    walls:true
	    step: 0
	    spaceships: [
		     spaceship(team:red name:gordon
			   positions: [pos(x:11 y:13 to:west) pos(x:12 y:13 to:west) pos(x:13 y:13 to:west) pos(x:14 y:13 to:west) pos(x:14 y:12 to:south) pos(x:14 y:11 to:south) pos(x:13 y:11 to:east) pos(x:12 y:11 to:east) pos(x:11 y:11 to:east)]
			   effects: nil
			   strategy: [forward forward forward]
			   seismicCharge: NoBomb
			  )
		     spaceship(team:green name:steve
			   positions: [pos(x:12 y:12 to:east) pos(x:11 y:12 to:east) pos(x:10 y:12 to:east)]
			   effects: nil
			   strategy: [forward turn(right) turn(right) repeat([forward] times:20)]
			   seismicCharge: NoBomb
			  )
		     spaceship(team:red name:patrick
			   positions: [pos(x:7 y:10 to:north) pos(x:7 y:11 to:north) pos(x:7 y:12 to:north)]
			   effects: nil
			   strategy: [forward forward forward forward]
			   seismicCharge: NoBomb
			  )
		    ]
	    bonuses: [
		    bonus(position:pos(x:13 y:12) color:orange effect:wormhole(x:8 y:13) target:catcher)
		    bonus(position:pos(x:8 y:13)  color:orange effect:wormhole(x:13 y:12) target:catcher)
		    bonus(position:pos(x:7 y:8)   color:yellow effect:wormhole(x:7 y:16) target:catcher)
		    bonus(position:pos(x:7 y:16)  color:yellow effect:wormhole(x:7 y:8) target:catcher)
	    ]
	    bombs: nil
	   )
end