// TODO: improve tribe function, clean code

#define	TRIBE_RANK_INITIATE	1
#define TRIBE_RANK_MEMBER	2
#define TRIBE_RANK_COUNCIL	3
#define TRIBE_RANK_CHIEF	4


mob/player
	New()

		spawn (2)
			checkSleep()

		SetTribeVerbs()
		return ..()

	var
		tribeName
		tmp/datum/tribe/Tribe
		tmp/InviteTimer
		tmp/BeingInvited

	proc/AssignTribe()
		if ( Tribe )
			SetTribeVerbs()
			return
		if ( !tribeName )
			SetTribeVerbs()
			return

		var datum/tribe/T = FindTribe(tribeName)

		if ( !T || !T.FindMember(src) )
			tribeName = null
			SetTribeVerbs()
			return
		else
			Tribe = T

		SetTribeVerbs()

	proc/SetTribeVerbs()
		if ( !Tribe )
			verbs += /mob/player/verb/New_Tribe
			verbs -= /mob/player/verb/Invite
			verbs -= /mob/player/verb/Boot
			verbs -= /mob/player/verb/Leave
			verbs -= /mob/player/verb/Promote
			verbs -= /mob/player/verb/Disband
			verbs -= /mob/player/verb/tSay
			verbs -= /mob/player/verb/Tribe_Who
			return

		var Rank = GetTribeRank()

		verbs -= /mob/player/verb/New_Tribe
		verbs += /mob/player/verb/tSay
		verbs += /mob/player/verb/Tribe_Who

		if ( Rank >= TRIBE_RANK_CHIEF )
			verbs -= /mob/player/verb/Leave
			verbs += /mob/player/verb/Disband
		else
			verbs += /mob/player/verb/Leave
			verbs -= /mob/player/verb/Disband

		if ( Rank >= TRIBE_RANK_COUNCIL )
			verbs += /mob/player/verb/Boot
			verbs += /mob/player/verb/Promote
		else
			verbs -= /mob/player/verb/Boot
			verbs -= /mob/player/verb/Promote

		if ( Rank >= TRIBE_RANK_MEMBER )
			verbs += /mob/player/verb/Invite
		else
			verbs -= /mob/player/verb/Invite

	proc/GetTribeRank()
		if ( !Tribe )
			return

		var datum/tribeMember/TM = Tribe.FindMember(src)
		if ( !TM )
			return

		return TM.rank

	proc/GetTribeRankName()
		if ( !Tribe )
			return

		var datum/tribeMember/TM = Tribe.FindMember(src)
		if ( !TM )
			return

		return TM.getRankName()



	proc/Invited(mob/player/clanmate,datum/tribe/newTribe)

		src << "[clanmate] has sent you an invitation to join [newTribe.name]."

		BeingInvited = 1
		var responce = alert(src,"Do you want to join [newTribe.name]?","Join Tribe?","Yes","No")
		BeingInvited = 0

		if ( responce == "No" )
			if ( clanmate )
				clanmate << "[src] has turned down your invitation."
			return


		newTribe.AddMember(src)
		newTribe.Message("[src] has joined the clan!")
		SetTribeVerbs()


	proc/isInSameTribe(mobname)
		if ( mobname == name )
			return 1

		if ( !Tribe )
			return 0

		for ( var/datum/tribeMember/TM in Tribe.memberList )
			if ( TM.name == mobname )
				return 1

		return 0


	verb
		New_Tribe()
			set category = "Tribe"
			if ( isBusy() )
				return

			setBusy(1)
			var newName = input(src,"Enter a name for your new tribe.","New Tribe") as text
			setBusy(0)

			if ( !newName )
				return

			if ( FindTribe(newName) )
				usr << "A tribe with that name already exists."
				return

			tribeName = newName
			Tribe = new(newName,src)
			usr << "You have founded a new tribe."
			SetTribeVerbs()


		Invite(mob/player/target)
			set category = "Tribe"
			if ( !target )
				return
			if ( !Tribe )
				return

			if ( target.isBusy() )
				usr << "[target] is busy right now."
				return
			if ( target.Tribe )
				usr << "[target] is already in a tribe."
				return

			if ( InviteTimer )
				usr << "Wait a moment before inviting again."
				return

			if ( target.BeingInvited )
				usr << "[target] is considering another invitation right now."
				return

			InviteTimer = 1
			spawn(200)
				InviteTimer = 0

			usr << "You send [target] an invitation to your tribe."
			target.Invited(src,Tribe)
		Boot(targetName as text)
			set category = "Tribe"
			if ( !targetName )
				return
			if ( !Tribe )
				return
			var datum/tribeMember/TM = Tribe.FindMemberByName(targetName)
			if ( !TM )
				usr << "Cannot find tribe member named \"[targetName]\"."
				return



			var Rank = GetTribeRank()
			if ( Rank <= TM.rank )
				usr << "You can only boot tribe members who are lower rank."
				return

			Tribe.Message("[targetName] has been booted from the tribe!")
			Tribe.RemoveMemberByTM(TM)
		Leave()
			set category = "Tribe"
			if ( !Tribe )
				return
			if ( isBusy() )
				return
			setBusy(1)
			var responce = alert("Are you sure you want to leave the tribe?","Leave Tribe","Yes","No")
			setBusy(0)
			if ( responce == "No" )
				return
			Tribe.Message("[src] has left the tribe.")
			Tribe.RemoveMember(name)

		Promote(targetName as text)
			set category = "Tribe"
			if ( !targetName )
				return
			if ( !Tribe )
				return
			if ( isBusy() )
				return

			var datum/tribeMember/TM = Tribe.FindMemberByName(targetName)
			if ( !TM )
				usr << "Cannot find tribe member named \"[targetName]\"."
				return

			var Rank = GetTribeRank()
			if ( Rank <= TM.rank )
				usr << "You can only promote tribe members lower ranked than you."
				return

			var list/selectionList = list("Initiate")

			if ( Rank > TRIBE_RANK_MEMBER )
				selectionList += "Member"
			if ( Rank > TRIBE_RANK_COUNCIL )
				selectionList += "Council Member"

			selectionList += "Nevermind"

			setBusy(1)
			var selection = input(src,"What rank do you want to assign to [targetName]?","New Rank") in selectionList
			setBusy(0)


			switch ( selection )
				if ( "Nevermind" )	return
				if ( "Initiate" ) TM.rank = TRIBE_RANK_INITIATE
				if ( "Member" ) TM.rank = TRIBE_RANK_MEMBER
				if ( "Council" ) TM.rank = TRIBE_RANK_COUNCIL

			Tribe.Message("Tribe member [targetName]'s rank is now [selection]")

			if ( TM.Mob )
				TM.Mob.SetTribeVerbs()
		Disband()
			set category = "Tribe"
			if ( !Tribe )
				return
			if ( isBusy() )
				return

			setBusy(1)
			var responce = alert(src,"Are you sure you want to disband the tribe?","Disband","Yes","No")
			setBusy(0)
			if ( responce == "No" )
				return

			Tribe.Message("Your tribe has disbanded.")

			del Tribe

		tSay(message as text)
			set category = "Tribe"
			if ( !message )
				return
			if ( !Tribe )
				return

			var rankName = GetTribeRankName()


			Tribe.Message("<b><font color = red>[rankName] [usr] says :</b><font color = black> [html_encode(message)]")

		Tribe_Who()
			set category = "Tribe"
			if ( !Tribe )
				return


			usr << "<b>Members of [Tribe.name]"
			for ( var/datum/tribeMember/TM in Tribe.memberList )
				usr << "[TM.getRankName()] [TM.name] : [TM.Mob?"Online":"Offline"]"



var/list/TribesList = new()

proc/FindTribe(tribeName)
	for ( var/datum/tribe/T in TribesList )
		if ( T.name == tribeName )
			return T



datum
	tribeMember
		var
			name
			tmp/mob/player/Mob
			rank

		New(mob/player/M,R=TRIBE_RANK_INITIATE)
			Mob = M
			if ( Mob )
				name = Mob.name
				Mob.SetTribeVerbs()
			rank = R


		Del()
			if ( Mob )
				Mob.Tribe = null
				Mob.tribeName = null
				Mob.SetTribeVerbs()
			return ..()

		proc
			setRank(R)
				rank = R
			getRankName()
				switch ( rank )
					if ( TRIBE_RANK_INITIATE )	return "Initiate"
					if ( TRIBE_RANK_MEMBER )	return "Member"
					if ( TRIBE_RANK_COUNCIL )	return "Council"
					if ( TRIBE_RANK_CHIEF )		return "Chief"


	tribe
		var
			name
			list/memberList = new()


		New(N,owner)
			name = N
			memberList += new /datum/tribeMember(owner,TRIBE_RANK_CHIEF)


			TribesList += src


		Del()
			for ( var/datum/tribeMember/TM in memberList )
				del TM

			TribesList -= src

			return ..()

		proc
			AddMember(member)
				memberList += new /datum/tribeMember(member)

			FindMember(mob/player/member)
				for ( var/datum/tribeMember/TM in memberList )
					if ( TM.name == member.name )
						TM.Mob = member

						return TM

			FindMemberByName(memberName)
				for ( var/datum/tribeMember/TM in memberList )
					if ( TM.name == memberName )
						return TM

			RemoveMember(memberName)
				var /datum/tribeMember/TM = FindMemberByName(memberName)

				if ( !TM )
					return -1

				RemoveMemberByTM(TM)

			RemoveMemberByTM(datum/tribeMember/TM)
				if ( !TM )
					return
				memberList -= TM
				del TM


			Message(message)
				for ( var/datum/tribeMember/TM in memberList )
					if ( TM.Mob )
						TM.Mob << "<b><font color = green>\[ Clan \] </b><font color = black>[message]"


world/proc/FindPlayer(playerName)
	for ( var/mob/player/player in contents )
		if ( player.name == playerName )
			return player

/*world/proc/CheckTribes()
	// In case a player starts over, this will clear them from their tribe.


	var mob/player/player
	find_tribes:
		for ( var/datum/tribe/T in TribesList )
			for ( var/datum/tribeMember/TM in T.memberList )
				if ( !TM.Mob )
					player = FindPlayer(TM.name)

					if ( player )
						if ( player.tribeName == T.name )
							TM.Mob = player
						else
							T.memberList -= TM
							del TM
							if ( !T.memberList.len )
								del T
								continue find_tribes
*/


world/proc/removePlayerFromTribe(playerName)
	for ( var/datum/tribe/T in TribesList )
		for ( var/datum/tribeMember/TM in T.memberList )
			if ( TM.name == playerName )
				if ( TM.rank == TRIBE_RANK_CHIEF )
					del T
					return
				else
					T.memberList -= TM
					del TM

					return


/*			if ( !TM.Mob )
				player = FindPlayer(TM.name)

				if ( player )
					if ( player.tribeName == T.name )
						TM.Mob = player
					else
						T.memberList -= TM
						del TM
						if ( !T.memberList.len )
							del T
							continue find_tribes */




