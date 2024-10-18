


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

local function GetPlayerAuraCount(spellID)
  local data = C_UnitAuras.GetPlayerAuraBySpellID(spellID)
  local count 
  if data then
      count = data.charges
  else
    -- 如果是nil，那就是无buff，返回0。
     return 0
  end

  -- 如果是0层，他们可能没有层数设置。
  if data.charges == 0 then
    count = 1
  end

  local currentTime = GetTime()
  local timeUntilExpire = data.expirationTime - currentTime


  -- 如果坚持不到下一个gcd结束，则是0 
  local spellCooldownInfo = C_Spell.GetSpellCooldown(61304)
  if spellCooldownInfo then
    if  data.expirationTime > 0) and (data.expirationTime < spellCooldownInfo.startTime + spellCooldownInfo.duration) then
        count = 0
    end
  end
      
  return count

end --GetPlayerAuraCount
