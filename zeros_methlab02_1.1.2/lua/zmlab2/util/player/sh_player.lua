zmlab2 = zmlab2 or {}
zmlab2.Player = zmlab2.Player or {}

// Returns the steam id of the player
function zmlab2.Player.GetID(ply)
    if ply:IsBot() then
        return ply:UserID()
    else
        return ply:SteamID()
    end
end

// Returns the name of the player
function zmlab2.Player.GetName(ply)
    if ply:IsBot() then
        return "Bot_" .. ply:UserID()
    else
        return ply:Nick()
    end
end

// Returns the player rank / usergroup
function zmlab2.Player.GetRank(ply)
	if SG then
		return ply:GetSecondaryUserGroup() or ply:GetUserGroup()
	else
		return ply:GetUserGroup()
	end
end

// Checks if the player has one of the specified ranks
function zmlab2.Player.RankCheck(ply,ranks)
	if table.Count(ranks) <= 0 then return true end
	if xAdmin then

		local HasRank = false
		for k, v in pairs(ranks) do
			if ply:IsUserGroup(k) then
				HasRank = true
				break
			end
		end
		return HasRank
	else
		if ranks[zmlab2.Player.GetRank(ply)] == nil then
			return false
		else
			return true
		end
	end
end

// Returns the players job
function zmlab2.Player.GetJob(ply)
	return ply:Team()
end

// Returns the players job name
function zmlab2.Player.GetJobName(ply)
	return team.GetName( zmlab2.Player.GetJob(ply) )
end



// This returns true if the player is a admin
function zmlab2.Player.IsAdmin(ply)
    if IsValid(ply) then
        if xAdmin then
            return ply:IsAdmin()
        elseif sam then
            return ply:IsAdmin()
        elseif sAdmin then
            return ply:IsAdmin()
        else
            if zmlab2.config.AdminRanks[zmlab2.Player.GetRank(ply)] then
                return true
            else
                return false
            end
        end
    else
        return false
    end
end



if SERVER then

	// This saves the owners SteamID
	function zmlab2.Player.SetOwner(ent, ply)

		if (IsValid(ply)) then
			ent:SetNWString("zmlab2_Owner", ply:SteamID())

			if CPPI then
				ent:CPPISetOwner(ply)
			end

			if gProtect and istable(gProtect) then
				gProtect.SetOwner(ply,ent)
			end
		else
			ent:SetNWString("zmlab2_Owner", "world")
		end
	end
end

// This returns the entites owner SteamID
function zmlab2.Player.GetOwnerID(ent)
	return ent:GetNWString("zmlab2_Owner", "nil")
end

// Checks if both entities have the same owner
function zmlab2.Player.SharedOwner(ent01,ent02)
	if IsValid(ent01) and IsValid(ent02) then

		if zmlab2.Player.GetOwnerID(ent01) == zmlab2.Player.GetOwnerID(ent02) then
			return true
		else
			return false
		end
	else
		return false
	end
end

// This returns the owner
function zmlab2.Player.GetOwner(ent)
	if IsValid(ent) then
		local id = ent:GetNWString("zmlab2_Owner", "nil")
		local ply = player.GetBySteamID(id)

		if (IsValid(ply)) then
			return ply
		else
			return false
		end
	else
		return false
	end
end

// Checks if the player is the owner of the entitiy
function zmlab2.Player.IsOwner(ply, ent)
	if IsValid(ent) and IsValid(ply) then
		local id = ent:GetNWString("zmlab2_Owner", "nil")
		local ply_id = ply:SteamID()

		if id == ply_id or id == "world" then

			return true
		else
			return false
		end
	else
		return false
	end
end

function zmlab2.Player.IsMethCook(ply)
    if BaseWars then return true end
	if zmlab2.config.Jobs == nil then return true end
	if table.Count(zmlab2.config.Jobs) <= 0 then return true end

	if zmlab2.config.Jobs[zmlab2.Player.GetJob(ply)] then
		return true
	else
		return false
	end
end

// Returns the dropoff point if the player has one assigned
function zmlab2.Player.GetDropoff(ply)
	return ply.zmlab2_Dropoff
end

// Does the player has meth?
function zmlab2.Player.HasMeth(ply)
	if (ply.zmlab2_MethList and #ply.zmlab2_MethList > 0) then
		return true
	else
		return false
	end
end

function zmlab2.Player.OnMeth(ply)
	if ply.zmlab2_MethDuration and ply.zmlab2_MethStart and (ply.zmlab2_MethDuration + ply.zmlab2_MethStart) > CurTime() then
		return true
	else
		return false
	end
end

// Checks if the player is allowed to interact with the entity
function zmlab2.Player.CanInteract(ply, ent)
    if zmlab2.Player.IsMethCook(ply) == false then
        zmlab2.Notify(ply, zmlab2.language["Interaction_Fail_Job"], 1)

        return false
    end

    if zmlab2.config.SharedEquipment == true then
        return true
    else
        // Is the entity a public entity?
        if ent.IsPublic == true then return true end

        if zmlab2.Player.IsOwner(ply, ent) then
            return true
        else
            zmlab2.Notify(ply, zmlab2.language["YouDontOwnThis"], 1)

            return false
        end
    end
end
