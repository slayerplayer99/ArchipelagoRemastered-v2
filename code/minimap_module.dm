

//obj/mapPiece
//	mouse_opacity = 0
//	icon = 'minimap.dmi'
//	icon_state = "1"

mob/player
	var	list/minimap = new/list(28,28)
	var tmp/showMinimap =0

/*	verb/Open_Minimap()

//		winset(src,"minimap","is-visible=true")


		var map = drawMiniMap()


		usr << browse(map,"window=map&size=240x240")

		showMinimap = 1

		//drawMiniMap()

	verb/Close_Minimap()
		showMinimap = 0

		usr << browse(null,"window=map") */

	proc/UpdateMiniMap()
		var mapx,mapy
		mapx = 1+round( ((x-1)/300) * 28 )
		mapy = 1+round( ((299-y)/300) * 28 )
		var update

		//src << "Setting [mapx] [mapy]"

		if ( ! minimap[mapx][mapy] )
			update = 1

		minimap[mapx][mapy] = 1

		if ( update && showMinimap )
			//usr << browse(null,"window=map")


			var map = drawMiniMap()
			usr << browse(map,"window=map&size=240x240")



	proc/drawMiniMap()
		var mapx,mapy
		//var C = 0
		var retstring


		var graphic = 'graphics/minimap2.png'
		src << browse_rsc(graphic,"minimap2.png")

		var graphic2 = 'graphics/minimapfog.png'
		src << browse_rsc(graphic2,"minimapfog.png")


//		var graphic3 = 'graphics/minimaploc.png'
//		src << browse_rsc(graphic3,"minimaploc.png")


		retstring += "<div style=\"position: absolute; top: 8px; left: 8px;\" >"
		retstring += "<img src=minimap2.png></div>"
		for ( mapx=1,mapx<=28,mapx++ )
			for ( mapy=1,mapy<=28,mapy++ )

				if ( minimap[mapx][mapy] )
					continue

				retstring += "<div style=\"position: absolute; top: [mapy*8]px; left: [mapx*8]px;\" >"
				retstring += "<img src=minimapfog.png></div>"






		return retstring

