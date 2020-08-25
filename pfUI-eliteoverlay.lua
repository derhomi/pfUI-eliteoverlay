pfUI:RegisterModule("EliteOverlay", "vanilla:tbc", function ()
  pfUI.gui.dropdowns.EliteOverlay_positions = {
    "left:" .. T["Left"],
    "right:" .. T["Right"],
    "off:" .. T["Disabled"]
  }

  -- detect current addon path
  local addonpath
  local tocs = { "", "-master", "-tbc", "-wotlk" }
  for _, name in pairs(tocs) do
    local current = string.format("pfUI-eliteoverlay%s", name)
    local _, title = GetAddOnInfo(current)
    if title then
      addonpath = "Interface\\AddOns\\" .. current
      break
    end
  end

  if pfUI.gui.CreateGUIEntry then -- new pfUI
    pfUI.gui.CreateGUIEntry(T["Thirdparty"], T["Elite Overlay"], function()
      pfUI.gui.CreateConfig(nil, T["Select dragon position"], C.EliteOverlay, "position", "dropdown", pfUI.gui.dropdowns.EliteOverlay_positions)
    end)
  else -- old pfUI
    pfUI.gui.tabs.thirdparty.tabs.EliteOverlay = pfUI.gui.tabs.thirdparty.tabs:CreateTabChild("EliteOverlay", true)
    pfUI.gui.tabs.thirdparty.tabs.EliteOverlay:SetScript("OnShow", function()
      if not this.setup then
        local CreateConfig = pfUI.gui.CreateConfig
        local update = pfUI.gui.update
        this.setup = true
      end
    end)
  end

  pfUI:UpdateConfig("EliteOverlay",       nil,         "position",   "right")

  if C.EliteOverlay.position == "off" then return end

  local HookRefreshUnit = pfUI.uf.RefreshUnit
  function pfUI.uf:RefreshUnit(unit, component)
    local pos = string.upper(C.EliteOverlay.position)
    local invert = C.EliteOverlay.position == "right" and 1 or -1
    local unitstr = ( unit.label or "" ) .. ( unit.id or "" )
    if unitstr == "" then return end

    local size = unit:GetWidth() / 1.5
    local elite = UnitClassification(unitstr)

    if not unit.dragonTopGold then
      unit.dragonTopGold = unit:CreateTexture(nil, "OVERLAY")
      unit.dragonTopGold:SetWidth(size)
      unit.dragonTopGold:SetHeight(size)
      unit.dragonTopGold:SetTexture(addonpath.."\\TOP_GOLD_"..pos)
      unit.dragonTopGold:SetPoint("TOP"..pos, unit, "TOP"..pos, invert*size/5, size/7)
      unit.dragonTopGold:SetParent(unit.hp.bar)
    end

    if not unit.dragonBottomGold then
      unit.dragonBottomGold = unit:CreateTexture(nil, "OVERLAY")
      unit.dragonBottomGold:SetWidth(size)
      unit.dragonBottomGold:SetHeight(size)
      unit.dragonBottomGold:SetTexture(addonpath.."\\BOTTOM_GOLD_"..pos)
      unit.dragonBottomGold:SetPoint("BOTTOM"..pos, unit, "BOTTOM"..pos, invert*size/5.2, -size/2.98)
      unit.dragonBottomGold:SetParent(unit.hp.bar)
    end
	
	if not unit.dragonTopGray then
      unit.dragonTopGray = unit:CreateTexture(nil, "OVERLAY")
      unit.dragonTopGray:SetWidth(size)
      unit.dragonTopGray:SetHeight(size)
      unit.dragonTopGray:SetTexture(addonpath.."\\TOP_GRAY_"..pos)
      unit.dragonTopGray:SetPoint("TOP"..pos, unit, "TOP"..pos, invert*size/5, size/7)
      unit.dragonTopGray:SetParent(unit.hp.bar)
    end

    if not unit.dragonBottomGray then
      unit.dragonBottomGray = unit:CreateTexture(nil, "OVERLAY")
      unit.dragonBottomGray:SetWidth(size)
      unit.dragonBottomGray:SetHeight(size)
      unit.dragonBottomGray:SetTexture(addonpath.."\\BOTTOM_GRAY_"..pos)
      unit.dragonBottomGray:SetPoint("BOTTOM"..pos, unit, "BOTTOM"..pos, invert*size/5.2, -size/2.98)
      unit.dragonBottomGray:SetParent(unit.hp.bar)
    end

    if elite == "worldboss" then
	  unit.dragonTopGray:Hide()
      unit.dragonBottomGray:Hide()
      unit.dragonTopGold:Show()
      unit.dragonTopGold:SetVertexColor(.85,.15,.15,1)
      unit.dragonBottomGold:Show()
      unit.dragonBottomGold:SetVertexColor(.85,.15,.15,1)
    elseif elite == "rareelite" then
	  unit.dragonTopGray:Hide()
      unit.dragonBottomGray:Hide()
      unit.dragonTopGold:Show()
      unit.dragonTopGold:SetVertexColor(1,1,1,1)
      unit.dragonBottomGold:Show()
      unit.dragonBottomGold:SetVertexColor(1,1,1,1)
    elseif elite == "elite" then
	  unit.dragonTopGray:Hide()
      unit.dragonBottomGray:Hide()
      unit.dragonTopGold:Show()
      unit.dragonTopGold:SetVertexColor(.75,.6,0,1)
      unit.dragonBottomGold:Show()
      unit.dragonBottomGold:SetVertexColor(.75,.6,0,1)
    elseif elite == "rare" then
	  unit.dragonTopGold:Hide()
      unit.dragonBottomGold:Hide()
      unit.dragonTopGray:Show()
      unit.dragonTopGray:SetVertexColor(.8,.8,.8,1)
      unit.dragonBottomGray:Show()
      unit.dragonBottomGray:SetVertexColor(.8,.8,.8,1)
    else
      unit.dragonTopGold:Hide()
      unit.dragonBottomGold:Hide()
	  unit.dragonTopGray:Hide()
      unit.dragonBottomGray:Hide()
    end

    HookRefreshUnit(this, unit, component)
  end
end)
