local Skadaskin = true

if Skadaskin then

	if IsAddOnLoaded("Skada") then

		local Skada = Skada
		local barSpacing = 0
		local borderWidth = 4

		local barmod = Skada.displays["bar"]

		-- Used to strip unecessary options from the in-game config
		local function StripOptions(options)
			options.baroptions.args.barspacing = nil
			options.titleoptions.args.texture = nil
			options.titleoptions.args.bordertexture = nil
			options.titleoptions.args.thickness = nil
			options.titleoptions.args.margin = nil
			options.titleoptions.args.color = nil
			options.windowoptions = nil
			options.baroptions.args.barfont = nil
			options.titleoptions.args.font = nil
		end

		local barmod = Skada.displays["bar"]
		barmod.AddDisplayOptions_ = barmod.AddDisplayOptions
		barmod.AddDisplayOptions = function(self, win, options)
			self:AddDisplayOptions_(win, options)
			StripOptions(options)
		end

		for k, options in pairs(Skada.options.args.windows.args) do
			if options.type == "group" then
				StripOptions(options.args)
			end
		end

		local titleBG = {
			bgFile = "Interface\\Buttons\\WHITE8x8",
			tile = false,
			tileSize = 0
		}

		barmod.ApplySettings_ = barmod.ApplySettings
		barmod.ApplySettings = function(self, win)
			barmod.ApplySettings_(self, win)
	
			local skada = win.bargroup

			if win.db.enabletitle then
				skada.button:SetBackdrop(titleBG)
			end

			skada:SetTexture("Interface\\AddOns\\addonskin\\media\\Minimalist")
			skada:SetSpacing(barSpacing)
			skada:SetFont(GameTooltipText:GetFont(), 14)
			skada:SetFrameLevel(5)
	
			local titlefont = CreateFont("TitleFont"..win.db.name)
			titlefont:SetFont(GameTooltipText:GetFont(), 14, "OUTLINE")
			win.bargroup.button:SetNormalFontObject(titlefont)

			local color = win.db.title.color
			win.bargroup.button:SetBackdropColor(1,1,1,0)

			skada:SetBackdrop(nil)

			win.bargroup.button:SetFrameStrata("MEDIUM")
			win.bargroup.button:SetFrameLevel(5)	
			win.bargroup:SetFrameStrata("MEDIUM")
	
		end

		local function EmbedWindow(window, width, barheight, height, point, relativeFrame, relativePoint, ofsx, ofsy)
			window.db.barwidth = width
			window.db.barheight = barheight
			if window.db.enabletitle then 
				height = height - barheight
			end
			window.db.background.height = height
			window.db.spark = false
			window.db.barslocked = true
			window.bargroup:ClearAllPoints()
			window.bargroup:SetPoint(point, relativeFrame, relativePoint, ofsx, ofsy)
	
			barmod.ApplySettings(barmod, window)
		end

		local windows = {}
		function EmbedSkada()
			if #windows == 1 then
				EmbedWindow(windows[1], 322, 15, 108, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -9, 26)
			elseif #windows == 2 then
				EmbedWindow(windows[1], 322, 15, 108,  "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -9, 26)
				EmbedWindow(windows[2], 322, 15, 108,  "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -340, 26)
			end
		end

		-- Update pre-existing displays
		for _, window in ipairs(Skada:GetWindows()) do
			window:UpdateDisplay()
		end


		Skada.CreateWindow_ = Skada.CreateWindow
		function Skada:CreateWindow(name, db)
			Skada:CreateWindow_(name, db)
		
			windows = {}
			for _, window in ipairs(Skada:GetWindows()) do
				tinsert(windows, window)
			end	
	
			EmbedSkada()
		end

		Skada.DeleteWindow_ = Skada.DeleteWindow
		function Skada:DeleteWindow(name)
			Skada:DeleteWindow_(name)
		
			windows = {}
			for _, window in ipairs(Skada:GetWindows()) do
				tinsert(windows, window)
			end	
		
			EmbedSkada()
		end

		local Skada_Skin = CreateFrame("Frame")
		Skada_Skin:RegisterEvent("PLAYER_ENTERING_WORLD")
		Skada_Skin:SetScript("OnEvent", function(self)
			self:UnregisterAllEvents()
			self = nil
		
			EmbedSkada()
		end)

		if ChatRBGTab then
			local button = CreateFrame('Button', 'SkadaToggleSwitch', ChatRBGTab)
			button:Width(90)
			button:Height(ChatRBGTab:GetHeight() - 4)
			button:Point("RIGHT", ChatRBGTab, "RIGHT", -2, 0)
		
			button.tex = button:CreateTexture(nil, 'OVERLAY')
			button.tex:SetTexture([[Interface\Buttons\WHITE8x8]])
			button.tex:Point('TOPRIGHT', -2, -2)
			button.tex:Height(button:GetHeight() - 4)
			button.tex:Width(16)
		
			button:FontString(nil, GameTooltipText:GetFont(), 12, 'OUTLINE')
			button.text:SetPoint('RIGHT', button.tex, 'LEFT')
			button.text:SetTextColor(0.3,0.1,0.1,1)
		
			button:SetScript('OnEnter', function(self) button.text:SetText(L.addons_toggle..' Skada') end)
			button:SetScript('OnLeave', function(self) self.tex:Point('TOPRIGHT', -2, -2); button.text:SetText(nil) end)
			button:SetScript('OnMouseDown', function(self) self.tex:Point('TOPRIGHT', -4, -4) end)
			button:SetScript('OnMouseUp', function(self) self.tex:Point('TOPRIGHT', -2, -2) end)
			button:SetScript('OnClick', function(self) Skada:ToggleWindow() end)
		end	
	end
end