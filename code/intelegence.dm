// TODO: Improve intelligence


mob/player/var
	list/IQlist = new()

datum/IQtype
	var
		IQtype
		subtype
	proc
		Match(T,S)
			return ( IQtype == T && subtype == S )
	New(T,S)
		IQtype = T
		subtype = S

mob/player/proc/CheckIQ(IQtype,subtype)

	if ( isobj(subtype) )
		subtype = subtype:type

	for ( var/datum/IQtype/IQ in IQlist )
		if ( IQ.Match(IQtype,subtype) )
			return


	src << "<B><font color = green>You are smarter!"
	var datum/IQtype/newIQ = new(IQtype,subtype)

	IQlist += newIQ

mob/player/proc/GetIQ()
	return round( IQlist.len / 2 )
	src.wei=round(IQlist.len/2)

mob/player
	var
		wei=0//IQ
		wei2=0//lvl weight
mob/player/proc/getweight()
	switch(src.wei)
		if ( 0 to 10 )
		//	Increase_Weight()
		if ( 11 to 20 )
	//		Increase_Weight()
		if ( 21 to 30 )
	//		Increase_Weight()
		if ( 31 to 40 )
	//		Increase_Weight()
		if ( 41 to 50 )
	//		Increase_Weight()
		if ( 51 to 60 )
	//		Increase_Weight()
		if ( 61 to 70 )
	//		Increase_Weight()
		if ( 71 to 80 )
	//		Increase_Weight()
		else
	//		Increase_Weight()

mob/player/proc/Increase_Weight()
	if(src.wei2==0)
		MAX_WEIGHT+=5
		src.wei=1
	if(src.wei2==1)
		MAX_WEIGHT+=5
		src.wei=2
	if(src.wei2==2)
		MAX_WEIGHT+=10
		src.wei=3
	if(src.wei2==3)
		MAX_WEIGHT+=10
		src.wei=4
	if(src.wei2==4)
		MAX_WEIGHT+=15
		src.wei=5
	if(src.wei2==5)
		MAX_WEIGHT+=15
		src.wei=6
	if(src.wei2==6)
		MAX_WEIGHT+=20
		src.wei=7
	if(src.wei2==7)
		MAX_WEIGHT+=20
		src.wei=8
	if(src.wei2==8)
		MAX_WEIGHT+=50
		src.wei=9


mob/player/proc/GetIQName()

	switch ( GetIQ() )
		if ( 0 to 10 )
	//		Increase_Weight()
	//		MAX_WEIGHT+=5
			getweight()
			return	"Tourist"
		if ( 11 to 20 )
	//		Increase_Weight()
	//		increase_max+=5
//			MAX_WEIGHT+=5
			return	"Savage"
		if ( 21 to 30 )
	//		Increase_Weight()
	//		increase_max+=10
		//	MAX_WEIGHT+=10
			return	"Boy Scout"
		if ( 31 to 40 )
	//		Increase_Weight()
	//		increase_max+=10
	//		MAX_WEIGHT+=10
			return	"Explorer"
		if ( 41 to 50 )
	//		Increase_Weight()
	//		increase_max+=15
	//		MAX_WEIGHT+=15
			return	"Native"
		if ( 51 to 60 )
	//		Increase_Weight()
	//		increase_max+=15
	//		MAX_WEIGHT+=15
			return	"Survivor"
		if ( 61 to 70 )
	//		Increase_Weight()
	//		increase_max+=20
	//		MAX_WEIGHT+=20
			return 	"Expert"
		if ( 71 to 80 )
	//		Increase_Weight()
	//		increase_max+=20
	//		MAX_WEIGHT+=20
			return	"Master"
		else
	//		Increase_Weight()
	//		increase_max+=50
	//		MAX_WEIGHT+=50
			return  "Grand Master"