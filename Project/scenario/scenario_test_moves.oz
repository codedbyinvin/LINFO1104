local
   NoBomb=false|NoBomb
in
   scenario(bombLatency:3
	    walls:true
	    step: 0
	    spaceships: [
		     spaceship(team:red name:gordon
			   positions: [pos(x:6 y:6 to:east) pos(x:5 y:6 to:east) pos(x:4 y:6 to:east) pos(x:3 y:6 to:east)]
			   effects: nil
			   strategy: [forward forward turn(right) turn(right)]
			   seismicCharge: NoBomb
			  )
		     spaceship(team:green name:steve
			   positions: [pos(x:6 y:7 to:east) pos(x:5 y:7 to:east) pos(x:4 y:7 to:east) pos(x:3 y:7 to:east)]
			   effects: nil
			   strategy: [forward turn(right) turn(right) turn(right) forward forward forward turn(right) turn(right) turn(left)
				      repeat([forward] times:30)]
			   seismicCharge: true|NoBomb
			  )
		     spaceship(team:red name:patrick
			   positions: [pos(x:7 y:3 to:west) pos(x:8 y:3 to:west) pos(x:9 y:3 to:west)]
			   effects: nil
			   strategy: [turn(left) turn(left) turn(left) turn(left) turn(left) turn(left) turn(left) turn(left) turn(left)]
			   seismicCharge: NoBomb
			  )
		     spaceship(team:red name:john
			   positions: [pos(x:9 y:5 to:south) pos(x:9 y:4 to:south) pos(x:10 y:4 to:west) pos(x:11 y:4 to:west) pos(x:12 y:4 to:west)]
			   effects: nil
			   strategy: [forward forward repeat([turn(left)
							      repeat([forward]
								     times:2)
							     ]
							     times:5)
				     ]
			   seismicCharge: NoBomb
			  )
		    ]
	    bonuses: nil
	    bombs: nil
	   )
end