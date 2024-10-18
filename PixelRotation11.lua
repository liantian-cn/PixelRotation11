


local f = CreateFrame("Frame", nil, UIParent)
--f:SetPoint("CENTER")
f:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0) -- 设置到左上角
f:SetSize(64, 64)
f:RegisterEvent("UNIT_COMBAT")
f:RegisterEvent("PLAYER_LEAVE_COMBAT")
f:RegisterEvent("PLAYER_ENTER_COMBAT")

f.tex = f:CreateTexture()
f.tex:SetAllPoints()
f.tex:SetColorTexture(0, 0, 0, 1)

local textBox = CreateFrame("Frame", nil, UIParent)
textBox:SetPoint("TOPLEFT", f, "TOPRIGHT", 0, 0) -- 放置在图标右侧
textBox:SetSize(256, 64)
local text = textBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
text:SetPoint("LEFT", textBox, "LEFT", 0, 0)
text:SetFont("Fonts\\FRIZQT__.TTF", 32, nil)
--text:SetText("这是一个文本框")


function SetFrameColorByTitle(title)
  if (title == "空白") then
    f.tex:SetColorTexture(1, 1, 1, 1)
    text:SetText("空白")
    return
  end
  if (title == "死神的抚摩") then
    f.tex:SetColorTexture(0, 0, 0.25, 1)
    text:SetText("死神的抚摩")
    return
  end
  if (title == "精髓分裂") then
    f.tex:SetColorTexture(0, 0, 0.5, 1)
    text:SetText("精髓分裂")
    return
  end
  if (title == "血液沸腾") then
    f.tex:SetColorTexture(0, 0, 0.75, 1)
    text:SetText("血液沸腾")
    return
  end
  if (title == "灵界打击") then
    f.tex:SetColorTexture(0, 0, 1, 1)
    text:SetText("灵界打击")
    return
  end
  if (title == "死神印记") then
    f.tex:SetColorTexture(0, 0.25, 0, 1)
    text:SetText("死神印记")
    return
  end
  if (title == "心脏打击") then
    f.tex:SetColorTexture(0, 0.25, 0.25, 1)
    text:SetText("心脏打击")
    return
  end
  if (title == "白骨风暴") then
    f.tex:SetColorTexture(0, 0.25, 0.5, 1)
    text:SetText("白骨风暴")
    return
  end
end

-- /script SetFrameColorByTitle("空白")
-- /script SetFrameColorByTitle("停手")

local function GetPlayerAuraCount(spellID)
  local data = C_UnitAuras.GetPlayerAuraBySpellID(spellID)
  local count 
  if data then
      count = data.applications
  else
    -- 如果是nil，那就是无buff，返回0。
     return 0
  end
  -- 如果是0层，他们可能没有层数设置。
  if data.applications == 0 then
    count = 1
  end
  
  -- 如果坚持不到下一个gcd结束，则是0
  local spellCooldownInfo = C_Spell.GetSpellCooldown(61304)
  if spellCooldownInfo then
    if  (data.expirationTime > 0) and (data.expirationTime < spellCooldownInfo.startTime + spellCooldownInfo.duration) then
        count = 0
    end
  end
      
  return count
  
end --GetPlayerAuraCount


local function are3EnemiesInRange()
    local inRange, unitID = 0
    for _, plate in pairs(C_NamePlate.GetNamePlates()) do
        unitID = plate.namePlateUnitToken
        if UnitCanAttack("player", unitID) and IsItemInRange(32321, unitID) then
            inRange = inRange + 1
            if inRange >= 3 then return true end
        end
    end
end

local function are5EnemiesInRange()
    local inRange, unitID = 0
    for _, plate in pairs(C_NamePlate.GetNamePlates()) do
        unitID = plate.namePlateUnitToken
        if UnitCanAttack("player", unitID) and IsItemInRange(32321, unitID) then
            inRange = inRange + 1
            if inRange >= 5 then return true end
        end
    end
end



function DoPixelRotation()

  -- 如果不在战斗，则stop
  if not UnitAffectingCombat("player") then
    return SetFrameColorByTitle("空白")
  end

  -- 符文
  local runes = UnitPower("player", Enum.PowerType.Runes)
  -- 符文能量
  local runic_power = UnitPower("player", Enum.PowerType.RunicPower)


  -- 打骨盾
  -- 骨盾ID 195181
  -- 如果骨盾<3
  --   如果 死神的抚摩 在CD好 且 符文 < 3 ，使用 死神的抚摩 195292
  --   如果 超出 精髓分裂 的距离， 且 死神的抚摩 CD好 ， 使用 死神的抚摩 195292
  --   否则 使用 精髓分裂  195182
  -- 且死亡触摸在CD，则死亡触摸。
  if (GetPlayerAuraCount(195181) < 3) then
    local spellCooldownInfo = C_Spell.GetSpellCooldown(195292)
    local inRange  = C_Spell.IsSpellInRange(195182, "target")

    if (spellCooldownInfo.duration == 0) and (runes < 3) then
      return SetFrameColorByTitle("死神的抚摩")
    end

    if (spellCooldownInfo.duration == 0) and (not inRange) then
      return SetFrameColorByTitle("死神的抚摩")
    end

    return SetFrameColorByTitle("精髓分裂")
  end



  -- 如果近战范围敌人>3个，血沸有2层，则血液沸腾 50842。
  if are3EnemiesInRange then
    local chargeInfo = C_Spell.GetSpellCharges(50842)
    if chargeInfo.currentCharges >= 2 then
      return SetFrameColorByTitle("血液沸腾")
    end
  end

  -- 如果能量大于115，使用灵界打击 49998

  if runic_power > 115 then
    return SetFrameColorByTitle("灵界打击")
  end

  -- 如果目标生命值大于80%，且符文大于2个，使用死神印记在冷却 439843
  if ( UnitHealth("target")/UnitHealthMax("target")) > 0.8 then
    local spellCooldownInfo = C_Spell.GetSpellCooldown(439843)

    if (spellCooldownInfo.duration == 0) and (runes > 3) then
      return SetFrameColorByTitle("死神印记")
    end
  end


  -- 如果身边有5个敌人，白骨风暴在冷却，骨盾有10层，则白骨风暴 194844
  if are5EnemiesInRange() then
    local spellCooldownInfo = C_Spell.GetSpellCooldown(194844)
    if (spellCooldownInfo.duration == 0) and (GetPlayerAuraCount(195181) >= 10) then
      return SetFrameColorByTitle("白骨风暴")
    end
  end


  -- 如果符文大于等于2个，则使用心脏打击206930。
  if runes >= 2 then
    return SetFrameColorByTitle("心脏打击")
  end

  return SetFrameColorByTitle("空白")
end -- DoPixelRotation


f:SetScript("OnEvent", function() DoPixelRotation() end)
