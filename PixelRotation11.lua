

local GetPlayerAuraBySpellID = C_UnitAuras.GetPlayerAuraBySpellID


local frame = CreateFrame("Frame", "PixelRotation11Frame", UIParent)
frame:SetSize(64, 64)
-- frame:SetPoint("CENTER")
frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0) -- 设置到左上角
frame.texture = frame:CreateTexture(nil, "BACKGROUND")
frame.texture:SetAllPoints(true)
frame.texture:SetColorTexture(1, 0, 0, 1) -- Red color with full opacity
frame:Show()



function are3EnemiesInRange()
   local inRange = 0
   local id
   for i = 1, 40 do
      id = "nameplate" .. i
      --local message = ""
       if UnitExists(id) then
         --message = id .. " "
         if UnitAffectingCombat(id) then
           -- message = message .. "in combat "
            if UnitIsEnemy("player",id) then
              -- message = message .. "is hostile "
               if IsItemInRange(63427, id) == true then
                 -- message = message .. "in range"
                  inRange = inRange + 1
               end
            end
         end
      end
      -- if (message ~= "") then
      --    print (message)
      -- end
      if (inRange > 2 ) then
         break
      end
   end

   return (inRange > 2)
end

function PR_get_buff_count(spellID)
    -- buff层数
    -- local _, _, _, count, _, duration, expires, _, _, _, spellID, _, _, _, _, _, _, _, _ =  UnitBuff("player", GetSpellInfo(db_buff[buff_name]))
    -- local _, _, _, count, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _ =  UnitBuff("player", GetSpellInfo(db_buff[buff_name]))
    local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal,spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod, _ = GetPlayerAuraBySpellID(spellID)
    -- 如果层数是nil，那就是无buff，返回0。
    if count == nil then
        return 0
    end

    -- 如果这是个读秒的buff，持续不到下次施法，则返回0
    if (expires > 0) and ((expires - cast.time_remaining()) <= 0) then
        return 0
    end

    -- 如果层数是0，则表明这是不叠层的buff，返回1，1层
    if count == 0 then
        count = 1
    end

    -- 愤怒buff考虑当前施法
    if (buff_name =="solar_wrath") and (current_casting == db_spell["solar_wrath"]) then
        count = count - 1
    end

    -- 愤怒buff考虑当前施法
    if (buff_name =="lunar_strike") and (current_casting == db_spell["lunar_strike"]) then
        count = count - 1
    end

    return count

end