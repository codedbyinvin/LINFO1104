local
   NoBomb=false|NoBomb
in
   scenario(bombLatency:3
	    walls:true
	    step: 0
	    spaceships: [
		     spaceship(team:blue name:gordon
			   positions: [pos(x:10 y:11 to:south) pos(x:10 y:10 to:south) pos(x:10 y:9 to:south) pos(x:10 y:9 to:south)]
			   effects: nil
			   strategy: [repeat([forward] times:20)]
			   seismicCharge: NoBomb
			  )
		     spaceship(team:green name:steve
			   positions: [pos(x:12 y:13 to:east) pos(x:11 y:13 to:east) pos(x:10 y:13 to:east) pos(x:9 y:13 to:east)]
			   effects: nil
			   strategy: [forward forward turn(right) repeat([forward] times:3) turn(right) forward turn(right) forward turn(left) repeat([forward] times:24)]
			   seismicCharge: false|false|false|false|false|false|true|NoBomb
			  )
		     spaceship(team:red name:patrick
			   positions: [pos(x:14 y:14 to:west) pos(x:15 y:14 to:west) pos(x:16 y:14 to:west) pos(x:17 y:14 to:west)]
			   effects: nil
			   strategy: [repeat([forward] times:7) turn(right) forward turn(left) forward forward]
			   seismicCharge: NoBomb
			  )
		    ]
	    bonuses: [
		      bonus(position:pos(x:10 y:14) color:red effect:revert target:catcher)
		      bonus(position:pos(x:14 y:13) color:red effect:revert target:catcher)
		      bonus(position:pos(x:16 y:14) color:red effect:revert target:catcher)
		     ]
	    bombs: [
		    bomb(position:pos(x:15 y:12) explodesIn:3)
		    bomb(position:pos(x:9 y:8) explodesIn:6)
		   ]
	   )
end