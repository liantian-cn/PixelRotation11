


local f = CreateFrame("Frame", nil, UIParent)
--f:SetPoint("CENTER")
f:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0) -- 设置到左上角
f:SetSize(64, 64)

f.tex = f:CreateTexture()
f.tex:SetAllPoints()
--f.tex:SetColorTexture(0, 0, 0, 1)

local textBox = CreateFrame("Frame", nil, UIParent)
textBox:SetPoint("TOPLEFT", f, "TOPRIGHT", 0, 0) -- 放置在图标右侧
textBox:SetSize(256, 64)
local text = textBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
text:SetPoint("LEFT", textBox, "LEFT", 0, 0)
text:SetFont("Fonts\\FRIZQT__.TTF", 32, nil)
--text:SetText("这是一个文本框")
f:RegisterEvent("UNIT_COMBAT")
f:RegisterEvent("PLAYER_LEAVE_COMBAT")
f:RegisterEvent("PLAYER_ENTER_COMBAT")

f:RegisterEvent("CHAT_MSG_ADDON")
f:RegisterEvent("PLAYER_STARTED_MOVING")
f:RegisterEvent("PLAYER_STOPPED_MOVING")
f:RegisterEvent("PLAYER_TOTEM_UPDATE")
f:RegisterEvent("UNIT_AURA")
f:RegisterEvent("UNIT_SPELLCAST_START")
f:RegisterEvent("UNIT_SPELLCAST_SENT")
f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
f:RegisterEvent("UNIT_SPELLCAST_FAILED")
f:RegisterEvent("UNIT_SPELLCAST_STOP")
f:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
f:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
f:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
f:RegisterEvent("UNIT_SPELLCAST_EMPOWER_START")
f:RegisterEvent("UNIT_SPELLCAST_EMPOWER_STOP")
f:RegisterEvent("UNIT_SPELLCAST_EMPOWER_UPDATE")
f:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
f:RegisterEvent("UNIT_POWER_UPDATE")
f:RegisterEvent("ENCOUNTER_START")
f:RegisterEvent("ENCOUNTER_END")
f:RegisterUnitEvent("AZERITE_EMPOWERED_ITEM_SELECTION_UPDATED")
f:RegisterUnitEvent("AZERITE_ESSENCE_ACTIVATED")
f:RegisterUnitEvent("PLAYER_EQUIPMENT_CHANGED")
f:RegisterUnitEvent("TRAIT_CONFIG_UPDATED")
f:RegisterUnitEvent("UI_ERROR_MESSAGE")
f:RegisterEvent("LOADING_SCREEN_ENABLED")
f:RegisterEvent("LOADING_SCREEN_DISABLED")
local last_title = 0

function SetFrameColorByTitle(title)

    if last_title == title then
      return
    end
    last_title = title

  if (title == "空白") then
    f.tex:SetColorTexture(1, 1, 1, 1)
    text:SetText("空白")
    return
  end
  --/script SetFrameColorByTitle("死神的抚摩")
  if (title == "死神的抚摩") then
    f.tex:SetColorTexture(0, 0, 0.5, 1)
    text:SetText("死神的抚摩")
    return
  end
  --/script SetFrameColorByTitle("精髓分裂")
  if (title == "精髓分裂") then
    f.tex:SetColorTexture(0, 0, 1, 1)
    text:SetText("精髓分裂")
    return
  end
  --/script SetFrameColorByTitle("血液沸腾")
  if (title == "血液沸腾") then
    f.tex:SetColorTexture(0, 0.5, 0, 1)
    text:SetText("血液沸腾")
    return
  end
  --/script SetFrameColorByTitle("灵界打击")
  if (title == "灵界打击") then
    f.tex:SetColorTexture(0, 0.5, 0.5, 1)
    text:SetText("灵界打击")
    return
  end
  --/script SetFrameColorByTitle("死神印记")
  if (title == "死神印记") then
    f.tex:SetColorTexture(0, 0.5, 1, 1)
    text:SetText("死神印记")
    return
  end
  --/script SetFrameColorByTitle("心脏打击")
  if (title == "心脏打击") then
    f.tex:SetColorTexture(0, 1, 0, 1)
    text:SetText("心脏打击")
    return
  end
  --/script SetFrameColorByTitle("白骨风暴")
  if (title == "白骨风暴") then
    f.tex:SetColorTexture(0, 1, 0.5, 1)
    text:SetText("白骨风暴")
    return
  end
  --/script SetFrameColorByTitle("吸血鬼之血")
  if (title == "吸血鬼之血") then
    f.tex:SetColorTexture(0, 1, 1, 1)
    text:SetText("吸血鬼之血")
    return
  end
  --/script SetFrameColorByTitle("吞噬")
  if (title == "吞噬") then
    f.tex:SetColorTexture(1, 0, 0, 1)
    text:SetText("吞噬")
    return
  end
  --/script SetFrameColorByTitle("墓石")
  if (title == "墓石") then
    f.tex:SetColorTexture(1, 0, 0.5, 1)
    text:SetText("墓石")
    return
  end
  --/script SetFrameColorByTitle("枯萎凋零")
  if (title == "枯萎凋零") then
    f.tex:SetColorTexture(1, 0, 1, 1)
    text:SetText("枯萎凋零")
    return
  end
end

--
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

local function AnyEnemiesInRange()
    local unitID = 0
    for _, plate in pairs(C_NamePlate.GetNamePlates()) do
        unitID = plate.namePlateUnitToken
        if UnitCanAttack("player", unitID) and C_Spell.IsSpellInRange(49998, unitID) then
            return true
        end
    end
end


-- 计算符文数
local function getRuneCount()
  local amount = 0
  for i = 1, 6 do
      local start, duration, runeReady = GetRuneCooldown(i)
      if runeReady then
          amount = amount + 1
      end
  end
  return amount
end


-- 80%减伤清单
function get80DamageReduction()
  local damage_spell_list = {
    320655,   --通灵 凋骨
    424888,   -- 宝库 老1
    428711,   -- 宝库 老3
    434722,   -- 千丝 老1
    441298,   -- 千丝 老2
    461842,   -- 千丝 老3
    447261,   -- 拖把 老1
    449444,   -- 拖把 老2
    450100,   -- 拖把 老4
    453212,   -- 破晨 老1
    427001,   -- 破晨 老2
    438471,   -- 回响 老1
    8690           -- 炉石
  }
  local _, _, _, _, _, _, _, _, target_spellId = UnitCastingInfo("target")

  if target_spellId == nil then
    return false
  end

  for _, v in ipairs(damage_spell_list) do
    if v == target_spellId then
      return true
    end
  end
  return false

end

--详细说明
--lastExecutionTime：记录上次函数执行的时间，初始化为0。
--cooldown：设置函数的调用冷却时间为0.2秒。
--GetTime()：获取当前游戏时间，从游戏启动到现在的秒数。
--ProtectedFunction()：
--获取当前时间currentTime。
--检查当前时间与上次执行时间lastExecutionTime的差异。如果差异小于冷却时间0.2秒，则直接返回，不执行函数。
--如果差异大于或等于冷却时间，更新上次执行时间lastExecutionTime为当前时间currentTime。
--执行函数的实际内容。

local lastExecutionTime = 0
local cooldown = 0.1


function DoPixelRotation()
   ----获取当前时间
   -- local currentTime = GetTime()
   --
   -- -- 检查当前时间与上次执行时间的差异
   -- if currentTime - lastExecutionTime < cooldown then
   --     -- 如果差异小于0.2秒，直接返回，不执行函数
   --     return
   -- end
   --
   -- -- 更新上次执行时间
   -- lastExecutionTime = currentTime


  -- 如果不在战斗，则stop
  if not UnitAffectingCombat("player") then
    return SetFrameColorByTitle("空白")
  end

  -- 符文
  local runes = getRuneCount()
  -- 符文能量
  local runic_power = UnitPower("player", Enum.PowerType.RunicPower)

  -- 近战有敌人

  local any_enemies_in_range = AnyEnemiesInRange()

  -- 精髓分裂 195182
  local inRange_195182  = C_Spell.IsSpellInRange(195182, "target")

  -- 死神的抚摩 195292
  local spellCooldownInfo_195292 = C_Spell.GetSpellCooldown(195292)

  -- 骨盾 195181
  local aura_195181 = C_UnitAuras.GetPlayerAuraBySpellID(195181)

  -- 血液沸腾 50842
  local chargeInfo_50842 = C_Spell.GetSpellCharges(50842)

  -- 死神印记 439843
  local spellCooldownInfo_439843 = C_Spell.GetSpellCooldown(439843)

  -- 吸血鬼之血 55233
  local spellCooldownInfo_55233 = C_Spell.GetSpellCooldown(55233)

  -- 白骨风暴 194844
  local spellCooldownInfo_194844 = C_Spell.GetSpellCooldown(194844)

  -- 墓石219809
  local spellCooldownInfo_219809 = C_Spell.GetSpellCooldown(219809)

  -- 凝血 463730，applications为可回复百分比
  local aura_463730 = C_UnitAuras.GetPlayerAuraBySpellID(463730)

  -- 赤色天灾 81141，applications为可回复百分比
  local aura_81141 = C_UnitAuras.GetPlayerAuraBySpellID(81141)
  -- 凋零buff
  local aura_188290 = C_UnitAuras.GetPlayerAuraBySpellID(188290)
  -- 凋零CD
  local chargeInfo_43265 = C_Spell.GetSpellCharges(43265)
  ------------------------------------------------------------------
  ---------            基础覆盖                                     ----
  ------------------------------------------------------------------

  -- 打骨盾
  -- 骨盾ID 195181
  -- 如果骨盾<3
  --   如果 死神的抚摩 在CD好 且 符文 < 3 ，使用 死神的抚摩 195292
  --   如果 超出 精髓分裂 的距离， 且 死神的抚摩 CD好 ， 使用 死神的抚摩 195292
  --   否则 使用 精髓分裂  195182
  -- 且死亡触摸在CD，则死亡触摸。
  if (GetPlayerAuraCount(195181) < 3) then

    if (spellCooldownInfo_195292.duration == 0) and (runes < 3) then
      return SetFrameColorByTitle("死神的抚摩")
    end

    if (spellCooldownInfo_195292.duration == 0) and (not inRange_195182) then
      return SetFrameColorByTitle("死神的抚摩")
    end

    return SetFrameColorByTitle("精髓分裂")
  end


  -- 如果骨盾的CD小于8秒，符文>2个
  -- 则使用精髓分裂 195182。
  if aura_195181 then
    if (aura_195181.expirationTime - GetTime()) < 8 and runes > 2 then
      if (spellCooldownInfo_195292.duration == 0) and (not inRange_195182) then
        return SetFrameColorByTitle("死神的抚摩")
      end

      return SetFrameColorByTitle("精髓分裂")

    end
  end

  ------------------------------------------------------------------
  ---------            减伤   和打断                              ----
  ------------------------------------------------------------------


  -- 如果有能量，血量少于50%，释放灵打。
  if runic_power > 40 then
    if ( UnitHealth("player")/UnitHealthMax("player")) < 0.5 then
      return SetFrameColorByTitle("灵界打击")
    end
  end

  -- 目标在释放以下技能，则低于80%血就灵打。

  if runic_power > 40 then
    if ( UnitHealth("player")/UnitHealthMax("player")) < 0.8 then
      if get80DamageReduction() then
        return SetFrameColorByTitle("灵界打击")
      end
    end
  end


  ------------------------------------------------------------------
  ---------            拉怪区域                                  ----
  ------------------------------------------------------------------

  -- 如果能量大于105，使用灵界打击 49998

  if runic_power > 105 then
    return SetFrameColorByTitle("灵界打击")
  end

  -- 如果近战范围敌人>3个，血沸有1层，则血液沸腾 50842。
  --if are3EnemiesInRange() then
    if (chargeInfo_50842.currentCharges >= 2) and inRange_195182 then
      return SetFrameColorByTitle("血液沸腾")
    end
  --end


  -- 如果凋零有2层，且有赤色天灾buff，则释放凋零。
  -- 如果凋零有2层，符文大于2，则释放凋零。
  if  (chargeInfo_43265.currentCharges > 1 ) then
    if aura_81141 then
      return SetFrameColorByTitle("枯萎凋零")
    end
    if runes > 2 then
      return SetFrameColorByTitle("枯萎凋零")
    end
  end


  -- 如果目标生命值大于80%，且符文大于2个，使用死神印记在冷却 439843
  --if ( UnitHealth("target")/UnitHealthMax("target")) > 0.8 then
    if (spellCooldownInfo_439843.duration == 0) and (runes > 2) then
      if C_Spell.IsSpellInRange(439843, "target") then
        return SetFrameColorByTitle("死神印记")
      end
    end
  --end


  -- 如果目标生命值大于80%，吸血鬼在冷却，使用吸血鬼之血 55233

  if ( UnitHealth("target")/UnitHealthMax("target")) > 0.8 then
    if (spellCooldownInfo_55233.duration == 0)  then
      if any_enemies_in_range then
        return SetFrameColorByTitle("吸血鬼之血")
      end
    end
  end

  -- 如果有吸血鬼的55233 buff，且吞噬在冷却，且符文小4个，则使用吞噬 274156
  local aura_55233 = C_UnitAuras.GetPlayerAuraBySpellID(55233)
  if aura_55233 then
    local spellCooldownInfo = C_Spell.GetSpellCooldown(274156)
    if (spellCooldownInfo.duration == 0) and (runes < 4) then
      if any_enemies_in_range then
        return SetFrameColorByTitle("吞噬")
      end
    end
  end


  -- 如果身边有5个敌人，白骨风暴在冷却，骨盾有8层，则白骨风暴 194844
  if are5EnemiesInRange() then
    if (spellCooldownInfo_194844.duration == 0) and (GetPlayerAuraCount(195181) >= 8) then
      return SetFrameColorByTitle("白骨风暴")
    end
  end

    -- 如果墓石219809在冷却，骨盾有8层，能量小于100，则墓石219809
  if (spellCooldownInfo_219809.duration == 0) and (GetPlayerAuraCount(195181) >= 8) and (runic_power<100)then
    return SetFrameColorByTitle("墓石")
  end


  -- 如果白骨之盾少于10层，符文大于3个，则使用精髓分裂 195182
  if (GetPlayerAuraCount(195181) < 10) and (runes >= 3) then
      return SetFrameColorByTitle("精髓分裂")
  end

  -- 如果如果白骨之盾大于层，符文大于等于2个，则使用心脏打击206930。
  if (GetPlayerAuraCount(195181) >= 10) and (runes >= 2) then
      return SetFrameColorByTitle("心脏打击")
  end

  return SetFrameColorByTitle("空白")
end -- DoPixelRotation


f:SetScript("OnEvent", function() DoPixelRotation() end)
