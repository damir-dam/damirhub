local createModeratorLookup = (function()
-- Bounded, shared membership lookup for startup and player lifecycle notices.
return function(groupService, knownIds, targetGroups, notify, isActive, clock, scheduler)
 local cache, pending, queue = {}, {}, {}
 local first, last, workers = 1, 0, 0
 local maxWorkers, cacheSeconds, maxCacheEntries = 4, 120, 256
 local cacheSize = 0
 local stats = { requests = 0, fallbackRequests = 0, cacheHits = 0, coalesced = 0, completed = 0, active = 0, peak = 0 }
 local targetSet = {}
 for _, groupId in ipairs(targetGroups) do targetSet[groupId] = true end

 local function remember(userId, member)
  if not cache[userId] then
   if cacheSize >= maxCacheEntries then
    local oldest, expiry
    for id, entry in pairs(cache) do
     if not expiry or entry.expires < expiry then oldest, expiry = id, entry.expires end
    end
    if oldest then cache[oldest] = nil; cacheSize -= 1 end
   end
   cacheSize += 1
  end
  cache[userId] = { member = member, expires = clock() + cacheSeconds }
 end

 local function lookup(player)
  stats.requests += 1
  local ok, groups = pcall(function() return groupService:GetGroupsAsync(player.UserId) end)
  if ok and type(groups) == "table" then
   local valid = true
   for _, group in ipairs(groups) do
    if type(group) ~= "table" or type(group.Id) ~= "number" then valid = false; break end
    if targetSet[group.Id] then return true, true end
   end
   if valid then return false, true end
  end
  -- Never cache a failed request as a successful negative membership result.
  local complete = true
  for _, groupId in ipairs(targetGroups) do
   if not isActive() then return false, false end
   stats.fallbackRequests += 1
   local worked, member = pcall(function()
    local method = player.IsInGroupAsync or player.IsInGroup
    return method(player, groupId)
   end)
   if worked and member then return true, true end
   if not worked then complete = false end
  end
  return false, complete
 end

 local function report(job, member)
  if member and isActive() then
   for _, notice in ipairs(job.notices) do notify(notice.prefix .. job.name, notice.duration) end
  end
 end

 local function pump()
  while workers < maxWorkers and first <= last and isActive() do
   workers += 1
   scheduler.spawn(function()
    while first <= last and isActive() do
     local index = first; first += 1
     local job = queue[index]; queue[index] = nil
     stats.active += 1; stats.peak = math.max(stats.peak, stats.active)
     local member, complete = lookup(job.player)
     stats.active -= 1; stats.completed += 1
     pending[job.userId] = nil
     if complete and isActive() then remember(job.userId, member) end
     report(job, member)
    end
    workers -= 1
    if workers == 0 and first > last then queue = {}; first, last = 1, 0 end
   end)
  end
 end

 local api = { stats = stats }
 function api.check(player, prefix, duration)
  if not isActive() then return end
  local userId = player.UserId
  local notice = { prefix = prefix, duration = duration }
  local job = { player = player, userId = userId, name = player.Name, notices = { notice } }
  if knownIds[userId] then report(job, true); return end
  local entry = cache[userId]
  if entry and entry.expires > clock() then stats.cacheHits += 1; report(job, entry.member); return end
  if pending[userId] then
   stats.coalesced += 1
   table.insert(pending[userId].notices, notice)
   return
  end
  pending[userId] = job; last += 1; queue[last] = job
  pump()
 end
 return api
end

end)()
local function __boohub_scalar_capture_cell(read,write)
 local frame=setmetatable({}, {
  __index=function(_,key)
   assert(key==1,"unexpected scalar capture read")
   return read()
  end,
  __newindex=function(_,key,value)
   assert(key==1,"unexpected scalar capture write")
   write(value)
  end,
 })
 return {[4]=1,[5]=frame}
end

-- Pure arithmetic remnants of removed LuaProt checks; no authentication or heartbeat.







local unpackCapturedArguments, appendCapturedArguments
unpackCapturedArguments = function(j,r)return unpack(r,1,r.n);end
appendCapturedArguments = function(j,r,p,...)local X=table.pack(...);table.move(X,1,X.n,p+1,r);end

-- Recovered Boo Hub main application; starts directly without a LuaProt loader.
-- Reconstructed names/capture structures remain; see the verification report for coverage.
return (function() local moderatorLookup; 
 
 
 
 
local instanceFactory, randomFactory 
 instanceFactory  = nil
		 instanceFactory  = Instance
		 randomFactory  = nil
		 randomFactory  = Random
		if not game:IsLoaded() then
			game.Loaded:Wait()
		end
		local library, coreGuiService, v6, v7 
		do
			local flag = getgenv().library ~= nil

if flag and getgenv().library and type(getgenv().library.Unload) == "function" then
    pcall(function()
        getgenv().library:Unload()
    end)
end
getgenv().library = nil
			 
			library = {
				loaded = false,
				tabs = {},
				flags = {},
				ConfigManager = {},
				Unloading = Instance.new("BindableEvent"),
				accent = Color3.new(0.60392159223556519, 0.28627452254295349, 0.87058824300765991),
				textcolor = Color3.new(0.72549021244049072, 0.72549021244049072, 0.72549021244049072),
				stroke = Color3.new(0.20784313976764679, 0.20784313976764679, 0.20784313976764679),
				stroke2 = Color3.new(0, 0, 0),
				buttoncolor = Color3.new(0.12941177189350128, 0.12941177189350128, 0.12941177189350128),
				contentcolor = Color3.new(0.070588238537311554, 0.070588238537311554, 0.070588238537311554),
				backgroundcolor = Color3.new(0.066666670143604279, 0.066666670143604279, 0.066666670143604279),
				misccolor = Color3.new(0.086274512112140656, 0.086274512112140656, 0.086274512112140656),
				font = nil,
				connections = {},
				flagchanged = {},
				notifications = {},
			}
			
			library.binds = {}
			library.objects = {}
			library.popupobjects = {}
			library.items = {}
			library.tables = {}
			library.colorindexes = {}
			library.accentSingles = {}
			
			library.mobileKeybindMode = false
			library.mobileKeybindsLocked = false
			library.mobileKeybindColor = Color3.new(0.086274512112140656, 0.086274512112140656, 0.086274512112140656)
			library.mobileKeybindSize = 40
			library.mobileKeybindButtons = {}
			library.mobileKeybindPositions = {}
			
			library.mobileKeybindCount = 0
			library.keybindListVisible = false
			coreGuiService = cloneref(game:GetService("CoreGui"))
			local v9 = cloneref
			local v10 = table.pack(game:GetService("TextService"))
			v6 = 0
			v7 = v9(table.unpack(v10, 1, v10.n))
		end
		local userInputService
		userInputService = cloneref(game:GetService("UserInputService"))
		local httpService
		httpService = cloneref(game:GetService("HttpService"))
		local runService
		runService = cloneref(game:GetService("RunService"))
		local tweenService
		tweenService = cloneref(game:GetService("TweenService"))
		cloneref(game:GetService("Stats"))
		local mouse
		mouse = cloneref(game:GetService("Players")).LocalPlayer:GetMouse()
		if not isfolder("Boo") then
			makefolder("Boo")
		end
		if not isfolder("Boo/fonts") then
			makefolder("Boo/fonts")
		end
		if not isfile("Boo/fonts/main.ttf") then
			writefile("Boo/fonts/main.ttf", game:HttpGet("https://github.com/zachtheguerro/ui/raw/refs/heads/main/fs-tahoma-8px.ttf"))
		end
		repeat
			task.wait()
		until isfile("Boo/fonts/main.ttf")
		local n5, tbl, v13, n7, v14 
		do
			local tbl2 = { name = "SmallestPixel7" }
			local faces = {}
			local tbl3 = {}
			
			
			tbl3.name = "Regular"
			tbl3.weight = 400
			tbl3.style = "normal"
			tbl3.assetId = getcustomasset("Boo/fonts/main.ttf")
			faces[1] = tbl3
			tbl2.faces = faces
			if not isfile("Boo/fonts/main_encoded.json") then
				v6 *= 2346859449
				writefile("Boo/fonts/main_encoded.json", httpService:JSONEncode(tbl2))
			end
			repeat
				task.wait()
			until isfile("Boo/fonts/main_encoded.json")
			loadcustomfont = function()
				
				task.wait(0.5)
				for i = 1, 20 do
					local ok, font = pcall(function()
						
						return Font.new(getcustomasset("Boo/fonts/main_encoded.json"), Enum.FontWeight.Regular)
					end)
					if ok and font then
						if pcall(function()
							
							local getTextBoundsParams = Instance.new("GetTextBoundsParams")
							getTextBoundsParams.Text = "Test"
							getTextBoundsParams.Size = 12
							getTextBoundsParams.Font = font
							getTextBoundsParams.Width = 500
							v7:GetTextBoundsAsync(getTextBoundsParams)
						end) then
							return font
						end
					end
					task.wait(0.25)
				end
				return Font.fromEnum(Enum.Font.SourceSans)
			end
			library.font = loadcustomfont()
			library.flagchanged.__index = library.flagchanged
			library.ConfigManager.Items = {}
			library.ConfigManager.Folder = ""
			library.ConfigManager.MigrateConfigs = function(arg2)
				
				
				arg2:MakeFolder(arg2.Folder)
				arg2:MakeFolder(arg2.GameFolder .. "/autoload")
				local v17 = listfiles(arg2.Folder)
				for _, v18 in ipairs(v17) do
					if isfolder(v18) then
						local match = v18:match("([^/\\]+)$")
						if match and tonumber(match) then
							local str = arg2.GameFolder .. "/autoload/" .. match
							arg2:MakeFolder(str)
							for _, v19 in ipairs(listfiles(v18)) do
								local match2 = v19:match("([^/\\]+)$")
								if match2 then
									if match2 == "autoload.txt" then
										local str2 = str .. "/autoload.txt"
										local v20 = readfile(v19)
										writefile(str2, v20)
										if isfile(str2) and delfile then
											delfile(v19)
										end
									else
										if match2:match("%.lua$") or match2:match("%.json$") then
											local str2 = arg2.Folder .. "/" .. match2
											if isfile(str2) then
												str2 = arg2.Folder .. "/" .. match .. "_" .. match2
											end
											local v20 = readfile(v19)
											writefile(str2, v20)
											local v21 = isfile(str2)
											if v21 and delfile then
												delfile(v19)
											end
										end
									end
								end
							end
							if #listfiles(v18) == 0 then
								local v19 = delfolder
								local v20 = pcall
								local n8 = 283259137
								local function fn()
									
									local v21 = n8
									local n9
									if v21 % 4294967296 ~= v21 % 4294967296 then
										n9 = 0
									else
										n9 = v21 % 4294967296 - v21 % 4294967296 % 1
									end
									if bit32.bxor(bit32.bxor(n9, 0), 413519003) ~= 263314271 then
										local v22 = n8
										local n10
										if v22 % 4294967296 ~= v22 % 4294967296 then
											n10 = 0
										else
											n10 = v22 % 4294967296 - v22 % 4294967296 % 1
										end
										n8 = bit32.bxor(n10, 3725748825)
									end
									v19(v18)
								end
								
								n8 = 387192772
								v20(fn)
							end
						end
					end
				end
			end
			local function makeFolder(arg2, arg3)
				
				local str = ""
				for match in string.gmatch(arg3, "[^/]+") do
					str = str == "" and match or str .. "/" .. match
					if not isfolder(str) then
						makefolder(str)
					end
				end
				return true
			end
			library.ConfigManager.MakeFolder = makeFolder
			library.ConfigManager.SetFolder = function(arg2, gameFolder)
				
				arg2.GameFolder = gameFolder
				arg2.Folder = gameFolder .. "/configs"
				arg2.AutoloadFolder = gameFolder .. "/autoload/" .. tostring(cloneref(game:GetService("Players")).LocalPlayer.UserId)
				arg2.AutoloadFile = arg2.AutoloadFolder .. "/autoload.txt"
				arg2:MigrateConfigs()
			end
			
			library.ConfigManager.Register = function(arg2, arg3, arg4)
				
				if not arg3 or arg3 == "" then
					return
				end
				arg2.Items[arg3] = arg4
			end
			local function serializeValue(arg2, arg3)
				
				
				
				if arg3.type == "toggle" then
					local tbl4 = { type = "toggle", value = arg3.value }
					if arg3.Keybind then
						
						local keybind = {
							flag = arg3.Keybind.cfg.flag,
							default = arg3.Keybind.key and tostring(arg3.Keybind.key) or nil,
							mode = arg3.Keybind.mode,
						}
						local sync = arg3.Keybind.sync
						
						keybind.state = sync == true and arg3.value or arg3.Keybind.value
						keybind.list = arg3.Keybind.list == true
						keybind.sync = arg3.Keybind.sync == true
						tbl4.keybind = keybind
						
						
					elseif arg3.DefaultKeybind or arg3.HadKeybind then
						tbl4.keybind = false
					end
					return tbl4
				end
				if arg3.type == "slider" then
					local tbl4 = {}
					
					tbl4.type = "slider"
					tbl4.value = arg3.value
					return tbl4
				end
				if arg3.type == "dropdown" then
					local tbl4 = { type = "dropdown" }
					
					tbl4.value = arg3.value
					return tbl4
				end
				if arg3.type == "textbox" then
					return { type = "textbox", value = arg3.value }
				end
				if arg3.type == "keybind" then
					local tbl4 = { type = "keybind", key = arg3.key and tostring(arg3.key) or nil }
					
					tbl4.mode = arg3.mode
					tbl4.state = arg3.value
					tbl4.list = arg3.list == true
					return tbl4
				end
				if arg3.type == "colorpicker" then
					local tbl4 = { type = "colorpicker" }
					local value = { r = math.floor(arg3.value.R * 255), g = math.floor(arg3.value.G * 255) }
					local floor = math.floor
					local b = arg3.value.B
					
					value.b = floor(b * 255)
					tbl4.value = value
					tbl4.alpha = arg3.Alpha or 0
					tbl4.rainbow = arg3.rainbow == true
					return tbl4
				end
				local flag = arg3.type == "position"
				if flag then
					
					flag = not userInputService.TouchEnabled
				end
				if flag then
					
					return { type = "position", x = arg3.object.Position.X.Offset, y = arg3.object.Position.Y.Offset }
				end
				if arg3.type == "mobilekeybindpositions" then
					local tbl4 = { type = "mobilekeybindpositions" }
					
					
					
					
					
					
					tbl4.positions = arg3.positions or {}
					return tbl4
				end
			end
			local configManager = library.ConfigManager
			
			
			
			
			
			
			
			
			configManager.SerializeValue = serializeValue
			library.ConfigManager.SerializeDefaultValue = function(arg2, arg3)
				local __boohub_spill_3_cell_4, __boohub_spill_3_cell_6  

				 
				 
				 
				 __boohub_spill_3_cell_4  = arg3.cfg or {}
				 
				 __boohub_spill_3_cell_6  = arg3.type == "toggle"
				 
				if  __boohub_spill_3_cell_6  then
					local state =  __boohub_spill_3_cell_4 .state
					if state == nil then
						state =  __boohub_spill_3_cell_4 .State
					end
					if state == nil then
						state =  __boohub_spill_3_cell_4 .default
					end
					if state == nil then
						state =  __boohub_spill_3_cell_4 .Default
					end
					local tbl4 = { type = "toggle", value = state == true }
					if arg3.DefaultKeybind or arg3.HadKeybind then
						tbl4.keybind = false
					end
					return tbl4
				end
				if arg3.type == "slider" then
					local default =  __boohub_spill_3_cell_4 .default
					if default == nil then
						default =  __boohub_spill_3_cell_4 .Default
					end
					if default == nil then
						default =  __boohub_spill_3_cell_4 .value
					end
					if default == nil then
						default =  __boohub_spill_3_cell_4 .Value
					end
					local tbl4 = {}
					
					
					
					
					
					
					
					tbl4.type = "slider"
					tbl4.value = default or 0
					return tbl4
				end
				if arg3.type ~= "dropdown" then
					if arg3.type == "textbox" then
						local default =  __boohub_spill_3_cell_4 .default
						if default == nil then
							default =  __boohub_spill_3_cell_4 .Default
						end
						if default == nil then
							default =  __boohub_spill_3_cell_4 .value
						end
						if default == nil then
							default =  __boohub_spill_3_cell_4 .Value
						end
						return { type = "textbox", value = default or "" }
					end
					if arg3.type == "keybind" then
						local default =  __boohub_spill_3_cell_4 .default
						if default == nil then
							default =  __boohub_spill_3_cell_4 .Default
						end
						local mode =  __boohub_spill_3_cell_4 .mode
						if mode == nil then
							mode =  __boohub_spill_3_cell_4 .Mode
						end
						local state =  __boohub_spill_3_cell_4 .state
						if state == nil then
							state =  __boohub_spill_3_cell_4 .State
						end
						local list =  __boohub_spill_3_cell_4 .list
						if list == nil then
							list =  __boohub_spill_3_cell_4 .List
							
						end
						return {
							type = "keybind",
							key = default and tostring(default) or nil,
							mode = mode or "Toggle",
							state = state == true,
							list = list == true,
						}
					end
					if arg3.type == "colorpicker" then
						local color =  __boohub_spill_3_cell_4 .color
						if color == nil then
							color =  __boohub_spill_3_cell_4 .Color
						end
						color = color or Color3.new(1, 1, 1)
						local alpha =  __boohub_spill_3_cell_4 .alpha
						
						
						if alpha == nil then
							alpha =  __boohub_spill_3_cell_4 .Alpha
						end
						local n11 = alpha or 0
						return {
							type = "colorpicker",
							value = {
								r = math.floor(color.R * 255),
								g = math.floor(color.G * 255),
								b = math.floor(color.B * 255),
							},
							alpha = n11,
							rainbow = false,
						}
					end
					if arg3.type == "position" and not userInputService.TouchEnabled then
						local tbl4 = { type = "position" }
						local defaultX = arg3.defaultX
						
						
						tbl4.x = defaultX or arg3.object.Position.X.Offset
						tbl4.y = arg3.defaultY or arg3.object.Position.Y.Offset
						return tbl4
					end
					if arg3.type == "mobilekeybindpositions" then
						
						return { type = "mobilekeybindpositions", positions = {} }
					end
					return
				end
 local default =  __boohub_spill_3_cell_4 .default
 if default == nil then default =  __boohub_spill_3_cell_4 .Default end
 if default == nil then default =  __boohub_spill_3_cell_4 .value end
 if default == nil then default =  __boohub_spill_3_cell_4 .Value end
 return {type="dropdown",value=default}
end
			local function save(arg2)
				
				local tbl4 = {}
				for k, item_ in pairs(arg2.Items) do
					tbl4[k] = arg2:SerializeValue(item_)
				end
				return tbl4
			end
			library.ConfigManager.Save = save
			local function saveDefaults(arg2)
				
				local tbl4 = {}
				for k, item_ in pairs(arg2.Items) do
					tbl4[k] = arg2:SerializeDefaultValue(item_)
				end
				return tbl4
			end
			library.ConfigManager.SaveDefaults = saveDefaults
			local function load(arg2, arg3)
				
				if type(arg3) ~= "table" then
					return false, "Config data is invalid"
				end
				local n8 = 0
				for k, v25 in pairs(arg3) do
					local v26 = arg2.Items[k]
					if v26 and v25 and v26.type == v25.type then
						local ok, result = pcall(function()
							
							
							
							
							if v25.type == "colorpicker" then
								if v25.value and v25.value.r and v25.value.g and v25.value.b then
									local color = Color3.fromRGB
									local r = v25.value.r
									
									local v28 = color(r, v25.value.g, v25.value.b)
									
									v26:set(v28, v25.alpha or 0)
									if v26.setrainbow then
										v26:setrainbow(v25.rainbow == true)
									end
									
									
								end
							elseif v25.type == "keybind" then
								local setbind = v26.setbind
								if setbind then
									local v27 = v25
									
									setbind = v27.key
									
								end
								if setbind then
									v26:setbind(v25.key)
								end
								if v26.setmode and v25.mode then
									v26:setmode(v25.mode)
								end
								if v26.set and type(v25.state) == "boolean" then
									v26:set(v25.state, true)
								end
								if v26.setlist then
									v26:setlist(v25.list == true)
								end
							else
								
								if v25.type == "toggle" then
									
									local keybind = type(v25.keybind) == "table" and v25.keybind or nil
									local flag = keybind and keybind.sync == true
									local keybind2 = v25.keybind
									
									if keybind2 == false then
										if v26.Keybind then
											
											v26.Keybind:Remove()
											local v28 = v26
											
											v28.Keybind = nil
											v26.KeybindConfig = nil
											
											
										end
									elseif keybind then
										if v26.keybind and not v26.Keybind then
											v26:keybind({
												flag = keybind.flag,
												default = keybind.default,
												mode = keybind.mode,
												state = flag and v25.value or keybind.state,
												list = keybind.list,
												sync = keybind.sync,
											})
										end
									end
									local set_ = v26.set
									if set_ then
										local v28 = type
										local v29 = v25
										
										set_ = v28(v29.value) == "boolean"
										
										
										
									end
									if set_ then
										v26:set(v25.value)
									end
									local keybind3
									if keybind then
										keybind3 = v26.Keybind
										
										
									else
										keybind3 = keybind
									end
									if keybind3 then
										if v26.Keybind.setbind and keybind.default then
											v26.Keybind:setbind(keybind.default)
										end
										if v26.Keybind.setmode and keybind.mode then
											v26.Keybind:setmode(keybind.mode)
										end
										if v26.Keybind.set then
											if flag then
												v26.Keybind:set(v26.value == true, true, true)
											elseif type(keybind.state) == "boolean" then
												v26.Keybind:set(keybind.state, true)
											end
										end
										if v26.Keybind.setlist then
											v26.Keybind:setlist(keybind.list == true)
										end
									end
									
								elseif v25.type == "slider" then
									local v27 = v26
									
									local set_ = v27.set
									if set_ then
										local v28 = type
										local v29 = v25
										
										local v31 = v28(v29.value)
										
										set_ = v31 == "number"
										
										
									end
									if set_ then
										v26:set(v25.value)
									end
									
								elseif v25.type == "textbox" then
									if v26.set and type(v25.value) == "string" then
										v26:set(v25.value)
									end
								else
									
									if v25.type == "dropdown" then
										if v26.set then
											v26:set(v25.value)
										end
									else
										if v25.type == "position" and not userInputService.TouchEnabled then
											local flag = v26.object and type(v25.x) == "number"
											if flag then
												flag = type(v25.y) == "number"
												
											end
											if flag then
												v26.object.Position = UDim2.fromOffset(v25.x, v25.y)
											end
										else
											local type_ = v25.type
											
											
											if type_ == "mobilekeybindpositions" then
												if type(v25.positions) == "table" then
													v26.positions = v25.positions
													
													if v26.apply then
														v26:apply(v25.positions)
													end
													
												end
											end
										end
									end
								end
								
							end
						end)
						if not ok then
							n8 += 1
							warn("Failed to load config flag '" .. tostring(k) .. "': " .. tostring(result))
						end
					end
				end
				if n8 > 0 then
					while not n8 do
					end
					return true, tostring(n8) .. " config item(s) failed to load"
				end
				return true
			end
			library.ConfigManager.Load = load
			library.ConfigManager.EnsureFolder = function(arg2)
				
				local v25, v26 = arg2:MakeFolder(arg2.Folder)
				if not v25 then
					return false, v26
				end
				local v27, v28 = arg2:MakeFolder(arg2.AutoloadFolder)
				if not v27 then
					return false, v28
				end
				return true
			end
			local function getPath(arg2, arg3)
				
				return string.format("%s/%s.json", arg2.Folder, arg3)
			end
			
			library.ConfigManager.GetPath = getPath
			library.ConfigManager.RefreshConfigList = function(arg2)
				
				local v25, v26 = arg2:EnsureFolder()
				if not v25 then
					warn(v26)
					return {}
				end
				local v27 = listfiles(arg2.Folder)
				local tbl4 = {}
				for _, v28 in ipairs(v27) do
					local match = v28:match("([^/\\]+)%.json$")
					if match then
						table.insert(tbl4, match)
					end
				end
				table.sort(tbl4)
				return tbl4
			end
			
			local function createConfig(arg2, arg3)
				
				local v26, v27 = arg2:EnsureFolder()
				if not v26 then
					return false, v27
				end
				if not arg3 or arg3 == "" then
					return false, "No config name provided"
				end
				local path = arg2:GetPath(arg3)
				if isfile(path) then
					return false, "Config already exists"
				end
				local v28 = arg2:SaveDefaults()
				writefile(path, httpService:JSONEncode(v28))
				return true
			end
			library.ConfigManager.CreateConfig = createConfig
			library.ConfigManager.SaveConfig = function(arg2, arg3)
				
				local v26, v27 = arg2:EnsureFolder()
				if not v26 then
					return false, v27
				end
				if not arg3 or arg3 == "" then
					return false, "No config name provided"
				end
				local path = arg2:GetPath(arg3)
				local v28 = arg2:Save()
				writefile(path, httpService:JSONEncode(v28))
				return true
			end
			library.ConfigManager.LoadConfig = function(arg2, arg3)
				
				if not arg3 or arg3 == "" then
					return false, "No config name provided"
				end
				local path = arg2:GetPath(arg3)
				if not isfile(path) then
					return false, "Config does not exist"
				end
				local v26 = readfile(path)
				local ok, result = pcall(function()
					
					return httpService:JSONDecode(v26)
				end)
				if not ok then
					return false, "Config JSON is invalid"
				end
				return arg2:Load(result)
			end
			local function deleteConfig(arg2, arg3)
				
				if not arg3 or arg3 == "" then
					return false, "No config name provided"
				end
				local path = arg2:GetPath(arg3)
				if not isfile(path) then
					return false, "Config does not exist"
				end
				delfile(path)
				return true
			end
			library.ConfigManager.DeleteConfig = deleteConfig
			library.ConfigManager.GetAutoloadPath = function(arg2)
				
				return arg2.AutoloadFile
			end
			library.ConfigManager.SetAutoload = function(arg2, arg3)
				
				local v26, v27 = arg2:EnsureFolder()
				if not v26 then
					return false, v27
				end
				if not arg3 or arg3 == "" then
					return false, "No config name provided"
				end
				local v28 = tostring
				writefile(arg2:GetAutoloadPath(), v28(arg3))
				return true
			end
			library.ConfigManager.GetAutoload = function(arg2)
				
				local v26, v27 = arg2:EnsureFolder()
				if not v26 then
					return nil, v27
				end
				local autoloadPath = arg2:GetAutoloadPath()
				if not isfile(autoloadPath) then
					return nil
				end
				local v28 = readfile(autoloadPath)
				if not v28 or v28 == "" then
					return nil
				end
				return v28
			end
			library.ConfigManager:SetFolder("Boo/games/" .. game.PlaceId)
			local tbl4 = {}
			local n8 = v6 - 468744256
			local n9 = n8 % 4294967296 - n8 % 4294967296 % 1
			tbl4[1] = "AccentProps"
			tbl4[2] = "StrokeProps"
			tbl4[3] = "StrokeProps2"
			tbl4[4] = "Buttons"
			tbl4[5] = "ContentProps"
			tbl4[6] = "BackgroundProps"
			tbl4[7] = "SectionProps"
			tbl4[8] = "TextProps"
			tbl4[9] = "MiscProps"
			for _, v26 in ipairs(tbl4) do
				library.colorindexes[v26] = {}
			end
			library.indexColorProps = function(arg2, arg3, arg4, arg5)
				
				local v26 = arg2.colorindexes[arg4]
				if not v26 then
					return
				end
				v26[arg3] = nil
				if type(arg5) ~= "string" or arg5 == "" then
					return
				end
				local tbl5 = {}
				for match in string.gmatch(arg5, "[^,]+") do
					tbl5[match] = true
				end
				if next(tbl5) then
					v26[arg3] = tbl5
				end
			end
			library.indexAccentSingle = function(arg2, arg3)
				
				local attribute = arg3:GetAttribute("IsAccent")
				arg2.accentSingles[arg3] = type(attribute) == "string" and attribute ~= "" and attribute or nil
			end
			library.indexObjectColors = function(arg2, arg3)
				
				for _, v26 in ipairs(tbl4) do
					arg2:indexColorProps(arg3, v26, arg3:GetAttribute(v26))
				end
				arg2:indexAccentSingle(arg3)
			end
			library.indexPopupObject = function(arg2, arg3)
				
				if arg3:GetAttribute("IsPopup") == true or arg3:GetAttribute("DropdownMenu") == true then
					arg2.popupobjects[arg3] = arg3
				else
					arg2.popupobjects[arg3] = nil
				end
			end
			library.hidepopups = function(arg2, arg3, arg4)
				
				for k in pairs(arg2.popupobjects) do
					if not k or not k.Parent then
						arg2.popupobjects[k] = nil
					elseif k ~= arg3 then
						local flag = k:GetAttribute("IsPopup") == true
						local flag2 = k:GetAttribute("DropdownMenu") == true
						local flag3 = not arg4
						if flag3 or arg4 == "popup" and flag or arg4 == "dropdown" and flag2 then
							k.Visible = false
						end
					end
				end
			end
			local function create(arg2, arg3, arg4)
				
				
				
				local n12 = 38629617
				local instance = Instance.new(arg3)
				local tbl5 = typeof(arg4) == "table" and arg4 or {}
				local tbl6 = {}
				local tbl7 = {}
				local tbl8 = {}
				local tbl9 = {}
				local tbl10 = {}
				local tbl11 = {}
				local tbl12 = {}
				local tbl13 = {}
				local tbl14 = {}
				for k, v26 in next, tbl5, nil do
					if v26 == library.accent then
						table.insert(tbl6, k)
					end
					if v26 == library.stroke then
						table.insert(tbl7, k)
					end
					if v26 == library.stroke2 then
						table.insert(tbl8, k)
					end
					if v26 == library.buttoncolor then
						table.insert(tbl9, k)
					end
					if v26 == library.contentcolor then
						table.insert(tbl10, k)
					end
					if v26 == library.backgroundcolor then
						table.insert(tbl11, k)
					end
					if v26 == library.sectioncolor then
						table.insert(tbl12, k)
					end
					local n13 = n12 + 3303448825 - 0
					local n14 = n13 % 4294967296 - n13 % 4294967296 % 1
					if v26 == library.textcolor then
						table.insert(tbl13, k)
					end
					if v26 == library.misccolor then
						table.insert(tbl14, k)
					end
					instance[k] = v26
					local n15 = n14 % 4294967296 - n14 % 4294967296 % 1 + 991518471
					n12 = n15 % 4294967296 - n15 % 4294967296 % 1
				end
				
				if #tbl6 > 0 then
					instance:SetAttribute("AccentProps", table.concat(tbl6, ","))
				end
				if #tbl7 > 0 then
					instance:SetAttribute("StrokeProps", table.concat(tbl7, ","))
				end
				if #tbl8 > 0 then
					instance:SetAttribute("StrokeProps2", table.concat(tbl8, ","))
				end
				if #tbl9 > 0 then
					instance:SetAttribute("Buttons", table.concat(tbl9, ","))
				end
				if #tbl10 > 0 then
					instance:SetAttribute("ContentProps", table.concat(tbl10, ","))
				end
				if #tbl11 > 0 then
					instance:SetAttribute("BackgroundProps", table.concat(tbl11, ","))
				end
				if #tbl12 > 0 then
					instance:SetAttribute("SectionProps", table.concat(tbl12, ","))
				end
				if #tbl13 > 0 then
					instance:SetAttribute("TextProps", table.concat(tbl13, ","))
				end
				if #tbl14 > 0 then
					instance:SetAttribute("MiscProps", table.concat(tbl14, ","))
				end
				library:indexObjectColors(instance)
				local n14 = 33091489
				local function fn()
					
					local n15 = bit32.bxor(n14 % 4294967296 - n14 % 4294967296 % 1, 0) + 127100083
					library:indexColorProps(instance, "AccentProps", instance:GetAttribute("AccentProps"))
				end
				n14 = 375758629
				library:connect(instance:GetAttributeChangedSignal("AccentProps"), fn)
				local v26 = library
				local connect = v26.connect
				local attributeChangedSignal = instance:GetAttributeChangedSignal("TextProps")
				local n15 = 177508994
				local function fn2()
					
					local flag = bit32.bxor(bit32.bxor(n15 % 4294967296 - n15 % 4294967296 % 1, 0), 129707495) == 99875363
					library:indexColorProps(instance, "TextProps", instance:GetAttribute("TextProps"))
				end
				
				n15 = 388252624
				connect(v26, attributeChangedSignal, fn2)
				local function fn3()
					
					library:indexAccentSingle(instance)
				end
				library:connect(instance:GetAttributeChangedSignal("IsAccent"), fn3)
				local v27 = library
				local connect2 = v27.connect
				local attributeChangedSignal2 = instance:GetAttributeChangedSignal("IsPopup")
				local n17 = 23453238
				local function fn4()
					
					local flag = bit32.bxor(n17 % 4294967296 - n17 % 4294967296 % 1, 0) ~= 230652921
					library:indexPopupObject(instance)
				end
				
				n17 = 230652921
				connect2(v27, attributeChangedSignal2, fn4)
				local n19 = n12 + 3704714601 - 0
				local n20 = n19 % 4294967296 - n19 % 4294967296 % 1
				local function fn5()
					
					library:indexPopupObject(instance)
				end
				library:connect(instance:GetAttributeChangedSignal("DropdownMenu"), fn5)
				local v28 = nil
				local v29 = pcall
				local n21 = 216320322
				local function fn6()
					
					local destroying = instance.Destroying
					local v30 = n21
					local n22
					if v30 % 4294967296 ~= v30 % 4294967296 then
						n22 = 0
					else
						n22 = v30 % 4294967296 - v30 % 4294967296 % 1
					end
					if bit32.bxor(bit32.bxor(n22, 0), 16535578) ~= 7812084 then
						local v31 = n21
						local n23
						if v31 % 4294967296 ~= v31 % 4294967296 then
							n23 = 0
						else
							n23 = v31 % 4294967296 - v31 % 4294967296 % 1
						end
						n21 = bit32.bxor(n23, 3788518553)
					end
					v28 = destroying
				end
				local v30 = bit32.bxor(n20, 3547417846)
				n21 = bit32.bxor(n21 % 4294967296 - n21 % 4294967296 % 1, v30)
				v29(fn6)
				if v28 then
					
					library:connect(v28, function()
						
						library.popupobjects[instance] = nil
					end)
				end
				library:indexPopupObject(instance)
				library.objects[instance] = instance
				return instance
			end
			library.Create = create
			library.setaccentstate = function(arg2, arg3, arg4, arg5)
				
				arg3:SetAttribute("Accent_" .. arg4, arg5)
			end
			library.Unload = function(arg2)
				
				
				for k in pairs(arg2.flags) do
					arg2.flags[k] = false
				end
				for _, connection in ipairs(arg2.connections) do
					if connection and connection.Disconnect then
						connection:Disconnect()
					end
				end
				table.clear(arg2.connections)
				for k in pairs(arg2.objects) do
					if k and k.Destroy then
						k:Destroy()
					end
				end
				table.clear(arg2.objects)
				table.clear(arg2.popupobjects)
				
				
				table.clear(arg2.accentSingles)
				for _, colorindexe in pairs(arg2.colorindexes) do
					table.clear(colorindexe)
				end
				table.clear(arg2.tabs)
				if arg2.frame and arg2.frame.Destroy then
					arg2.frame:Destroy()
					arg2.frame = nil
				end
				library.Unloading:Fire()
				
				getgenv().library = nil
			end
			library.flagchanged.new = function()
				
				return setmetatable({ callbacks = {} }, library.flagchanged)
			end
			library.flagchanged.Connect = function(arg2, arg3)
				
				table.insert(arg2.callbacks, arg3)
				return { Disconnect = function()
					
					local v26 = table.find(arg2.callbacks, arg3)
					if v26 then
						table.remove(arg2.callbacks, v26)
					end
				end }
			end
			
			library.onflagchanged = function(arg2, arg3)
				
				arg2.flagchanged[arg3] = arg2.flagchanged[arg3] or arg2.flagchanged.new()
				return arg2.flagchanged[arg3]
			end
			library.flagchanged.Fire = function(arg2, ...)
				
				local v27 = table.pack(...)
				local v28, v29, v30 = ipairs(arg2.callbacks)
				local v31 = (function(...) local __lph_iterator=coroutine.wrap(function(j,r,p,X)local Y= coroutine.yield ;Y();for j,V in r,p,X do Y(true,j,V);end;end);__lph_iterator(...);return __lph_iterator end)(nil, v28, v29, v30)
				local v32 = table.pack(v31())
				if v32[1] then
					task.spawn(v32[3], ...)
					while true do
						local v33 = table.pack(v31())
						if v33[1] then
							task.spawn(v33[3], table.unpack(v27, 1, v27.n))
						else
							break
						end
					end
				end
			end
			library.setflag = function(arg2, arg3, arg4)
				
				local v27 = arg2.flags[arg3]
				arg2.flags[arg3] = arg4
				local flagchanged = arg2.flagchanged and arg2.flagchanged[arg3]
				if flagchanged and v27 ~= arg4 then
					flagchanged:Fire(arg4, v27)
				end
			end
			library.makedraggable = function(arg2, arg3, arg4)
				
				arg3.Active = true
				local flag = false
				local v27 = nil
				local v28 = nil
				local v29 = nil
				library:connect(arg3.InputBegan, function(j)local P=j.UserInputType==Enum.UserInputType.MouseButton1 or j.UserInputType==Enum.UserInputType.Touch;if P then local P,P,P,b= arg3 , arg3 ,Vector2.new(j.Position.X- arg3 .AbsolutePosition.X,j.Position.Y- arg3 .AbsolutePosition.Y).Y;local b= arg4 ;if P>(b or 40)then return;end; flag =true;local p,P=j.Position, arg3 ; v28 =p;local r,p=P.Position,j; v29 =r; v27 =p;j.Changed:Connect(function()local r=j.UserInputState==Enum.UserInputState.End;if r then  flag , v27 =false,nil;end;end);end;end)
				library:connect(arg3.InputChanged, function(j)local p=j.UserInputType==Enum.UserInputType.MouseMovement or j.UserInputType==Enum.UserInputType.Touch;if p then local p=j; v27 =p;end;end)
				library:connect(userInputService.InputChanged, function(j)local e= flag and j== v27 ;if e then local r,p=j.Position- v28 ;local j,p= arg3 ;j.Position=UDim2.new( v29 .X.Scale, v29 .X.Offset+r.X, v29 .Y.Scale, v29 .Y.Offset+r.Y);end;end)
			end
			library.connect = function(arg2, arg3, arg4)
				
				local connection = arg3:Connect(arg4)
				table.insert(library.connections, connection)
				return connection
			end
			local function disconnect(arg2, arg3)
				
				if not arg3 then
					return
				end
				local v27 = table.find(library.connections, arg3)
				arg3:Disconnect()
				if v27 then
					table.remove(library.connections, v27)
				end
			end
			
			library.disconnect = disconnect
			library.gettextbounds = function(arg2, arg3, font, size, arg4)
				
				local text = tostring(arg3 or "")
				size = size or 13
				arg4 = arg4 or Vector2.new(1920, 1080)
				if typeof(font) == "Font" then
					local getTextBoundsParams = Instance.new("GetTextBoundsParams")
					getTextBoundsParams.Text = text
					getTextBoundsParams.Size = size
					getTextBoundsParams.Font = font
					getTextBoundsParams.Width = arg4.X
					local textBoundsAsync = v7:GetTextBoundsAsync(getTextBoundsParams)
					return textBoundsAsync.X, textBoundsAsync.Y
				end
				local textSize = v7:GetTextSize(text, size, font or Enum.Font.SourceSans, arg4)
				return textSize.X, textSize.Y
			end
			n5 = 0
			library.nextflag = function()
				
				n5 += 1
				return string.format("%.14g", n5)
			end
			library.mouseffects = function(arg2, arg3, arg4)
				
				
				
				if not arg3 or not arg4 then
					return
				end
				local str
				if arg4:IsA("UIStroke") then
					str = "Color"
				else
					local isFrame = arg4:IsA("Frame") or arg4:IsA("TextButton") or arg4:IsA("TextLabel")
					str = nil
					if isFrame then
						str = "BackgroundColor3"
					end
				end
				if str then
					arg4:SetAttribute("IsAccent", str)
				else
					arg4:SetAttribute("IsAccent", nil)
				end
				arg4:SetAttribute("Selected", false)
				arg4:SetAttribute("Pressed", false)
				local n12 = 165965983
				local function fn(arg5)
					
					local accent = arg5 and library.accent or library.stroke
					local n13 = bit32.bxor(n12 % 4294967296 - n12 % 4294967296 % 1, 0) + 309265633
					if arg4:IsA("UIStroke") then
						arg4.Color = accent
					elseif arg4:IsA("Frame") or arg4:IsA("TextButton") or arg4:IsA("TextLabel") then
						arg4.BackgroundColor3 = accent
					end
				end
				n12 = 114579640
				local n13 = 154832945
				local function fn2()
					
					bit32.bxor(bit32.bxor(n13 % 4294967296 - n13 % 4294967296 % 1, 0), 46778481)
					arg4:SetAttribute("Selected", true)
					if not arg4:GetAttribute("Pressed") then
						fn(true)
					end
				end
				n13 = 405746113
				library:connect(arg3.MouseEnter, fn2)
				library:connect(arg3.MouseLeave, function()
					
					arg4:SetAttribute("Selected", false)
					arg4:SetAttribute("Pressed", false)
					fn(false)
				end)
				if arg3:IsA("TextBox") or arg3:IsA("Frame") or arg3:IsA("ImageLabel") then
					return
				end
				local v28 = library
				local connect = v28.connect
				local mouseButton1Down = arg3.MouseButton1Down
				local n14 = 167063864
				local function fn3()
					
					arg4:SetAttribute("Pressed", true)
					local flag = bit32.bxor(n14 % 4294967296 - n14 % 4294967296 % 1, 0) ~= 139206282
					fn(false)
				end
				
				n14 = 139206282
				connect(v28, mouseButton1Down, fn3)
				local n15 = 205276988
				local function fn4()
					
					arg4:SetAttribute("Pressed", false)
					local flag = bit32.bxor(bit32.bxor(n15 % 4294967296 - n15 % 4294967296 % 1, 0), 423925263) ~= 230605217
					fn(arg4:GetAttribute("Selected") == true)
				end
				n15 = 351950766
				library:connect(arg3.MouseButton1Up, fn4)
			end
			library.updateColorGroup = function(arg2, arg3)
				
				local value = arg3.value
				local store = arg3.store
				local propsAttribute = arg3.propsAttribute
				local disabledAttribute = arg3.disabledAttribute
				local accentMode = arg3.accentMode
				local function fn(arg4, arg5)
					
					if not arg5 or not arg5.Parent then
						return false
					end
					if disabledAttribute and arg5:GetAttribute(disabledAttribute) then
						return false
					end
					return true
				end
				local function fn2(arg4, arg5, arg6)
					
					local v28 = pcall
					local n10 = 325497235
					local function fn3()
						
						local v29 = arg5
						local v30 = arg6
						local v31 = value
						local n11 = bit32.bxor(n10 % 4294967296 - n10 % 4294967296 % 1, 0) + 221336254
						v29[v30] = v31
					end
					local v29 = bit32.bxor(arg4 % 4294967296 - arg4 % 4294967296 % 1, 344762021)
					n10 = bit32.bxor(325497235, v29 % 4294967296 - v29 % 4294967296 % 1)
					v28(fn3)
				end
				if store then
					library[store] = value
				end
				if accentMode then
					for k, accentSingle in pairs(library.accentSingles) do
						if fn(81063897, k) then
							local attribute = k:GetAttribute("Selected")
							local attribute2 = k:GetAttribute("Pressed")
							if (attribute == true or attribute == nil) and not attribute2 then
								fn2(224569939, k, accentSingle)
							end
						else
							library.accentSingles[k] = nil
						end
					end
					for k, accentProp in pairs(library.colorindexes.AccentProps) do
						if fn(81063897, k) then
							if not k:GetAttribute("Pressed") then
								for k2 in pairs(accentProp) do
									local attribute = k:GetAttribute("Accent_" .. k2)
									if attribute == true or attribute == nil then
										fn2(224569939, k, k2)
									end
								end
							end
						else
							library.colorindexes.AccentProps[k] = nil
						end
					end
					return
				end
				local v28 = library.colorindexes[propsAttribute]
				if not v28 then
					return
				end
				for k, v29 in pairs(v28) do
					if fn(81063897, k) then
						for k2 in pairs(v29) do
							fn2(224569939, k, k2)
						end
					else
						v28[k] = nil
					end
				end
			end
			tbl = { [Enum.KeyCode.LeftShift] = "LS" }
			local rightShift = Enum.KeyCode.RightShift
			local v28 = bit32.band(n9, 2523945968)
			tbl[rightShift] = "RS"
			tbl[Enum.KeyCode.LeftControl] = "LCtrl"
			tbl[Enum.KeyCode.RightControl] = "RCtrl"
			tbl[Enum.KeyCode.LeftAlt] = "LAlt"
			
			
			tbl[Enum.KeyCode.RightAlt] = "RAlt"
			tbl[Enum.KeyCode.CapsLock] = "CAPS"
			tbl[Enum.KeyCode.One] = "1"
			tbl[Enum.KeyCode.Two] = "2"
			tbl[Enum.KeyCode.Three] = "3"
			tbl[Enum.KeyCode.Four] = "4"
			local five = Enum.KeyCode.Five
			
			tbl[five] = "5"
			tbl[Enum.KeyCode.Six] = "6"
			tbl[Enum.KeyCode.Seven] = "7"
			tbl[Enum.KeyCode.Eight] = "8"
			tbl[Enum.KeyCode.Nine] = "9"
			tbl[Enum.KeyCode.Zero] = "0"
			tbl[Enum.KeyCode.KeypadOne] = "Num1"
			tbl[Enum.KeyCode.KeypadTwo] = "Num2"
			tbl[Enum.KeyCode.KeypadThree] = "Num3"
			local keypadFour = Enum.KeyCode.KeypadFour
			local n11 = v28 - 602963872 + 2926599184
			local n12 = n11 % 4294967296 - n11 % 4294967296 % 1
			tbl[keypadFour] = "Num4"
			tbl[Enum.KeyCode.KeypadFive] = "Num5"
			tbl[Enum.KeyCode.KeypadSix] = "Num6"
			tbl[Enum.KeyCode.KeypadSeven] = "Num7"
			tbl[Enum.KeyCode.KeypadEight] = "Num8"
			tbl[Enum.KeyCode.KeypadNine] = "Num9"
			tbl[Enum.KeyCode.KeypadZero] = "Num0"
			tbl[Enum.KeyCode.Minus] = "-"
			tbl[Enum.KeyCode.Equals] = "="
			tbl[Enum.KeyCode.Tilde] = "~"
			local leftBracket = Enum.KeyCode.LeftBracket
			local v30 = bit32.bxor(2926599184, n12 % 4294967296 - n12 % 4294967296 % 1)
			tbl[leftBracket] = "["
			tbl[Enum.KeyCode.RightBracket] = "]"
			tbl[Enum.KeyCode.RightParenthesis] = ")"
			tbl[Enum.KeyCode.LeftParenthesis] = "("
			tbl[Enum.KeyCode.Semicolon] = ","
			tbl[Enum.KeyCode.Quote] = "'"
			tbl[Enum.KeyCode.BackSlash] = "\\"
			local comma = Enum.KeyCode.Comma
			v13 = bit32.bxor(2792992341, n12)
			tbl[comma] = ","
			tbl[Enum.KeyCode.Period] = "."
			tbl[Enum.KeyCode.Slash] = "/"
			tbl[Enum.KeyCode.Asterisk] = "*"
			local plus = Enum.KeyCode.Plus
			n7 = n12 // bit32.bxor(v30 % 4294967296 - v30 % 4294967296 % 1, 0)
			tbl[plus] = "+"
			tbl[Enum.KeyCode.Period] = "."
			tbl[Enum.KeyCode.Backquote] = "`"
			local mouseButton1 = Enum.UserInputType.MouseButton1
			v14 = bit32.bxor(v30 % 4294967296 - v30 % 4294967296 % 1, 3079880652)
			tbl[mouseButton1] = "MB1"
		end
		tbl[Enum.UserInputType.MouseButton2] = "MB2"
		tbl[Enum.UserInputType.MouseButton3] = "MB3"
do
    local v15 = library
    local create = v15.Create
    local tbl2 = { Name = httpService:GenerateGUID(true) }
    
    -- БЕЗОПАСНОЕ ОПРЕДЕЛЕНИЕ РОДИТЕЛЯ
    local okHui, hui = pcall(gethui)
    local parentGui = nil
    if okHui and hui and typeof(hui) == "Instance" then
        if hui:IsA("BasePlayerGui") or hui:IsA("Folder") then
            parentGui = hui
        end
    end
    if not parentGui and coreGuiService then
        local ok, _ = pcall(function()
            local test = Instance.new("ScreenGui")
            test.Parent = coreGuiService
            test:Destroy()
        end)
        if ok then
            parentGui = coreGuiService
        end
    end
    if not parentGui then
        parentGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end
    
    tbl2.Parent = parentGui
    tbl2.DisplayOrder = 1
    tbl2.ResetOnSpawn = false
    library.ScreenGUI = create(v15, "ScreenGui", tbl2)
end
		NotiHolder = library:Create("Frame", {
			Parent = library.ScreenGUI,
			Position = UDim2.new(1, -5, 0, 0),
			AnchorPoint = Vector2.new(1, 0),
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 400, 1, 0),
			ClipsDescendants = false,
		})
		watermark = library:Create("Frame", {
			BackgroundColor3 = library.misccolor,
			BorderColor3 = library.accent,
			BorderSizePixel = 1,
			Position = UDim2.new(0.039999999105930328, 0, 0.019999999552965164, 0),
			Size = UDim2.new(0, 0, 0, 23),
			Visible = false,
			Parent = library.ScreenGUI,
			ZIndex = 50,
		})
		library:makedraggable(watermark)
		library.ConfigManager:Register("watermarkposition", { type = "position", object = watermark })
		local tween_ = library:Create("TextLabel", {
			FontFace = library.font,
			TextColor3 = library.textcolor,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Center,
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.new(0, 0, 0),
			AnchorPoint = Vector2.new(0.5, 0),
			BorderSizePixel = 0,
			Size = UDim2.new(0, 0, 0, 23),
			Visible = true,
			Parent = watermark,
			ZIndex = 50,
		})
		library:Create("UIStroke", {
			Color = library.stroke,
			Thickness = 1,
			Parent = watermark,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			LineJoinMode = Enum.LineJoinMode.Miter,
			ZIndex = 49,
		})
		library:Create("UIStroke", {
			Color = library.stroke2,
			Thickness = 2,
			Parent = watermark,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			LineJoinMode = Enum.LineJoinMode.Miter,
			ZIndex = 48,
		})
		library:Create("Frame", {
			Parent = watermark,
			BackgroundColor3 = library.accent,
			Size = UDim2.new(1, 0, 0, 2),
			Position = UDim2.new(0, 0, 0, 0),
			BorderSizePixel = 0,
			ZIndex = 50,
		})
		library:Create("Frame", {
			Parent = watermark,
			BackgroundColor3 = Color3.new(0.12941177189350128, 0.070588238537311554, 0.18823529779911041),
			BackgroundTransparency = 0.5,
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 0, 1),
			BorderSizePixel = 0,
			ZIndex = 50,
		})
		library.setwatermark = function(arg2, text)
			
			tween_.Text = text or "Watermark"
			local v15 = library:gettextbounds(text, library.font, 12)
			watermark.Size = UDim2.new(0, v15 + 15, 0, 23)
			tween_.Size = UDim2.new(0, v15, 0, 23)
			tween_.Position = UDim2.new(0.5, 0, 0, 0)
		end
		library:setwatermark()
		local n8
		do
			local tween_2 = library:Create("Frame", {
				BackgroundColor3 = library.misccolor,
				BorderColor3 = Color3.new(0.11764705926179886, 0.11764705926179886, 0.11764705926179886),
				BorderSizePixel = 1,
				Position = UDim2.new(0, 20, 0.40000000596046448, 0),
				Size = UDim2.new(0, 5, 0, 14),
				Visible = false,
				ClipsDescendants = false,
				Parent = library.ScreenGUI,
				ZIndex = 100,
			})
			library:Create("UIStroke", {
				Color = library.stroke,
				Thickness = 1,
				Parent = tween_2,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				LineJoinMode = Enum.LineJoinMode.Miter,
				ZIndex = 99,
			})
			library:Create("UIStroke", {
				Color = library.stroke2,
				Thickness = 2,
				Parent = tween_2,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				LineJoinMode = Enum.LineJoinMode.Miter,
				ZIndex = 98,
			})
			local tween_3 = library:Create("TextLabel", {
				FontFace = library.font,
				TextColor3 = library.textcolor,
				TextSize = 12,
				Text = "",
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, 20),
				Position = UDim2.new(0, 2, 0, 0),
				Visible = true,
				Parent = tween_2,
				ZIndex = 100,
			})
			local n = n7 + 337466227
			library:connect(runService.RenderStepped, function()
				
				local mouseLocation = userInputService:GetMouseLocation()
				local guiInset = game:GetService("GuiService"):GetGuiInset()
				tween_2.Position = UDim2.fromOffset(mouseLocation.X - guiInset.X + 12, mouseLocation.Y - guiInset.Y + 12)
			end)
			local function tooltip(arg2, arg3, arg4)
				
				arg3:SetAttribute("Tooltip", arg4.tooltip or arg4.Tooltip or "")
			end
			n8 = n7 * 54117
			library.tooltip = tooltip
			local v15 = nil
			local function fn()
				
				v15 = nil
				tween_2.Visible = false
				tween_3.Text = ""
				tween_3.Size = UDim2.new(0, 10, 0, 16)
				tween_2.Size = UDim2.new(0, 10, 0, 16)
			end
			local function fn2(text)
				
				if not text or text == "" then
					fn()
					return
				end
				if v15 == text and tween_2.Visible then
					return
				end
				v15 = text
				local n9 = library:gettextbounds(text, library.font, 12) + 4
				tween_3.Text = text
				local v16 = tween_2
				v16.Size = UDim2.new(0, n9, 0, 16)
				tween_3.Size = UDim2.new(0, n9, 0, 16)
				tween_2.Visible = true
			end
			local now = tick()
			local connect = library.connect
			local renderStepped = runService.RenderStepped
			local n9 = n8 + 529463058
			local function fn3()
				
				if tick() - now < 0.05 then
					return
				end
				local mouseLocation = userInputService:GetMouseLocation()
				local guiObjectsAtPosition = library.ScreenGUI:GetGuiObjectsAtPosition(mouseLocation.X, mouseLocation.Y)
				now = tick()
				local v16, v17, v18 = ipairs(guiObjectsAtPosition)
				local v19 = n9
				local n10
				if v19 % 4294967296 ~= v19 % 4294967296 then
					n10 = 0
				else
					n10 = v19 % 4294967296 - v19 % 4294967296 % 1
				end
				if bit32.bxor(n10, 0) == 194504103 then
					local v20 = n9
					local n11
					if v20 % 4294967296 ~= v20 % 4294967296 then
						n11 = 0
					else
						n11 = v20 % 4294967296 - v20 % 4294967296 % 1
					end
					n9 = bit32.bxor(n11, 2371895579)
				end
				local v20 = nil
				local flag = false
				local exitTo = nil
				local flag2
				for _, v21 in v16, v17, v18 do
					while true do
						local flag3 = v21 and v21 ~= library.ScreenGUI.Parent
						flag2 = false
						if flag3 then
							local flag4 = v21:GetAttribute("DropdownMenu") == true
							if flag4 or v21:GetAttribute("IsPopup") == true then
								local attribute = v21:GetAttribute("Tooltip")
								local flag5 = attribute and attribute ~= ""
								
								flag2 = true
								if flag5 then
									flag2 = true
									v20 = attribute
								end
								break
							else
								local attribute = v21:GetAttribute("Tooltip")
								if attribute and attribute ~= "" then
									v20 = attribute
									break
								else
									v21 = v21.Parent
									continue
								end
							end
						end
						break
					end
					if flag2 then
						exitTo = 1
						break
					elseif v20 then
						exitTo = 2
						break
					end
				end
				if exitTo == 1 then
					flag = true
				elseif exitTo ~= 2 then
				end
				if flag and not v20 then
					fn()
				elseif v20 then
					fn2(v20)
				else
					fn()
				end
			end
			local v16 = bit32.bxor(v14, 328413647)
			n9 = bit32.bxor(n9 % 4294967296 - n9 % 4294967296 % 1, v16)
			connect(library, renderStepped, fn3)
		end
		KeybindContainer = library:Create("Frame", {
			BackgroundColor3 = library.misccolor,
			BorderColor3 = Color3.new(0.11764705926179886, 0.11764705926179886, 0.11764705926179886),
			BorderSizePixel = 0,
			Position = UDim2.new(0, 20, 0.40000000596046448, 0),
			Size = UDim2.new(0, 150, 0, 20),
			Visible = false,
			ClipsDescendants = false,
			Parent = library.ScreenGUI,
			ZIndex = 50,
		})
		library.ConfigManager:Register("keybindlistposition", { type = "position", object = KeybindContainer })
		library:Create("UIStroke", {
			Color = library.stroke,
			Thickness = 1,
			Parent = KeybindContainer,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			LineJoinMode = Enum.LineJoinMode.Miter,
			ZIndex = 49,
		})
		library:Create("UIStroke", {
			Color = library.stroke2,
			Thickness = 2,
			Parent = KeybindContainer,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			LineJoinMode = Enum.LineJoinMode.Miter,
			ZIndex = 48,
		})
		library:Create("TextLabel", {
			FontFace = library.font,
			TextColor3 = library.textcolor,
			TextSize = 12,
			Text = "Keybind List",
			TextXAlignment = Enum.TextXAlignment.Center,
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.new(0, 0, 0),
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 20),
			Position = UDim2.new(0, 0, 0, 0),
			Visible = true,
			Parent = KeybindContainer,
			ZIndex = 50,
		})
		library:Create("Frame", {
			Parent = KeybindContainer,
			BackgroundColor3 = library.accent,
			Size = UDim2.new(1, 0, 0, 2),
			BorderSizePixel = 0,
			ZIndex = 50,
		})
		library:Create("Frame", {
			Parent = KeybindContainer,
			BackgroundColor3 = Color3.new(0.12941177189350128, 0.070588238537311554, 0.18823529779911041),
			BackgroundTransparency = 0.5,
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 0, 1),
			BorderSizePixel = 0,
			ZIndex = 50,
		})
		KeybindContainerContent = library:Create("Frame", {
			BackgroundColor3 = library.misccolor,
			BorderColor3 = Color3.new(0.11764705926179886, 0.11764705926179886, 0.11764705926179886),
			BorderSizePixel = 0,
			Position = UDim2.new(0, 0, 0, 23),
			Size = UDim2.new(1, 0, 0, 0),
			Visible = true,
			ClipsDescendants = false,
			Parent = KeybindContainer,
			ZIndex = 50,
		})
		library:Create("UIStroke", {
			Color = library.stroke,
			Thickness = 1,
			Parent = KeybindContainerContent,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			LineJoinMode = Enum.LineJoinMode.Miter,
			ZIndex = 49,
		})
		library:Create("UIStroke", {
			Color = library.stroke2,
			Thickness = 2,
			Parent = KeybindContainerContent,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			LineJoinMode = Enum.LineJoinMode.Miter,
			ZIndex = 48,
		})
		KeybindContainerLayout = library:Create("UIListLayout", {
			Parent = KeybindContainerContent,
			Padding = UDim.new(0, 0),
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
		})
		KeybindContainerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			
			KeybindContainerContent.Size = UDim2.new(1, 0, 0, KeybindContainerLayout.AbsoluteContentSize.Y)
			KeybindContainerContent.Visible = KeybindContainerLayout.AbsoluteContentSize.Y > 0
		end)
		library:makedraggable(KeybindContainer)
		library.ConfigManager:Register("mobilekeybindpositions", {
			type = "mobilekeybindpositions",
			positions = library.mobileKeybindPositions,
			apply = function(arg2, mobileKeybindPositions)
				
				library.mobileKeybindPositions = mobileKeybindPositions or {}
				arg2.positions = library.mobileKeybindPositions
				for k in next, library.mobileKeybindButtons, nil do
					if k.SetMobilePositionFromConfig then
						k:SetMobilePositionFromConfig()
					end
				end
			end,
		})
		library.SetMobileKeybinds = function(arg2, arg3)
			
			if arg2.mobileKeybindMode and arg3 ~= true then
				for k in next, arg2.mobileKeybindButtons, nil do
					if k.MobilePosition and k.StoreMobilePosition then
						k:StoreMobilePosition(k.MobilePosition)
					end
				end
			end
			arg2.mobileKeybindMode = arg3 == true
			for k in next, arg2.mobileKeybindButtons, nil do
				if k.ApplyMobileKeybindMode then
					k:ApplyMobileKeybindMode()
				end
			end
			KeybindContainer.Visible = not arg2.mobileKeybindMode and arg2.keybindListVisible == true
			task.defer(function()
				
				KeybindContainerContent.Size = UDim2.new(1, 0, 0, KeybindContainerLayout.AbsoluteContentSize.Y)
				KeybindContainerContent.Visible = KeybindContainerLayout.AbsoluteContentSize.Y > 0
			end)
		end
		local function setMobileKeybindsLocked(arg2, arg3)
			
			arg2.mobileKeybindsLocked = arg3 == true
			if arg2.mobileKeybindsLocked then
				for k in next, arg2.mobileKeybindButtons, nil do
					if k.MobilePosition and k.StoreMobilePosition then
						k:StoreMobilePosition(k.MobilePosition)
					end
				end
			end
		end
		library.SetMobileKeybindsLocked = setMobileKeybindsLocked
		library.SetMobileKeybindColor = function(arg2, mobileKeybindColor, arg3)
			
			arg2.mobileKeybindColor = mobileKeybindColor or arg2.mobileKeybindColor
			if arg3 ~= nil then
				arg2.mobileKeybindTransparency = math.clamp(arg3, 0, 1)
			end
			for k in next, arg2.mobileKeybindButtons, nil do
				if k.ApplyMobileKeybindColor then
					k:ApplyMobileKeybindColor()
				end
			end
		end
		local v15
		local function setMobileKeybindSize(arg2, arg3)
			
			arg2.mobileKeybindSize = math.clamp(tonumber(arg3) or arg2.mobileKeybindSize, 32, 80)
			for k in next, arg2.mobileKeybindButtons, nil do
				if k.ApplyMobileKeybindSize then
					k:ApplyMobileKeybindSize()
				end
			end
		end
		v15 = bit32.bxor(v14, v13 % 4294967296 - v13 % 4294967296 % 1)
		library.SetMobileKeybindSize = setMobileKeybindSize
		local function updatenotis(arg2, arg3)
			
			local targetY = 0
			for _, notification in ipairs(arg2.notifications) do
				if notification and notification.Frame and notification.Frame.Parent then
					notification.TargetY = targetY
					if notification.MoveTween then
						notification.MoveTween:Cancel()
						notification.MoveTween = nil
					end
					local udim2 = UDim2.new(1, -10, 0, targetY)
					if notification ~= arg3 then
						notification.MoveTween = tweenService:Create(notification.Frame, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { Position = udim2 })
						notification.MoveTween:Play()
					else
						notification.Frame.Position = udim2
					end
					targetY = targetY + notification.Height + 8
				end
			end
		end
		library.updatenotis = updatenotis
		local function removenoti(arg2, arg3)
			
			
			
			if not arg3 or arg3.Removing then
				return
			end
			
			arg3.Removing = true
			library:disconnect(arg3.clickconnection)
			arg3.clickconnection = nil
			local frame = arg3.Frame
			if not frame or not frame.Parent then
				local v16 = table.find(arg2.notifications, arg3)
				if v16 then
					table.remove(arg2.notifications, v16)
					arg2:updatenotis()
				end
				return
			end
			if arg3.MoveTween then
				arg3.MoveTween:Cancel()
				arg3.MoveTween = nil
			end
			if arg3.TimeTween then
				arg3.TimeTween:Cancel()
				arg3.TimeTween = nil
			end
			local tween_2 = tweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { Position = UDim2.new(1, frame.AbsoluteSize.X + 20, 0, arg3.TargetY) })
			tween_2:Play()
			local completed = tween_2.Completed
			local once = completed.Once
			local n11 = 299626686
			local function fn()
				
				local find = table.find
				local v16 = arg2
				bit32.bxor(n11 % 4294967296 - n11 % 4294967296 % 1, 0)
				local v17 = find(v16.notifications, arg3)
				if v17 then
					table.remove(arg2.notifications, v17)
				end
				frame:Destroy()
				arg2:updatenotis()
			end
			
			n11 = 27691700
			once(completed, fn)
		end
		library.removenoti = removenoti
		bit32.bxor(v15, 2880812973)
		
		local function fn(__lph_capture_array_1000001, __lph_unused_1)
			return function(arg2, arg3)
				
				
				
				local tbl2 = { clickconnection = nil }
				local text = arg3.text
				text = text or arg3.Text or "Notification"
				local time = arg3.time
				if not time then
					
					time = arg3.Time
					
					
				end
				local n11 = time or 5
				local highlights = arg3.highlights or arg3.Highlights or {}
				
				if type(highlights) ~= "table" then
					highlights = {}
				end
				
				local height = 4 + (1 + #highlights) * 16 + 2
				local v16 = __lph_capture_array_1000001[1]:gettextbounds(tostring(text), __lph_capture_array_1000001[1].font, 12)
				for _, highlight in ipairs(highlights) do
					local v17 = __lph_capture_array_1000001[1]:gettextbounds(tostring(highlight), __lph_capture_array_1000001[1].font, 12)
					if v16 < v17 then
						v16 = v17
					end
				end
				local n14 = v16 + 15
				local tween_2 = __lph_capture_array_1000001[1]:Create("Frame", {
					Parent = NotiHolder,
					BackgroundColor3 = __lph_capture_array_1000001[1].misccolor,
					BorderSizePixel = 0,
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.new(1, n14 + 20, 0, 0),
					Size = UDim2.new(0, n14, 0, height),
					ClipsDescendants = true,
					ZIndex = 100,
				})
				__lph_capture_array_1000001[1]:Create("UIStroke", {
					Parent = tween_2,
					Color = __lph_capture_array_1000001[1].stroke,
					Thickness = 1,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					LineJoinMode = Enum.LineJoinMode.Miter,
					ZIndex = 99,
				})
				__lph_capture_array_1000001[1]:Create("UIStroke", {
					Parent = tween_2,
					Color = __lph_capture_array_1000001[1].stroke2,
					Thickness = 2,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					LineJoinMode = Enum.LineJoinMode.Miter,
					ZIndex = 98,
				})
				__lph_capture_array_1000001[1]:Create("Frame", {
					Parent = tween_2,
					BackgroundColor3 = __lph_capture_array_1000001[1].accent,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(1, 0, 0, 2),
					ZIndex = 100,
				})
				__lph_capture_array_1000001[1]:Create("Frame", {
					Parent = tween_2,
					BackgroundColor3 = Color3.new(0.12941177189350128, 0.070588238537311554, 0.18823529779911041),
					BackgroundTransparency = 0.5,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 0, 0, 1),
					Size = UDim2.new(1, 0, 0, 1),
					ZIndex = 100,
				})
				local v17 = __lph_capture_array_1000001[1]
				local create = v17.Create
				local frame = create(v17, "Frame", {
					Parent = tween_2,
					BackgroundColor3 = __lph_capture_array_1000001[1].accent,
					BorderSizePixel = 0,
					AnchorPoint = Vector2.new(1, 1),
					Visible = n11 ~= "inf" and true or false,
					Position = UDim2.new(1, 0, 1, 0),
					Size = UDim2.new(1, 0, 0, 1),
					ZIndex = 100,
				})
				local tween_3 = __lph_capture_array_1000001[1]:Create("TextButton", {
					Parent = tween_2,
					BackgroundTransparency = 1,
					Text = tostring(text),
					FontFace = __lph_capture_array_1000001[1].font,
					TextSize = 12,
					TextColor3 = __lph_capture_array_1000001[1].textcolor,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					Position = UDim2.new(0, 8, 0, 3),
					AutoButtonColor = false,
					Size = UDim2.new(1, -16, 0, 16),
					ZIndex = 100,
				})
				
				for i, highlight in ipairs(highlights) do
					__lph_capture_array_1000001[1]:Create("TextLabel", {
						Parent = tween_2,
						BackgroundTransparency = 1,
						Text = tostring(highlight),
						FontFace = __lph_capture_array_1000001[1].font,
						TextSize = 12,
						TextColor3 = __lph_capture_array_1000001[1].accent,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						Position = UDim2.new(0, 8, 0, 3 + i * 16),
						Size = UDim2.new(1, -16, 0, 16),
						ZIndex = 100,
					})
				end
				tbl2.Frame = tween_2
				tbl2.TimeBar = frame
				tbl2.Height = height
				tbl2.TargetY = 0
				tbl2.Removing = false
				tbl2.MoveTween = nil
				tbl2.TimeTween = nil
				local insert = table.insert
				
				insert(arg2.notifications, 1, tbl2)
				arg2:updatenotis()
				local udim2 = UDim2.new
				
				
				tween_2.Position = udim2(1, n14 + 20, 0, tbl2.TargetY)
				tbl2.MoveTween = __lph_capture_array_1000001[2]:Create(tween_2, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { Position = UDim2.new(1, -10, 0, tbl2.TargetY) })
				tbl2.MoveTween:Play()
				local v21 = __lph_capture_array_1000001[1]
				local connect = v21.connect
				local activated = tween_3.Activated
				local n16 = 272682967
				local function fn2()
					
					local flag = bit32.bxor(n16 % 4294967296 - n16 % 4294967296 % 1, 0) == 28182260
					__lph_capture_array_1000001[1]:removenoti(tbl2)
				end
				
				n16 = 428422845
				tbl2.clickconnection = connect(v21, activated, fn2)
				
				if n11 ~= "inf" then
					
					tbl2.TimeTween = __lph_capture_array_1000001[2]:Create(frame, TweenInfo.new(n11, Enum.EasingStyle.Linear), { Size = UDim2.new(0, 0, 0, 1) })
					tbl2.TimeTween:Play()
					local spawn = task.spawn
					local v23 = 375428402
					local function fn3()
						
						task.wait(n11)
						local v24 = v23
						local n19
						if v24 % 4294967296 ~= v24 % 4294967296 then
							n19 = 0
						else
							n19 = v24 % 4294967296 - v24 % 4294967296 % 1
						end
						if bit32.bxor(n19, 0) ~= 524247603 then
							local v25 = v23
							local n20
							if v25 % 4294967296 ~= v25 % 4294967296 then
								n20 = 0
							else
								n20 = v25 % 4294967296 - v25 % 4294967296 % 1
							end
							v23 = bit32.bxor(n20, 3289830687)
						end
						__lph_capture_array_1000001[1]:removenoti(tbl2)
					end
					
					v23 = 524247603
					spawn(fn3)
				end
				return tbl2
			end
		end
		library.Notify = fn(table.pack(library, tweenService))
		MobileButton = library:Create("ImageButton", {
			Parent = library.ScreenGUI,
			Image = "rbxassetid://82901197465489",
			BackgroundTransparency = 0,
			BackgroundColor3 = library.misccolor,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Visible = false,
			Position = UDim2.new(0.5, 0, 0.05000000074505806, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(0, 40, 0, 40),
			Active = true,
			ZIndex = 75,
		})
		library:Create("UICorner", { Parent = MobileButton, CornerRadius = UDim.new(0, 8) })
		library:makedraggable(MobileButton, 40)
		library:connect(MobileButton.Activated, function()
			
			library:toggle(not MainFrameBG1.Visible)
		end)
		MobileFreecamLeft = library:Create("Frame", {
			Parent = library.ScreenGUI,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 30, 1, -30),
			Size = UDim2.new(0, 180, 0, 180),
			AnchorPoint = Vector2.new(0, 1),
			Visible = false,
			ZIndex = 75,
			Active = true,
		})
		library:Create("UICorner", {
			Parent = library:Create("Frame", {
				Parent = MobileFreecamLeft,
				BackgroundColor3 = Color3.new(0.078431375324726105, 0.078431375324726105, 0.078431375324726105),
				BackgroundTransparency = 0.1,
				BorderColor3 = library.accent,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 1, 1, 1),
				ZIndex = 75,
			}),
			CornerRadius = UDim.new(0, 90),
		})
		MobileFreecamLeftStick = library:Create("Frame", {
			Parent = MobileFreecamLeft,
			BackgroundColor3 = library.accent,
			BackgroundTransparency = 0.4,
			BorderColor3 = library.stroke,
			BorderSizePixel = 1,
			Size = UDim2.new(0, 70, 0, 70),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			ZIndex = 76,
			Active = true,
		})
		library:Create("UICorner", { Parent = MobileFreecamLeftStick, CornerRadius = UDim.new(0, 35) })
		local n9 = n8 - 3956311516
		
		local function fn2(__lph_capture_array_1000004, __lph_unused_1)
			return function(arg2, arg3)
				
				
				
				local default = arg3.default
				if not default then
					default = arg3.Default
					
					
				end
				default = default or nil
				local mode = arg3.mode or arg3.Mode or "Toggle"
				local blacklist = arg3.blacklist or arg3.Blacklist
				if not blacklist then
					blacklist = {}
					local mouseMovement = Enum.UserInputType.MouseMovement
					local backspace = Enum.KeyCode.Backspace
					blacklist[1] = mouseMovement
					blacklist[2] = backspace
					
					
				end
				local v16 = blacklist
				local flag = arg3.flag or arg3.Flag or __lph_capture_array_1000004[1]:nextflag()
				local callback = arg3.callback or arg3.Callback or function()
					
				end
				
				local sync = arg3.sync or arg3.Sync or false
				local state = arg3.state or arg3.State or false
				local list = arg3.list or arg3.List or false
				
				if not arg3.tooltip then
					
					local tooltip = arg3.Tooltip
				end
				local v17 = mode
				local parentname = arg3.parentname or arg3.ParentName or ""
				local tbl2 = { type = "keybind", key = default, mode = v17, value = state, list = list, cfg = arg3, sync = sync }
				local tween_2 = __lph_capture_array_1000004[1]:Create("Frame", {
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 18),
					Visible = true,
					Parent = KeybindContainerContent,
					ZIndex = 50,
				})
				local v18 = __lph_capture_array_1000004[1]
				local create = v18.Create
				local tbl3 = { FontFace = __lph_capture_array_1000004[1].font }
				local accent = state and __lph_capture_array_1000004[1].accent
				if not accent then
					
					accent = __lph_capture_array_1000004[1].textcolor
				end
				tbl3.TextColor3 = accent
				tbl3.TextSize = 12
				tbl3.Text = parentname
				tbl3.TextXAlignment = Enum.TextXAlignment.Left
				tbl3.TextYAlignment = Enum.TextYAlignment.Bottom
				tbl3.BackgroundTransparency = 1
				tbl3.Position = UDim2.new(0.029999999329447746, 0, 0, 0)
				tbl3.Size = UDim2.new(0.75, 0, 0.75, 0)
				tbl3.Visible = true
				tbl3.Parent = tween_2
				tbl3.ZIndex = 50
				local textLabel = create(v18, "TextLabel", tbl3)
				textLabel:SetAttribute("IsAccent", "TextColor3")
				textLabel:SetAttribute("Selected", state)
				local v19 = __lph_capture_array_1000004[1]
				local create2 = v19.Create
				local tbl4 = {
					FontFace = __lph_capture_array_1000004[1].font,
					TextColor3 = state and __lph_capture_array_1000004[1].accent or __lph_capture_array_1000004[1].textcolor,
					TextSize = 12,
					Text = "[" .. (default and __lph_capture_array_1000004[2][default] or "[None]") .. "]",
				}
				tbl4.TextXAlignment = Enum.TextXAlignment.Right
				tbl4.TextYAlignment = Enum.TextYAlignment.Bottom
				tbl4.BackgroundTransparency = 1
				tbl4.Position = UDim2.new(0.74000000953674316, 1, 0, 0)
				tbl4.Size = UDim2.new(0.23000000417232513, 0, 0.75, 0)
				tbl4.Visible = true
				tbl4.Parent = tween_2
				tbl4.ZIndex = 50
				local textLabel2 = create2(v19, "TextLabel", tbl4)
				
				local tween_3 = __lph_capture_array_1000004[1]:Create("TextButton", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Text = "",
					BackgroundTransparency = 1,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(1, 0, 1, 0),
					Visible = true,
					Parent = tween_2,
					ZIndex = 50,
				})
				textLabel2:SetAttribute("IsAccent", "TextColor3")
				textLabel2:SetAttribute("Selected", state)
				__lph_capture_array_1000004[1]:Create("UICorner", { Parent = tween_2, CornerRadius = UDim.new(0, 8) })
				__lph_capture_array_1000004[1].binds[tween_2] = tween_2
				__lph_capture_array_1000004[1].mobileKeybindButtons[tbl2] = true
				tbl2.Frame = tween_2
				tbl2.Button = tween_3
				tbl2.LeftText = textLabel
				tbl2.RightText = textLabel2
				
				__lph_capture_array_1000004[1].mobileKeybindCount = __lph_capture_array_1000004[1].mobileKeybindCount + 1
				tbl2.MobileIndex = __lph_capture_array_1000004[1].mobileKeybindCount
				local v20 = nil
				local flag2 = false
				local v21 = nil
				
				local position = nil
				local position2 = nil
				local str = tostring(flag)
				local function fn3(arg4)
					
					local str2 = tostring(arg4 or "")
					local tbl5 = {}
					for match in str2:gmatch("%u") do
						table.insert(tbl5, match)
					end
					local n16 = #tbl5
					if n16 then
						if n16 == 0 then
							for match in str2:gmatch("%S+") do
								table.insert(tbl5, match:sub(1, 1):upper())
							end
						end
					end
					if #tbl5 == 0 then
						table.insert(tbl5, str2:sub(1, 1):upper())
					end
					return table.concat(tbl5, "")
				end
				local function fn4()
					
					if __lph_capture_array_1000004[1].mobileKeybindMode then
						return list and __lph_capture_array_1000004[1].keybindListVisible == true
					end
					return list
				end
				
				tbl2.StoreMobilePosition = function(arg4, mobilePosition)
					
					if not mobilePosition then
						return
					end
					if mobilePosition.X.Offset == 0 and mobilePosition.Y.Offset == 0 then
						return
					end
					arg4.MobilePosition = mobilePosition
					__lph_capture_array_1000004[1].mobileKeybindPositions[str] = { x = mobilePosition.X.Offset, y = mobilePosition.Y.Offset }
				end
				local function setMobilePositionFromConfig(arg4)
					
					local v23 = str
					local v24 = __lph_capture_array_1000004[1].mobileKeybindPositions[v23]
					if type(v24) == "table" and type(v24.x) == "number" and type(v24.y) == "number" then
						if v24.x == 0 and v24.y == 0 then
							__lph_capture_array_1000004[1].mobileKeybindPositions[str] = nil
							return
						end
						arg4.MobilePosition = UDim2.fromOffset(v24.x, v24.y)
						local mobileKeybindMode = __lph_capture_array_1000004[1].mobileKeybindMode
						if mobileKeybindMode then
							local v25 = tween_2
							if not v23 then
								tween_2.Position = arg4.MobilePosition
							else
								mobileKeybindMode = v25.Parent == __lph_capture_array_1000004[1].ScreenGUI
								if mobileKeybindMode then
									tween_2.Position = arg4.MobilePosition
									return
								end
							end
						end
					end
				end
				
				tbl2.SetMobilePositionFromConfig = setMobilePositionFromConfig
				tbl2:SetMobilePositionFromConfig()
				local function applyMobileKeybindMode()
					
					
					
					
					if __lph_capture_array_1000004[1].mobileKeybindMode then
						
						if not v20 then
							local tbl5 = {}
							local v23 = tween_2
							
							tbl5.Parent = v23.Parent
							tbl5.AnchorPoint = tween_2.AnchorPoint
							tbl5.Position = tween_2.Position
							tbl5.Size = tween_2.Size
							tbl5.BackgroundColor3 = tween_2.BackgroundColor3
							tbl5.BackgroundTransparency = tween_2.BackgroundTransparency
							tbl5.ZIndex = tween_2.ZIndex
							tbl5.LeftVisible = textLabel.Visible
							tbl5.LeftPosition = textLabel.Position
							tbl5.LeftSize = textLabel.Size
							tbl5.LeftTextSize = textLabel.TextSize
							tbl5.LeftText = textLabel.Text
							tbl5.LeftXAlignment = textLabel.TextXAlignment
							
							
							
							tbl5.LeftYAlignment = textLabel.TextYAlignment
							tbl5.LeftZIndex = textLabel.ZIndex
							tbl5.LeftTextScaled = textLabel.TextScaled
							tbl5.LeftTextWrapped = textLabel.TextWrapped
							tbl5.RightVisible = textLabel2.Visible
							tbl5.RightPosition = textLabel2.Position
							tbl5.RightSize = textLabel2.Size
							
							tbl5.RightTextSize = textLabel2.TextSize
							tbl5.RightXAlignment = textLabel2.TextXAlignment
							tbl5.RightYAlignment = textLabel2.TextYAlignment
							
							tbl5.RightZIndex = textLabel2.ZIndex
							tbl5.RightTextScaled = textLabel2.TextScaled
							tbl5.RightTextWrapped = textLabel2.TextWrapped
							tbl5.ButtonPosition = tween_3.Position
							tbl5.ButtonSize = tween_3.Size
							local v27 = tween_3
							
							
							
							
							
							
							
							
							
							tbl5.ButtonAnchorPoint = v27.AnchorPoint
							tbl5.ButtonZIndex = tween_3.ZIndex
							v20 = tbl5
							
							
							
							
						end
						tween_2.Parent = __lph_capture_array_1000004[1].ScreenGUI
						tween_2.AnchorPoint = Vector2.new(0.5, 0.5)
						local v23 = tbl2
						
						if not v23.MobilePosition then
							local n22 = (tbl2.MobileIndex or 1) - 1
							tbl2:StoreMobilePosition(UDim2.fromOffset(60 + n22 % 4 * 46, 120 + math.floor(n22 / 4) * 46))
						end
						tween_2.Position = tbl2.MobilePosition
						tween_2.Size = UDim2.fromOffset(__lph_capture_array_1000004[1].mobileKeybindSize, __lph_capture_array_1000004[1].mobileKeybindSize)
						
						tween_2.BackgroundColor3 = __lph_capture_array_1000004[1].mobileKeybindColor
						tween_2.BackgroundTransparency = 0.15
						local v25 = tween_2
						
						
						v25.ZIndex = 80
						local n23 = math.max(3, math.floor(__lph_capture_array_1000004[1].mobileKeybindSize * 0.08))
						textLabel.Visible = true
						
						textLabel.Text = fn3(parentname)
						local v28 = textLabel
						local udim2 = UDim2.new
						
						v28.Position = udim2(0, n23, 0, n23)
						textLabel.Size = UDim2.new(1, -n23 * 2, 1, -n23 * 2)
						textLabel.TextSize = 12
						textLabel.TextScaled = false
						local v29 = textLabel
						
						v29.TextWrapped = false
						textLabel.TextXAlignment = Enum.TextXAlignment.Center
						local v31 = textLabel
						local textYAlignment = Enum.TextYAlignment
						
						v31.TextYAlignment = textYAlignment.Center
						textLabel.ZIndex = 81
						textLabel2.Visible = false
						textLabel2.TextScaled = false
						textLabel2.TextWrapped = false
						textLabel2.ZIndex = 81
						tween_3.AnchorPoint = Vector2.new(0.5, 0.5)
						tween_3.Position = UDim2.new(0.5, 0, 0.5, 0)
						tween_3.Size = UDim2.new(1, 0, 1, 0)
						tween_3.ZIndex = 82
						tween_2.Visible = fn4()
						
						
						
					elseif v20 then
						tween_2.Parent = v20.Parent
						local v23 = tween_2
						local anchorPoint = v20.AnchorPoint
						
						
						v23.AnchorPoint = anchorPoint
						tween_2.Position = v20.Position
						local v26 = tween_2
						local size = v20.Size
						
						v26.Size = size
						tween_2.BackgroundColor3 = v20.BackgroundColor3
						tween_2.BackgroundTransparency = v20.BackgroundTransparency
						tween_2.ZIndex = v20.ZIndex
						textLabel.Visible = v20.LeftVisible
						textLabel.Text = v20.LeftText or parentname
						local v28 = textLabel
						local leftPosition = v20.LeftPosition
						
						
						v28.Position = leftPosition
						textLabel.Size = v20.LeftSize
						textLabel.TextSize = v20.LeftTextSize
						local v29 = textLabel
						local leftXAlignment = v20.LeftXAlignment
						
						
						v29.TextXAlignment = leftXAlignment
						
						textLabel.TextYAlignment = v20.LeftYAlignment
						textLabel.ZIndex = v20.LeftZIndex
						textLabel.TextScaled = v20.LeftTextScaled
						textLabel.TextWrapped = v20.LeftTextWrapped
						local v32 = textLabel2
						local v33 = v20
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						
						v32.Visible = v33.RightVisible
						
						textLabel2.Position = v20.RightPosition
						textLabel2.Size = v20.RightSize
						textLabel2.TextSize = v20.RightTextSize
						textLabel2.TextXAlignment = v20.RightXAlignment
						textLabel2.TextYAlignment = v20.RightYAlignment
						
						textLabel2.ZIndex = v20.RightZIndex
						textLabel2.TextScaled = v20.RightTextScaled
						
						textLabel2.TextWrapped = v20.RightTextWrapped
						tween_3.AnchorPoint = v20.ButtonAnchorPoint
						local v48 = tween_3
						local buttonPosition = v20.ButtonPosition
						
						
						
						
						
						
						
						
						v48.Position = buttonPosition
						tween_3.Size = v20.ButtonSize
						local v56 = tween_3
						
						v56.ZIndex = v20.ButtonZIndex
						tween_2.Visible = fn4()
						v20 = nil
						
						
					end
					local defer = task.defer
					local v23 = 423074278
					local function fn5()
						
						KeybindContainerContent.Size = UDim2.new(1, 0, 0, KeybindContainerLayout.AbsoluteContentSize.Y)
						local v24 = KeybindContainerContent
						local visible = KeybindContainerLayout.AbsoluteContentSize.Y > 0
						local flag3 = bit32.bxor(bit32.bxor(v23 % 4294967296 - v23 % 4294967296 % 1, 0), 470364570) ~= 6305416
						v24.Visible = visible
					end
					
					v23 = 476645138
					defer(fn5)
				end
				
				tbl2.ApplyMobileKeybindMode = applyMobileKeybindMode
				local function applyMobileKeybindColor()
					
					if __lph_capture_array_1000004[1].mobileKeybindMode then
						tween_2.BackgroundColor3 = __lph_capture_array_1000004[1].mobileKeybindColor
						tween_2.BackgroundTransparency = __lph_capture_array_1000004[1].mobileKeybindTransparency or 0
					end
				end
				tbl2.ApplyMobileKeybindColor = applyMobileKeybindColor
				tbl2.ApplyMobileKeybindSize = function()
					
					if __lph_capture_array_1000004[1].mobileKeybindMode then
						local n18 = math.max(3, math.floor(__lph_capture_array_1000004[1].mobileKeybindSize * 0.08))
						tween_2.Size = UDim2.fromOffset(__lph_capture_array_1000004[1].mobileKeybindSize, __lph_capture_array_1000004[1].mobileKeybindSize)
						textLabel.Position = UDim2.new(0, n18, 0, n18)
						textLabel.Size = UDim2.new(1, -n18 * 2, 1, -n18 * 2)
						textLabel.TextSize = 12
					end
				end
				local function fn5(arg4)
					
					if not __lph_capture_array_1000004[1].mobileKeybindMode or __lph_capture_array_1000004[1].mobileKeybindsLocked then
						return
					end
					if arg4.UserInputType ~= Enum.UserInputType.MouseButton1 and arg4.UserInputType ~= Enum.UserInputType.Touch then
						return
					end
					flag2 = true
					v21 = arg4
					position = arg4.Position
					position2 = tween_2.Position
					arg4.Changed:Connect(function()
						
						if arg4.UserInputState == Enum.UserInputState.End then
							flag2 = false
							v21 = nil
							if tbl2.MobilePosition then
								tbl2:StoreMobilePosition(tbl2.MobilePosition)
							end
						end
					end)
				end
				tbl2.MobileDragBeganConnection = __lph_capture_array_1000004[1]:connect(tween_3.InputBegan, fn5)
				tbl2.MobileDragChangedConnection = __lph_capture_array_1000004[1]:connect(tween_3.InputChanged, function(arg4)
					
					if arg4.UserInputType == Enum.UserInputType.MouseMovement or arg4.UserInputType == Enum.UserInputType.Touch then
						v21 = arg4
					end
				end)
				
				local v25 = __lph_capture_array_1000004[1]
				local connect = v25.connect
				local inputChanged = __lph_capture_array_1000004[3].InputChanged
				
				local function fn6(arg4)
  if flag2 and arg4 == v21 and position2 then
   local delta = arg4.Position - position
   local nextPosition = UDim2.new(position2.X.Scale, position2.X.Offset + delta.X,
    position2.Y.Scale, position2.Y.Offset + delta.Y)
   tween_2.Position = nextPosition
   tbl2:StoreMobilePosition(nextPosition)
  end
 end
				
				
				tbl2.MobileDragMoveConnection = connect(v25, inputChanged, fn6)
				tbl2.update = function(arg4, value, arg5)
					
					
					
					if tbl2.mode == "Button" then
						return
					end
					if state == value and not arg5 then
						return
					end
					state = value
					__lph_capture_array_1000004[1]:setflag(flag, value)
					tbl2.value = value
					if state then
						textLabel.TextColor3 = __lph_capture_array_1000004[1].accent
						
						textLabel2.TextColor3 = __lph_capture_array_1000004[1].accent
						textLabel:SetAttribute("Selected", true)
						textLabel2:SetAttribute("Selected", true)
						textLabel:SetAttribute("TextDisabled", true)
						textLabel2:SetAttribute("TextDisabled", true)
					else
						textLabel.TextColor3 = __lph_capture_array_1000004[1].textcolor
						local v26 = textLabel2
						local v27 = __lph_capture_array_1000004[1]
						
						v26.TextColor3 = v27.textcolor
						textLabel:SetAttribute("Selected", false)
						textLabel2:SetAttribute("Selected", false)
						textLabel:SetAttribute("TextDisabled", false)
						textLabel2:SetAttribute("TextDisabled", false)
					end
				end
				tbl2.set = function(arg4, arg5, arg6, arg7)
					
					if tbl2.mode == "Button" then
						if __lph_capture_array_1000004[1].mobileKeybindMode and not __lph_capture_array_1000004[1].mobileKeybindsLocked then
							return
						end
						if arg6 then
							return
						end
						callback()
						return
					end
					local flag3 = state ~= arg5
					if not flag3 and not arg7 then
						return
					end
					tbl2:update(arg5, arg7)
					if flag3 and not arg6 then
						callback(arg5)
					end
				end
				__lph_capture_array_1000004[1]:connect(tween_3.InputBegan, function(arg4)
					
					
					
					local mobileKeybindMode = __lph_capture_array_1000004[1].mobileKeybindMode
					if mobileKeybindMode then
						mobileKeybindMode = not __lph_capture_array_1000004[1].mobileKeybindsLocked
						
					end
					if mobileKeybindMode then
						return
					end
					if arg4.UserInputType ~= Enum.UserInputType.MouseButton1 and arg4.UserInputType ~= Enum.UserInputType.Touch then
						return
					end
					if tbl2.mode == "Button" then
						callback()
					elseif v17 == "Hold" then
						tbl2:set(true)
					else
						tbl2:set(not state)
					end
					
					local n23 = 0
					local n24 = 1
					local exitTo = nil
					for _, v26 in { [{}] = 68, [{}] = 73, [{}] = 50, [{}] = 62, [{}] = 94 }, nil, nil do
						n23 += 1
						if n23 >= 3 then
							exitTo = 1
							break
						else
							n24 += n23 * v26
						end
					end
					if exitTo == 1 then
						n24 = n24 % 113 * 6 + n24 % 659 + 55
					end
					if not (not ({ [189] = true })[n24 + 189] or 0 ~= n24 + n24 or 0 % n24 < 0) then
						return
					end
					
				end)
				__lph_capture_array_1000004[1]:connect(tween_3.InputEnded, function(arg4)
					
					if __lph_capture_array_1000004[1].mobileKeybindMode and not __lph_capture_array_1000004[1].mobileKeybindsLocked then
						return
					end
					if arg4.UserInputType ~= Enum.UserInputType.MouseButton1 and arg4.UserInputType ~= Enum.UserInputType.Touch then
						return
					end
					if tbl2.mode ~= "Button" and v17 == "Hold" then
						tbl2:set(false)
					end
				end)
				
				local tween_4 = __lph_capture_array_1000004[1]:Create("TextButton", {
					Parent = arg2,
					Text = "",
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.new(1, 0, 0, 0),
					Size = UDim2.new(0, 30, 1, 0),
					AutoButtonColor = false,
					ZIndex = 9,
				})
				__lph_capture_array_1000004[1]:tooltip(tween_4, arg3)
				local v26 = __lph_capture_array_1000004[1]
				local create3 = v26.Create
				local tbl5 = { Parent = tween_4 }
				local text
				if default then
					text = "[" .. (__lph_capture_array_1000004[2][default] or tostring(default)) .. "]"
				else
					text = default
				end
				tbl5.Text = text or "[None]"
				tbl5.FontFace = __lph_capture_array_1000004[1].font
				tbl5.BackgroundColor3 = __lph_capture_array_1000004[1].textcolor
				tbl5.BackgroundTransparency = 1
				tbl5.BorderSizePixel = 0
				tbl5.Position = UDim2.new(0, 2, 0, 0)
				tbl5.Size = UDim2.new(1, 0, 1, 0)
				tbl5.TextSize = 12
				tbl5.TextColor3 = __lph_capture_array_1000004[1].textcolor
				tbl5.TextXAlignment = Enum.TextXAlignment.Right
				tbl5.TextYAlignment = Enum.TextYAlignment.Bottom
				tbl5.LineHeight = 1
				tbl5.RichText = true
				tbl5.ClipsDescendants = false
				tbl5.ZIndex = 9
				local textLabel3 = create3(v26, "TextLabel", tbl5)
				local v27 = __lph_capture_array_1000004[1]
				local create4 = v27.Create
				local frame = create4(v27, "Frame", {
					Parent = arg2.Parent,
					BackgroundTransparency = 0,
					Position = UDim2.new(0.86000001430511475, -1, 1.1000000238418579, 0),
					BackgroundColor3 = __lph_capture_array_1000004[1].misccolor,
					BorderColor3 = Color3.new(0.11764705926179886, 0.11764705926179886, 0.11764705926179886),
					BorderSizePixel = 0,
					Size = tbl2.mode ~= "Button" and UDim2.new(0, 42, 0, 50) or UDim2.new(0, 42, 0, 16),
					Visible = false,
					ClipsDescendants = false,
					ZIndex = 18,
				})
				__lph_capture_array_1000004[1]:Create("ImageLabel", {
					Parent = frame,
					Image = "rbxassetid://87505091287358",
					ImageTransparency = 0.8,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(1, 0, 1, 0),
					ZIndex = 20,
				})
				local tween_5 = __lph_capture_array_1000004[1]:Create("UIStroke", {
					Color = __lph_capture_array_1000004[1].stroke,
					Thickness = 1,
					Parent = frame,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					LineJoinMode = Enum.LineJoinMode.Miter,
					ZIndex = 17,
				})
				__lph_capture_array_1000004[1]:Create("UIStroke", {
					Color = __lph_capture_array_1000004[1].stroke2,
					Thickness = 2,
					Parent = frame,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					LineJoinMode = Enum.LineJoinMode.Miter,
					ZIndex = 16,
				})
				local v28 = __lph_capture_array_1000004[1]
				local create5 = v28.Create
				local tbl6 = {
					Parent = frame,
					Text = "Hold",
					BackgroundTransparency = 1,
					FontFace = __lph_capture_array_1000004[1].font,
					TextSize = 12,
					AnchorPoint = Vector2.new(0.5, 0.5),
					TextColor3 = __lph_capture_array_1000004[1].textcolor,
					Position = UDim2.new(0.5, 0, 0.15000000596046448, 0),
					BackgroundColor3 = __lph_capture_array_1000004[1].buttoncolor,
					BorderColor3 = Color3.new(0.11764705926179886, 0.11764705926179886, 0.11764705926179886),
					Visible = tbl2.mode ~= "Button" and true or false,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0.25, 0),
					ClipsDescendants = false,
					AutoButtonColor = false,
				}
				tbl6.TextXAlignment = Enum.TextXAlignment.Center
				tbl6.TextYAlignment = Enum.TextYAlignment.Center
				tbl6.ZIndex = 18
				local textButton = create5(v28, "TextButton", tbl6)
				local v29 = __lph_capture_array_1000004[1]
				local create6 = v29.Create
				local tbl7 = {
					Parent = frame,
					Text = "Toggle",
					BackgroundTransparency = 1,
					FontFace = __lph_capture_array_1000004[1].font,
					TextSize = 12,
					AnchorPoint = Vector2.new(0.5, 1),
					Visible = tbl2.mode ~= "Button" and true or false,
					TextColor3 = __lph_capture_array_1000004[1].textcolor,
					Position = UDim2.new(0.5, 0, 0.57999998331069946, 0),
					BackgroundColor3 = __lph_capture_array_1000004[1].buttoncolor,
				}
				tbl7.BorderSizePixel = 0
				tbl7.BorderColor3 = Color3.new(0.11764705926179886, 0.11764705926179886, 0.11764705926179886)
				tbl7.Size = UDim2.new(1, 0, 0.25, 0)
				tbl7.ClipsDescendants = false
				tbl7.AutoButtonColor = false
				tbl7.TextXAlignment = Enum.TextXAlignment.Center
				tbl7.TextYAlignment = Enum.TextYAlignment.Center
				tbl7.ZIndex = 20
				local textButton2 = create6(v29, "TextButton", tbl7)
				local v30 = __lph_capture_array_1000004[1]
				local create7 = v30.Create
				local tbl8 = {
					Parent = frame,
					Text = "List",
					BackgroundTransparency = 1,
					FontFace = __lph_capture_array_1000004[1].font,
					TextSize = 12,
					AnchorPoint = Vector2.new(0.5, 1),
				}
				tbl8.TextColor3 = list and __lph_capture_array_1000004[1].accent or __lph_capture_array_1000004[1].textcolor
				tbl8.Position = tbl2.mode ~= "Button" and UDim2.new(0.5, 0, 0.92000001668930054, 0) or UDim2.new(0.5, 0, 1, -2)
				tbl8.BackgroundColor3 = __lph_capture_array_1000004[1].buttoncolor
				tbl8.BorderSizePixel = 0
				tbl8.BorderColor3 = Color3.new(0.11764705926179886, 0.11764705926179886, 0.11764705926179886)
				tbl8.Size = tbl2.mode ~= "Button" and UDim2.new(1, 0, 0.25, 0) or UDim2.new(1, 0, 1, -4)
				tbl8.ClipsDescendants = false
				tbl8.AutoButtonColor = false
				tbl8.TextXAlignment = Enum.TextXAlignment.Center
				tbl8.TextYAlignment = Enum.TextYAlignment.Center
				tbl8.ZIndex = 20
				local textButton3 = create7(v30, "TextButton", tbl8)
				textButton3:SetAttribute("AccentProps", "TextColor3")
				local n21 = 440073689
				local function setlist(arg4, arg5)
					
					list = arg5 and true or false
					arg3.list = list
					tbl2.list = list
					local v31 = textButton3
					local accent2 = list
					local v32 = n21
					local n22
					if v32 % 4294967296 ~= v32 % 4294967296 then
						n22 = 0
					else
						n22 = v32 % 4294967296 - v32 % 4294967296 % 1
					end
					if bit32.bxor(n22, 0) == 124589419 then
						local v33 = n21
						local v34, v35
						if v33 % 4294967296 ~= v33 % 4294967296 then
							v34 = table.pack(530751891)
							v35 = 530751891
						else
							v34 = table.pack(bit32.bxor(v33 % 4294967296 - v33 % 4294967296 % 1, 530751891))
							v35 = v34[1]
						end
						n21 = v35
					end
					accent2 = accent2 and __lph_capture_array_1000004[1].accent
					local v33
					if accent2 then
						v33 = accent2
					else
						accent2 = __lph_capture_array_1000004[1].textcolor
						v33 = accent2
					end
					v31.TextColor3 = v33
					textButton3:SetAttribute("Selected", list)
					textButton3:SetAttribute("TextDisabled", list)
					__lph_capture_array_1000004[1]:setaccentstate(textButton3, "TextColor3", list)
					local v34 = tween_2
					local v35 = n21
					local n23
					if v35 % 4294967296 ~= v35 % 4294967296 then
						n23 = 0
					else
						n23 = v35 % 4294967296 - v35 % 4294967296 % 1
					end
					if bit32.bxor(n23, 0) ~= 200356957 then
						accent2 = fn4
					end
					v34.Visible = accent2()
					task.defer(function()
						
						KeybindContainerContent.Size = UDim2.new(1, 0, 0, KeybindContainerLayout.AbsoluteContentSize.Y)
						KeybindContainerContent.Visible = KeybindContainerLayout.AbsoluteContentSize.Y > 0
					end)
				end
				
				n21 = 416678068
				tbl2.setlist = setlist
				tbl2.setmode = function(arg4, mode2)
					
					
					
					if mode2 ~= "Hold" and mode2 ~= "Toggle" then
						return
					end
					v17 = mode2
					tbl2.mode = mode2
					
					if mode2 == "Hold" then
						tbl2:set(false)
						__lph_capture_array_1000004[1]:setaccentstate(textButton, "TextColor3", true)
						__lph_capture_array_1000004[1]:setaccentstate(textButton2, "TextColor3", false)
						textButton.TextColor3 = __lph_capture_array_1000004[1].accent
						textButton2.TextColor3 = __lph_capture_array_1000004[1].textcolor
						textButton:SetAttribute("TextDisabled", true)
						textButton2:SetAttribute("TextDisabled", false)
						textButton:SetAttribute("Selected", true)
						textButton2:SetAttribute("Selected", false)
					else
						__lph_capture_array_1000004[1]:setaccentstate(textButton, "TextColor3", false)
						__lph_capture_array_1000004[1]:setaccentstate(textButton2, "TextColor3", true)
						textButton.TextColor3 = __lph_capture_array_1000004[1].textcolor
						textButton2.TextColor3 = __lph_capture_array_1000004[1].accent
						textButton:SetAttribute("TextDisabled", false)
						textButton2:SetAttribute("TextDisabled", true)
						textButton:SetAttribute("Selected", false)
						
						textButton2:SetAttribute("Selected", true)
					end
				end
				local function fn7()
					
					tbl2:setmode("Hold")
					frame.Visible = false
				end
				textButton.MouseButton1Click:Connect(fn7)
				textButton2.MouseButton1Click:Connect(function()
					
					tbl2:setmode("Toggle")
					frame.Visible = false
				end)
				textButton3.MouseButton1Click:Connect(function()
					
					tbl2:setlist(not list)
					frame.Visible = false
				end)
				textButton:SetAttribute("AccentProps", "TextColor3")
				textButton2:SetAttribute("AccentProps", "TextColor3")
				textButton:SetAttribute("TextDisabled", false)
				textButton2:SetAttribute("TextDisabled", false)
				__lph_capture_array_1000004[1]:setaccentstate(textButton, "TextColor3", false)
				__lph_capture_array_1000004[1]:setaccentstate(textButton2, "TextColor3", false)
				
				
				
				__lph_capture_array_1000004[1]:mouseffects(frame, tween_5)
				local v32 = nil
				local v33 = nil
				local flag3 = false
				
				local function fn8(key)
  if tostring(key):find('Enum.KeyCode.') then
   key=Enum.KeyCode[tostring(key):gsub('Enum.KeyCode.','')]
  elseif tostring(key):find('Enum.UserInputType.') then
   key=Enum.UserInputType[tostring(key):gsub('Enum.UserInputType.','')]
  end
  if key~=nil and not table.find(v16,key) then
   v32=key
   tbl2.key=key
   local text=__lph_capture_array_1000004[2][key]
   if not text then text=tostring(key):gsub('Enum.KeyCode.',''):gsub('Enum.UserInputType.','')end
   textLabel3.Text='['..text..']'
   tween_4.Size=UDim2.new(0,__lph_capture_array_1000004[1]:gettextbounds(text,__lph_capture_array_1000004[1].font,12)+4,1,0)
   textLabel2.Text='['..text..']'
  else
   v32=nil
   tbl2.key=nil
   textLabel3.Text='[None]'
   textLabel2.Text='[None]'
  end
 end
				local v35 = nil
				tbl2.InputBeganConnection = __lph_capture_array_1000004[1]:connect(__lph_capture_array_1000004[3].InputBegan, function(arg4)
					
					if __lph_capture_array_1000004[3]:GetFocusedTextBox() then
						return
					end
					if v32 == nil then
						return
					end
					if v33 then
						return
					end
					if flag3 then
						if arg4.KeyCode == v32 or arg4.UserInputType == v32 then
							flag3 = false
							return
						end
					end
					if arg4.KeyCode == v32 or arg4.UserInputType == v32 then
						if v17 == "Hold" then
							tbl2:set(true)
						else
							tbl2:set(not state)
						end
					end
				end)
				tbl2.InputEndedConnection = __lph_capture_array_1000004[1]:connect(__lph_capture_array_1000004[3].InputEnded, function(arg4)
					
					if __lph_capture_array_1000004[3]:GetFocusedTextBox() then
						return
					end
					if v32 == nil then
						return
					end
					local flag4 = v17 == "Hold"
					local flag5
					if flag4 then
						flag5 = arg4.KeyCode == v32 or arg4.UserInputType == v32
					else
						flag5 = flag4
					end
					if flag5 then
						if v35 then
							v35:Disconnect()
							v35 = nil
						end
						if flag then
							__lph_capture_array_1000004[1]:setflag(flag, false)
						end
						tbl2:set(false)
					end
				end)
				local v36 = __lph_capture_array_1000004[1]
				local connect2 = v36.connect
				
				
				connect2(v36, tween_4.MouseButton1Click, function()
					
					if __lph_capture_array_1000004[3]:GetFocusedTextBox() then
						return
					end
					if not v33 then
						local flag4 = nil
						task.spawn(function()
							
							local n26 = 0
							while not flag4 do
								n26 = n26 % 3 + 1
								textLabel3.Text = "[" .. string.rep(".", n26) .. "]"
								task.wait(0.5)
							end
						end)
						v33 = __lph_capture_array_1000004[1]:connect(__lph_capture_array_1000004[3].InputBegan, function(arg4)
							
							if arg4.UserInputType == Enum.UserInputType.Touch then
								fn8(nil)
							else
								fn8(arg4.UserInputType == Enum.UserInputType.Keyboard and arg4.KeyCode or arg4.UserInputType)
							end
							__lph_capture_array_1000004[1]:disconnect(v33)
							task.wait()
							v33 = nil
							flag4 = true
						end)
					end
				end)
				tween_4.MouseButton2Click:Connect(function()
					
					frame.Visible = not frame.Visible
				end)
				local flag4 = false
				local n26 = 0
				tween_4.InputBegan:Connect(function(input)
					
					if input.UserInputType ~= Enum.UserInputType.Touch then
						return
					end
					flag4 = true
					n26 = tick()
					task.delay(1, function()
						
						if not flag4 then
							return
						end
						if tick() - n26 < 1 then
							return
						end
						frame.Visible = not frame.Visible
					end)
				end)
				tween_4.InputEnded:Connect(function(input)
					
					if input.UserInputType ~= Enum.UserInputType.Touch then
						return
					end
					flag4 = false
				end)
				local v37 = 290277741
				local function setbind(arg4, arg5)
					
					local n27 = bit32.bxor(v37 % 4294967296 - v37 % 4294967296 % 1, 0) + 138277343
					fn8(arg5)
				end
				
				v37 = 238617800
				tbl2.setbind = setbind
				local function remove(arg4)
					
					
					
					if arg4.InputBeganConnection then
						__lph_capture_array_1000004[1]:disconnect(arg4.InputBeganConnection)
						arg4.InputBeganConnection = nil
					end
					if arg4.InputEndedConnection then
						__lph_capture_array_1000004[1]:disconnect(arg4.InputEndedConnection)
						arg4.InputEndedConnection = nil
					end
					if v33 then
						__lph_capture_array_1000004[1]:disconnect(v33)
						v33 = nil
					end
					v32 = nil
					
					tbl2.key = nil
					local mobileKeybindButtons = __lph_capture_array_1000004[1].mobileKeybindButtons
					local v39 = tbl2
					
					mobileKeybindButtons[v39] = nil
					if tween_2 then
						tween_2:Destroy()
					end
					tween_4:Destroy()
					if frame then
						frame:Destroy()
					end
					if arg3.register ~= false and flag then
						
						__lph_capture_array_1000004[1].items[flag] = nil
						__lph_capture_array_1000004[1]:setflag(flag, nil)
						
					end
					if arg4.ownerToggle then
						local addons = arg4.ownerToggle.Addons
						if addons then
							local v41 = table.find(addons, arg4)
							if v41 then
								table.remove(addons, v41)
							end
						end
						arg4.ownerToggle.Keybind = nil
						arg4.ownerToggle.KeybindConfig = nil
					end
				end
				tbl2.Remove = remove
				
				local register = arg3.register
				
				
				if register ~= false then
					__lph_capture_array_1000004[1].items[flag] = tbl2
					__lph_capture_array_1000004[1].ConfigManager:Register(flag, tbl2)
				end
				tbl2:setlist(list)
				tbl2:setbind(default)
				
				tbl2:setmode(mode)
				
				if tbl2.mode ~= "Button" then
					tbl2:set(state)
				end
				if __lph_capture_array_1000004[1].mobileKeybindMode then
					tbl2:ApplyMobileKeybindMode()
				end
				return tbl2
			end
		end
		library.createkeybind = fn2(table.pack(library, tbl, userInputService, nil))
		local n10 = v13 - 2605873489 - 4169423600
		
		local function fn3(__lph_capture_array_1000003, __lph_unused_1)
			return function(arg2, arg3)
				
				
				
				local tbl2 = { cfg = arg3, type = "colorpicker" }
				local color = arg3.color or arg3.Color or Color3.new(1, 1, 1)
				local alpha = arg3.alpha
				if not alpha then
					
					alpha = arg3.Alpha
				end
				local v16 = alpha or nil
				local flag = arg3.flag or arg3.Flag or __lph_capture_array_1000003[1]:nextflag()
				local callback = arg3.callback or function()
					
				end
				local rainbow = false
				local v17 = 488438870
				local function setHSVFromRGB(arg4, arg5)
					
					local color2, v18, v19 = Color3.toHSV(arg5)
					local v20 = tbl2
					local v21 = tbl2
					local v22 = v17
					local n13
					if v22 % 4294967296 ~= v22 % 4294967296 then
						n13 = 0
					else
						n13 = v22 % 4294967296 - v22 % 4294967296 % 1
					end
					if bit32.bxor(n13, 0) == 808136 then
						local v23 = v17
						local n14
						if v23 % 4294967296 ~= v23 % 4294967296 then
							n14 = 0
						else
							n14 = v23 % 4294967296 - v23 % 4294967296 % 1
						end
						v17 = bit32.bxor(n14, 224049029)
					end
					v20.Hue = v21.Hue or color2 or 0
					if v18 > 0 then
						tbl2.Hue = color2
					end
					tbl2.Sat = v18
					tbl2.Vib = v19
				end
				
				v17 = 269911445
				tbl2.SetHSVFromRGB = setHSVFromRGB
				tbl2:SetHSVFromRGB(color)
				tbl2.Alpha = v16 or 0
				local tween_2 = __lph_capture_array_1000003[1]:Create("Frame", {
					Parent = arg2,
					BackgroundColor3 = __lph_capture_array_1000003[1].stroke2,
					BorderColor3 = Color3.new(0.11764705926179886, 0.11764705926179886, 0.11764705926179886),
					BorderSizePixel = 1,
					Size = UDim2.new(0, 24, 0.80000001192092896, 4),
					ZIndex = 8,
				})
				__lph_capture_array_1000003[1]:Create("UICorner", { Parent = tween_2, CornerRadius = UDim.new(0, 8) })
				local tween_3 = __lph_capture_array_1000003[1]:Create("Frame", {
					Parent = tween_2,
					BackgroundColor3 = __lph_capture_array_1000003[1].stroke,
					BorderColor3 = Color3.new(0.11764705926179886, 0.11764705926179886, 0.11764705926179886),
					BorderSizePixel = 1,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(1, -2, 1, -2),
					ZIndex = 9,
				})
				
				
				__lph_capture_array_1000003[1]:Create("UICorner", { Parent = tween_3, CornerRadius = UDim.new(0, 8) })
				local tween_4 = __lph_capture_array_1000003[1]:Create("TextButton", {
					Parent = tween_3,
					Text = "",
					BackgroundColor3 = color,
					BorderColor3 = Color3.new(0.11764705926179886, 0.11764705926179886, 0.11764705926179886),
					BorderSizePixel = 1,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(1, -2, 1, -2),
					AutoButtonColor = false,
					ZIndex = 10,
				})
				__lph_capture_array_1000003[1]:Create("UICorner", { Parent = tween_4, CornerRadius = UDim.new(0, 8) })
				__lph_capture_array_1000003[1]:tooltip(tween_4, arg3)
				__lph_capture_array_1000003[1]:mouseffects(tween_4, tween_3)
				local tween_5 = __lph_capture_array_1000003[1]:Create("Frame", {
					Parent = __lph_capture_array_1000003[1].ScreenGUI,
					BackgroundColor3 = __lph_capture_array_1000003[1].misccolor,
					BorderColor3 = Color3.new(0.11764705926179886, 0.11764705926179886, 0.11764705926179886),
					AnchorPoint = Vector2.new(0, 0),
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(0, 190, 0, 240),
					Visible = false,
					ZIndex = 25,
				})
				tween_5:SetAttribute("IsPopup", true)
				local function fn4()
					
					local absolutePosition = tween_4.AbsolutePosition
					local absoluteSize = tween_4.AbsoluteSize
					local parent = arg2.Parent.Parent
					local n14 = parent.AbsolutePosition.Y + 3
					local n15 = absolutePosition.Y + absoluteSize.Y + 6
					local n16 = n14 + 2
					if absolutePosition.Y + absoluteSize.Y > parent.AbsolutePosition.Y + parent.AbsoluteSize.Y then
						tween_5.Visible = false
					end
					tween_5.Position = UDim2.fromOffset(absolutePosition.X - 170, math.max(n15, n16))
				end
				__lph_capture_array_1000003[1]:connect(__lph_capture_array_1000003[2].RenderStepped, function()local j= tween_5 ;local r=j.Visible;if r then j= fn4 ;j();end;end)
				fn4()
				__lph_capture_array_1000003[1]:Create("UIStroke", {
					Color = __lph_capture_array_1000003[1].stroke,
					Thickness = 1,
					Parent = tween_5,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					LineJoinMode = Enum.LineJoinMode.Miter,
					ZIndex = 24,
				})
				__lph_capture_array_1000003[1]:Create("UIStroke", {
					Color = __lph_capture_array_1000003[1].stroke2,
					Thickness = 2,
					Parent = tween_5,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					LineJoinMode = Enum.LineJoinMode.Miter,
					ZIndex = 23,
				})
				__lph_capture_array_1000003[1]:Create("Frame", {
					Parent = tween_5,
					BackgroundColor3 = __lph_capture_array_1000003[1].accent,
					Size = UDim2.new(1, 0, 0, 2),
					Position = UDim2.new(0, 0, 0, 0),
					BorderSizePixel = 0,
					ZIndex = 25,
				})
				__lph_capture_array_1000003[1]:Create("Frame", {
					Parent = tween_5,
					BackgroundColor3 = Color3.new(0.12941177189350128, 0.070588238537311554, 0.18823529779911041),
					BackgroundTransparency = 0.5,
					Size = UDim2.new(1, 0, 0, 1),
					Position = UDim2.new(0, 0, 0, 1),
					BorderSizePixel = 0,
					ZIndex = 25,
				})
				local tween_6 = __lph_capture_array_1000003[1]:Create("TextBox", {
					Parent = tween_5,
					Text = "",
					FontFace = __lph_capture_array_1000003[1].font,
					BackgroundColor3 = __lph_capture_array_1000003[1].buttoncolor,
					BorderColor3 = Color3.new(0.11764705926179886, 0.11764705926179886, 0.11764705926179886),
					Size = UDim2.new(0, 177, 0, 18),
					AnchorPoint = Vector2.new(0, 0),
					Position = UDim2.new(0.029999999329447746, 0, 0.79500001668930054, 0),
					BorderSizePixel = 0,
					TextSize = 12,
					ClearTextOnFocus = false,
					TextColor3 = Color3.new(1, 1, 1),
					TextXAlignment = Enum.TextXAlignment.Center,
					ZIndex = 25,
				})
				local tween_7 = __lph_capture_array_1000003[1]:Create("UIStroke", {
					Color = __lph_capture_array_1000003[1].stroke,
					Thickness = 1,
					Parent = tween_6,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					LineJoinMode = Enum.LineJoinMode.Miter,
					ZIndex = 24,
				})
				__lph_capture_array_1000003[1]:Create("UIStroke", {
					Color = __lph_capture_array_1000003[1].stroke2,
					Thickness = 2,
					Parent = tween_6,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					LineJoinMode = Enum.LineJoinMode.Miter,
					ZIndex = 23,
				})
				__lph_capture_array_1000003[1]:Create("ImageLabel", {
					Parent = tween_6,
					Image = "rbxassetid://87505091287358",
					ImageTransparency = 0.8,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(1, 0, 1, 0),
					ZIndex = 30,
				})
				__lph_capture_array_1000003[1]:mouseffects(tween_6, tween_7)
				local tween_8 = __lph_capture_array_1000003[1]:Create("ImageButton", {
					Parent = tween_5,
					Image = "rbxassetid://132886931979102",
					BorderColor3 = Color3.new(0.11764705926179886, 0.11764705926179886, 0.11764705926179886),
					BorderSizePixel = 0,
					AnchorPoint = Vector2.new(0, 0),
					Position = UDim2.new(0.029999999329447746, 0, 0.05000000074505806, -2),
					Size = UDim2.new(0, 157, 0, 157),
					AutoButtonColor = false,
					ZIndex = 25,
				})
				local function fn5(arg4, arg5)
					
					local v20 = workspace
					local n14 = arg4 + #tostring({}) + tick() + string.unpack("xxx", tostring({})) + v20:GetServerTimeNow() + os.clock()
					local n15 = 255293048
					local function fn6(arg6)
						
						local v21 = n14
						local n16 = bit32.bxor(n15 % 4294967296 - n15 % 4294967296 % 1, 0) + 234899760
						return v21 == arg6 and (n14 % 832 + 77) % 537 + n14 % 537
					end
					local v21 = bit32.bxor(arg5 % 4294967296 - arg5 % 4294967296 % 1, 475015354)
					n15 = bit32.bxor(255293048, v21 % 4294967296 - v21 % 4294967296 % 1)
					return n14, fn6
				end
				local v20, v21 = fn5(0, 319338038)
				local tbl3 = {}
				tbl3[#tbl3 + 1] = v20
				local function fn6(arg4, arg5)
					
					local function fn7(arg6)
						
						local n14
						if arg6 % 4294967296 ~= arg6 % 4294967296 then
							n14 = 0
						else
							n14 = arg6 % 4294967296 - arg6 % 4294967296 % 1
						end
						if n14 == 487361292 then
							local n15
							if arg6 % 4294967296 ~= arg6 % 4294967296 then
								n15 = 0
							else
								n15 = arg6 % 4294967296 - arg6 % 4294967296 % 1
							end
							bit32.bxor(n15, 2222689921)
						end
						return arg4
					end
					local n14 = arg5 + 239617347
					return fn7
				end
				
				
				
				
				
				
				
				local v28 = fn6(v20, 219314300)
				local n15 = (v20 % 293 + 272) * 16 % 932
				local n16 = (v20 % 293 + 272) * 16 % 932
				
				
				
				do
do

						do
do
if v28(39003167) == v20 then
								local tween_9 = __lph_capture_array_1000003[1]:Create("UIStroke", {
									Color = __lph_capture_array_1000003[1].stroke,
									Thickness = 1,
									Parent = tween_8,
									ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
									LineJoinMode = Enum.LineJoinMode.Miter,
									ZIndex = 25,
								})
								__lph_capture_array_1000003[1]:Create("UIStroke", {
									Color = __lph_capture_array_1000003[1].stroke2,
									Thickness = 2,
									Parent = tween_8,
									ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
									LineJoinMode = Enum.LineJoinMode.Miter,
									ZIndex = 23,
								})
								local tween_10 = __lph_capture_array_1000003[1]:Create("Frame", {
									Parent = tween_8,
									BackgroundColor3 = Color3.new(0.11764705926179886, 0.11764705926179886, 0.11764705926179886),
									BorderColor3 = Color3.new(1, 1, 1),
									AnchorPoint = Vector2.new(0.5, 0.5),
									Size = UDim2.new(0, 2, 0, 2),
									ZIndex = 30,
								})
								tween_10:SetAttribute("TextDisabled", true)
								__lph_capture_array_1000003[1]:mouseffects(tween_8, tween_9)
								local tween_11 = __lph_capture_array_1000003[1]:Create("TextButton", {
									Parent = tween_5,
									Text = "",
									BorderColor3 = Color3.new(0.11764705926179886, 0.11764705926179886, 0.11764705926179886),
									BorderSizePixel = 0,
									BackgroundColor3 = Color3.new(1, 1, 1),
									BackgroundTransparency = 0,
									Position = UDim2.new(0.87000000476837158, 3, 0.05000000074505806, -2),
									Size = UDim2.new(0.079999998211860657, -1, 0, 157),
									AutoButtonColor = false,
									ZIndex = 27,
								})
								tween_11:SetAttribute("TextDisabled", true)
								local tween_12 = __lph_capture_array_1000003[1]:Create("UIStroke", {
									Color = __lph_capture_array_1000003[1].stroke,
									Thickness = 1,
									Parent = tween_11,
									ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
									LineJoinMode = Enum.LineJoinMode.Miter,
									ZIndex = 25,
								})
								__lph_capture_array_1000003[1]:Create("UIStroke", {
									Color = __lph_capture_array_1000003[1].stroke2,
									Thickness = 2,
									Parent = tween_11,
									ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
									LineJoinMode = Enum.LineJoinMode.Miter,
									ZIndex = 23,
								})
								local tween_13 = __lph_capture_array_1000003[1]:Create("Frame", {
									Parent = tween_5,
									BorderSizePixel = 0,
									AnchorPoint = Vector2.new(0, 0),
									Position = UDim2.new(0.029999999329447746, 0, 0.69999998807907104, 5),
									Size = UDim2.new(0, 177, 0, 12),
									Visible = true,
									ZIndex = 25,
								})
								local tween_14 = __lph_capture_array_1000003[1]:Create("ImageButton", {
									Parent = tween_13,
									Image = "rbxassetid://127711021512810",
									BorderColor3 = Color3.new(0.11764705926179886, 0.11764705926179886, 0.11764705926179886),
									BorderSizePixel = 0,
									AnchorPoint = Vector2.new(0, 0),
									Position = UDim2.new(0, 0, 0, 0),
									Size = UDim2.new(1, 0, 1, 0),
									AutoButtonColor = false,
									ScaleType = Enum.ScaleType.Tile,
									TileSize = UDim2.new(0, 8, 0, 8),
									BackgroundTransparency = 1,
									ZIndex = 25,
								})
								local tween_15 = __lph_capture_array_1000003[1]:Create("Frame", {
									Parent = tween_13,
									Size = UDim2.new(1, 0, 1, 0),
									BorderSizePixel = 0,
									BackgroundColor3 = color,
									ZIndex = 25,
								})
								__lph_capture_array_1000003[1]:Create("UIGradient", {
									Rotation = 190,
									Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) }),
									Parent = tween_15,
								})
								local tween_16 = __lph_capture_array_1000003[1]:Create("UIStroke", {
									Color = __lph_capture_array_1000003[1].stroke,
									Thickness = 1,
									Parent = tween_13,
									ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
									LineJoinMode = Enum.LineJoinMode.Miter,
									ZIndex = 25,
								})
								__lph_capture_array_1000003[1]:Create("UIStroke", {
									Color = __lph_capture_array_1000003[1].stroke2,
									Thickness = 2,
									Parent = tween_13,
									ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
									LineJoinMode = Enum.LineJoinMode.Miter,
									ZIndex = 23,
								})
								local tween_17 = __lph_capture_array_1000003[1]:Create("TextButton", {
									Parent = tween_5,
									Text = "Rainbow: Off",
									FontFace = __lph_capture_array_1000003[1].font,
									BackgroundColor3 = __lph_capture_array_1000003[1].buttoncolor,
									BorderColor3 = Color3.new(0.11764705926179886, 0.11764705926179886, 0.11764705926179886),
									Size = UDim2.new(0, 177, 0, 18),
									AnchorPoint = Vector2.new(0, 0),
									BorderSizePixel = 0,
									Position = UDim2.new(0.029999999329447746, 0, 0.89999997615814209, 0),
									TextSize = 12,
									AutoButtonColor = false,
									TextColor3 = Color3.new(1, 1, 1),
									TextXAlignment = Enum.TextXAlignment.Center,
									ZIndex = 25,
								})
								local tween_18 = __lph_capture_array_1000003[1]:Create("UIStroke", {
									Color = __lph_capture_array_1000003[1].stroke,
									Thickness = 1,
									Parent = tween_17,
									ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
									LineJoinMode = Enum.LineJoinMode.Miter,
									ZIndex = 24,
								})
								__lph_capture_array_1000003[1]:Create("UIStroke", {
									Color = __lph_capture_array_1000003[1].stroke2,
									Thickness = 2,
									Parent = tween_17,
									ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
									LineJoinMode = Enum.LineJoinMode.Miter,
									ZIndex = 23,
								})
								__lph_capture_array_1000003[1]:Create("ImageLabel", {
									Parent = tween_17,
									Image = "rbxassetid://87505091287358",
									ImageTransparency = 0.8,
									BackgroundTransparency = 1,
									BorderSizePixel = 0,
									Position = UDim2.new(0, 0, 0, 0),
									Size = UDim2.new(1, 0, 1, 0),
									ZIndex = 30,
								})
								__lph_capture_array_1000003[1]:mouseffects(tween_17, tween_18)
								local tween_19 = __lph_capture_array_1000003[1]:Create("Frame", {
									Parent = tween_11,
									BackgroundColor3 = Color3.new(0.11764705926179886, 0.11764705926179886, 0.11764705926179886),
									BorderColor3 = Color3.new(1, 1, 1),
									AnchorPoint = Vector2.new(0.5, 0),
									Size = UDim2.new(0, 0, 1, 0),
									Position = UDim2.new(0.5, 0, 0, 0),
									ZIndex = 30,
								})
								tween_19:SetAttribute("TextDisabled", true)
								local udim2 = UDim2.new
								
								
								
								
								
								tween_19.Size = udim2(0, tween_11.AbsoluteSize.X + 1, 0, 1)
								tween_19.Position = UDim2.new(0.5, 0, 0, tbl2.Hue * (tween_11.AbsoluteSize.Y - 2))
								local tween_20 = __lph_capture_array_1000003[1]:Create("Frame", {
									Parent = tween_13,
									BackgroundColor3 = Color3.new(0.11764705926179886, 0.11764705926179886, 0.11764705926179886),
									BorderColor3 = Color3.new(1, 1, 1),
									AnchorPoint = Vector2.new(0.5, 0),
									Size = UDim2.new(0, 0, 1, 0),
									Position = UDim2.new(0.5, 0, 0, 0),
									ZIndex = 30,
								})
								tween_20.AnchorPoint = Vector2.new(0.5, 0.5)
								tween_20.Size = UDim2.new(0, 1, 0, tween_13.AbsoluteSize.Y)
								tween_20.Position = UDim2.new(0, 0, 0.5, 0)
								
								
								tween_20:SetAttribute("TextDisabled", true)
								__lph_capture_array_1000003[1]:mouseffects(tween_11, tween_12)
								__lph_capture_array_1000003[1]:mouseffects(tween_13, tween_16)
								local tbl4 = {}
								for i = 0, 1, 0.1 do
									table.insert(tbl4, ColorSequenceKeypoint.new(i, Color3.fromHSV(i, 1, 1)))
								end
								__lph_capture_array_1000003[1]:Create("UIGradient", {
									Parent = tween_11,
									Rotation = 90,
									Color = ColorSequence.new(tbl4),
									Offset = Vector2.new(0.05000000074505806, 0),
								})
								if v16 == nil then
									tween_5.Size = UDim2.new(0, 190, 0, 216)
									tween_13.Visible = false
									tween_17.Size = UDim2.new(0, 177, 0, 16)
									tween_6.Size = UDim2.new(0, 177, 0, 16)
									
									
								end
								
								local function updatevisuals()
  local hue = tbl2.Hue or 0
  local sat = tbl2.Sat or 0
  local vib = tbl2.Vib or 0
  local alpha = tbl2.Alpha or 0
  local color = Color3.fromHSV(hue,sat,vib)
  tween_4.BackgroundColor3 = color
  tween_4.BackgroundTransparency = alpha
  tween_8.BackgroundColor3 = Color3.fromHSV(hue,1,1)
  tween_8.ImageColor3 = Color3.new(1,1,1)
  tween_15.BackgroundColor3 = color
  tween_6.Text = table.concat({math.floor(color.R*255),math.floor(color.G*255),math.floor(color.B*255)},', ')
  tween_10.Position = UDim2.new(sat,0,1-vib,0)
  tween_19.Position = UDim2.new(0.5,0,0,math.clamp(hue*(tween_11.AbsoluteSize.Y-2),0,tween_11.AbsoluteSize.Y-2))
  if v16 ~= nil then
   tween_20.Position = UDim2.new(0,1+alpha*(tween_13.AbsoluteSize.X-2),0.5,0)
  end
 end
								
								
								
								tbl2.updatevisuals = updatevisuals
								tbl2.set = function(arg4, arg5, arg6)
									
									
									if arg5 then
										tbl2:SetHSVFromRGB(arg5)
									end
									if arg6 ~= nil then
										local v31 = tbl2
										
										v31.Alpha = math.clamp(arg6, 0, 1)
										
									else
										tbl2.Alpha = tbl2.Alpha or 0
									end
									local color2 = Color3.fromHSV(tbl2.Hue or 0, tbl2.Sat or 0, tbl2.Vib or 0)
									tbl2.value = color2
									tbl2.transparency = tbl2.Alpha
									__lph_capture_array_1000003[1]:setflag(flag, { Color = color2, Alpha = tbl2.Alpha })
									tbl2:updatevisuals()
									callback(color2, tbl2.Alpha)
								end
								local function fn7()
									
									tbl2:set(Color3.fromHSV(tbl2.Hue or 0, tbl2.Sat or 0, tbl2.Vib or 0), tbl2.Alpha)
								end
								__lph_capture_array_1000003[1]:connect(tween_8.InputBegan, function(arg4)
									
									local flag2 = arg4.UserInputType ~= Enum.UserInputType.MouseButton1
									if flag2 and arg4.UserInputType ~= Enum.UserInputType.Touch then
										return
									end
									tween_10.Visible = true
									while arg4.UserInputType == Enum.UserInputType.Touch and arg4.UserInputState ~= Enum.UserInputState.End or arg4.UserInputType == Enum.UserInputType.MouseButton1 and __lph_capture_array_1000003[4]:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
										local x = arg4.UserInputType == Enum.UserInputType.Touch and arg4.Position.X or __lph_capture_array_1000003[5].X
										local y = arg4.UserInputType == Enum.UserInputType.Touch and arg4.Position.Y or __lph_capture_array_1000003[5].Y
										local n29 = math.clamp(x - tween_8.AbsolutePosition.X, 0, tween_8.AbsoluteSize.X)
										local n30 = math.clamp(y - tween_8.AbsolutePosition.Y, 0, tween_8.AbsoluteSize.Y)
										tbl2.Sat = n29 / tween_8.AbsoluteSize.X
										tbl2.Vib = 1 - n30 / tween_8.AbsoluteSize.Y
										fn7()
										__lph_capture_array_1000003[2].RenderStepped:Wait()
									end
								end)
								local v31 = __lph_capture_array_1000003[1]
								local connect = v31.connect
								local inputBegan = tween_11.InputBegan
								local v32 = 411791038
								local function fn8(arg4)
									
									
									local userInputType = arg4.UserInputType
									local userInputType2 = Enum.UserInputType
									bit32.bxor(v32 % 4294967296 - v32 % 4294967296 % 1, 0)
									local flag2 = userInputType ~= userInputType2.MouseButton1
									local flag3
									if flag2 then
										
										flag3 = arg4.UserInputType ~= Enum.UserInputType.Touch
									else
										flag3 = flag2
									end
									if flag3 then
										return
									end
									while arg4.UserInputType == Enum.UserInputType.Touch and arg4.UserInputState ~= Enum.UserInputState.End or arg4.UserInputType == Enum.UserInputType.MouseButton1 and __lph_capture_array_1000003[4]:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
										local y = arg4.UserInputType == Enum.UserInputType.Touch and arg4.Position.Y or __lph_capture_array_1000003[5].Y
										local n30 = tween_11.AbsoluteSize.Y - 2
										tbl2.Hue = math.clamp(y - tween_11.AbsolutePosition.Y, 0, n30) / n30
										fn7()
										__lph_capture_array_1000003[2].RenderStepped:Wait()
									end
								end
								
								v32 = 533080645
								connect(v31, inputBegan, fn8)
								local v34 = __lph_capture_array_1000003[1]
								local function fn9(arg4)
									
									
									local flag2 = arg4.UserInputType ~= Enum.UserInputType.MouseButton1
									if flag2 then
										
										flag2 = arg4.UserInputType ~= Enum.UserInputType.Touch
									end
									if flag2 then
										return
									end
									while arg4.UserInputType == Enum.UserInputType.Touch and arg4.UserInputState ~= Enum.UserInputState.End or arg4.UserInputType == Enum.UserInputType.MouseButton1 and __lph_capture_array_1000003[4]:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
										tbl2.Alpha = math.clamp(math.clamp((arg4.UserInputType == Enum.UserInputType.Touch and arg4.Position.X or __lph_capture_array_1000003[5].X) - tween_13.AbsolutePosition.X, 0, tween_13.AbsoluteSize.X) / (tween_13.AbsoluteSize.X - 1), 0, 1)
										fn7()
										__lph_capture_array_1000003[2].RenderStepped:Wait()
									end
								end
								__lph_capture_array_1000003[1]:connect(tween_14.InputBegan, fn9)
								local focusLost = tween_6.FocusLost
								
								local connect2 = focusLost.Connect
								local v35 = 466139151
								local function fn10(arg4)
									
									if arg4 then
										local match, v36, v37 = tween_6.Text:match("(%d+),%s*(%d+),%s*(%d+)")
										local num = tonumber(match)
										local num2 = tonumber(v36)
										local num3 = tonumber(v37)
										if num and num2 and num3 then
											local n30 = math.clamp(num, 0, 255)
											local n31 = math.clamp(num2, 0, 255)
											local n32 = math.clamp(num3, 0, 255)
											tbl2:set(Color3.fromRGB(n30, n31, n32), tbl2.Alpha)
											return
										end
									end
									local v36 = v35
									local v37, v38
									if v36 % 4294967296 ~= v36 % 4294967296 then
										v37 = table.pack(0)
										v38 = 0
									else
										v37 = table.pack(bit32.bxor(v36 % 4294967296 - v36 % 4294967296 % 1, 0))
										v38 = v37[1]
									end
									local flag2 = v38 == 131517757
									if not flag2 then
									end
									if flag2 == 200412176 then
										local v39 = v35
										local n30
										if v39 % 4294967296 ~= v39 % 4294967296 then
											n30 = 0
										else
											n30 = v39 % 4294967296 - v39 % 4294967296 % 1
										end
										v35 = bit32.bxor(n30, 968312767)
									end
									fn7()
								end
								
								v35 = 131517757
								connect2(focusLost, fn10)
								local v37 = nil
								tbl2.setrainbow = function(arg4, arg5)
									
									
									
									rainbow = arg5 and true or false
									tbl2.rainbow = rainbow
									tween_17:SetAttribute("Selected", rainbow)
									if v37 then
										v37:Disconnect()
										v37 = nil
									end
									if rainbow then
										tween_17.Text = "Rainbow: On"
										tween_17.TextColor3 = __lph_capture_array_1000003[1].accent
										tween_17:SetAttribute("AccentProps", "TextColor3")
										v37 = __lph_capture_array_1000003[1]:connect(__lph_capture_array_1000003[2].RenderStepped, function()local j,p=tick()*0.2%1;local p= tbl2 ;p:set(Color3.fromHSV(j,1,1), tbl2 .Alpha);end)
									else
										tween_17.Text = "Rainbow: Off"
										tween_17.TextColor3 = __lph_capture_array_1000003[1].textcolor
										tween_17:SetAttribute("AccentProps", nil)
										
										tween_17:SetAttribute("Selected", false)
										
									end
								end
								__lph_capture_array_1000003[1]:connect(tween_17.Activated, function()
									
									tbl2:setrainbow(not tbl2.rainbow)
								end)
								if not v34 then
								end
								return nil, tween_5
							end
							
end
end
end
end
			end
		end
		library.createcolorpicker = fn3(table.pack(library, runService, nil, userInputService, mouse))
		local tbl2, settings, n11, v16, n12
		do
			local v17 = n8
			bit32.bxor(v15, 2880812973)
			
			local function fn4(__lph_capture_array_1000021, __lph_unused_1)
				return function(arg2)
					local content = arg2.Content
					local parentTab = arg2.ParentTab
					local function fn5(arg3, frame, name_)
						
						arg3.Frame = frame
						arg3.Tab = parentTab
						arg3.Content = content
						arg3.Name = name_
						local lower = string.lower
						arg3.SearchText = lower(tostring(name_ or ""))
						table.insert(__lph_capture_array_1000021[1].tables, arg3)
					end
					arg2.toggle = function(arg3, arg4)
						
						
						
						
						local ownerToggle = { cfg = arg4, type = "toggle" }
						ownerToggle.Addons = {}
						ownerToggle.Keybind = nil
						local name_ = arg4.name
						local name_2 = name_ or arg4.Name or "Toggle"
						local state = arg4.state or arg4.State or false
						local flag = arg4.flag
						local v18
						if flag then
							v18 = flag
						else
							
							
							local flag2 = arg4.Flag
							
							v18 = flag2
						end
						local v19
						if v18 then
							v19 = v18
						else
							local v20 = __lph_capture_array_1000021[1]:nextflag()
							
							
							
							
							
							
							
							
							
							v19 = v20
						end
						if not arg4.tooltip then
							local tooltip = arg4.Tooltip
						end
						local callback = arg4.callback or arg4.Callback or function()
							
						end
						local value = state
						local flag2 = false
						local flag3 = false
						local tween_2 = __lph_capture_array_1000021[1]:Create("Frame", {
							Parent = content,
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, 20),
							ClipsDescendants = false,
							ZIndex = 8,
						})
						ownerToggle.Frame = tween_2
						local tween_3 = __lph_capture_array_1000021[1]:Create("TextButton", {
							Parent = tween_2,
							Text = "",
							Position = UDim2.new(0, 0, 0, 0),
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 1, 0),
							ClipsDescendants = false,
							AutoButtonColor = false,
							ZIndex = 8,
						})
						
						local tween_4 = __lph_capture_array_1000021[1]:Create("TextButton", {
							Parent = __lph_capture_array_1000021[1].ScreenGUI,
							Text = "",
							BackgroundColor3 = __lph_capture_array_1000021[1].buttoncolor,
							AnchorPoint = Vector2.new(0, 0),
							Position = UDim2.new(0, 0, 0, 0),
							BackgroundTransparency = 0,
							Size = UDim2.new(0, 120, 0, 16),
							ClipsDescendants = true,
							Visible = false,
							AutoButtonColor = false,
							ZIndex = 25,
						})
						local tween_5 = __lph_capture_array_1000021[1]:Create("TextButton", {
							Parent = tween_4,
							FontFace = __lph_capture_array_1000021[1].font,
							TextColor3 = __lph_capture_array_1000021[1].textcolor,
							Text = "",
							TextSize = 12,
							BackgroundColor3 = __lph_capture_array_1000021[1].buttoncolor,
							TextXAlignment = Enum.TextXAlignment.Center,
							TextYAlignment = Enum.TextYAlignment.Center,
							BorderSizePixel = 0,
							Position = UDim2.new(0, 0, 0, -2),
							BackgroundTransparency = 0,
							Size = UDim2.new(1, 0, 1, 2),
							ClipsDescendants = false,
							AutoButtonColor = false,
							ZIndex = 25,
						})
						__lph_capture_array_1000021[1]:Create("ImageLabel", {
							Parent = tween_4,
							Image = "rbxassetid://87505091287358",
							ImageTransparency = 0.55,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Position = UDim2.new(0, -1, 0, -1),
							Size = UDim2.new(1, 2, 1, 2),
							ZIndex = 24,
						})
						tween_4:SetAttribute("IsPopup", true)
						tween_4:SetAttribute("DropdownMenu", true)
						local tween_6 = __lph_capture_array_1000021[1]:Create("UIStroke", {
							Color = __lph_capture_array_1000021[1].stroke,
							Thickness = 1,
							Parent = tween_4,
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							LineJoinMode = Enum.LineJoinMode.Miter,
							ZIndex = 24,
						})
						__lph_capture_array_1000021[1]:Create("UIStroke", {
							Color = __lph_capture_array_1000021[1].stroke2,
							Thickness = 2,
							Parent = tween_4,
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							LineJoinMode = Enum.LineJoinMode.Miter,
							ZIndex = 23,
						})
						__lph_capture_array_1000021[1]:mouseffects(tween_5, tween_6)
						local tween_7 = __lph_capture_array_1000021[1]:Create("Frame", {
							Parent = tween_2,
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.new(0.045000001788139343, 0, 0.55000001192092896, -1),
							Size = UDim2.new(0, 16, 0, 16),
							BorderSizePixel = 0,
							BackgroundColor3 = __lph_capture_array_1000021[1].stroke2,
							ClipsDescendants = false,
							ZIndex = 6,
						})
						__lph_capture_array_1000021[1]:Create("UICorner", { Parent = tween_7, CornerRadius = UDim.new(0, 4) })
						local tween_8 = __lph_capture_array_1000021[1]:Create("Frame", {
							Parent = tween_7,
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.new(0.5, 0, 0.5, 0),
							Size = UDim2.new(0, 14, 0, 14),
							BorderSizePixel = 0,
							BackgroundTransparency = 0,
							BackgroundColor3 = __lph_capture_array_1000021[1].stroke,
							ClipsDescendants = false,
							ZIndex = 7,
						})
						__lph_capture_array_1000021[1]:Create("UICorner", { Parent = tween_8, CornerRadius = UDim.new(0, 4) })
						local tween_9 = __lph_capture_array_1000021[1]:Create("Frame", {
							Parent = tween_8,
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.new(0.5, 0, 0.5, 0),
							Size = UDim2.new(0, 12, 0, 12),
							BorderSizePixel = 0,
							BackgroundTransparency = 0,
							BackgroundColor3 = __lph_capture_array_1000021[1].buttoncolor,
							ClipsDescendants = false,
							ZIndex = 8,
						})
						__lph_capture_array_1000021[1]:Create("UICorner", { Parent = tween_9, CornerRadius = UDim.new(0, 4) })
						__lph_capture_array_1000021[1]:Create("ImageLabel", {
							Parent = tween_9,
							Image = "rbxassetid://87505091287358",
							ImageTransparency = 1,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Position = UDim2.new(0, -1, 0, -1),
							Size = UDim2.new(1, 2, 1, 2),
							ZIndex = 8,
						})
						__lph_capture_array_1000021[1]:Create("TextLabel", {
							Parent = tween_2,
							Text = name_2,
							FontFace = __lph_capture_array_1000021[1].font,
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							TextSize = 12,
							TextColor3 = __lph_capture_array_1000021[1].textcolor,
							Position = UDim2.new(0, 30, 0.25, 0),
							Size = UDim2.new(0, 0, 0, 8),
							TextXAlignment = Enum.TextXAlignment.Left,
							ZIndex = 8,
						})
						local function fn6()
							
							
							
							if value then
								
								tween_9.BackgroundColor3 = __lph_capture_array_1000021[1].accent
								__lph_capture_array_1000021[1]:setaccentstate(tween_9, "BackgroundColor3", true)
								tween_9:SetAttribute("ButtonDisabled", true)
								tween_8.BackgroundColor3 = __lph_capture_array_1000021[1].accent
								tween_8:SetAttribute("StrokeDisabled", true)
								__lph_capture_array_1000021[1]:setaccentstate(tween_8, "Color", true)
								if flag3 then
									tween_7.BackgroundColor3 = __lph_capture_array_1000021[1].stroke2
									tween_7:SetAttribute("Stroke2Disabled", false)
									__lph_capture_array_1000021[1]:setaccentstate(tween_7, "Color", false)
								elseif flag2 then
									
									
									tween_7.BackgroundColor3 = __lph_capture_array_1000021[1].accent
									tween_7:SetAttribute("Stroke2Disabled", true)
									
									__lph_capture_array_1000021[1]:setaccentstate(tween_7, "Color", true)
									
									
								else
									tween_7.BackgroundColor3 = __lph_capture_array_1000021[1].stroke2
									tween_7:SetAttribute("Stroke2Disabled", false)
									__lph_capture_array_1000021[1]:setaccentstate(tween_7, "Color", false)
								end
							else
								tween_9.BackgroundColor3 = __lph_capture_array_1000021[1].buttoncolor
								__lph_capture_array_1000021[1]:setaccentstate(tween_9, "BackgroundColor3", false)
								tween_9:SetAttribute("ButtonDisabled", false)
								tween_7.BackgroundColor3 = __lph_capture_array_1000021[1].stroke2
								tween_7:SetAttribute("StrokeDisabled", true)
								__lph_capture_array_1000021[1]:setaccentstate(tween_7, "Color", false)
								if flag3 then
									tween_8.BackgroundColor3 = __lph_capture_array_1000021[1].stroke
									tween_8:SetAttribute("StrokeDisabled", false)
									__lph_capture_array_1000021[1]:setaccentstate(tween_8, "Color", false)
								elseif flag2 then
									local v20 = tween_8
									
									v20.BackgroundColor3 = __lph_capture_array_1000021[1].accent
									tween_8:SetAttribute("StrokeDisabled", true)
									__lph_capture_array_1000021[1]:setaccentstate(tween_8, "Color", true)
									
									
								else
									tween_8.BackgroundColor3 = __lph_capture_array_1000021[1].stroke
									tween_8:SetAttribute("StrokeDisabled", false)
									__lph_capture_array_1000021[1]:setaccentstate(tween_8, "Color", false)
								end
							end
						end
						local function fn7()
							
							flag2 = true
							fn6()
						end
						tween_3.MouseEnter:Connect(fn7)
						local mouseLeave = tween_3.MouseLeave
						local connect = mouseLeave.Connect
						local v20 = 158682188
						local function fn8()
							
							flag2 = false
							flag3 = false
							local flag4 = bit32.bxor(v20 % 4294967296 - v20 % 4294967296 % 1, 0) ~= 167727905
							fn6()
						end
						
						v20 = 167727905
						connect(mouseLeave, fn8)
						tween_3.MouseButton1Down:Connect(function()
							
							flag3 = true
							fn6()
						end)
						tween_3.MouseButton1Up:Connect(function()
							
							flag3 = false
							fn6()
						end)
						local function fn9()
							
							local parent = tween_2.Parent
							while parent do
								if parent:IsA("ScrollingFrame") then
									return parent
								end
								parent = parent.Parent
							end
							return content
						end
						local function fn10()
							
							
							local absolutePosition = tween_2.AbsolutePosition
							local absoluteSize = tween_2.AbsoluteSize
							local v21 = fn9()
							local y = v21.AbsolutePosition.Y
							local n18 = y + v21.AbsoluteSize.Y
							local x = v21.AbsolutePosition.X
							local n19 = x + v21.AbsoluteSize.X
							
							local y2 = absolutePosition.Y
							local n21 = y2 + absoluteSize.Y
							local x2 = absolutePosition.X
							local n22 = x2 + absoluteSize.X
							if not tween_2.Visible or not content.Visible or not v21.Visible or n21 <= y or y2 >= n18 or n22 <= x or x2 >= n19 then
								tween_4.Visible = false
								return false
							end
							local max = math.max
							local floor = math.floor
							local x3 = absoluteSize.X
							
							local v23 = max(floor(x3 * 0.5), 120)
							local n23 = absolutePosition.X + (absoluteSize.X - v23) / 2
							
							
							
							local n27 = absolutePosition.Y + absoluteSize.Y + 2
							local currentCamera = workspace.CurrentCamera
							currentCamera = currentCamera and currentCamera.ViewportSize or Vector2.new(0, 0)
							if currentCamera.Y > 0 and n27 + 16 > currentCamera.Y - 2 then
								n27 = absolutePosition.Y - 16 - 2
							end
							if currentCamera.X > 0 then
								local clamp = math.clamp
								
								n23 = clamp(n23, 2, math.max(2, currentCamera.X - v23 - 2))
							end
							tween_4.Size = UDim2.fromOffset(v23, 16)
							tween_4.Position = UDim2.fromOffset(n23, n27)
							return true
						end
						local function fn11(arg5)
							
							__lph_capture_array_1000021[1]:hidepopups(arg5)
						end
						local function fn12(visible)
							
							if ownerToggle.Keybind then
								tween_5.Text = "Remove Keybind"
							else
								tween_5.Text = "Add Keybind"
							end
							if visible then
								if not fn10() then
									tween_4.Visible = false
									return
								end
								fn11(tween_4)
							end
							tween_4.Visible = visible
						end
						__lph_capture_array_1000021[1]:connect(__lph_capture_array_1000021[2].RenderStepped, function()local j= tween_4 ;local r=j.Visible;if r then j= fn10 ;j();end;end)
						local mouseButton2Click = tween_3.MouseButton2Click
						local connect2 = mouseButton2Click.Connect
						local n17 = 394622939
						local function fn13()
							
							local visible = tween_4.Visible
							local flag4 = bit32.bxor(bit32.bxor(n17 % 4294967296 - n17 % 4294967296 % 1, 0), 205379572) ~= 120141645
							fn12(not visible)
						end
						
						n17 = 185917625
						connect2(mouseButton2Click, fn13)
						
						local flag4 = false
						local n20 = 0
						tween_3.InputBegan:Connect(function(input)
							
							if input.UserInputType ~= Enum.UserInputType.Touch then
								return
							end
							flag4 = true
							n20 = tick()
							local function fn14()
								
								if not flag4 then
									return
								end
								if tick() - n20 < 1 then
									return
								end
								fn12(not tween_4.Visible)
							end
							task.delay(1, fn14)
						end)
						tween_3.InputEnded:Connect(function(input)
							
							if input.UserInputType ~= Enum.UserInputType.Touch then
								return
							end
							flag4 = false
						end)
						local tween_10 = __lph_capture_array_1000021[1]:Create("Frame", {
							Parent = tween_2,
							AnchorPoint = Vector2.new(0, 0.5),
							Position = UDim2.new(1, -20, 0, 5),
							AnchorPoint = Vector2.new(1, 0),
							BackgroundTransparency = 1,
							Size = UDim2.new(0, 36, 0, 10),
							ClipsDescendants = false,
							ZIndex = 8,
						})
						__lph_capture_array_1000021[1]:Create("UIListLayout", {
							Parent = tween_10,
							Padding = UDim.new(0.15000000596046448, 0),
							FillDirection = Enum.FillDirection.Horizontal,
							HorizontalAlignment = Enum.HorizontalAlignment.Right,
							VerticalAlignment = Enum.VerticalAlignment.Center,
						})
						tween_9:SetAttribute("AccentProps", "BackgroundColor3")
						tween_8:SetAttribute("AccentProps", "Color")
						
						tween_7:SetAttribute("AccentProps", "Color")
						local function set_(arg5, arg6)
							
							
							
							value = arg6 and true or false
							ownerToggle.value = value
							__lph_capture_array_1000021[1]:setflag(v19, value)
							local v21 = tween_9
							
							local accent = value
							if value then
								accent = __lph_capture_array_1000021[1].accent
							end
							v21.BackgroundColor3 = accent or __lph_capture_array_1000021[1].buttoncolor
							tween_9:SetAttribute("ButtonDisabled", value)
							__lph_capture_array_1000021[1]:setaccentstate(tween_9, "BackgroundColor3", value)
							fn6()
							
							for _, v22 in next, ownerToggle.Addons, nil do
								if v22.type == "keybind" and v22.sync == true and v22.mode ~= "Button" and v22.Mode ~= "Button" then
									v22:set(value, true, true)
								elseif v22.type ~= "keybind" and v22.show then
									v22:show(value)
								end
							end
							callback(value, ownerToggle)
						end
						ownerToggle.set = set_
						
						tween_3.MouseButton1Click:Connect(function()
							
							ownerToggle:set(not value)
						end)
						ownerToggle.show = function(arg5, arg6)
							
							tween_2.Visible = arg6 == true
						end
						local v22 = nil
						ownerToggle.keybind = function(arg5, keybindConfig)
							
							
							
							if ownerToggle.Keybind then
								return ownerToggle.Keybind
							end
							keybindConfig = keybindConfig or {}
							keybindConfig.parentname = name_2
							keybindConfig.flag = keybindConfig.flag or v19 .. "_keybind"
							keybindConfig.register = false
							if keybindConfig.sync and keybindConfig.mode ~= "Button" and keybindConfig.Mode ~= "Button" then
								local n24 = 348480069
								local function callback2(arg6)
									
									local v23 = n24
									local n25
									if v23 % 4294967296 ~= v23 % 4294967296 then
										n25 = 0
									else
										n25 = v23 % 4294967296 - v23 % 4294967296 % 1
									end
									if bit32.bxor(bit32.bxor(n25, 0), 164990047) ~= 187120292 then
										local v24 = n24
										local n26
										if v24 % 4294967296 ~= v24 % 4294967296 then
											n26 = 0
										else
											n26 = v24 % 4294967296 - v24 % 4294967296 % 1
										end
										n24 = bit32.bxor(n26, 91596981)
									end
									ownerToggle:set(arg6)
								end
								
								n24 = 49460987
								keybindConfig.callback = callback2
							end
							local v23 = __lph_capture_array_1000021[1].createkeybind(tween_10, keybindConfig)
							ownerToggle.Keybind = v23
							ownerToggle.KeybindConfig = keybindConfig
							ownerToggle.HadKeybind = true
							v23.ownerToggle = ownerToggle
							table.insert(ownerToggle.Addons, v23)
							if keybindConfig.sync then
								v23:set(ownerToggle.value, true, true)
							end
							return v23
						end
						ownerToggle.colorpicker = function(arg5, arg6)
							
							return __lph_capture_array_1000021[1].createcolorpicker(tween_10, arg6)
						end
						local n22 = 393490191
						local function toggle(arg5, arg6)
							
							local tbl3 = arg6 or {}
							local tbl4 = { Content = content }
							bit32.bxor(bit32.bxor(n22 % 4294967296 - n22 % 4294967296 % 1, 0), 381009861)
							tbl4.ParentTab = parentTab
							additems(tbl4)
							local v23 = tbl4:toggle(tbl3)
							table.insert(ownerToggle.Addons, v23)
							v23:show(ownerToggle.value == true)
							return v23
						end
						
						
						n22 = 225264573
						ownerToggle.toggle = toggle
						ownerToggle.dropdown = function(arg5, arg6)
							
							local tbl3 = arg6 or {}
							local tbl4 = { Content = content, ParentTab = parentTab }
							additems(tbl4)
							local v24 = tbl4:dropdown(tbl3)
							table.insert(ownerToggle.Addons, v24)
							v24:show(ownerToggle.value == true)
							return v24
						end
						local function slider(arg5, arg6)
							
							local tbl3 = arg6 or {}
							local tbl4 = { Content = content, ParentTab = parentTab }
							additems(tbl4)
							local v24 = tbl4:slider(tbl3)
							table.insert(ownerToggle.Addons, v24)
							v24:show(ownerToggle.value == true)
							return v24
						end
						ownerToggle.slider = slider
						ownerToggle.textbox = function(arg5, arg6)
							
							local tbl3 = arg6 or {}
							local tbl4 = { Content = content, ParentTab = parentTab }
							additems(tbl4)
							local v24 = tbl4:textbox(tbl3)
							table.insert(ownerToggle.Addons, v24)
							v24:show(ownerToggle.value == true)
							return v24
						end
						local function button(arg5, arg6)
							
							local tbl3 = arg6 or {}
							local tbl4 = { Content = content, ParentTab = parentTab }
							additems(tbl4)
							local v24 = tbl4:button(tbl3)
							table.insert(ownerToggle.Addons, v24)
							v24:show(ownerToggle.value == true)
							return v24
						end
						ownerToggle.button = button
						local n24 = 476235485
						local function label(arg5, arg6)
							
							local tbl3 = arg6 or {}
							local tbl4 = {}
							bit32.bxor(bit32.bxor(n24 % 4294967296 - n24 % 4294967296 % 1, 0), 139951419)
							tbl4.Content = content
							tbl4.ParentTab = parentTab
							additems(tbl4)
							local v24 = tbl4:label(tbl3)
							table.insert(ownerToggle.Addons, v24)
							v24:show(ownerToggle.value == true)
							return v24
						end
						
						n24 = 302629245
						ownerToggle.label = label
						local function separator(arg5, arg6)
							
							local tbl3 = arg6 or {}
							local tbl4 = { Content = content, ParentTab = parentTab }
							additems(tbl4)
							local v25 = tbl4:separator(tbl3)
							table.insert(ownerToggle.Addons, v25)
							v25:show(ownerToggle.value == true)
							return v25
						end
						ownerToggle.separator = separator
						ownerToggle.toggleaddons = function(arg5, arg6)
							
							for _, v25 in next, ownerToggle.Addons, nil do
								if v25.type ~= "keybind" then
									v25:show(arg6 == true)
								end
							end
						end
						
						tween_5.MouseButton1Click:Connect(function()
							
							if ownerToggle.Keybind then
								ownerToggle.Keybind:Remove()
								
								ownerToggle.Keybind = nil
								ownerToggle.KeybindConfig = nil
								ownerToggle.HadKeybind = true
								tween_5.Text = "Add Keybind"
								fn12(false)
							else
								v22 = ownerToggle:keybind({ sync = true, list = true })
								ownerToggle.HadKeybind = true
								tween_5.Text = "Remove Keybind"
								fn12(false)
							end
						end)
						ownerToggle:set(state)
						__lph_capture_array_1000021[1]:tooltip(tween_2, arg4)
						__lph_capture_array_1000021[1].items[v19] = ownerToggle
						__lph_capture_array_1000021[1].ConfigManager:Register(v19, ownerToggle)
						ownerToggle.value = value
						ownerToggle.Tab = parentTab
						
						ownerToggle.Content = content
						ownerToggle.Name = name_2
						fn5(ownerToggle, tween_2, name_2)
						return ownerToggle
					end
					arg2.button = function(arg3, arg4)
						
						
						
						
						local tbl3 = { cfg = arg4 }
						local name_ = arg4.name or arg4.Name or "Button"
						local confirm = arg4.confirm or arg4.Confirm or false
						if not arg4.tooltip then
							local tooltip = arg4.Tooltip
						end
						
						local callback = arg4.callback
						
						
						
						local callback2 = callback or arg4.Callback or function()
							
						end
						local flag = false
						local flag2 = false
						local tween_2 = __lph_capture_array_1000021[1]:Create("Frame", {
							Parent = content,
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, 22),
							ClipsDescendants = false,
							ZIndex = 6,
						})
						tbl3.Frame = tween_2
						local tween_3 = __lph_capture_array_1000021[1]:Create("Frame", {
							Parent = tween_2,
							BackgroundColor3 = __lph_capture_array_1000021[1].stroke2,
							BorderColor3 = __lph_capture_array_1000021[1].buttoncolor,
							AnchorPoint = Vector2.new(0.5, 0.5),
							BorderSizePixel = 0,
							BackgroundTransparency = 0,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							Size = UDim2.new(0, 364, 0, 22),
							ClipsDescendants = true,
							ZIndex = 6,
						})
						__lph_capture_array_1000021[1]:Create("UICorner", { Parent = tween_3, CornerRadius = UDim.new(0, 4) })
						local tween_4 = __lph_capture_array_1000021[1]:Create("Frame", {
							Parent = tween_3,
							BackgroundColor3 = __lph_capture_array_1000021[1].stroke,
							BorderColor3 = __lph_capture_array_1000021[1].buttoncolor,
							AnchorPoint = Vector2.new(0.5, 0.5),
							BorderSizePixel = 0,
							BackgroundTransparency = 0,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							Size = UDim2.new(1, -2, 1, -2),
							ClipsDescendants = true,
							ZIndex = 7,
						})
						__lph_capture_array_1000021[1]:Create("UICorner", { Parent = tween_4, CornerRadius = UDim.new(0, 4) })
						local v18 = __lph_capture_array_1000021[1]
						local create = v18.Create
						local tbl4 = { Parent = tween_4, Text = "", BackgroundColor3 = __lph_capture_array_1000021[1].buttoncolor }
						tbl4.BorderColor3 = __lph_capture_array_1000021[1].buttoncolor
						tbl4.AnchorPoint = Vector2.new(0.5, 0.5)
						tbl4.BorderSizePixel = 0
						tbl4.BackgroundTransparency = 0
						tbl4.Position = UDim2.new(0.5, 0, 0.5, 0)
						tbl4.Size = UDim2.new(1, -2, 1, -2)
						tbl4.ClipsDescendants = true
						tbl4.AutoButtonColor = false
						tbl4.ZIndex = 8
						local textButton = create(v18, "TextButton", tbl4)
						
						__lph_capture_array_1000021[1]:mouseffects(textButton, tween_4)
						__lph_capture_array_1000021[1]:Create("UICorner", { Parent = textButton, CornerRadius = UDim.new(0, 4) })
						
						local tween_5 = __lph_capture_array_1000021[1]:Create("TextLabel", {
							Parent = textButton,
							Text = name_,
							FontFace = __lph_capture_array_1000021[1].font,
							BackgroundTransparency = 1,
							TextSize = 12,
							TextColor3 = __lph_capture_array_1000021[1].textcolor,
							Size = UDim2.new(1, 0, 1.1499999761581421, 0),
							Position = UDim2.new(0, 0, -0.15000000596046448, 0),
							TextXAlignment = Enum.TextXAlignment.Center,
							TextYAlignment = Enum.TextYAlignment.Center,
							ZIndex = 8,
						})
						__lph_capture_array_1000021[1]:Create("ImageLabel", {
							Parent = textButton,
							Image = "rbxassetid://87505091287358",
							ImageTransparency = 0.8,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Position = UDim2.new(0, 0, 0, 0),
							Size = UDim2.new(1, 0, 1, 0),
							ZIndex = 10,
						})
						
						
						__lph_capture_array_1000021[1]:tooltip(tween_2, arg4)
						local mouseButton1Click = textButton.MouseButton1Click
						local connect = mouseButton1Click.Connect
						local n22 = 40222316
						local function fn6()
							
							local spawn = task.spawn
							local v19 = n22
							local n23
							if v19 % 4294967296 ~= v19 % 4294967296 then
								n23 = 0
							else
								n23 = v19 % 4294967296 - v19 % 4294967296 % 1
							end
							if bit32.bxor(n23, 0) ~= 380687729 then
								local v20 = n22
								local n24
								if v20 % 4294967296 ~= v20 % 4294967296 then
									n24 = 0
								else
									n24 = v20 % 4294967296 - v20 % 4294967296 % 1
								end
								n22 = bit32.bxor(n24, 4063287459)
							end
							spawn(function()
								
								
								if confirm then
									if flag2 then
										flag2 = false
										flag = false
										tween_5.Text = name_
										
										callback2()
									else
										flag2 = true
										flag = true
										for i = 3, 1, -1 do
											if not flag then
												flag2 = false
												flag = false
												tween_5.Text = name_
												return
											end
											tween_5.Text = "Confirm? " .. tostring(i)
											wait(1)
											local function fn7(arg5, arg6)
												
												local function fn8()
													
												end
												local n25 = arg5 + string.gsub(tostring({}), "%D", "") + string.gsub(tostring(fn8), "%D", "")
												local v20 = collectgarbage
												local flag3 = bit32.bxor(arg6, 284169451) == 267017050
												local n26 = n25 + v20("count") + os.clock()
												return n26 + __lph_capture_array_1000021[3].new():NextInteger(1000, 9999)
											end
											local v20 = fn7(0, 359562139)
											local NumberValue = __lph_capture_array_1000021[4].new("NumberValue")
											NumberValue.Value = v20
											local tbl5 = {}
											tbl5[#tbl5 + 1] = v20
											local n25 = (v20 % 293 + 272) * 16 % 932
											do
do
NumberValue:Destroy()
												if tbl5[1] == v20 then
													continue
												end
												
end
end
										end
										flag2 = false
										flag = false
										tween_5.Text = name_
									end
								else
									callback2()
								end
							end)
						end
						
						n22 = 380687729
						connect(mouseButton1Click, fn6)
						fn5(tbl3, tween_2, name_)
						local n23 = 426305396
						local function show(arg5, visible)
							
							local v20 = tween_2
							local flag3 = bit32.bxor(n23 % 4294967296 - n23 % 4294967296 % 1, 0) ~= 232247522
							v20.Visible = visible
						end
						
						n23 = 232247522
						tbl3.show = show
						return tbl3
					end
					arg2.slider = function(arg3,arg4)
	
	
	
	local tbl = { cfg = arg4 }
	
	tbl.type = "slider"
	local name = arg4.name or arg4.Name or "Slider"
	local n3 = tonumber(arg4.min or arg4.Min or arg4.minimum or arg4.Minimum) or 0
	local n4 = tonumber(arg4.max or arg4.Max or arg4.maximum or arg4.Maximum) or 100
	if n4 < n3 then
		local v2 = n4
		n4 = n3
		n3 = v2
	end
	local suffix = arg4.suffix
	
	local suffix2 = suffix or arg4.Suffix or ""
	
	if not arg4.text then
	end
	local v2 = tonumber
	local float = arg4.float
	local n7 = v2(float or arg4.Float) or 1
	if n7 <= 0 then
		n7 = 1
	end
	local default = arg4.default
	if default == nil then
		default = arg4.Default
	end
	local flag = default ~= nil
	if flag then
		flag = math.clamp(tonumber(default) or n3, n3, n4)
	end
	flag = flag or n3
	local flag2 = arg4.flag or __lph_capture_array_1000021[1]:nextflag()
	
	
	
	
	if not arg4.tooltip then
		local tooltip = arg4.Tooltip
	end
	local callback = arg4.callback or function()
		
	end
	local tween = __lph_capture_array_1000021[1]:Create("Frame", {
		Parent = content,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 32),
		ClipsDescendants = false,
		ZIndex = 8,
	})
	tbl.Frame = tween
	local v4 = __lph_capture_array_1000021[1]
	__lph_capture_array_1000021[1]:Create("TextLabel", {
		Parent = tween,
		Text = name,
		FontFace = __lph_capture_array_1000021[1].font,
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 1,
		TextSize = 12,
		TextColor3 = __lph_capture_array_1000021[1].textcolor,
		Position = UDim2.new(0, 20, 0, 6),
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 8,
	})
	local tween2 = __lph_capture_array_1000021[1]:Create("TextButton", {
		Parent = tween,
		Text = "",
		BackgroundColor3 = __lph_capture_array_1000021[1].stroke2,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0.5, 0, 0.75, 2),
		Size = UDim2.new(0, 364, 0, 10),
		ClipsDescendants = false,
		AutoButtonColor = false,
		ZIndex = 9,
	})
	__lph_capture_array_1000021[1]:Create("UICorner", { Parent = tween2, CornerRadius = UDim.new(0, 4) })
	local tween3 = __lph_capture_array_1000021[1]
	local create = tween3.Create
	local tbl2 = {
		Parent = tween2,
		Text = "",
		BackgroundColor3 = __lph_capture_array_1000021[1].stroke,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, -2, 1, -2),
		ClipsDescendants = false,
		AutoButtonColor = false,
		ZIndex = 9,
	}
	local str = "TextButton"
	local v5 = create(tween3, str, tbl2)
	local v6, create2, tbl3
	if v4 then
		__lph_capture_array_1000021[1]:Create("UICorner", { Parent = v5, CornerRadius = UDim.new(0, 4) })
		tween3 = __lph_capture_array_1000021[1]:Create("TextButton", {
			Parent = v5,
			Text = "",
			BackgroundColor3 = __lph_capture_array_1000021[1].buttoncolor,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(1, -2, 1, -2),
			ClipsDescendants = false,
			AutoButtonColor = false,
			ZIndex = 9,
		})
		__lph_capture_array_1000021[1]:Create("UICorner", { Parent = tween3, CornerRadius = UDim.new(0, 4) })
		str = __lph_capture_array_1000021[1]:Create("TextLabel", {
			Parent = tween3,
			Text = tostring(flag) .. suffix2,
			FontFace = __lph_capture_array_1000021[1].font,
			BackgroundTransparency = 1,
			TextSize = 12,
			TextColor3 = __lph_capture_array_1000021[1].textcolor,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 20, 0, 10),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextStrokeTransparency = 1,
			TextStrokeColor3 = Color3.new(0, 0, 0),
			ZIndex = 11,
		})
		__lph_capture_array_1000021[1]:Create("ImageLabel", {
			Parent = tween3,
			Image = "rbxassetid://87505091287358",
			ImageTransparency = 0.8,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = 10,
		})
		tbl2 = __lph_capture_array_1000021[1]:Create("Frame", {
			Parent = tween3,
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundColor3 = __lph_capture_array_1000021[1].accent,
			BorderSizePixel = 0,
			Size = UDim2.new(0, 0, 0, 0),
			ClipsDescendants = false,
			ZIndex = 9,
		})
		__lph_capture_array_1000021[1]:Create("UICorner", { Parent = tbl2, CornerRadius = UDim.new(0, 4) })
		v6 = __lph_capture_array_1000021[1]
		create2 = v6.Create
		tbl3 = { Parent = tween, Text = "" }
	end
	tbl3.BackgroundTransparency = 1
	tbl3.AnchorPoint = Vector2.new(0.5, 0.5)
	tbl3.Position = UDim2.new(0, 10, 0.64999997615814209, 0)
	tbl3.BorderSizePixel = 0
	tbl3.TextXAlignment = Enum.TextXAlignment.Center
	tbl3.TextYAlignment = Enum.TextYAlignment.Bottom
	tbl3.Size = UDim2.new(0, 8, 0, 8)
	tbl3.ClipsDescendants = false
	tbl3.AutoButtonColor = false
	tbl3.ZIndex = 12
	local textButton = create2(v6, "TextButton", tbl3)
	local tween4 = __lph_capture_array_1000021[1]:Create("TextButton", {
		Parent = tween,
		Text = "",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.97699999809265137, 0, 0.64999997615814209, 0),
		BorderSizePixel = 0,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		Size = UDim2.new(0, 8, 0, 8),
		ClipsDescendants = false,
		AutoButtonColor = false,
		ZIndex = 12,
	})
	
	
	
	
	
	
	
	
	
	local tween5 = __lph_capture_array_1000021[1]:Create("TextLabel", {
		Parent = textButton,
		Text = "-",
		FontFace = __lph_capture_array_1000021[1].font,
		TextSize = 12,
		BackgroundColor3 = Color3.new(1, 1, 1),
		TextColor3 = __lph_capture_array_1000021[1].textcolor,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 1, 0.25, 0),
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		Size = UDim2.new(1, 0, 1, 0),
		ClipsDescendants = false,
		ZIndex = 12,
	})
	local tween6 = __lph_capture_array_1000021[1]:Create("TextLabel", {
		Parent = tween4,
		Text = "+",
		FontFace = __lph_capture_array_1000021[1].font,
		TextSize = 12,
		BackgroundColor3 = Color3.new(1, 1, 1),
		TextColor3 = __lph_capture_array_1000021[1].textcolor,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.25, 0),
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		Size = UDim2.new(1, 0, 1, 0),
		ClipsDescendants = false,
		ZIndex = 12,
	})
	tbl.set = function(arg3, arg4)
		
		
		
		local num = tonumber(arg4)
		num = num or n3
		local match = string.format("%.12f", tonumber(n7) or 1):gsub("0+$", ""):gsub("%.$", ""):match("%.(%d+)")
		match = match and #match or 0
		local n16 = 10 ^ match
		
		
		local value = math.floor(math.clamp(n3 + math.floor((num - n3) / n7 + 0.5) * n7, n3, n4) * n16 + 0.5) / n16
		tbl.value = value
		__lph_capture_array_1000021[1]:setflag(flag2, value)
		local n18 = 0
		if n4 ~= n3 then
			n18 = math.clamp((value - n3) / (n4 - n3), 0, 1)
		end
		
		tbl2.Size = UDim2.new(n18, 0, 0, 6)
		str.Text = string.format("%." .. match .. "f", value) .. suffix2
		local x = str.TextBounds.X
		local x2 = tween3.AbsoluteSize.X
		str.Size = UDim2.new(0, x + 2, 0, str.TextBounds.Y)
		local n20 = (x + 1) / 2
		local n21 = x2 - (x + 2) / 2 + 1
		if n21 < n20 then
			n21 = n20
		end
		local n22 = math.clamp(n18 * x2, n20, n21)
		str.AnchorPoint = Vector2.new(0.5, 0.5)
		str.Position = UDim2.new(0, math.floor(n22 + 0.5), 0.5, 3)
		callback(value)
	end
	local activated = textButton.Activated
	
	
	
	
	activated:Connect(function()
		
		tbl:set(__lph_capture_array_1000021[1].flags[flag2] - n7)
	end)
	local mouseEnter = textButton.MouseEnter
	local connect = mouseEnter.Connect
	local n15 = 445363308
	local function fn()
		
		tween5.TextColor3 = __lph_capture_array_1000021[1].accent
		local flag3 = bit32.bxor(n15 % 4294967296 - n15 % 4294967296 % 1, 0) ~= 474629348
		tween5:SetAttribute("Selected", true)
	end
	
	n15 = 474629348
	connect(mouseEnter, fn)
	local function __boohub_slider_callback_2()
		
		tween5.TextColor3 = __lph_capture_array_1000021[1].textcolor
		tween5:SetAttribute("Selected", false)
	end
	textButton.MouseLeave:Connect(__boohub_slider_callback_2)
	local inputBegan = textButton.InputBegan
	local connect2 = inputBegan.Connect
	local n16 = 112890195
	local function __boohub_slider_callback_3(arg3)
		
		local userInputType = arg3.UserInputType
		local userInputType2 = Enum.UserInputType
		bit32.bxor(n16 % 4294967296 - n16 % 4294967296 % 1, 0)
		if userInputType == userInputType2.MouseButton1 or arg3.UserInputType == Enum.UserInputType.Touch then
			tween5.TextColor3 = __lph_capture_array_1000021[1].textcolor
			tween5:SetAttribute("Selected", false)
		end
	end
	
	n16 = 146378176
	connect2(inputBegan, __boohub_slider_callback_3)
	
	textButton.InputEnded:Connect(function(input)
		
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			tween5.TextColor3 = __lph_capture_array_1000021[1].accent
			tween5:SetAttribute("Selected", true)
		end
	end)
	local activated2 = tween4.Activated
	local connect3 = activated2.Connect
	local n18 = 46814969
	local function __boohub_slider_callback_4()
		
		local flag3 = bit32.bxor(bit32.bxor(n18 % 4294967296 - n18 % 4294967296 % 1, 0), 260013321) == 504760463
		tbl:set(__lph_capture_array_1000021[1].flags[flag2] + n7)
	end
	
	n18 = 188640506
	connect3(activated2, __boohub_slider_callback_4)
	tween4.MouseEnter:Connect(function()
		
		tween6.TextColor3 = __lph_capture_array_1000021[1].accent
		tween6:SetAttribute("Selected", true)
	end)
	tween4.MouseLeave:Connect(function()
		
		tween6.TextColor3 = __lph_capture_array_1000021[1].textcolor
		tween6:SetAttribute("Selected", false)
	end)
	tween4.InputBegan:Connect(function(input)
		
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			tween6.TextColor3 = __lph_capture_array_1000021[1].textcolor
			tween6:SetAttribute("Selected", false)
		end
	end)
	local function __boohub_slider_callback_5(input)
 if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
  tween6.TextColor3=__lph_capture_array_1000021[1].accent
  tween6:SetAttribute("Selected",true)
 end
end
	tween4.InputEnded:Connect(__boohub_slider_callback_5)
	__lph_capture_array_1000021[1]:mouseffects(tween3, v5)
	__lph_capture_array_1000021[1]:tooltip(tween, arg4)
	tbl:set(flag)
	local flag3 = false
	local v18 = nil
	local function __boohub_slider_callback_6(arg3)
		
		tbl:set((n4 - n3) * math.clamp((arg3.Position.X - tween3.AbsolutePosition.X) / tween3.AbsoluteSize.X, 0, 1) + n3)
	end
	__lph_capture_array_1000021[1]:connect(tween3.InputBegan, function(arg3)
		
		if arg3.UserInputType == Enum.UserInputType.MouseButton1 or arg3.UserInputType == Enum.UserInputType.Touch then
			flag3 = true
			v18 = arg3
			__boohub_slider_callback_6(arg3)
		end
	end)
	__lph_capture_array_1000021[1]:connect(tween3.InputEnded, function(arg3)
		
		if arg3 == v18 or arg3.UserInputType == Enum.UserInputType.MouseButton1 or arg3.UserInputType == Enum.UserInputType.Touch then
			flag3 = false
			v18 = nil
		end
	end)
	local v19 = __lph_capture_array_1000021[1]
	local connect4 = v19.connect
	local inputChanged = __lph_capture_array_1000021[6].InputChanged
	local n20 = 373732633
	local function __boohub_slider_callback_7(arg3)
		
		if not flag3 then
			return
		end
		local v20 = v18
		local v21 = n20
		local n21
		if v21 % 4294967296 ~= v21 % 4294967296 then
			n21 = 0
		else
			n21 = v21 % 4294967296 - v21 % 4294967296 % 1
		end
		if bit32.bxor(n21, 0) ~= 523920200 then
			local v22 = n20
			local n22
			if v22 % 4294967296 ~= v22 % 4294967296 then
				n22 = 0
			else
				n22 = v22 % 4294967296 - v22 % 4294967296 % 1
			end
			n20 = bit32.bxor(n22, 4132702401)
		end
		if arg3 == v20 or arg3.UserInputType == Enum.UserInputType.MouseMovement or arg3.UserInputType == Enum.UserInputType.Touch then
			__boohub_slider_callback_6(arg3)
		end
	end
	
	n20 = 523920200
	connect4(v19, inputChanged, __boohub_slider_callback_7)
	__lph_capture_array_1000021[1]:connect(__lph_capture_array_1000021[6].InputEnded, function(arg3)
		
		if arg3 == v18 or arg3.UserInputType == Enum.UserInputType.MouseButton1 or arg3.UserInputType == Enum.UserInputType.Touch then
			flag3 = false
			v18 = nil
		end
	end)
	__lph_capture_array_1000021[1].items[flag2] = tbl
	__lph_capture_array_1000021[1].ConfigManager:Register(flag2, tbl)
	
	fn5(tbl, tween, name)
	tbl.show = function(arg3, visible)
		
		tween.Visible = visible
	end
	return tbl
end
					arg2.dropdown = function(arg3, arg4)
						
						
						
						
						local tbl3 = { cfg = arg4, type = "dropdown" }
						local name_ = arg4.name or arg4.Name or "Dropdown"
						local default = arg4.default or arg4.Default
						local options = type(arg4.options or arg4.Options) == "table" and (arg4.options or arg4.Options) or {}
						local max = arg4.max
						local max2
						if max then
							max2 = max
						else
							max2 = arg4.Max
							
						end
						local n15 = max2 or 1
						local flag = arg4.flag or __lph_capture_array_1000021[1]:nextflag()
						
						
						local flag2 = arg4.save ~= false and arg4.Save ~= false
						if not arg4.tooltip then
							local tooltip = arg4.Tooltip
						end
						local callback = arg4.callback or function()
							
						end
						
						
						if type(n15) ~= "number" then
							n15 = 1
						end
						local tbl4 = {}
						local flag3 = n15 > 1
						
						local value = flag3 and {} or nil
						local flag4 = false
						
						if n15 <= 1 and type(default) == "table" then
							default = nil
						end
						if n15 > 1 and default == nil then
							default = {}
						end
						if type(default) == "table" then
							
							
							for i = #default, 1, -1 do
								if not table.find(options, default[i]) then
									table.remove(default, i)
								elseif i > n15 then
									table.remove(default, i)
								end
							end
							
						elseif default ~= nil then
							if not table.find(options, default) then
								default = nil
							end
						end
						local textYAlignment = content
						local tween_2 = __lph_capture_array_1000021[1]:Create("Frame", {
							Parent = textYAlignment,
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, 36),
							ClipsDescendants = false,
							ZIndex = 8,
						})
						tbl3.Frame = tween_2
						__lph_capture_array_1000021[1]:tooltip(tween_2, arg4)
						local v18 = __lph_capture_array_1000021[1]
						__lph_capture_array_1000021[1]:Create("TextLabel", {
							Parent = tween_2,
							Text = name_,
							FontFace = __lph_capture_array_1000021[1].font,
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							TextSize = 12,
							TextColor3 = __lph_capture_array_1000021[1].textcolor,
							Position = UDim2.new(0, 20, 0.15999999642372131, 0),
							TextXAlignment = Enum.TextXAlignment.Left,
							ZIndex = 8,
						})
						local v19 = __lph_capture_array_1000021[1]
						local create = v19.Create
						local tbl5 = {
							Parent = tween_2,
							Text = "",
							FontFace = __lph_capture_array_1000021[1].font,
							BackgroundColor3 = __lph_capture_array_1000021[1].stroke2,
							AnchorPoint = Vector2.new(0.5, 0.5),
							BorderSizePixel = 0,
							Position = UDim2.new(0.5, 0, 0, 26),
							TextSize = 12,
							TextColor3 = __lph_capture_array_1000021[1].textcolor,
							Size = UDim2.new(0, 364, 0, 22),
							TextXAlignment = Enum.TextXAlignment.Left,
							ClipsDescendants = false,
							AutoButtonColor = false,
							ZIndex = 7,
						}
						local textButton = create(v19, "TextButton", tbl5)
						local flag6 = not not v18
						local v20, create2, tbl6
						if flag6 then
							__lph_capture_array_1000021[1]:Create("UICorner", { Parent = textButton, CornerRadius = UDim.new(0, 4) })
							tbl5 = __lph_capture_array_1000021[1]:Create("TextButton", {
								Parent = textButton,
								Text = "",
								FontFace = __lph_capture_array_1000021[1].font,
								BackgroundColor3 = __lph_capture_array_1000021[1].stroke,
								AnchorPoint = Vector2.new(0.5, 0.5),
								BorderSizePixel = 0,
								Position = UDim2.new(0.5, 0, 0.5, 0),
								TextSize = 12,
								TextColor3 = __lph_capture_array_1000021[1].textcolor,
								Size = UDim2.new(1, -2, 1, -2),
								TextXAlignment = Enum.TextXAlignment.Left,
								ClipsDescendants = false,
								AutoButtonColor = false,
								ZIndex = 8,
							})
							flag6 = __lph_capture_array_1000021[1]
							
							textYAlignment = true
							__lph_capture_array_1000021[1]:Create("UICorner", { Parent = tbl5, CornerRadius = UDim.new(0, 4) })
							v20 = __lph_capture_array_1000021[1]
							create2 = v20.Create
							tbl6 = {
								Parent = tbl5,
								Text = "",
								FontFace = __lph_capture_array_1000021[1].font,
								BackgroundColor3 = __lph_capture_array_1000021[1].buttoncolor,
								AnchorPoint = Vector2.new(0.5, 0.5),
								BorderSizePixel = 0,
								Position = UDim2.new(0.5, 0, 0.5, 0),
								TextSize = 12,
								TextColor3 = __lph_capture_array_1000021[1].textcolor,
								Size = UDim2.new(1, -2, 1, -2),
								TextXAlignment = Enum.TextXAlignment.Left,
								ClipsDescendants = false,
								AutoButtonColor = false,
							}
						end
						tbl6.ZIndex = 9
						local textButton2 = create2(v20, "TextButton", tbl6)
						__lph_capture_array_1000021[1]:Create("UICorner", { Parent = textButton2, CornerRadius = UDim.new(0, 4) })
						local v21 = __lph_capture_array_1000021[1]
						local create3 = v21.Create
						local tbl7 = {
							Parent = textButton2,
							Image = "rbxassetid://87505091287358",
							ImageTransparency = 0.8,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Position = UDim2.new(0, 0, 0, 0),
							Size = UDim2.new(1, 0, 1, 0),
							ZIndex = 10,
						}
						create3(v21, "ImageLabel", tbl7)
						if flag6 then
							local function fn6(arg5, arg6)
								
								if type(arg6) == "table" then
									if #arg6 == 0 then
										return "None"
									end
									return table.concat(arg6, ", ")
								end
								if arg6 == nil then
									return "None"
								end
								local v22 = tostring
								bit32.bxor(arg5, 408800556)
								return v22(arg6)
							end
							v21 = __lph_capture_array_1000021[1]
							create3 = v21.Create
							tbl7 = {
								Parent = textButton2,
								Text = fn6(270755571, default),
								FontFace = __lph_capture_array_1000021[1].font,
								BackgroundColor3 = Color3.new(1, 1, 1),
								BackgroundTransparency = 1,
								TextSize = 12,
								TextColor3 = __lph_capture_array_1000021[1].textcolor,
								Position = UDim2.new(0.019999999552965164, 0, 0, 0),
								Size = UDim2.new(0.94999998807907104, 0, 0.89999997615814209, 0),
								TextXAlignment = Enum.TextXAlignment.Left,
							}
							textYAlignment = Enum.TextYAlignment.Center
						end
						tbl7.TextYAlignment = textYAlignment
						tbl7.ClipsDescendants = true
						tbl7.ZIndex = 11
						local textLabel = create3(v21, "TextLabel", tbl7)
						local tween_3 = __lph_capture_array_1000021[1]:Create("TextBox", {
							Parent = textButton2,
							Text = "",
							PlaceholderText = "Search",
							FontFace = __lph_capture_array_1000021[1].font,
							BackgroundTransparency = 1,
							TextSize = 12,
							TextColor3 = __lph_capture_array_1000021[1].textcolor,
							Position = UDim2.new(0.019999999552965164, 0, 0, 0),
							Size = UDim2.new(0.25, 0, 0.89999997615814209, 0),
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Center,
							ClearTextOnFocus = false,
							Visible = false,
							ZIndex = 12,
						})
						local tween_4 = __lph_capture_array_1000021[1]:Create("ImageLabel", {
							Parent = textButton2,
							Image = "rbxassetid://97582511137728",
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							Position = UDim2.new(0.95999997854232788, 0, 0.20000000298023224, 0),
							Size = UDim2.new(0, 10, 0, 10),
							Visible = true,
							ZIndex = 12,
						})
						local tween_5 = __lph_capture_array_1000021[1]:Create("Frame", {
							Parent = __lph_capture_array_1000021[1].ScreenGUI,
							BackgroundTransparency = 0,
							BackgroundColor3 = __lph_capture_array_1000021[1].stroke2,
							BorderColor3 = Color3.new(0.23921568691730499, 0.23921568691730499, 0.23921568691730499),
							BorderSizePixel = 0,
							Size = UDim2.new(0, textButton2.AbsoluteSize.X + 4, 0, 100),
							Position = UDim2.new(0, 0, 0, 0),
							Active = true,
							ClipsDescendants = true,
							Visible = false,
							ZIndex = 13,
						})
						__lph_capture_array_1000021[1]:Create("UICorner", { Parent = tween_5, CornerRadius = UDim.new(0, 4) })
						local tween_6 = __lph_capture_array_1000021[1]:Create("Frame", {
							Parent = tween_5,
							BackgroundTransparency = 0,
							BackgroundColor3 = __lph_capture_array_1000021[1].stroke,
							BorderColor3 = Color3.new(0.23921568691730499, 0.23921568691730499, 0.23921568691730499),
							BorderSizePixel = 0,
							Size = UDim2.new(1, -2, 1, -2),
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.new(0.5, 0, 0.5, 0),
							Active = true,
							ClipsDescendants = true,
							Visible = true,
							ZIndex = 14,
						})
						local flag7 = __lph_capture_array_1000021[1]
						local create4 = __lph_capture_array_1000021[1]
						local create5 = create4.Create
						local tbl8 = { Parent = tween_6, CornerRadius = UDim.new(0, 4) }
						local str = "UICorner"
						repeat
							create5(create4, str, tbl8)
							create5 = __lph_capture_array_1000021[1]:Create("Frame", {
								Parent = tween_6,
								BackgroundTransparency = 0,
								BackgroundColor3 = __lph_capture_array_1000021[1].buttoncolor,
								BorderColor3 = Color3.new(0.23921568691730499, 0.23921568691730499, 0.23921568691730499),
								BorderSizePixel = 0,
								Size = UDim2.new(1, -2, 1, -2),
								AnchorPoint = Vector2.new(0.5, 0.5),
								Position = UDim2.new(0.5, 0, 0.5, 0),
								Active = true,
								ClipsDescendants = true,
								Visible = true,
								ZIndex = 14,
							})
							str = __lph_capture_array_1000021[1]
							create4 = str.Create
							tbl8 = "UICorner"
							create4(str, tbl8, { Parent = create5, CornerRadius = UDim.new(0, 4) })
							flag7 = not not flag7
						until flag7
						__lph_capture_array_1000021[1]:Create("ImageLabel", {
							Parent = create5,
							Image = "rbxassetid://87505091287358",
							ImageTransparency = 0.8,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Position = UDim2.new(0, 0, 0, 0),
							Size = UDim2.new(1, 0, 1, 0),
							ZIndex = 15,
						})
						local tween_7 = __lph_capture_array_1000021[1]:Create("ScrollingFrame", {
							Parent = create5,
							BackgroundTransparency = 1,
							BackgroundColor3 = __lph_capture_array_1000021[1].buttoncolor,
							BorderColor3 = Color3.new(0.23921568691730499, 0.23921568691730499, 0.23921568691730499),
							BorderSizePixel = 0,
							Size = UDim2.new(1, -2, 1, -2),
							BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
							TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.new(0.5, 0, 0.5, 0),
							ScrollBarThickness = 1,
							Active = true,
							ClipsDescendants = true,
							Visible = true,
							ZIndex = 15,
						})
						__lph_capture_array_1000021[1]:Create("UICorner", { Parent = tween_7, CornerRadius = UDim.new(0, 4) })
						tween_5:SetAttribute("DropdownMenu", true)
						local tween_8 = __lph_capture_array_1000021[1]:Create("UIPadding", {
							Parent = tween_7,
							PaddingTop = UDim.new(0, 6),
							PaddingLeft = UDim.new(0, 6),
							PaddingBottom = UDim.new(0, 6),
						})
						
						local tween_9 = __lph_capture_array_1000021[1]:Create("UIListLayout", { Parent = tween_7, Padding = UDim.new(0, 1), SortOrder = Enum.SortOrder.LayoutOrder })
						local function fn6(arg5, arg6)
							
							if type(arg6) == "table" then
								if #arg6 == 0 then
									arg6 = "None"
								else
									arg6 = table.concat(arg6, ", ")
								end
							end
							local text = tostring(arg6 or "")
							local x = arg5.AbsoluteSize.X
							if x <= 0 then
								arg5.Text = text
								return
							end
							local function fn7(arg7, arg8)
								
								return __lph_capture_array_1000021[7]:GetTextSize(arg8, arg5.TextSize, Enum.Font.Gotham, Vector2.new(math.huge, math.huge)).X
							end
							if fn7(19329537, text) <= x then
								arg5.Text = text
								return
							end
							if x < fn7(19329537, "...") then
								arg5.Text = "..."
								return
							end
							while #text > 0 do
								text = text:sub(1, #text - 1)
								local text2 = text .. "..."
								if not (fn7(19329537, text2) <= x) then
									continue
								end
								arg5.Text = text2
								return
							end
							arg5.Text = "..."
						end
						
						local function fn7()
 local absolutePosition=textButton2.AbsolutePosition
 local absoluteSize=textButton2.AbsoluteSize
local v2 = content
local n3 = v2.AbsolutePosition.Y + 3
local n4 = absolutePosition.Y + absoluteSize.Y + 6
local n5 = n3 + 2
if absolutePosition.Y + absoluteSize.Y > v2.AbsolutePosition.Y + v2.AbsoluteSize.Y then
				tween_5.Visible = false
			end
tween_5.Position = UDim2.fromOffset(absolutePosition.X - 2, math.max(n4, n5))
return
 end
						local v22 = __lph_capture_array_1000021[1]
						local connect = v22.connect
						
						
						connect(v22, __lph_capture_array_1000021[2].RenderStepped, function()local j= tween_5 ;local r=j.Visible;if r then j= fn7 ;j();end;end)
						local function fn8()local j= tween_8 ;local b,i=j.PaddingTop.Offset, tween_8 ;local r,O=i.PaddingBottom.Offset;i= tween_9 ;j=i.AbsoluteContentSize.Y+b+r-2;b=math.min(j,100);r= tween_7 ;r.CanvasSize=UDim2.new(0,0,0,j);i= tween_7 ;i.Size=UDim2.new(1,-2,0,b);local p,i,i= create5 ;i,p.Size= textButton2 ,UDim2.new(0, textButton2 .AbsoluteSize.X,0,b);p,i= tween_6 ;i,p.Size= textButton2 ,UDim2.new(0, textButton2 .AbsoluteSize.X+2,0,b+2);p,r= tween_5 ;r,p.Size= textButton2 ,UDim2.new(0, textButton2 .AbsoluteSize.X+4,0,b+4);p= tween_7 ;p.ScrollBarThickness=j>100 and 1 or 0;end
						local function fn9()
							
							if n15 > 1 then
								if type(value) == "table" and #value > 0 then
									return table.concat(value, ", ")
								end
								return "None"
							end
							return value or "None"
						end
						local function fn10(j)j=string.lower(tostring(j or""));local X= tbl4 ;for r,Y in next,X,nil do if Y.button then local V=j==""or string.find(string.lower(tostring(r)),j,1,true)~=nil;Y.button.Visible=V;end;end;X= fn8 ;X();end
						local function fn11(arg5)
							
							tween_5.Visible = false
							tween_4.Rotation = 0
							flag4 = false
							
							tween_3:ReleaseFocus()
							tween_3.Visible = false
							tween_3.Text = ""
							textLabel.Visible = true
							if arg5 ~= false then
								fn6(textLabel, fn9())
							end
							fn10("")
						end
						local function fn12()
							
							fn7()
							tween_5.Visible = true
							tween_4.Rotation = 90
							flag4 = true
							__lph_capture_array_1000021[1]:hidepopups(tween_5, "dropdown")
							textLabel.Visible = false
							tween_3.Visible = true
							tween_3.Text = ""
							fn10("")
							tween_3:CaptureFocus()
						end
						local function fn13(arg5)
							
							
							if n15 > 1 then
								if type(arg5) ~= "table" then
									arg5 = {}
								end
								value = table.clone(arg5)
								for k, v23 in next, tbl4, nil do
									local flag8 = table.find(value, k) ~= nil
									v23.text.TextColor3 = flag8 and __lph_capture_array_1000021[1].accent or __lph_capture_array_1000021[1].textcolor
									v23.text:SetAttribute("Selected", flag8)
									v23.text:SetAttribute("TextDisabled", flag8)
								end
								fn6(textLabel, #value > 0 and table.concat(value, ", ") or "None")
								
								if #value > 0 then
									__lph_capture_array_1000021[1]:setflag(flag, table.clone(value))
									tbl3.value = table.clone(value)
									callback(table.clone(value))
								else
									__lph_capture_array_1000021[1]:setflag(flag, nil)
									tbl3.value = nil
									callback(nil)
								end
								
							else
								if type(arg5) == "table" then
									arg5 = nil
								end
								if arg5 ~= nil and not table.find(options, arg5) then
									arg5 = nil
								end
								value = arg5
								
								for k, v23 in next, tbl4, nil do
									local flag8 = k == arg5
									v23.text.TextColor3 = flag8 and __lph_capture_array_1000021[1].accent or __lph_capture_array_1000021[1].textcolor
									v23.text:SetAttribute("Selected", flag8)
									v23.text:SetAttribute("TextDisabled", flag8)
								end
								fn6(textLabel, arg5 or "None")
								__lph_capture_array_1000021[1]:setflag(flag, value)
								tbl3.value = value
								callback(value)
							end
						end
						tbl3.set = function(arg5, arg6)
							
							fn13(arg6)
						end
						__lph_capture_array_1000021[1]:mouseffects(textButton2, tbl5)
						local function fn14(arg5, arg6)
							
							arg6.MouseButton1Click:Connect(function()
								
								
								
								if n15 > 1 then
									local tbl9
									if type(value) == "table" then
										tbl9 = table.clone(value) or {}
									else
										tbl9 = {}
									end
									if table.find(tbl9, arg5) then
										table.remove(tbl9, table.find(tbl9, arg5))
										
									else
										if n15 <= #tbl9 then
											return
										end
										table.insert(tbl9, arg5)
									end
									tbl3:set(tbl9)
									tween_3:CaptureFocus()
									fn10(tween_3.Text)
								else
									if value == arg5 then
										tbl3:set(nil)
									else
										tbl3:set(arg5)
									end
									
									if not fn6 then
										while true do
										end
									else
										fn6(textLabel, fn9())
										textLabel.Visible = false
										tween_3.Visible = true
										tween_3:CaptureFocus()
										fn10(tween_3.Text)
										
									end
								end
							end)
						end
						local v23 = (function(__lph_raw_capture_3) return function(j)local e=next;for P,b in e,j,nil do P= tbl4 ;if P[b]then continue;end;P= tbl4 ;P[b]={};local j,e,i= __lph_raw_capture_3 ,{};P= tween_7 ;e.Parent=P;e.Text="";P= __lph_raw_capture_3 ;e.BackgroundColor3=P.buttoncolor;e.BorderColor3=Color3.fromRGB(61,61,61);e.BorderSizePixel=0;e.BackgroundTransparency=1;e.AutoButtonColor=false;e.Size=UDim2.new(0.98,# options <=5 and 5 or 4,0,16);e.ZIndex=15;local X,Y=j:Create("TextButton",e), tbl4 ;Y[b].button=X;Y,j,P= __lph_raw_capture_3 ,{Parent=X,Text=tostring(b)}, __lph_raw_capture_3 ;j.FontFace=P.font;j.BackgroundTransparency=1;j.Size=UDim2.new(1,0,1,0);j.TextSize=12;e= __lph_raw_capture_3 ;j.TextColor3=e.textcolor;j.Position=UDim2.new(0,3,0,0);j.TextXAlignment=Enum.TextXAlignment.Left;j.TextYAlignment=Enum.TextYAlignment.Top;j.ZIndex=16;e,P=Y:Create("TextLabel",j), __lph_raw_capture_3 ;P.objects[e]=e;e:SetAttribute("IsAccent","TextColor3");e:SetAttribute("Selected",false);e:SetAttribute("TextDisabled",false);P= tbl4 ;P[b].text=e;Y= fn14 ;Y(b,X,e);end;end
						end)(__lph_capture_array_1000021[1])
						v23(options)
						tbl3.setoptions = function(arg5, arg6)
							
							
							
							arg6 = type(arg6) == "table" and arg6 or {}
							local flag8 = #arg6 == #options
							if flag8 then
								
								
								
								
								
								
								
								local exitTo = nil
								for i = 1, #arg6 do
									if arg6[i] ~= options[i] then
										exitTo = 1
										break
									end
								end
								if exitTo == 1 then
									flag8 = false
								end
								
								
							end
							if flag8 then
								fn10(tween_3.Text)
								return
							end
							local tbl9 = {}
							local tbl10 = {}
							for i = 1, #arg6 do
								local v24 = arg6[i]
								if v24 ~= nil and not tbl9[v24] then
									tbl9[v24] = true
									tbl10[#tbl10 + 1] = v24
								end
							end
							for k, v24 in pairs(tbl4) do
								if not tbl9[k] then
									if v24.button then
										v24.button:Destroy()
									end
									tbl4[k] = nil
								end
							end
							options = tbl10
							for i = 1, #options do
								local v24 = options[i]
								if not tbl4[v24] then
									v23({ v24 })
								end
								local v25 = tbl4[v24]
								if v25 and v25.button then
									v25.button.LayoutOrder = i
									local button = v25.button
									local udim2 = UDim2.new
									local flag9 = #options <= 5
									button.Size = udim2(0.98, flag9 and 5 or 4, 0, 16)
								end
							end
							if n15 > 1 then
								local tbl11 = {}
								if type(value) == "table" then
									
									for i = 1, #value do
										local v24 = value[i]
										if tbl9[v24] then
											tbl11[#tbl11 + 1] = v24
										end
									end
								end
								value = tbl11
								local v24 = pairs
								
								
								for k, v26 in v24(tbl4) do
									if v26.text then
										local flag9 = table.find(value, k) ~= nil
										v26.text.TextColor3 = flag9 and __lph_capture_array_1000021[1].accent or __lph_capture_array_1000021[1].textcolor
										v26.text:SetAttribute("Selected", flag9)
										v26.text:SetAttribute("TextDisabled", flag9)
									end
								end
								if #value > 0 then
									tbl3.value = table.clone(value)
									__lph_capture_array_1000021[1]:setflag(flag, table.clone(value))
									fn6(textLabel, table.concat(value, ", "))
								else
									tbl3.value = nil
									__lph_capture_array_1000021[1]:setflag(flag, nil)
									fn6(textLabel, "None")
								end
								
							else
								local flag9 = value ~= nil
								local flag10
								if flag9 then
									
									flag10 = not tbl9[value]
								else
									flag10 = flag9
								end
								if flag10 then
									value = nil
								end
								for k, v24 in pairs(tbl4) do
									if v24.text then
										local flag11 = k == value
										v24.text.TextColor3 = flag11 and __lph_capture_array_1000021[1].accent or __lph_capture_array_1000021[1].textcolor
										v24.text:SetAttribute("Selected", flag11)
										v24.text:SetAttribute("TextDisabled", flag11)
									end
								end
								tbl3.value = value
								__lph_capture_array_1000021[1]:setflag(flag, value)
								fn6(textLabel, value or "None")
							end
							fn10(tween_3.Text)
						end
						
						tween_3:GetPropertyChangedSignal("Text"):Connect(function()
							
							if flag4 then
								fn10(tween_3.Text)
							end
						end)
						local mouseButton1Click = textButton2.MouseButton1Click
						local connect2 = mouseButton1Click.Connect
						local n23 = 390065638
						local function fn15()
							
							local visible = tween_5.Visible
							bit32.bxor(n23 % 4294967296 - n23 % 4294967296 % 1, 0)
							if visible then
								fn11(true)
							else
								fn12()
							end
						end
						
						n23 = 248483199
						connect2(mouseButton1Click, fn15)
						tween_9:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(fn8)
						fn7()
						fn8()
						tbl3:set(default)
						__lph_capture_array_1000021[1].items[flag] = tbl3
						if flag2 then
							__lph_capture_array_1000021[1].ConfigManager:Register(flag, tbl3)
						end
						fn5(tbl3, tween_2, name_)
						local v25 = 249432045
						local function show(arg5, visible)
							
							local v26 = tween_2
							bit32.bxor(bit32.bxor(v25 % 4294967296 - v25 % 4294967296 % 1, 0), 140763354)
							v26.Visible = visible
							if not visible and tween_5.Visible then
								tween_5.Visible = false
							end
						end
						
						v25 = 242758581
						tbl3.show = show
						return tbl3
					end
					arg2.textbox = function(arg3, arg4)
						
						
						
						
						local tbl3 = { cfg = arg4, type = "textbox" }
						local name_ = arg4.name or arg4.Name or "Textbox"
						local default = arg4.default or arg4.Default or "Text"
						local flag = arg4.flag or __lph_capture_array_1000021[1]:nextflag()
						local flag2 = arg4.save ~= false
						if flag2 then
							
							local save = arg4.Save
							
							flag2 = save ~= false
							
						end
						if not arg4.tooltip then
							local tooltip = arg4.Tooltip
						end
						local callback = arg4.callback or function()
							
						end
						local tween_2 = __lph_capture_array_1000021[1]:Create("Frame", {
							Parent = content,
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, 36),
							ClipsDescendants = false,
							ZIndex = 8,
						})
						tbl3.Frame = tween_2
						__lph_capture_array_1000021[1]:tooltip(tween_2, arg4)
						__lph_capture_array_1000021[1]:Create("TextLabel", {
							Parent = tween_2,
							Text = name_,
							FontFace = __lph_capture_array_1000021[1].font,
							BackgroundColor3 = __lph_capture_array_1000021[1].textcolor,
							BackgroundTransparency = 1,
							TextSize = 12,
							TextColor3 = __lph_capture_array_1000021[1].textcolor,
							Position = UDim2.new(0, 20, 0.20000000298023224, 0),
							TextXAlignment = Enum.TextXAlignment.Left,
							ZIndex = 8,
						})
						local tween_3 = __lph_capture_array_1000021[1]:Create("Frame", {
							Parent = tween_2,
							BackgroundColor3 = __lph_capture_array_1000021[1].stroke2,
							BorderColor3 = Color3.new(0.11764705926179886, 0.11764705926179886, 0.11764705926179886),
							Position = UDim2.new(0.5, 0, 0.69999998807907104, 0),
							AnchorPoint = Vector2.new(0.5, 0.5),
							Size = UDim2.new(0, 364, 0, 22),
							ClipsDescendants = true,
							ZIndex = 7,
						})
						__lph_capture_array_1000021[1]:Create("UICorner", { Parent = tween_3, CornerRadius = UDim.new(0, 4) })
						
						local tween_4 = __lph_capture_array_1000021[1]:Create("Frame", {
							Parent = tween_3,
							BackgroundColor3 = __lph_capture_array_1000021[1].stroke,
							BorderColor3 = Color3.new(0.11764705926179886, 0.11764705926179886, 0.11764705926179886),
							Position = UDim2.new(0.5, 0, 0.5, 0),
							AnchorPoint = Vector2.new(0.5, 0.5),
							Size = UDim2.new(1, -2, 1, -2),
							ClipsDescendants = true,
							ZIndex = 8,
						})
						__lph_capture_array_1000021[1]:Create("UICorner", { Parent = tween_4, CornerRadius = UDim.new(0, 4) })
						local v19 = __lph_capture_array_1000021[1]
						local create = v19.Create
						local frame = create(v19, "Frame", {
							Parent = tween_4,
							BackgroundColor3 = __lph_capture_array_1000021[1].buttoncolor,
							BorderColor3 = Color3.new(0.11764705926179886, 0.11764705926179886, 0.11764705926179886),
							Position = UDim2.new(0.5, 0, 0.5, 0),
							AnchorPoint = Vector2.new(0.5, 0.5),
							Size = UDim2.new(1, -2, 1, -2),
							ClipsDescendants = true,
							ZIndex = 9,
						})
						__lph_capture_array_1000021[1]:Create("UICorner", { Parent = frame, CornerRadius = UDim.new(0, 4) })
						__lph_capture_array_1000021[1]:Create("ImageLabel", {
							Parent = frame,
							Image = "rbxassetid://87505091287358",
							ImageTransparency = 0.8,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Position = UDim2.new(0, 0, 0, 0),
							Size = UDim2.new(1, 0, 1, 0),
							ZIndex = 10,
						})
						local tween_5 = __lph_capture_array_1000021[1]:Create("TextButton", {
							Parent = frame,
							Text = "",
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Position = UDim2.new(0, 0, 0, 0),
							Size = UDim2.new(1, 0, 1, 0),
							ZIndex = 10,
						})
						local tween_6 = __lph_capture_array_1000021[1]:Create("TextBox", {
							Parent = frame,
							Text = default,
							FontFace = __lph_capture_array_1000021[1].font,
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							TextSize = 12,
							TextColor3 = __lph_capture_array_1000021[1].textcolor,
							Position = UDim2.new(0.019999999552965164, 0, -0.15000000596046448, 0),
							Size = UDim2.new(0.97000002861022949, 0, 1.1499999761581421, 0),
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Center,
							ClipsDescendants = true,
							ClearTextOnFocus = false,
							ZIndex = 10,
						})
						local n15 = 154525055
						local function set_(arg5, arg6)
							
							local value = tostring(arg6 or "")
							callback(value)
							bit32.bxor(n15 % 4294967296 - n15 % 4294967296 % 1, 0)
							__lph_capture_array_1000021[1]:setflag(flag, value)
							tbl3.value = value
							tween_6.Text = value
						end
						
						n15 = 484461271
						tbl3.set = set_
						
						
						local signal = tween_6:GetPropertyChangedSignal("Text")
						local connect = signal.Connect
						local n18 = 117428494
						local function fn6()
							
							local v21 = tbl3
							local text = tween_6.Text
							local n19 = bit32.bxor(n18 % 4294967296 - n18 % 4294967296 % 1, 0) + 41715038
							v21.value = text
							__lph_capture_array_1000021[1]:setflag(flag, tween_6.Text)
						end
						
						n18 = 237283398
						connect(signal, fn6)
						local focusLost = tween_6.FocusLost
						local connect2 = focusLost.Connect
						local n20 = 179804762
						local function fn7()
							
							local flag3 = bit32.bxor(n20 % 4294967296 - n20 % 4294967296 % 1, 0) == 112490605
							tbl3:set(tween_6.Text)
						end
						
						n20 = 390642791
						connect2(focusLost, fn7)
						
						__lph_capture_array_1000021[1]:mouseffects(tween_5, tween_4)
						tbl3:set(default)
						__lph_capture_array_1000021[1].items[flag] = tbl3
						if flag2 then
							__lph_capture_array_1000021[1].ConfigManager:Register(flag, tbl3)
						end
						fn5(tbl3, tween_2, name_)
						
						local function show(arg5, visible)
							
							tween_2.Visible = visible
						end
						tbl3.show = show
						return tbl3
					end
					arg2.label = function(arg3, cfg)
						
						
						
						local tbl3 = {}
						tbl3.cfg = cfg
						local name_ = cfg.name or cfg.Name or "Label"
						if not cfg.tooltip then
							local tooltip = cfg.Tooltip
						end
						local tween_2 = __lph_capture_array_1000021[1]:Create("Frame", {
							Parent = content,
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, 16),
							ClipsDescendants = false,
							ZIndex = 8,
						})
						tbl3.Frame = tween_2
						__lph_capture_array_1000021[1]:tooltip(tween_2, cfg)
						local tween_3 = __lph_capture_array_1000021[1]:Create("Frame", {
							Parent = tween_2,
							AnchorPoint = Vector2.new(0, 0.5),
							Position = UDim2.new(1, -20, 0, 3),
							AnchorPoint = Vector2.new(1, 0),
							BackgroundTransparency = 1,
							Size = UDim2.new(0, 36, 0, 10),
							ClipsDescendants = false,
							ZIndex = 8,
						})
						__lph_capture_array_1000021[1]:Create("UIListLayout", {
							Parent = tween_3,
							Padding = UDim.new(0.15000000596046448, 0),
							FillDirection = Enum.FillDirection.Horizontal,
							HorizontalAlignment = Enum.HorizontalAlignment.Right,
							VerticalAlignment = Enum.VerticalAlignment.Center,
						})
						local tween_4 = __lph_capture_array_1000021[1]:Create("TextLabel", {
							Parent = tween_2,
							Text = name_,
							FontFace = __lph_capture_array_1000021[1].font,
							BackgroundColor3 = Color3.new(1, 1, 1),
							BackgroundTransparency = 1,
							TextSize = 12,
							TextColor3 = __lph_capture_array_1000021[1].textcolor,
							Position = UDim2.new(0, 20, 0.44999998807907104, 0),
							TextXAlignment = Enum.TextXAlignment.Left,
							ZIndex = 8,
						})
						local function keybind(arg4, arg5)
							
							arg5.parentname = name_
							return __lph_capture_array_1000021[1].createkeybind(tween_3, arg5)
						end
						tbl3.keybind = keybind
						local function fn6(arg4, arg5)
							
							local n14 = arg5 + math.random(1, 999) + tick() + collectgarbage("count") + os.time() + gcinfo()
							local n15 = 181543636
							local function fn7(arg6)
								
								local flag = n14 == arg6
								local n16 = bit32.bxor(n15 % 4294967296 - n15 % 4294967296 % 1, 0) + 54580262
								return flag and n14 % 715 * 28 + n14 % 147 + 194
							end
							local v18 = bit32.bxor(arg4 % 4294967296 - arg4 % 4294967296 % 1, 373308967)
							n15 = bit32.bxor(181543636, v18 % 4294967296 - v18 % 4294967296 % 1)
							return n14, fn7
						end
						local v18, v19 = fn6(397908871, 0)
						local n14 = (v18 % 293 + 272) * 16 % 932
						
						local n16 = (v18 % 293 + 272) * 16 % 932
						local flag = not ({ [v19(v18)] = true })[v18 % 715 * 28 + v18 % 147 + 194]
						
						if not (flag or n14 % n16 < 0 or n14 + n16 ~= n16 * 2) then
							local n17 = 418863132
							local function colorpicker(arg4, arg5)
								
								local createcolorpicker = __lph_capture_array_1000021[1].createcolorpicker
								local v21 = n17
								local n18
								if v21 % 4294967296 ~= v21 % 4294967296 then
									n18 = 0
								else
									n18 = v21 % 4294967296 - v21 % 4294967296 % 1
								end
								if bit32.bxor(n18, 0) ~= 228634870 then
									local v22 = n17
									local n19
									if v22 % 4294967296 ~= v22 % 4294967296 then
										n19 = 0
									else
										n19 = v22 % 4294967296 - v22 % 4294967296 % 1
									end
									n17 = bit32.bxor(n19, 3728504157)
								end
								return createcolorpicker(tween_3, arg5)
							end
							
							n17 = 228634870
							tbl3.colorpicker = colorpicker
							fn5(tbl3, tween_2, name_)
							local n19 = 319127396
							local function set_(arg4, text)
								
								local v21 = tween_4
								local v22 = n19
								local n20
								if v22 % 4294967296 ~= v22 % 4294967296 then
									n20 = 0
								else
									n20 = v22 % 4294967296 - v22 % 4294967296 % 1
								end
								local n21 = bit32.bxor(n20, 0) + 42465747
								if n21 % 4294967296 - n21 % 4294967296 % 1 ~= 295979221 then
									local v23 = n19
									local n22
									if v23 % 4294967296 ~= v23 % 4294967296 then
										n22 = 0
									else
										n22 = v23 % 4294967296 - v23 % 4294967296 % 1
									end
									n19 = bit32.bxor(n22, 2033574779)
								end
								v21.Text = text
							end
							n19 = 253513474
							tbl3.set = set_
							local n20 = 463301754
							local function show(arg4, visible)
								
								tween_2.Visible = visible
								local flag2 = bit32.bxor(bit32.bxor(n20 % 4294967296 - n20 % 4294967296 % 1, 0), 398623825) == 184767387
							end
							n20 = 11164767
							tbl3.show = show
							return tbl3
						end
						
					end
					arg2.separator = function(arg3, arg4)
						
						
						local tbl3 = {}
						local name_ = arg4.name or arg4.Name or "Separator"
						local v18 = __lph_capture_array_1000021[1]:gettextbounds(name_, __lph_capture_array_1000021[1].font, 12)
						local tween_2 = __lph_capture_array_1000021[1]:Create("Frame", {
							Parent = content,
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, 14),
							ClipsDescendants = true,
							ZIndex = 6,
						})
						local v19 = __lph_capture_array_1000021[1]
						__lph_capture_array_1000021[1]:Create("Frame", {
							Parent = tween_2,
							BorderSizePixel = 0,
							BackgroundColor3 = __lph_capture_array_1000021[1].stroke,
							Size = UDim2.new(1, -38, 0, 1),
							Position = UDim2.new(0.5, 0, 0.5, 0),
							AnchorPoint = Vector2.new(0.5, 0.5),
							ClipsDescendants = true,
							ZIndex = 6,
						})
						local v20 = __lph_capture_array_1000021[1]
						local create = v20.Create
						local tbl4 = {
							Parent = tween_2,
							Text = name_,
							FontFace = __lph_capture_array_1000021[1].font,
							BackgroundTransparency = 0,
							BorderSizePixel = 0,
							TextSize = 12,
						}
						repeat
							tbl4.BackgroundColor3 = __lph_capture_array_1000021[1].contentcolor
							tbl4.TextColor3 = __lph_capture_array_1000021[1].textcolor
							tbl4.Position = UDim2.new(0.5, 0, 0.5, -1)
							tbl4.AnchorPoint = Vector2.new(0.5, 0.5)
							tbl4.Size = UDim2.new(0, v18 + 6, 0, 12)
							tbl4.TextXAlignment = Enum.TextXAlignment.Center
							tbl4.TextYAlignment = Enum.TextYAlignment.Center
							tbl4.ZIndex = 8
							create(v20, "TextLabel", tbl4)
							
						until v19
						fn5(tbl3, tween_2, name_)
						local n13 = 441772219
						local function show(arg5, visible)
							
							local v21 = tween_2
							local flag = bit32.bxor(n13 % 4294967296 - n13 % 4294967296 % 1, 0) == 222008264
							v21.Visible = visible
						end
						
						n13 = 188399817
						tbl3.show = show
						return tbl3
					end
				end
			end
			additems = fn4(table.pack(library, runService,  randomFactory ,  instanceFactory , nil, userInputService, v7))
			local n = n8 - 3956311516
			
			local function fn5(__lph_capture_array_1000002, __lph_unused_1)
				return function(arg2, arg3)
					
					local n14 = 2635040641
					
					local n16 = 500150319
					local tbl3 = {}
					local game_ = arg3.game or arg3.Game or ""
					local v18 = __lph_capture_array_1000002[1]
					local create = v18.Create
					MainFrameBG1 = create(v18, "Frame", {
						Parent = __lph_capture_array_1000002[1].ScreenGUI,
						AnchorPoint = Vector2.new(0.5, 0.5),
						BorderSizePixel = 0,
						BackgroundColor3 = __lph_capture_array_1000002[1].stroke2,
						Position = UDim2.new(__lph_capture_array_1000002[2].TouchEnabled and 0.5 or 0.25, 0, __lph_capture_array_1000002[2].TouchEnabled and 0.5 or 0.6, 0),
						Size = UDim2.new(0, 564, 0, __lph_capture_array_1000002[2].TouchEnabled and 304 or 424),
						ClipsDescendants = true,
						Visible = true,
						ZIndex = 2,
					})
					
					__lph_capture_array_1000002[1]:Create("UICorner", { Parent = MainFrameBG1, CornerRadius = UDim.new(0, 8) })
					
					local v19 = __lph_capture_array_1000002[1]
					local create2 = v19.Create
					local tbl4 = {
						Parent = MainFrameBG1,
						AnchorPoint = Vector2.new(0.5, 0.5),
						BorderSizePixel = 0,
						BackgroundColor3 = __lph_capture_array_1000002[1].stroke,
						Position = UDim2.new(0.5, 0, 0.5, 0),
					}
					local udim2 = UDim2.new
					tbl4.Size = udim2(0, 562, 0, __lph_capture_array_1000002[2].TouchEnabled and 302 or 422)
					tbl4.ClipsDescendants = true
					tbl4.Visible = true
					tbl4.ZIndex = 2
					local frame = create2(v19, "Frame", tbl4)
					__lph_capture_array_1000002[1]:Create("UICorner", { Parent = frame, CornerRadius = UDim.new(0, 8) })
					local v20 = __lph_capture_array_1000002[1]
					local create3 = v20.Create
					local tbl5 = {
						Parent = frame,
						AnchorPoint = Vector2.new(0.5, 0.5),
						BorderSizePixel = 0,
						BackgroundColor3 = __lph_capture_array_1000002[1].backgroundcolor,
						Position = UDim2.new(0.5, 0, 0.5, 0),
					}
					local udim22 = UDim2.new
					local touchEnabled = __lph_capture_array_1000002[2].TouchEnabled
					if touchEnabled then
						
						n16 = 500150319
						touchEnabled = 300
					end
					tbl5.Size = udim22(0, 560, 0, touchEnabled or 420)
					tbl5.ClipsDescendants = true
					tbl5.Visible = true
					tbl5.ZIndex = 2
					local frame2 = create3(v20, "Frame", tbl5)
					__lph_capture_array_1000002[1]:Create("UICorner", { Parent = frame2, CornerRadius = UDim.new(0, 8) })
					__lph_capture_array_1000002[1]:Create("ImageLabel", {
						Parent = frame2,
						Image = "rbxassetid://82901197465489",
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Position = UDim2.new(0, 40, 0, 1),
						Size = UDim2.new(0, 66, 0, 28),
						ZIndex = 3,
					})
					__lph_capture_array_1000002[1]:Create("TextLabel", {
						Parent = frame2,
						Text = game_,
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						TextSize = 12,
						FontFace = __lph_capture_array_1000002[1].font,
						TextColor3 = __lph_capture_array_1000002[1].accent,
						Position = UDim2.new(1, 0, 0, 0),
						Size = UDim2.new(0, 400, 0, 30),
						AnchorPoint = Vector2.new(1, 0),
						ZIndex = 3,
					})
					local v21 = __lph_capture_array_1000002[1]
					local v22 = __lph_capture_array_1000002[1]
					local create4 = v22.Create
					local tbl6 = {
						Parent = frame2,
						BackgroundColor3 = __lph_capture_array_1000002[1].stroke,
						BorderSizePixel = 0,
						Position = UDim2.new(0, 0, 0, 30),
						Size = UDim2.new(1, 0, 0, 1),
						ZIndex = 10,
					}
					local str = "Frame"
					create4(v22, str, tbl6)
					local function toggle(arg4, visible)
						
						MainFrameBG1.Visible = visible
						if not visible then
							__lph_capture_array_1000002[1]:hidepopups()
						end
					end
					local v23 = __lph_capture_array_1000002[1]
					
					if v21 then
						n14 = 2820604588
						v23.toggle = toggle
						
						n16 = 3050353283
						
						__lph_capture_array_1000002[1]:makedraggable(MainFrameBG1, 30)
						v22 = __lph_capture_array_1000002[1]
						create4 = v22.Create
						tbl6 = {
							Parent = frame2,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Size = UDim2.new(0, 160, 1, -30),
							BackgroundColor3 = __lph_capture_array_1000002[1].accent,
							CanvasSize = UDim2.new(0, 0, 0, 0),
							ScrollBarThickness = 2,
							Position = UDim2.new(0, 0, 0, 30),
							ClipsDescendants = true,
							ZIndex = 3,
						}
						str = "ScrollingFrame"
					end
					local v24 = create4(v22, str, tbl6)
					__lph_capture_array_1000002[1]:Create("Frame", {
						Parent = frame2,
						BackgroundColor3 = __lph_capture_array_1000002[1].stroke,
						BorderSizePixel = 0,
						Position = UDim2.new(0, 160, 0, 30),
						Size = UDim2.new(0, 1, 1, -30),
						ZIndex = 7,
					})
					local tween_2 = __lph_capture_array_1000002[1]:Create("UIListLayout", {
						Parent = v24,
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Top,
						Padding = UDim.new(0, 2),
					})
					local n20 = 433886523
					local function fn6()
						
						local v25 = v24
						local udim23 = UDim2.new(0, 0, 0, tween_2.AbsoluteContentSize.Y + 16)
						local flag = bit32.bxor(bit32.bxor(n20 % 4294967296 - n20 % 4294967296 % 1, 0), 300065229) ~= 164418291
						v25.CanvasSize = udim23
					end
					n20 = 405697342
					tween_2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(fn6)
					
					__lph_capture_array_1000002[1]:Create("UIPadding", { Parent = v24, PaddingTop = UDim.new(0, 4) })
					local tween_3 = __lph_capture_array_1000002[1]:Create("TextButton", {
						Text = name,
						Parent = v24,
						BackgroundTransparency = 0,
						TextSize = 12,
						FontFace = __lph_capture_array_1000002[1].font,
						BackgroundColor3 = __lph_capture_array_1000002[1].stroke2,
						TextColor3 = Color3.new(1, 1, 1),
						BorderSizePixel = 0,
						Size = UDim2.new(0.92000001668930054, 4, 0, 24),
						AutoButtonColor = false,
						ZIndex = 3,
					})
					__lph_capture_array_1000002[1]:Create("UICorner", { Parent = tween_3, CornerRadius = UDim.new(0, 6) })
					local tween_4 = __lph_capture_array_1000002[1]:Create("TextButton", {
						Text = name,
						Parent = tween_3,
						BackgroundTransparency = 0,
						AnchorPoint = Vector2.new(0.5, 0.5),
						TextSize = 12,
						FontFace = __lph_capture_array_1000002[1].font,
						BackgroundColor3 = __lph_capture_array_1000002[1].stroke,
						TextColor3 = Color3.new(1, 1, 1),
						BorderSizePixel = 0,
						Size = UDim2.new(1, -2, 1, -2),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						AutoButtonColor = false,
						ZIndex = 4,
					})
					__lph_capture_array_1000002[1]:Create("UICorner", { Parent = tween_4, CornerRadius = UDim.new(0, 6) })
					local tween_5 = __lph_capture_array_1000002[1]:Create("Frame", {
						Parent = tween_4,
						BackgroundTransparency = 0,
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = __lph_capture_array_1000002[1].buttoncolor,
						BorderSizePixel = 0,
						Size = UDim2.new(1, -2, 1, -2),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						ClipsDescendants = true,
						ZIndex = 5,
					})
					__lph_capture_array_1000002[1]:Create("ImageLabel", {
						Parent = tween_5,
						Image = "rbxassetid://102190813787384",
						ImageColor3 = __lph_capture_array_1000002[1].textcolor,
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0, 3, 0.5, 0),
						Size = UDim2.new(0, 14, 0, 14),
						ZIndex = 5,
					})
					local v25 = __lph_capture_array_1000002[1]
					local tween_6 = v25:Create("TextBox", {
						PlaceholderText = "Search",
						Text = "",
						Parent = tween_5,
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(0.5, 0.5),
						TextSize = 12,
						FontFace = __lph_capture_array_1000002[1].font,
						TextColor3 = Color3.new(1, 1, 1),
						BorderSizePixel = 0,
						Size = UDim2.new(1, -2, 1, 1),
						Position = UDim2.new(0.5, 0, 0.5, -1),
						ZIndex = 5,
					})
					local v26 = n14
					local n22
					if v26 % 4294967296 ~= v26 % 4294967296 then
						n22 = 0
					else
						n22 = v26 % 4294967296 - v26 % 4294967296 % 1
					end
					if not (n22 ~= 253166320) then
					end
					v25:Create("ImageLabel", {
						Parent = tween_6,
						Image = "rbxassetid://87505091287358",
						ImageTransparency = 0.85,
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Position = UDim2.new(0, 0, 0, 0),
						Size = UDim2.new(1, 0, 1, 0),
						ZIndex = 6,
					})
					__lph_capture_array_1000002[1]:Create("UICorner", { Parent = tween_5, CornerRadius = UDim.new(0, 6) })
					
					local function fn7(selectedtab)
  local hiddenBySearch = not selectedtab or selectedtab.HiddenBySearch
  if not hiddenBySearch then
   hiddenBySearch = selectedtab.TabRoot
   if hiddenBySearch then
    local tabRoot = selectedtab.TabRoot
    hiddenBySearch = not tabRoot.Visible
   end
  end
  if hiddenBySearch then return end
  for _, tab in ipairs(__lph_capture_array_1000002[1].tabs) do
   tab.Content.Visible = false
   tab.Tab.TextColor3 = __lph_capture_array_1000002[1].textcolor
   tab.Tab:SetAttribute('Selected', false)
  end
  __lph_capture_array_1000002[1]:hidepopups()
  selectedtab.Content.Visible = true
  selectedtab.Tab.TextColor3 = __lph_capture_array_1000002[1].accent
  selectedtab.Tab:SetAttribute('Selected', true)
  __lph_capture_array_1000002[1].selectedtab = selectedtab
 end
					
					
					
					local n25 = 172736155
					local function fn8()
	local v = string.lower((tween_6.Text or ""):gsub("^%s+", ""):gsub("%s+$", ""))
	local flag = v ~= ""
	local tbl = {}
	for _, table_ in ipairs(__lph_capture_array_1000002[1].tables) do
		if table_ and not table_.IsSection and table_.Frame and table_.Frame.Parent then
			local searchText = table_.SearchText
			if not searchText then
				searchText = string.lower(tostring(table_.Name or ""))
			end
			local visible = not flag or string.find(searchText, v, 1, true) ~= nil
			table_.Frame.Visible = visible
			table_._searchVisible = visible
			if visible and table_.Tab then
				tbl[table_.Tab] = (tbl[table_.Tab] or 0) + 1
			end
		end
	end
	for _, table_ in ipairs(__lph_capture_array_1000002[1].tables) do
		if table_ and table_.IsSection and table_.Frame and table_.SectionContent then
			local visible = false
			local exitTo = nil
			for _, child in ipairs(table_.SectionContent:GetChildren()) do
				if child:IsA("GuiObject") and child.Visible then
					exitTo = 1
					break
				end
			end
			if exitTo == 1 then
				visible = true
			end
			table_.Frame.Visible = visible
			table_._searchVisible = visible
			if visible and table_.Tab then
				tbl[table_.Tab] = (tbl[table_.Tab] or 0) + 1
			end
		end
	end
	local v2 = nil
	for _, tab in ipairs(__lph_capture_array_1000002[1].tabs) do
		local hiddenBySearch = (tbl[tab] or 0) <= 0
		tab.HiddenBySearch = hiddenBySearch
		local visible = not hiddenBySearch
		tab.TabRoot.Visible = visible
		if visible and not v2 then
			v2 = tab
		end
	end
	if __lph_capture_array_1000002[1].selectedtab and __lph_capture_array_1000002[1].selectedtab.HiddenBySearch then
		__lph_capture_array_1000002[1].selectedtab = nil
	end
	if __lph_capture_array_1000002[1].selectedtab and __lph_capture_array_1000002[1].selectedtab.TabRoot.Visible then
		if not __lph_capture_array_1000002[1].selectedtab.Content.Visible then
			fn7(__lph_capture_array_1000002[1].selectedtab)
		end
	elseif v2 then
		fn7(v2)
	else
		for _, tab in ipairs(__lph_capture_array_1000002[1].tabs) do
			tab.Content.Visible = false
			tab.Tab.TextColor3 = __lph_capture_array_1000002[1].textcolor
			tab.Tab:SetAttribute("Selected", false)
		end
	end
end
					local v28 = tween_6
					local getPropertyChangedSignal = v28.GetPropertyChangedSignal
					local n26
					if n16 % 4294967296 ~= n16 % 4294967296 then
						n26 = 0
					else
						n26 = n16 % 4294967296 - n16 % 4294967296 % 1
					end
					local v29 = bit32.bxor(n26, 3214923496)
					n25 = bit32.bxor(172736155, v29)
					getPropertyChangedSignal(v28, "Text"):Connect(fn8)
					local n27 = 499532646
					local function tab(arg4,arg5)
	
	
	
	
	local name = arg5.name or arg5.Name or "Tab"
	
	local tween_ = __lph_capture_array_1000002[1]:Create("TextButton", {
		Text = name,
		Parent = v24,
		BackgroundTransparency = 0,
		TextSize = 12,
		FontFace = __lph_capture_array_1000002[1].font,
		BackgroundColor3 = __lph_capture_array_1000002[1].stroke2,
		TextColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		Size = UDim2.new(0.92000001668930054, 4, 0, 24),
		AutoButtonColor = false,
		ZIndex = 3,
	})
	
	
	__lph_capture_array_1000002[1]:Create("UICorner", { Parent = tween_, CornerRadius = UDim.new(0, 6) })
	local tween_2 = __lph_capture_array_1000002[1]:Create("TextButton", {
		Text = name,
		Parent = tween_,
		BackgroundTransparency = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		TextSize = 12,
		FontFace = __lph_capture_array_1000002[1].font,
		BackgroundColor3 = __lph_capture_array_1000002[1].stroke,
		TextColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		Size = UDim2.new(1, -2, 1, -2),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AutoButtonColor = false,
		ZIndex = 4,
	})
	__lph_capture_array_1000002[1]:Create("UICorner", { Parent = tween_2, CornerRadius = UDim.new(0, 6) })
	local tween_3 = __lph_capture_array_1000002[1]:Create("Frame", {
		Parent = tween_2,
		BackgroundTransparency = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = __lph_capture_array_1000002[1].buttoncolor,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -2, 1, -2),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		ClipsDescendants = true,
		ZIndex = 5,
	})
	local tween_4 = __lph_capture_array_1000002[1]:Create("TextButton", {
		Text = name,
		Parent = tween_3,
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		TextSize = 12,
		FontFace = __lph_capture_array_1000002[1].font,
		BackgroundColor3 = __lph_capture_array_1000002[1].buttoncolor,
		TextColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		Size = UDim2.new(1, -2, 1, 1),
		Position = UDim2.new(0.5, 0, 0.5, -1),
		AutoButtonColor = false,
		ZIndex = 5,
	})
	__lph_capture_array_1000002[1]:Create("ImageLabel", {
		Parent = tween_4,
		Image = "rbxassetid://87505091287358",
		ImageTransparency = 0.85,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = 6,
	})
	__lph_capture_array_1000002[1]:Create("UICorner", { Parent = tween_3, CornerRadius = UDim.new(0, 6) })
	tween_4.TextColor3 = __lph_capture_array_1000002[1].textcolor
	
	tween_4:SetAttribute("TextProps", nil)
	tween_4:SetAttribute("IsAccent", "TextColor3")
	local tween_5 = __lph_capture_array_1000002[1]:Create("ScrollingFrame", {
		Parent = frame2,
		BackgroundColor3 = __lph_capture_array_1000002[1].contentcolor,
		BorderSizePixel = 0,
		Position = UDim2.new(1, 0, 0, 30),
		ScrollBarThickness = 2,
		Size = UDim2.new(0, 400, 1, -30),
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AnchorPoint = Vector2.new(1, 0),
		ClipsDescendants = true,
		Visible = false,
		ZIndex = 6,
	})
	
	__lph_capture_array_1000002[1]:Create("UICorner", { Parent = tween_5, CornerRadius = UDim.new(0, 8) })
	local tween_6 = __lph_capture_array_1000002[1]:Create("UIListLayout", {
		Parent = tween_5,
		Padding = UDim.new(0, 2),
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
	})
	__lph_capture_array_1000002[1]:Create("UIPadding", { Parent = tween_5, PaddingTop = UDim.new(0, 4) })
	local signal = tween_6:GetPropertyChangedSignal("AbsoluteContentSize")
	local connect = signal.Connect
	local n9 = 148492710
	local function fn()
		
		tween_5.CanvasSize = UDim2.new(0, 0, 0, tween_6.AbsoluteContentSize.Y + 10)
		local flag = bit32.bxor(bit32.bxor(n9 % 4294967296 - n9 % 4294967296 % 1, 0), 512249979) == 87672098
	end
	
	n9 = 480391298
	connect(signal, fn)
	local parentTab = { Tab = tween_4, TabRoot = tween_, Content = tween_5, Name = name }
	
	
	
	table.insert(__lph_capture_array_1000002[1].tabs, parentTab)
	parentTab.ParentTab = parentTab
	tween_4:SetAttribute("IsAccent", "TextColor3")
	tween_4:SetAttribute("Selected", #__lph_capture_array_1000002[1].tabs == 1)
	if #__lph_capture_array_1000002[1].tabs == 1 then
		tween_4.TextColor3 = __lph_capture_array_1000002[1].accent
		tween_5.Visible = true
	else
		tween_4.TextColor3 = __lph_capture_array_1000002[1].textcolor
		tween_5.Visible = false
	end
	local mouseButton1Click = tween_4.MouseButton1Click
	local connect2 = mouseButton1Click.Connect
	local n13 = 121866671
	local function fn2()
		
		local v2 = parentTab
		bit32.bxor(bit32.bxor(n13 % 4294967296 - n13 % 4294967296 % 1, 0), 410036106)
		if v2.HiddenBySearch then
			return
		end
		fn7(parentTab)
	end
	
	n13 = 32999617
	connect2(mouseButton1Click, fn2)
	local n14 = 215830731
	local function fn3(arg3, frame, name2)
		
		local n15 = bit32.bxor(n14 % 4294967296 - n14 % 4294967296 % 1, 0) + 506672696
		arg3.Frame = frame
		arg3.Tab = parentTab
		arg3.Content = tween_5
		arg3.Name = name2
		arg3.SearchText = string.lower(tostring(name2 or ""))
		table.insert(__lph_capture_array_1000002[1].tables, arg3)
	end
	
	n14 = 445338967
	
	local function section(arg3,arg4)
	
	
	
	
	local tbl = { ParentTab = parentTab }
	
	local name = arg4.name or arg4.Name or "Section"
	local show = arg4.show or arg4.Show or false
	local tween_ = __lph_capture_array_1000002[1]:Create("Frame", {
		Parent = tween_5,
		BackgroundTransparency = 0,
		BackgroundColor3 = __lph_capture_array_1000002[1].stroke2,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -4, 0, 24),
		ClipsDescendants = true,
		ZIndex = 6,
	})
	__lph_capture_array_1000002[1]:Create("UICorner", { Parent = tween_, CornerRadius = UDim.new(0, 6) })
	local tween_2 = __lph_capture_array_1000002[1]:Create("Frame", {
		Parent = tween_,
		BackgroundTransparency = 0,
		BackgroundColor3 = __lph_capture_array_1000002[1].stroke,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -2, 0, 22),
		Position = UDim2.new(0.5, 0, 0, 1),
		AnchorPoint = Vector2.new(0.5, 0),
		ClipsDescendants = true,
		ZIndex = 6,
	})
	__lph_capture_array_1000002[1]:Create("UICorner", { Parent = tween_2, CornerRadius = UDim.new(0, 6) })
	local tween_3 = __lph_capture_array_1000002[1]:Create("Frame", {
		Parent = tween_2,
		BackgroundTransparency = 0,
		BackgroundColor3 = __lph_capture_array_1000002[1].contentcolor,
		Size = UDim2.new(1, -2, 0, 20),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		ClipsDescendants = true,
		ZIndex = 6,
	})
	__lph_capture_array_1000002[1]:Create("UICorner", { Parent = tween_3, CornerRadius = UDim.new(0, 6) })
	__lph_capture_array_1000002[1]:Create("TextButton", {
		Parent = tween_3,
		Text = name,
		FontFace = __lph_capture_array_1000002[1].font,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		TextSize = 12,
		BackgroundColor3 = __lph_capture_array_1000002[1].buttoncolor,
		TextColor3 = __lph_capture_array_1000002[1].textcolor,
		Position = UDim2.new(0.5, 0, 0, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		Size = UDim2.new(1, 0, 0, 16),
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		ZIndex = 8,
	})
	local tween_4 = __lph_capture_array_1000002[1]:Create("TextButton", {
		Parent = tween_3,
		Text = "",
		FontFace = __lph_capture_array_1000002[1].font,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		TextSize = 12,
		BackgroundColor3 = __lph_capture_array_1000002[1].buttoncolor,
		TextColor3 = __lph_capture_array_1000002[1].textcolor,
		Position = UDim2.new(0.5, 0, 0, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		Size = UDim2.new(1, 0, 0, 20),
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		ZIndex = 8,
	})
	
	local tween_5 = __lph_capture_array_1000002[1]:Create("Frame", {
		Parent = tween_,
		BackgroundColor3 = __lph_capture_array_1000002[1].contentcolor,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, -2, 0, 22),
		Size = UDim2.new(1, 0, 0, 0),
		ClipsDescendants = true,
		Visible = true,
		ZIndex = 6,
	})
	local v = __lph_capture_array_1000002[1]
	local create = v.Create
	local imageLabel = create(v, "ImageLabel", {
		Parent = tween_2,
		Image = "rbxassetid://97582511137728",
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 1,
		Position = UDim2.new(0.94999998807907104, 0, 0, 6),
		Rotation = show and 0 or 90,
		Size = UDim2.new(0, 10, 0, 10),
		Visible = true,
		ZIndex = 8,
	})
	
	tbl.Content = tween_5
	tbl.SectionContent = tween_5
	tbl.Frame = tween_
	
	
	tbl.IsSection = true
	local tween_6 = __lph_capture_array_1000002[1]:Create("UIListLayout", {
		Parent = tween_5,
		Padding = UDim.new(0, 2),
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
	})
	local signal = tween_6:GetPropertyChangedSignal("AbsoluteContentSize")
	local connect = signal.Connect
	local n8 = 378230212
	local function fn()
		
		
		local n10 = 1637615141
		if show then
			tween_5.Size = show and UDim2.new(1, 0, 0, tween_6.AbsoluteContentSize.Y) or UDim2.new(1, 2, 0, 0)
			local v2 = tween_
			local v3 = show
			if show then
				local udim2 = UDim2.new
				local v4 = tween_6
				local v5 = bit32.bxor(n8 % 4294967296 - n8 % 4294967296 % 1, 0)
				v3 = udim2(1, -4, 0, v4.AbsoluteContentSize.Y + 28)
				n10 = bit32.bxor(v5, 1959758083)
			end
			v2.Size = v3 or UDim2.new(1, -4, 0, 24)
			local v4 = tween_2
			v4.Size = show and UDim2.new(1, -2, 0, tween_6.AbsoluteContentSize.Y + 26) or UDim2.new(1, -2, 0, 22)
			local v5 = tween_3
			local v6 = show
			if show then
				local udim2 = UDim2.new
				local v7 = bit32.bxor(n8 % 4294967296 - n8 % 4294967296 % 1, 0)
				local n11 = bit32.band(3373953551, v7) - 938971127
				v6 = udim2(1, -2, 0, tween_6.AbsoluteContentSize.Y + 24)
			end
			v5.Size = v6 or UDim2.new(1, -2, 0, 20)
		end
	end
	
	n8 = 357797670
	connect(signal, fn)
	local v2 = __lph_capture_array_1000002[1]
	local connect2 = v2.connect
	local activated = tween_4.Activated
	
	local function fn2()
	show = not show
	local v = __lph_capture_array_1000002[3]
	local create = v.Create
	local tweenInfo = TweenInfo.new(0.1)
	local tbl = {}
	tbl.Rotation = show and 0 or 90
	create(v, imageLabel, tweenInfo, tbl):Play()
	local v2 = __lph_capture_array_1000002[3]
	local create2 = v2.Create
	local tweenInfo2 = TweenInfo.new(0.1)
	local tbl2 = {}
	local v3 = show
	if show then
		local udim2 = UDim2.new(1, -4, 0, tween_6.AbsoluteContentSize.Y + 28)
		v3 = udim2
	end
	tbl2.Size = v3 or UDim2.new(1, -4, 0, 24)
	create2(v2, tween_, tweenInfo2, tbl2):Play()
	local v4 = __lph_capture_array_1000002[3]
	local create3 = v4.Create
	local tweenInfo3 = TweenInfo.new(0.1)
	local tbl3 = {}
	tbl3.Size = show and UDim2.new(1, -2, 0, tween_6.AbsoluteContentSize.Y + 26) or UDim2.new(1, -2, 0, 22)
	create3(v4, tween_2, tweenInfo3, tbl3):Play()
	local v5 = __lph_capture_array_1000002[3]
	local create4 = v5.Create
	local tweenInfo4 = TweenInfo.new(0.1)
	local tbl4 = {}
	tbl4.Size = show and UDim2.new(1, -2, 0, tween_6.AbsoluteContentSize.Y + 24) or UDim2.new(1, -2, 0, 20)
	create4(v5, tween_3, tweenInfo4, tbl4):Play()
	local v6 = __lph_capture_array_1000002[3]
	local create5 = v6.Create
	local tweenInfo5 = TweenInfo.new(0.1)
	local tbl5 = {}
	local udim2 = show
	if show then
		udim2 = UDim2.new(1, 0, 0, tween_6.AbsoluteContentSize.Y)
	end
	tbl5.Size = udim2 or UDim2.new(1, 0, 0, 0)
	tween = create5(v6, tween_5, tweenInfo5, tbl5):Play()
end
	
	
	connect2(v2, activated, fn2)
	additems(tbl)
	fn3(tbl, tween_, name)
	return tbl
end
	
	parentTab.section = section
	
	additems(parentTab)
	return parentTab
end
					local n28 = n14 - 2707478690
					
					local n30
					if n28 % 4294967296 ~= n28 % 4294967296 then
						n30 = 0
					else
						n30 = n28 % 4294967296 - n28 % 4294967296 % 1
					end
					n27 = bit32.bxor(499532646, n30)
					tbl3.tab = tab
					return tbl3
				end
			end
			library.new = fn5(table.pack(library, userInputService, tweenService))
			getgenv().library = library
			hooktest = function()
    return "original"
end
local hookOk = false
pcall(function()
    if typeof(hookfunction) == "function" then
        hookfunction(hooktest, function()
            return "hooked"
        end)
        hookOk = (hooktest() == "hooked")
    end
end)
if not hookOk then
    pcall(function()
        library:Notify({
            text = "Executor may not fully support all features. Use at your own risk.",
            time = 10,
            highlights = { tostring(identifyexecutor and identifyexecutor() or "Unknown") },
        })
    end)
end
			if not isfolder("Boo/games/" .. game.PlaceId) then
				local v18 = makefolder
				local placeId = game.PlaceId
				n8 = bit32.bor(n8, v17)
				v18("Boo/games/" .. placeId)
			end
			tbl2 = {}
			settings = { enabled = library.flags.enableesp }
			local v18 = bit32.rshift(v17, 9)
			settings.maxDistance = library.flags.espmaxdistance or 1000
			local box = { enabled = library.flags.enableespbox }
			box.color = library.flags.espboxcolorpicker and library.flags.espboxcolorpicker.Color or Color3.new(1, 1, 1)
			box.thickness = 1
			box.transparency = library.flags.espboxcolorpicker and 1 - library.flags.espboxcolorpicker.Alpha or 1
			box.filled = false
			settings.box = box
			local highlight = { enabled = library.flags.enableesphighlight }
			local esphighlightcolorpickerfill = library.flags.esphighlightcolorpickerfill
			local color
			if esphighlightcolorpickerfill then
				local flags = library.flags
				local n13 = bit32.bxor(n8, 392011027) + 3902956269
				n8 = n13 % 4294967296 - n13 % 4294967296 % 1
				color = flags.esphighlightcolorpickerfill.Color
			else
				color = esphighlightcolorpickerfill
			end
			highlight.fillColor = color or Color3.new(1, 1, 1)
			highlight.outlineColor = library.flags.esphighlightcolorpickeroutline and library.flags.esphighlightcolorpickeroutline.Color or Color3.new(1, 1, 1)
			local v19 = bit32.rshift(n8, 10)
			highlight.fillTransparency = library.flags.esphighlightcolorpickerfill and library.flags.esphighlightcolorpickerfill.Alpha or 0.5
			highlight.outlineTransparency = library.flags.esphighlightcolorpickeroutline and library.flags.esphighlightcolorpickeroutline.Alpha or 0
			highlight.depthMode = Enum.HighlightDepthMode.AlwaysOnTop
			settings.highlight = highlight
			local n13 = v18 * 16
			local text = {
				nameEnabled = library.flags.enableespname,
				distanceEnabled = library.flags.enableespdistance,
				godindicator = library.flags.enableespgodindicator,
			}
			text.color = library.flags.espnamecolorpicker and library.flags.espnamecolorpicker.Color or Color3.new(1, 1, 1)
			text.size = library.flags.esptextsize or 16
			n11 = v19 // 94
			text.center = true
			text.outline = library.flags.enableesptextoutlines
			text.outlineColor = library.flags.esptextoutlinecolorpicker and library.flags.esptextoutlinecolorpicker.Color or Color3.new(0, 0, 0)
			settings.text = text
			local itemtext = { enabled = false }
			local n14 = n11 + 317525938
			local espnamecolorpicker = library.flags.espnamecolorpicker
			if espnamecolorpicker then
				n13 = bit32.lshift(n13, 24)
				espnamecolorpicker = library.flags.espnamecolorpicker.Color
			end
			itemtext.color = espnamecolorpicker or Color3.new(1, 1, 1)
			itemtext.size = library.flags.esptextsize or 16
			itemtext.center = true
			itemtext.outline = library.flags.enableesptextoutlines
			itemtext.outlineColor = library.flags.esptextoutlinecolorpicker and library.flags.esptextoutlinecolorpicker.Color or Color3.new(0, 0, 0)
			settings.itemtext = itemtext
			local healthbar = { enabled = library.flags.enableesphealthbar, thickness = 1, filled = true, transparency = 1 }
			local n15 = n13 // 122
			local background = { enabled = true, thickness = 2, filled = true }
			local espbarcolorpicker = library.flags.espbarcolorpicker
			local v20
			if espbarcolorpicker then
				local color2 = library.flags.espbarcolorpicker.Color
				n11 *= bit32.bxor(v15, 0)
				v20 = color2
			else
				v20 = espbarcolorpicker
			end
			background.color = v20 or Color3.new(0, 0, 0)
			healthbar.background = background
			settings.healthbar = healthbar
			local healthtext = {
				enabled = library.flags.enableesphealthtext,
				color = library.flags.esphealthtextcolorpicker and library.flags.esphealthtextcolorpicker.Color or Color3.new(1, 1, 1),
				size = library.flags.esptextsize or 16,
				center = true,
				outline = library.flags.enableesptextoutlines,
			}
			healthtext.outlineColor = library.flags.esptextoutlinecolorpicker and library.flags.esptextoutlinecolorpicker.Color or Color3.new(0, 0, 0)
			settings.healthtext = healthtext
			tbl2.settings = settings
			v16 = cloneref(game:GetService("RunService"))
			n12 = n15 + n11
		end
		local v17
		v17 = cloneref(game:GetService("ReplicatedStorage"))
		local v18
		v18 = cloneref(game:GetService("Players"))
		cloneref(game:GetService("Debris"))
		local v19
		v19 = cloneref(game:GetService("Workspace"))
		cloneref(game:GetService("TweenService"))
		local v20
		v20 = cloneref(game:GetService("CollectionService"))
		local v21
		v21 = cloneref(game:GetService("TeleportService"))
		local v22
		v22 = cloneref(game:GetService("CoreGui"))
		local v23
		v23 = cloneref(game:GetService("GuiService"))
		local v24
		v24 = cloneref(game:GetService("Lighting"))
		local v25, v26, localPlayer, mouse2, currentCamera, mainGui, topbar, character, humanoid, humanoidRootPart
		local game_, Packets, GameUtil, ItemIDS, ItemData, animations, inventory, functions, rendering, interpolationBuffer
		local tool, n13, bufferWriter, client, Clock, statusEffects, LevelData, tbl3, tbl4, flag
		local n14, n15
		do
			local n = n11 * n12
			v25 = cloneref(game:GetService("UserInputService"))
			cloneref(game:GetService("PathfindingService"))
			v26 = cloneref(game:GetService("VirtualInputManager"))
			repeat
				task.wait()
			until v17:FindFirstChild("GameLoaded")
			if v17:FindFirstChild("ClientAnimalReady") then
				v17:FindFirstChild("ClientAnimalReady"):Destroy()
			end
			localPlayer = v18.LocalPlayer
			local playerGui = localPlayer.PlayerGui
			mouse2 = localPlayer:GetMouse()
			currentCamera = v19.CurrentCamera
			mainGui = playerGui.MainGui
			local n16 = n - 4117800832
			local n17 = n16 % 4294967296 - n16 % 4294967296 % 1
			local secondaryGui = playerGui.SecondaryGui
			topbar = playerGui.Topbar
			character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
			humanoid = character:WaitForChild("Humanoid")
			humanoidRootPart = character:WaitForChild("HumanoidRootPart")
			game_ = v17:FindFirstChild("Game")
			Packets = require(v17.Modules.Packets)
			GameUtil = require(v17.Modules.GameUtil)
			ItemIDS = require(v17.Modules.ItemIDS)
			ItemData = require(v17.Modules.ItemData)
			animations = require(game_.animations)
			require(game_.pickup)
			inventory = require(game_.inventory)
			functions = require(game_.functions)
			rendering = require(game_.rendering)
			interpolationBuffer = rendering.interpolationBuffer
			tool = require(game_.tool)
			n13 = n12 * 13 // 11
			bufferWriter = require(v17.Modules.ByteNet.process.bufferWriter)
			client = require(v17.Modules.ByteNet.process.client)
			Clock = require(v17.Modules.Clock)
			require(game_.classes.projectile)
			require(game_.structures)
			require(v17.Modules.Achievements)
			require(game_.toolbar)
			require(game_.tool.Draw)
			statusEffects = require(game_.classes.statusEffects)
			LevelData = require(v17.Modules.LevelData)
			tbl3 = {}
			tbl4 = {}
			flag = false
			n14 = 0
			local v27 = bit32.bxor(v15, 0)
			local v28 = table.pack(bit32.band(n17, 4294967295))
			local v29 = table.pack(bit32.band(v27, 4294967295))
			local v30 = table.pack(bit32.band(v28[1], 65535))
			local v31 = table.pack(bit32.rshift(v28[1], 16))
			local v32 = table.pack(bit32.band(v29[1], 65535))
			local v33 = table.pack(bit32.band(v30[1] * v32[1] + bit32.lshift(bit32.band(v30[1] * bit32.rshift(v29[1], 16) + v31[1] * v32[1], 65535), 16), 4294967295))
			n15 = (v33[1] % 4294967296 - v33[1] % 4294967296 % 1) // 4
		end
		local v27, n16, fn4
		do
			local function fn5(arg2)
				
				if arg2 then
					pcall(function()
						
						arg2.Visible = false
						arg2:Remove()
					end)
				end
			end
			local function fn6(arg2)
				
				if arg2 then
					pcall(function()
						
						arg2:Destroy()
					end)
				end
			end
			local function fn7()
				
				local tbl5 = { v22, v19 }
				local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
				if playerGui then
					table.insert(tbl5, playerGui)
				end
				local ok, result = pcall(gethui)
				if ok and result then
					table.insert(tbl5, result)
				end
				return tbl5
			end
			local function fn8(arg2)
				
				return arg2.Name == "KillAuraHighlight" or arg2.Name == "ResourceHighlight" or arg2:GetAttribute("BooESP") == true or arg2:GetAttribute("BooHighlight") == true
			end
			local function fn9()
				
				for _, v28 in ipairs(fn7()) do
					for _, descendant in ipairs(v28:QueryDescendants("Highlight")) do
						if descendant:IsA("Highlight") and fn8(descendant) then
							fn6(descendant)
						end
					end
				end
			end
			local function fn10()
				
				fn6(killaurahighlight)
				killaurahighlight = nil
				killauratarget = nil
				do
local previousResourceHighlights=resourcehighlights
if previousResourceHighlights~=nil then
for _, v28 in pairs(previousResourceHighlights) do
					if type(v28) == "table" then
						for k, v29 in pairs(v28) do
							fn6(v29)
							v28[k] = nil
						end
					end
				end
end
end
				fn9()
			end
			fn10()
			v27 = bit32.bxor(v15, n15 % 4294967296 - n15 % 4294967296 % 1)
			local function fn11(arg2, arg3)
				
				local v28 = Drawing.new(arg2)
				for k, v29 in pairs(arg3) do
					v28[k] = v29
				end
				return v28
			end
			local function fn12(arg2)
				
				for _, child in ipairs(arg2:GetChildren()) do
					if child:IsA("Tool") then
						return tostring(child.Name)
					end
				end
				return "None"
			end
			local function fn13(arg2)
				
				local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
				playerGui = playerGui and playerGui:FindFirstChild("SecondaryGui")
				playerGui = playerGui and playerGui:FindFirstChild("PlayerList")
				local list = playerGui and playerGui:FindFirstChild("List")
				list = list and list:FindFirstChild(arg2.Name)
				if not list then
					return arg2.Name
				end
				local levelLabel = list:FindFirstChild("LevelLabel", true)
				if levelLabel and levelLabel:IsA("TextLabel") then
					return arg2.Name .. " (" .. levelLabel.Text .. ")"
				end
				return arg2.Name
			end
			local function fn14(arg2, arg3)
				
				local v28 = fn13(arg2)
				if tbl2.settings.text.distanceEnabled then
					local currentCamera2 = v19.CurrentCamera
					if currentCamera2 and arg3 then
						v28 ..= " [" .. math.floor((currentCamera2.CFrame.Position - arg3.Position).Magnitude) .. "m]"
					end
				end
				return v28
			end
			local function fn15(arg2, arg3)
				
				
				
				local currentCamera2 = v19.CurrentCamera
				if not currentCamera2 then
					return
				end
				if not arg3 or not arg3.Parent then
					return
				end
				local humanoid2 = arg2:FindFirstChildOfClass("Humanoid")
				
				local position = arg3.Position
				local n18 = humanoid2 and humanoid2.HipHeight + 5 or 6
				local n19 = position + Vector3.new(0, n18 / 2, 0)
				local n20 = position - Vector3.new(0, n18 / 2, 0)
				local v29, v30 = currentCamera2:WorldToViewportPoint(n19)
				local v31 = v29
				local v32 = v30
				local v33, v34 = currentCamera2:WorldToViewportPoint(n20)
				if v31.Z <= 0 or v33.Z <= 0 then
					return
				end
				local flag2 = not v32
				
				if flag2 and not v34 then
					return
				end
				local n21 = math.abs(v31.Y - v33.Y)
				local n22 = n21 / 2.2
				if n21 <= 2 or n22 <= 2 then
					return
				end
				return v33.X - n22 / 2, v31.Y, n22, n21
			end
			n16 = n13 // bit32.bxor(v27, 0)
			
			local function fn16(__lph_capture_array_1000013, __lph_unused_1)
				return function(arg2)
					local tbl5 = {}
					local tbl6 = {
						Visible = false,
						Color = __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]].settings.box.color,
						Thickness = __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]].settings.box.thickness,
						Transparency = __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]].settings.box.transparency,
					}
					
					
					tbl6.Filled = __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]].settings.box.filled
					local Square = __lph_capture_array_1000013[1]("Square", tbl6)
					local tbl7 = {
						Visible = false,
						Text = "GOD",
						Color = __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]].settings.text.color,
						Size = __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]].settings.text.size,
					}
					local center = __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]].settings.text.center
					
					tbl7.Center = center
					tbl7.Outline = __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]].settings.text.outline
					tbl7.OutlineColor = __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]].settings.text.outlineColor
					local Text = __lph_capture_array_1000013[1]("Text", tbl7)
					local tbl8 = { Visible = false }
					
					tbl8.Text = "GOD"
					tbl8.Color = Color3.new(1, 1, 0)
					
					tbl8.Size = __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]].settings.text.size
					tbl8.Center = __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]].settings.text.center
					tbl8.Outline = __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]].settings.text.outline
					tbl8.OutlineColor = __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]].settings.text.outlineColor
					local Text2 = __lph_capture_array_1000013[1]("Text", tbl8)
					local tbl9 = {
						Visible = false,
						Color = __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]].settings.itemtext.color,
						Size = __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]].settings.itemtext.size,
						Center = __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]].settings.itemtext.center,
						Outline = __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]].settings.itemtext.outline,
					}
					local settings2 = __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]].settings
					
					tbl9.OutlineColor = settings2.itemtext.outlineColor
					local Text3 = __lph_capture_array_1000013[1]("Text", tbl9)
					local Square2 = __lph_capture_array_1000013[1]("Square", {
						Visible = false,
						Thickness = __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]].settings.healthbar.background.thickness,
						Filled = __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]].settings.healthbar.background.filled,
						Color = __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]].settings.healthbar.background.color,
					})
					local tbl10 = { Visible = false }
					local thickness = __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]].settings.healthbar.thickness
					
					tbl10.Thickness = thickness
					tbl10.Filled = __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]].settings.healthbar.filled
					tbl10.Transparency = __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]].settings.healthbar.transparency
					local Square3 = __lph_capture_array_1000013[1]("Square", tbl10)
					
					local tbl11 = {
						Visible = false,
						Color = __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]].settings.healthtext.color,
						Size = __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]].settings.healthtext.size,
						Center = __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]].settings.healthtext.center,
					}
					local healthtext = __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]].settings.healthtext
					
					tbl11.Outline = healthtext.outline
					
					
					tbl11.OutlineColor = __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]].settings.healthtext.outlineColor
					local Text4 = __lph_capture_array_1000013[1]("Text", tbl11)
					local highlight = nil
					if __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]].settings.highlight.enabled then
						highlight = Instance.new("Highlight")
						highlight:SetAttribute("BooESP", true)
						highlight:SetAttribute("BooHighlight", true)
						highlight.Enabled = false
						highlight.Adornee = nil
						highlight.FillColor = __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]].settings.highlight.fillColor
						
						highlight.OutlineColor = __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]].settings.highlight.outlineColor
						
						
						highlight.FillTransparency = __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]].settings.highlight.fillTransparency
						highlight.OutlineTransparency = __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]].settings.highlight.outlineTransparency
						
						local v34 = __lph_capture_array_1000013[2][5][__lph_capture_array_1000013[2][4]]
						
						highlight.DepthMode = v34.settings.highlight.depthMode
						highlight.Parent = __lph_capture_array_1000013[3]
						
						
						
					end
					local flag2 = false
					
					local n23 = 464791422
					local function hide()
						
						Square.Visible = false
						Text.Visible = false
						Text2.Visible = false
						Text3.Visible = false
						bit32.bxor(bit32.bxor(n23 % 4294967296 - n23 % 4294967296 % 1, 0), 284085716)
						Square2.Visible = false
						Square3.Visible = false
						Text4.Visible = false
						if highlight then
							highlight.Enabled = false
							highlight.Adornee = nil
						end
					end
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					n23 = 312213010
					tbl5.hide = hide
					tbl5.update = (function(__lph_raw_capture_1,__lph_raw_capture_4,__lph_raw_capture_9,__lph_raw_capture_13,__lph_raw_capture_15,__lph_raw_capture_19,__lph_raw_capture_21,__lph_raw_capture_34,__lph_raw_capture_43,__lph_raw_capture_58,__lph_raw_capture_67,__lph_raw_capture_103) return function()local j= __lph_raw_capture_1 [5][ __lph_raw_capture_1 [4]]or  flag2 ;if j then return;end;local r,p=not  __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.enabled;if r then j= hide ;j();return;end;r= arg2 ;local p,T=not r;if p then T=p;else r= arg2 ;T=not r.Parent;end;local t if T then t=T;else j,p= arg2 , __lph_raw_capture_9 ;t=not j:IsDescendantOf(p);end;if t then p= tbl5 ;p.remove();return;end;j= arg2 ;r=j.Parent;t=r and(r:FindFirstChildOfClass("Humanoid"));j=not r or not r.Parent or not t or t.Health<=0;if j then T= tbl5 ;T.remove();return;end;p= __lph_raw_capture_13 ;T=not p[r.Name]and(r:FindFirstChild("God Halo")or r:FindFirstChild("God Chestplate")or r:FindFirstChild("God Legs"));if T then j= __lph_raw_capture_13 ;j[r.Name]=true;end;p= __lph_raw_capture_9 ;j=p.CurrentCamera;T=not j;if T then p= hide ;p();return;end;local e e, __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.maxDistance= __lph_raw_capture_15 ,tonumber( __lph_raw_capture_15 .flags.espmaxdistance)or  __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.maxDistance or 1000;p= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.maxDistance or 1/0;T,e= arg2 ,(j.CFrame.Position- arg2 .Position).Magnitude>p;if e then p= hide ;p();return;end;p= __lph_raw_capture_19 ;e=p:GetPlayerFromCharacter(r);p=not e;if p then local Y= tbl5 ;Y.remove();return;end;p= __lph_raw_capture_21 ;local Y,P,O,O=p.isInATribe(e.UserId), __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.highlight.enabled;if P then p=not  highlight ;if p then  highlight =Instance.new("Highlight"); highlight :SetAttribute("BooESP",true); highlight :SetAttribute("BooHighlight",true); highlight .Enabled=false; highlight .Adornee=nil;e= __lph_raw_capture_34 ; highlight .Parent=e;end; highlight .Adornee=r; highlight .Enabled=true;local O,D= highlight , __lph_raw_capture_15 ;local A,T=D.flags.esptribecolors;if A then D= __lph_raw_capture_43 ;T=D[Y];else T=A;end;O.FillColor=T or  __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.highlight.fillColor; highlight .OutlineColor= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.highlight.outlineColor; highlight .FillTransparency= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.highlight.fillTransparency; highlight .OutlineTransparency= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.highlight.outlineTransparency; highlight .DepthMode= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.highlight.depthMode;else local O= highlight ;if O then  highlight .Enabled=false; highlight .Adornee=nil;end;end;p,e= __lph_raw_capture_58 , arg2 ;local O,D,L,A=p(r,e);local s,T,T,T,T,T,T,T,T=not O;if s then p= Square ;p.Visible=false;P= Text3 ;P.Visible=false;e= Square2 ;e.Visible=false;local T= Square3 ;T.Visible=false;T= arg2 ;local q,U=j:WorldToViewportPoint(T.Position+Vector3.new(0,3,0));T= arg2 ;local S,Q=j:WorldToViewportPoint(T.Position+Vector3.new(0,-3,0));T= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.text.nameEnabled and U and q.Z>0;if T then local F,y,m= Text , __lph_raw_capture_67 , arg2 ;F.Text=y(r,m);y= Text ;y.Position=Vector2.new(q.X,q.Y);F= Text ;F.Color= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.text.color;F= Text ;F.Size= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.text.size;F= Text ;F.Center= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.text.center;m= Text ;m.Outline= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.text.outline;y= Text ;y.OutlineColor= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.text.outlineColor;y= Text ;y.Visible=true;else local F= Text ;F.Visible=false;end;local F,y= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.text.godindicator;if F then T= __lph_raw_capture_13 ;y=T[r.Name];else y=F;end;T=y and U and q.Z>0;if T then F= Text2 ;F.Position=Vector2.new(q.X,q.Y+7);y= Text2 ;y.Color=Color3.fromRGB(255,255,0);U= Text2 ;U.Size= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.text.size;local m= Text2 ;m.Center= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.text.center;m= Text2 ;m.Outline= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.text.outline;m= Text2 ;m.OutlineColor= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.text.outlineColor;m= Text2 ;m.Visible=true;else local m= Text2 ;m.Visible=false;end;F= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.healthtext.enabled and Q and S.Z>0;if F then q= Text4 ;q.Text=tostring(math.floor(t.Health));y= Text4 ;y.Position=Vector2.new(S.X,S.Y);T= Text4 ;T.Color= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.healthtext.color;Q= Text4 ;Q.Size= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.healthtext.size;U= Text4 ;U.Center= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.healthtext.center;local T= Text4 ;T.Outline= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.healthtext.outline;T= Text4 ;T.OutlineColor= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.healthtext.outlineColor;T= Text4 ;T.Visible=true;else local T= Text4 ;T.Visible=false;end;return;end;p= Square ;p.Size=Vector2.new(math.floor(math.clamp(L,4,9999)),math.floor(math.clamp(A,6,9999)));p= Square ;p.Position=Vector2.new(O,D);s,P= Square , __lph_raw_capture_15 ;j,e=P.flags.esptribecolors;if j then p= __lph_raw_capture_43 ;e=p[Y];else e=j;end;s.Color=e or  __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.box.color;e= Square ;e.Thickness= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.box.thickness;j= Square ;j.Transparency= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.box.transparency;s= Square ;s.Filled= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.box.filled;e= Square ;e.Visible= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.box.enabled;P= Text3 ;P.Position=Vector2.new(O+L/2,D+A);local M,T,T= Text3 ;T,M.Text= __lph_raw_capture_103 ,tostring( __lph_raw_capture_103 (r));s= Text3 ;s.Color= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.itemtext.color;s= Text3 ;s.Size= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.itemtext.size;e= Text3 ;e.Center= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.itemtext.center;M= Text3 ;M.Outline= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.itemtext.outline;s= Text3 ;s.OutlineColor= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.itemtext.outlineColor;p= Text3 ;p.Visible= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.itemtext.enabled;j,p,e= Text , __lph_raw_capture_67 , arg2 ;j.Text=p(r,e);s= Text ;s.Position=Vector2.new(O+L/2,D-20);M,s= Text , __lph_raw_capture_15 ;j,T=s.flags.esptribecolors;if j then p= __lph_raw_capture_43 ;T=p[Y];else T=j;end;M.Color=T or  __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.text.color;M= Text ;M.Size= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.text.size;j= Text ;j.Center= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.text.center;j= Text ;j.Outline= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.text.outline;j= Text ;j.OutlineColor= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.text.outlineColor;s= Text ;s.Visible= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.text.nameEnabled;T= Text2 ;T.Text="GOD";p= Text2 ;p.Position=Vector2.new(O+L/2,D-35);T= Text2 ;T.Color=Color3.fromRGB(255,255,0);L= Text2 ;L.Size= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.text.size;j= Text2 ;j.Center= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.text.center;j= Text2 ;j.Outline= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.text.outline;P= Text2 ;P.OutlineColor= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.text.outlineColor;Y,e= Text2 , __lph_raw_capture_13 ;Y.Visible=e[r.Name]and  __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.text.godindicator or false;Y,L=t.MaxHealth,t.Health;r,P=if Y>0 then math.clamp(L/Y,0,1)else 0, Square2 ;P.Size=Vector2.new(3,math.floor(math.clamp(A,6,9999)));Y= Square2 ;Y.Position=Vector2.new(O-5,D);e= Square2 ;e.Thickness= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.healthbar.background.thickness;s= Square2 ;s.Filled= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.healthbar.background.filled;j= Square2 ;j.Color= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.healthbar.background.color;e= Square2 ;e.Visible= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.healthbar.background.enabled and  __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.healthbar.enabled;e= Square3 ;e.Size=Vector2.new(3,-A*r);t= Square3 ;t.Position=Vector2.new(O-5,D+A);j= Square3 ;j.Thickness= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.healthbar.thickness;M= Square3 ;M.Filled= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.healthbar.filled;j= Square3 ;j.Transparency= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.healthbar.transparency;Y= Square3 ;Y.Visible= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.healthbar.enabled;P,s,M,Y=Color3.new(1,0,0),Color3.new(1,1,0),Color3.new(0,1,0),r<=0.5;if Y then T= Square3 ;T.Color=P:Lerp(s,r*2);else t= Square3 ;t.Color=s:Lerp(M,(r-0.5)*2);end;p= Text4 ;p.Text=tostring(math.floor(L));p,e= Text4 ;e,p.Position= Text4 ,Vector2.new(O- Text4 .TextBounds.X,D+A);O= Text4 ;O.Color= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.healthtext.color;j= Text4 ;j.Size= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.healthtext.size;r= Text4 ;r.Center= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.healthtext.center;T= Text4 ;T.Outline= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.healthtext.outline;O= Text4 ;O.OutlineColor= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.healthtext.outlineColor;O= Text4 ;O.Visible= __lph_raw_capture_4 [5][ __lph_raw_capture_4 [4]].settings.healthtext.enabled;end
					end)(__lph_capture_array_1000013[4],__lph_capture_array_1000013[2],__lph_capture_array_1000013[5],__lph_capture_array_1000013[6],__lph_capture_array_1000013[7],__lph_capture_array_1000013[8],__lph_capture_array_1000013[9],__lph_capture_array_1000013[3],__lph_capture_array_1000013[10],__lph_capture_array_1000013[11],__lph_capture_array_1000013[12],__lph_capture_array_1000013[13])
					tbl5.remove = (function(__lph_raw_capture_6,__lph_raw_capture_16) return function()local j= flag2 ;if j then return;end; flag2 =true;j= hide ;j();local r,p= __lph_raw_capture_6 ;j= Square ;r(j);local p,Y= __lph_raw_capture_6 ;j= Text ;p(j);local Y,V= __lph_raw_capture_6 ;r= Text2 ;Y(r);local V,e= __lph_raw_capture_6 ;r= Text3 ;V(r);local r,V= __lph_raw_capture_6 ;Y= Square2 ;r(Y);local r,Y= __lph_raw_capture_6 ;j= Square3 ;r(j);local r,Y= __lph_raw_capture_6 ;j= Text4 ;r(j);p= highlight ;if p then r= __lph_raw_capture_16 ;r( highlight ); highlight =nil;end;end
					end)(__lph_capture_array_1000013[14],__lph_capture_array_1000013[15])
					return tbl5
				end
			end
			CreateESP = fn16(table.pack(fn11, __boohub_scalar_capture_cell(function() return  tbl2  end, function(__value)  tbl2 =__value end), v22, __boohub_scalar_capture_cell(function() return  flag  end, function(__value)  flag =__value end), v19, {}, library, v18, GameUtil, {
				Black = Color3.new(0, 0, 0),
				Blue = Color3.new(0.050980392843484879, 0.4117647111415863, 0.67450982332229614),
				Brown = Color3.new(0.48627451062202454, 0.36078432202339172, 0.27450981736183167),
				["Dark Green"] = Color3.new(0.15294118225574493, 0.27450981736183167, 0.17647059261798859),
				Green = Color3.new(0, 1, 0),
				Grey = Color3.new(0.29411765933036804, 0.29411765933036804, 0.29411765933036804),
				Lavendar = Color3.new(0.54901963472366333, 0.35686275362968445, 0.62352943420410156),
				["Light Blue"] = Color3.new(0.15686275064945221, 0.58431375026702881, 0.68235296010971069),
				["Light Grey"] = Color3.new(0.52549022436141968, 0.53333336114883423, 0.56862747669219971),
				Maroon = Color3.new(0.50196081399917603, 0, 0),
				Olive = Color3.new(0.50196081399917603, 0.50196081399917603, 0),
				Orange = Color3.new(1, 0.66666668653488159, 0),
				Purple = Color3.new(0.23921568691730499, 0.08235294371843338, 0.5215686559677124),
				Red = Color3.new(1, 0, 0),
				Teal = Color3.new(0.34509804844856262, 1, 0.85882353782653809),
				Violet = Color3.new(1, 0.15294118225574493, 0.96078431606292725),
				White = Color3.new(0.78431373834609985, 0.78431373834609985, 0.78431373834609985),
				Yellow = Color3.new(1, 0.78431373834609985, 0),
			}, fn15, fn14, fn12, fn5, fn6))
			local function fn17()
				
				for _, v28 in pairs(tbl3) do
					if v28 and v28.hide then
						v28.hide()
					end
				end
			end
			local function setEnabled(arg2, arg3)
				
				tbl2.settings.enabled = arg3 and true or false
				if not tbl2.settings.enabled then
					fn17()
				end
			end
			tbl2.SetEnabled = setEnabled
			local function fn18(arg2)
				
				local v28 = tbl3[arg2]
				if v28 then
					v28.remove()
					tbl3[arg2] = nil
				end
			end
			fn4 = function()
				
				if flag then
					return
				end
				for k, v28 in pairs(tbl3) do
					if not k or not k.Parent then
						if v28 then
							v28.remove()
						end
						tbl3[k] = nil
					end
				end
				for _, player in ipairs(v18:GetPlayers()) do
					if player ~= localPlayer then
						local character2 = player.Character
						local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
						local humanoid2 = character2 and character2:FindFirstChildOfClass("Humanoid")
						if character2 and humanoidRootPart2 and humanoid2 and humanoid2.Health > 0 then
							if not tbl3[character2] then
								tbl3[character2] = CreateESP(humanoidRootPart2)
							end
							tbl3[character2].update()
						elseif character2 then
							fn18(character2)
						end
					end
				end
			end
			local function fn19(arg2)
				
				if flag or not arg2 then
					return
				end
				fn18(arg2)
				local humanoidRootPart2 = arg2:WaitForChild("HumanoidRootPart", 5)
				local humanoid2 = arg2:WaitForChild("Humanoid", 5)
				if not humanoidRootPart2 or not humanoid2 or flag then
					return
				end
				if not tbl2.settings.enabled then
					return
				end
				tbl3[arg2] = CreateESP(humanoidRootPart2)
			end
			local function fn20(arg2)
				
				fn18(arg2)
			end
			local function fn21(arg2)
				
				if flag or arg2 == localPlayer then
					return
				end
				table.insert(tbl4, arg2.CharacterAdded:Connect(function(character2)
					
					fn19(character2)
				end))
				local function fn22(character2)
					
					fn20(character2)
				end
				table.insert(tbl4, arg2.CharacterRemoving:Connect(fn22))
				if arg2.Character then
					fn19(arg2.Character)
				end
			end
			local function fn22(arg2)
				
				if arg2.Character then
					fn18(arg2.Character)
				end
				for k, v28 in pairs(tbl3) do
					if k and k.Name == arg2.Name then
						if v28 then
							v28.remove()
						end
						tbl3[k] = nil
					end
				end
			end
			tbl2.Unload = function()
				
				flag = true
				tbl2.settings.enabled = false
				for _, v28 in ipairs(tbl4) do
					if v28 then
						v28:Disconnect()
					end
				end
				table.clear(tbl4)
				for k, v28 in pairs(tbl3) do
					if v28 then
						v28.remove()
					end
					tbl3[k] = nil
				end
				fn10()
			end
			table.insert(tbl4, library:connect(v18.PlayerAdded, fn21))
			table.insert(tbl4, library:connect(v18.PlayerRemoving, fn22))
		end
		local function fn5()
			
			local v28 = cloneref(game:GetService("VirtualUser"))
			library:connect(localPlayer.Idled, function()
				
				v28:CaptureController()
				v28:ClickButton2(Vector2.new())
			end)
			repeat
				task.wait()
			until v22:FindFirstChild("RobloxPromptGui")
			local promptOverlay = v22.RobloxPromptGui:FindFirstChild("promptOverlay")
			if not promptOverlay then
				return
			end
			library:connect(promptOverlay.ChildAdded, function(arg2)
				
				if arg2.Name == "ErrorPrompt" and library.flags.autofarmobject and library.flags.autofarmobjectrejoin then
					while true do
						task.wait(not v19.Resources:FindFirstChild(library.flags.autofarmobjectitem) and 10 or 2)
						v21:Teleport(game.PlaceId, localPlayer)
						if not (not library or not library.flags.autofarmobject or not library.flags.autofarmobjectrejoin) then
							continue
						end
						break
					end
				end
			end)
		end
		task.spawn(fn5)
		local vector
		vector = nil
		local tbl5, v28
		do
			local v29 = isfile
			local placeId = game.PlaceId
			local n = n15 // 2
			if v29("Boo/games/" .. placeId .. "/restpoints/" .. (library.flags.streamermode and variables.oldLPId or localPlayer.UserId) .. "/restpoint.txt") then
				local v30 = readfile
				local placeId2 = game.PlaceId
				local v31 = bit32.bxor(v27, n % 4294967296 - n % 4294967296 % 1)
				local oldLPId = library.flags.streamermode and variables.oldLPId
				local userId
				if oldLPId then
					userId = oldLPId
				else
					n16 = n - 95591312
					userId = localPlayer.UserId
				end
				local match, v32, v33 = v30("Boo/games/" .. placeId2 .. "/restpoints/" .. userId .. "/restpoint.txt"):match("([^,]+),%s*([^,]+),%s*([^,]+)")
				local num = tonumber(match)
				local num2 = tonumber(v32)
				local num3 = tonumber(v33)
				if num and num2 and num3 then
					vector = Vector3.new(num, num2, num3)
				end
				v27 = bit32.bxor(v31, 95591312)
			end
			if not isfolder("Boo/games/" .. game.PlaceId .. "/paths/") then
				makefolder("Boo/games/" .. game.PlaceId .. "/paths/")
			end
			if game.PlaceId == 11729688377 then
				if isfile("Boo/games/" .. game.PlaceId .. "/paths/goldfarmbyZach.json") then
					delfile("Boo/games/" .. game.PlaceId .. "/paths/goldfarmbyZach.json")
				end
				local v30 = writefile
				local str = "Boo/games/" .. game.PlaceId .. "/paths/goldfarmbyZach&rinn.json"
				local v31 = bit32.bxor(v27, 0)
				local v32 = bit32.bxor(n16, v31)
				v30(str, "wyd here")
				n16 = v32 - 3036674729
			end
			tbl5 = {
				healthconnection = nil,
				diedconnection = nil,
				autohealIndex = nil,
				autoeatIndex = nil,
				autoplantIndex = nil,
			}
			v28 = bit32.rshift(n, 10)
		end
		local n17 = n16 + 220680492
		tbl5.autodropIndex = nil
		tbl5.autocampfireIndex = nil
		tbl5.pointwait = nil
		tbl5.pointjump = nil
		tbl5.pointequipslot = nil
		local tbl6, v29, tbl7, items, v30, n18
		do
			local v31 = bit32.bxor(v27, v28 % 4294967296 - v28 % 4294967296 % 1)
			tbl5.pointdotrate = nil
			tbl5.selectedpoint = nil
			tbl5.pointequipslotenable = nil
			tbl5.lastpart = nil
			tbl5.draggingpart = nil
			tbl5.killauratarget = nil
			tbl5.killaurahighlight = nil
			tbl5.Autofarmobject = nil
			tbl5.chosenchest = nil
			tbl5.chesthighlight = nil
			tbl5.freecamCFrame = nil
			tbl5.draggingpoint = nil
			tbl5.lastbloodfruit = nil
			tbl5.selectedresourcehighlight = nil
			tbl5.autofarmmovestartpos = nil
			tbl5.autofarmmovetarget = nil
			tbl5.autofarmmovestarted = nil
			local n = n16 // v28
			tbl5.servantfarmtween = nil
			tbl5.lastinventory = nil
			tbl5.heldpoint = nil
			tbl5.freecamdir = nil
			tbl5.freecamlook = nil
			tbl5.freecamMoveTouch = nil
			tbl5.freecamMoveCenter = nil
			local v32 = bit32.bxor(v31, 3218344828)
			tbl5.lastfreecampos = nil
			tbl5.spectating = nil
			tbl5.spectatinglabel = nil
			tbl5.infjumpconnection = nil
			tbl5.infiniteJumpConnection = nil
			tbl5.hitanim1 = nil
			tbl5.hitanim2 = nil
			tbl5.oldLPId = nil
			tbl5.oldLPName = nil
			tbl5.oldLPDisplay = nil
			tbl5.autodropdropdown = nil
			tbl5.freecamvars = { freecamYaw = 0, freecamPitch = 0 }
			local n19 = v28 + n + 3014990670
			tbl6 = {
				isHitting = false,
				ismineauraing = false,
				autotfarmobjectloop = false,
				eating = false,
				stopbuild = false,
			}
			v29 = bit32.bxor(v32, 230508117)
			tbl6.previewsexist = false
			tbl6.dropping = false
			local n20 = n * bit32.bxor(v29, 0)
			tbl6.coinpressing = false
			tbl6.autospawning = false
			tbl6.placingautopots = false
			tbl6.autopotioning = false
			tbl6.pathrunning = false
			tbl6.autoresourceloop = false
			tbl6.sendlowbloodfruit = false
			tbl6.healing = false
			tbl6.crafting = false
			tbl6.purchasing = false
			tbl6.pointhold = false
			tbl6.freecamMoveFromJoystick = false
			tbl6.freecamLookFromJoystick = false
			tbl6.autoChestItemsRunning = false
			tbl6.isplayinghitanim = false
			tbl6.updateautodropdropdown = false
			local n21 = n20 // bit32.bxor(v29, 0)
			tbl6.goldfarmbyZachloaded = false
			tbl7 = {
				potions = {
					Swift = { ["Crystal Chunk"] = 1, Cloudberry = 3 },
					Strength = { Adurite = 2, Bloodfruit = 2 },
					Healing = { Bloodfruit = 5, Strawberry = 2 },
					Haste = { Iron = 2, Lemon = 2 },
				},
			}
			local v33 = bit32.band(n19, n21)
			tbl7.oldnames = {}
			tbl7.resourcetable = {}
			tbl7.validmineaura = {}
			tbl7.checkedmineaura = {}
			tbl7.validitems = {}
			tbl7.checkeditems = {}
			tbl7.chestitems = {}
			tbl7.plantboxes = {}
			local v34 = bit32.lshift(n21, 14)
			tbl7.plants = {}
			tbl7.inventory = {}
			tbl7.inventorylist = {}
			tbl7.pathpoints = {}
			tbl7.pathdots = {}
			tbl7.groundpoints = {}
			tbl7.pathparts = {}
			tbl7.pathlist = {}
			tbl7.pathsegments = {}
			tbl7.pointguis = {}
			tbl7.pointbypart = {}
			tbl7.spectateconnections = {}
			tbl7.lastChestItemInteract = {}
			tbl7.chestteleports = {}
			tbl7.failedchestitems = {}
			local resourcehighlights_ = {}
			local v35 = bit32.bxor(v29, 0)
			local v36 = bit32.band(v33, v35)
			resourcehighlights_["Stone Node"] = {}
			resourcehighlights_["Big Rock"] = {}
			resourcehighlights_["Coal Node"] = {}
			resourcehighlights_["Iron Node"] = {}
			resourcehighlights_["Gold Node"] = {}
			resourcehighlights_["Adurite Rich Rock"] = {}
			resourcehighlights_["Adurite Rock"] = {}
			resourcehighlights_["Crystal Lode"] = {}
			resourcehighlights_["Emerald Lode"] = {}
			resourcehighlights_["Meteor Rock"] = {}
			resourcehighlights_["Ice Mound"] = {}
			resourcehighlights_.Iceberg = {}
			resourcehighlights_["Magnetite Rock"] = {}
			resourcehighlights_["Obsidian Deposit"] = {}
			resourcehighlights_["Obsidian Boulder"] = {}
			resourcehighlights_["Void Crag"] = {}
			local n22 = v34 + v36
			resourcehighlights_["Meteor Core"] = {}
			resourcehighlights_["Crystal Meteor Core"] = {}
			resourcehighlights_["Suspicious Meteor"] = {}
			resourcehighlights_["Ancient God"] = {}
			resourcehighlights_["Furious God"] = {}
			resourcehighlights_["Hateful God"] = {}
			resourcehighlights_["Lonely God"] = {}
			resourcehighlights_["Miserable God"] = {}
			local v37 = bit32.band(v36, n22)
			resourcehighlights_["Old God"] = {}
			resourcehighlights_["Sleeping God"] = {}
			resourcehighlights_["Wealthy God"] = {}
			resourcehighlights_["Dark God"] = {}
			resourcehighlights_["Infinity God"] = {}
			resourcehighlights_["Magical God"] = {}
			resourcehighlights_["Odd God"] = {}
			resourcehighlights_["Soulless God"] = {}
			resourcehighlights_["Strange God"] = {}
			tbl7.resourcehighlights = resourcehighlights_
			local resourceflags = {}
			local v38 = bit32.bor(v37, 3925893444)
			resourceflags["Stone Node"] = "stonenode"
			resourceflags["Big Rock"] = "bigrock"
			resourceflags["Coal Node"] = "coalnode"
			resourceflags["Iron Node"] = "ironnode"
			resourceflags["Gold Node"] = "goldnode"
			resourceflags["Adurite Rich Rock"] = "aduriterichrock"
			resourceflags["Adurite Rock"] = "aduriterock"
			resourceflags["Crystal Lode"] = "crystallode"
			resourceflags["Emerald Lode"] = "emeraldlode"
			resourceflags["Meteor Rock"] = "meteorrock"
			resourceflags["Ice Mound"] = "icemound"
			resourceflags.Iceberg = "iceberg"
			resourceflags["Magnetite Rock"] = "magnetiterock"
			resourceflags["Obsidian Deposit"] = "obsidiandeposit"
			resourceflags["Obsidian Boulder"] = "obsidianboulder"
			resourceflags["Void Crag"] = "voidcrag"
			resourceflags["Meteor Core"] = "meteorcore"
			resourceflags["Crystal Meteor Core"] = "crystalmeteorcore"
			resourceflags["Suspicious Meteor"] = "suspiciousmeteor"
			resourceflags["Ancient God"] = "ancientgod"
			resourceflags["Furious God"] = "furiousgod"
			resourceflags["Hateful God"] = "hatefulgod"
			resourceflags["Lonely God"] = "lonelygod"
			resourceflags["Miserable God"] = "miserablegod"
			local n23 = n22 - v38
			resourceflags["Old God"] = "oldgod"
			resourceflags["Sleeping God"] = "sleepinggod"
			resourceflags["Wealthy God"] = "wealthygod"
			resourceflags["Dark God"] = "darkgod"
			resourceflags["Infinity God"] = "infinitygod"
			resourceflags["Magical God"] = "magicalgod"
			resourceflags["Odd God"] = "oddgod"
			local v39 = bit32.band(n23 % 4294967296 - n23 % 4294967296 % 1, v38)
			resourceflags["Soulless God"] = "soullessgod"
			resourceflags["Strange God"] = "strangegod"
			tbl7.resourceflags = resourceflags
			items = {}
			local v40 = bit32.bxor(v38, 4032686074)
			v30 = bit32.bxor(v29, v40 % 4294967296 - v40 % 4294967296 % 1)
			local v41 = bit32.bxor(v30, 0)
			local v42 = table.pack(bit32.band(v40, 4294967295))
			local v43 = table.pack(bit32.band(v41, 4294967295))
			local v44 = table.pack(bit32.band(v42[1], 65535))
			local v45 = table.pack(bit32.rshift(v42[1], 16))
			local v46 = table.pack(bit32.band(v43[1], 65535))
			local v47 = table.pack(bit32.band(v44[1] * v46[1] + bit32.lshift(bit32.band(v44[1] * bit32.rshift(v43[1], 16) + v45[1] * v46[1], 65535), 16), 4294967295))
			n18 = v39 * 60779
		end
		items[1] = "All"
		items[2] = "Essence"
		items[3] = "Coin"
		items[4] = "Coin2"
		items[5] = "Coin Stack"
		items[6] = "Wood"
		items[7] = "Stone"
		items[8] = "Coal"
		items[9] = "Iron"
		items[10] = "Gold"
		items[11] = "Adurite"
		items[12] = "Magnetite"
		items[13] = "Emerald"
		items[14] = "Pink Diamond"
		items[15] = "Obsidian"
		items[16] = "Crystal Chunk"
		items[17] = "Spirit Key"
		items[18] = "Void Shard"
		items[19] = "Hide"
		items[20] = "Fire Hide"
		items[21] = "Leaves"
		items[22] = "Log"
		items[23] = "Sand"
		items[24] = "Glass"
		items[25] = "Scute"
		items[26] = "Lead"
		items[27] = "Cogs"
		items[28] = "Ice Cube"
		items[29] = "Raw Gold"
		items[30] = "Raw Iron"
		items[31] = "Raw Adurite"
		items[32] = "Raw Emerald"
		items[33] = "Raw Magnetite"
		items[34] = "Raw Pink Diamond"
		items[35] = "Steel"
		items[36] = "Steel Mix"
		items[37] = "Berry"
		items[38] = "Oddberry"
		items[39] = "Cloudberry"
		items[40] = "Bluefruit"
		items[41] = "Bloodfruit"
		items[42] = "Strawberry"
		items[43] = "Sunfruit"
		items[44] = "Strangefruit"
		items[45] = "Petrified Berry"
		items[46] = "Frostfruit"
		items[47] = "Blossom"
		items[48] = "Banana"
		items[49] = "Apple"
		items[50] = "Lemon"
		items[51] = "Orange"
		items[52] = "Mango"
		items[53] = "Watermelon"
		items[54] = "Pumpkin"
		items[55] = "Pumpkins"
		items[56] = "Carrot"
		items[57] = "Carrots"
		items[58] = "Corn"
		items[59] = "Barley"
		items[60] = "Coconut"
		items[61] = "Jelly"
		items[62] = "Egg"
		items[63] = "Eggs"
		items[64] = "Raw Meat"
		items[65] = "Raw Fish"
		items[66] = "Raw Morsel"
		items[67] = "Raw Crab"
		items[68] = "Raw Squid"
		items[69] = "Raw Eel"
		items[70] = "Raw Baracuda"
		items[71] = "Cooked Meat"
		items[72] = "Cooked Fish"
		items[73] = "Cooked Morsel"
		items[74] = "Cooked Crab"
		items[75] = "Cooked Squid"
		items[76] = "Cooked Eel"
		items[77] = "Cooked Baracuda"
		items[78] = "Cooked Egg"
		items[79] = "Bread"
		items[80] = "Pie"
		items[81] = "Fruit Cake"
		items[82] = "Cornbread"
		items[83] = "Fried Egg"
		items[84] = "Fried Cactus"
		items[85] = "Jelly Sandwich"
		items[86] = "Meat Sandwich"
		items[87] = "Cookies"
		items[88] = "Peppermints"
		items[89] = "Poison Potion"
		items[90] = "Splash Poison Potion"
		items[91] = "Swiftness Potion"
		items[92] = "Splash Swiftness Potion"
		items[93] = "Phantasm Potion"
		items[94] = "Splash Phantasm Potion"
		items[95] = "Haste Potion"
		items[96] = "Splash Haste Potion"
		items[97] = "Fire Resistance Potion"
		items[98] = "Splash Fire Resistance Potion"
		items[99] = "Strength Potion"
		items[100] = "Splash Strength Potion"
		items[101] = "Healing Potion"
		items[102] = "Splash Healing Potion"
		items[103] = "Harming Potion"
		items[104] = "Splash Harming Potion"
		items[105] = "Placebo Potion"
		items[106] = "Splash Placebo Potion"
		tbl7.items = items
		local v31
		local food = {}
		v31 = bit32.bxor(v30, 0)
		food[1] = "Berry"
		food[2] = "Oddberry"
		food[3] = "Cloudberry"
		food[4] = "Bluefruit"
		food[5] = "Bloodfruit"
		food[6] = "Petrified Berry"
		food[7] = "Strawberry"
		food[8] = "Sunfruit"
		food[9] = "Strangefruit"
		food[10] = "Jelly"
		food[11] = "Frostfruit"
		food[12] = "Blossom"
		food[13] = "Banana"
		food[14] = "Apple"
		food[15] = "Lemon"
		food[16] = "Orange"
		food[17] = "Mango"
		food[18] = "Watermelon"
		food[19] = "Pumpkin"
		food[20] = "Pumpkins"
		food[21] = "Carrot"
		food[22] = "Carrots"
		food[23] = "Corn"
		food[24] = "Barley"
		food[25] = "Coconut"
		food[26] = "Egg"
		food[27] = "Eggs"
		food[28] = "Cooked Meat"
		food[29] = "Cooked Fish"
		food[30] = "Cooked Morsel"
		food[31] = "Cooked Crab"
		food[32] = "Cooked Squid"
		food[33] = "Cooked Eel"
		food[34] = "Cooked Baracuda"
		food[35] = "Cooked Egg"
		food[36] = "Bread"
		food[37] = "Pie"
		food[38] = "Fruit Cake"
		food[39] = "Cornbread"
		food[40] = "Fried Egg"
		food[41] = "Fried Cactus"
		food[42] = "Jelly Sandwich"
		food[43] = "Meat Sandwich"
		food[44] = "Cookies"
		food[45] = "Peppermints"
		tbl7.food = food
		local resourcefarmtable
		if game.PlaceId == 11729688377 then
			local n = n18 - v31
			resourcefarmtable = {
				"Stone Node",
				"Big Rock",
				"Coal Node",
				"Iron Node",
				"Gold Node",
				"Adurite Rich Rock",
				"Adurite Rock",
				"Crystal Lode",
				"Emerald Lode",
				"Meteor Rock",
				"Ice Mound",
				"Iceberg",
			}
			n18 = n % 4294967296 - n % 4294967296 % 1 - 3811943016
		else
			resourcefarmtable = {}
			local v32 = bit32.bxor(v30, v31 % 4294967296 - v31 % 4294967296 % 1)
			resourcefarmtable[1] = "Magnetite Rock"
			resourcefarmtable[2] = "Obsidian Deposit"
			resourcefarmtable[3] = "Obsidian Boulder"
			resourcefarmtable[4] = "Void Crag"
			resourcefarmtable[5] = "Suspicious Meteor"
			v30 = bit32.bxor(v32 % 4294967296 - v32 % 4294967296 % 1, 483024280)
		end
		tbl7.resourcefarmtable = resourcefarmtable
		tbl7.tooltypes = {}
		tbl7.newitems = {}
		tbl7.sendReliableTable = { cursor = 0, size = 256, ready = true, buff = buffer.create(256) }
		local n19, v32, n20, tbl8, tbl9, v33, v34, v35, v36
		do
			local n = n18 * 127
			tbl7.freecamKeys = { W = false, A = false, S = false, D = false, Q = false, E = false, Shift = false }
			tbl7.weapons = {
				"Rock",
				"War Hammer",
				"Mace",
				"Club",
				"Battle Axe",
				"Crystal Stick",
				"God Rock",
				"Emerald Blade",
			}
			local abbreviations = {}
			n19 = v31 // n
			v32 = bit32.bxor(bit32.bxor(v30, n19 % 4294967296 - n19 % 4294967296 % 1), 492471217)
			abbreviations[1] = "K"
			abbreviations[2] = "M"
			abbreviations[3] = "B"
			abbreviations[4] = "T"
			abbreviations[5] = "Qa"
			abbreviations[6] = "Qn"
			abbreviations[7] = "Sx"
			abbreviations[8] = "Sp"
			abbreviations[9] = "Oc"
			abbreviations[10] = "No"
			abbreviations[11] = "Dc"
			abbreviations[12] = "Ud"
			abbreviations[13] = "Dd"
			abbreviations[14] = "Td"
			abbreviations[15] = "QaD"
			abbreviations[16] = "QnD"
			abbreviations[17] = "SxD"
			abbreviations[18] = "SpD"
			abbreviations[19] = "OcD"
			abbreviations[20] = "NoD"
			abbreviations[21] = "Vg"
			abbreviations[22] = "UvG"
			abbreviations[23] = "DvG"
			abbreviations[24] = "TvG"
			abbreviations[25] = "QaVg"
			abbreviations[26] = "QnVg"
			abbreviations[27] = "SxVg"
			abbreviations[28] = "SpVg"
			abbreviations[29] = "OcVg"
			abbreviations[30] = "NoVg"
			tbl7.abbreviations = abbreviations
			tbl7.idx = { discardIdx = 0 }
			local modIds = { [3823650630] = true }
			local v37 = bit32.bxor(v32, 0)
			local v38 = table.pack(bit32.band(n, 4294967295))
			local v39 = table.pack(bit32.band(v37, 4294967295))
			local v40 = table.pack(bit32.band(v38[1], 65535))
			local v41 = table.pack(bit32.rshift(v38[1], 16))
			local v42 = table.pack(bit32.band(v39[1], 65535))
			local v43 = table.pack(bit32.band(v40[1] * v42[1] + bit32.lshift(bit32.band(v40[1] * bit32.rshift(v39[1], 16) + v41[1] * v42[1], 65535), 16), 4294967295))
			n20 = v43[1] % 4294967296 - v43[1] % 4294967296 % 1
			modIds[4125419685] = true
			modIds[5696213221] = true
			modIds[391069122] = true
			modIds[200884556] = true
			modIds[1304899462] = true
			modIds[1506714874] = true
			modIds[10643012852] = true
			modIds[1827371515] = true
			modIds[593542036] = true
			modIds[888926254] = true
			modIds[1941158447] = true
			modIds[177370120] = true
			modIds[3333755037] = true
			modIds[2422912891] = true
			modIds[3458874234] = true
			local n21 = n19 * bit32.bxor(v32, 0)
			modIds[10323650981] = true
			modIds[98002074] = true
			local n22 = v32 + 330943556
			modIds[159413166] = true
			modIds[5413404059] = true
			modIds[5709702683] = true
			modIds[352588896] = true
			modIds[8664264465] = true
			tbl7.modIds = modIds
			tbl7.modGroups = { 15829231, 16160563, 626299398, 16576968, 15051522 }
			tbl8 = { spoofconnections = {} }
			local v44 = table.pack(bit32.band(n21, 4294967295))
			local v45 = table.pack(bit32.band(n20, 4294967295))
			local v46 = table.pack(bit32.band(v44[1], 65535))
			local v47 = table.pack(bit32.rshift(v44[1], 16))
			local v48 = table.pack(bit32.band(v45[1], 65535))
			local v49 = table.pack(bit32.band(v46[1] * v48[1] + bit32.lshift(bit32.band(v46[1] * bit32.rshift(v45[1], 16) + v47[1] * v48[1], 65535), 16), 4294967295))
			local n23 = v49[1] % 4294967296 - v49[1] % 4294967296 % 1
			tbl8.freecamconnections = {}
			tbl8.buildconnection = nil
			tbl9 = { lastautofarmcache = 0, lastautofarmmove = 0, lastheal = 0 }
			v33 = bit32.bxor(v32, n20 % 4294967296 - n20 % 4294967296 % 1)
			tbl9.healdrop = 0
			tbl9.lastdiscard = 0
			tbl9.lastdotratechange = 0
			tbl9.lastmineauracache = 0
			tbl9.lastpickup = 0
			tbl9.lastservanttween = 0
			tbl9.pointholdstart = 0
			tbl9.lastrebirthcheck = 0
			tbl9.lastcampfirecheck = 0
			tbl9.lasteatcheck = 0
			tbl9.lastresourceaura = 0
			tbl9.lastkillaura = 0
			tbl9.lastchestinteractcleanup = 0
			local n24 = n20 + bit32.bxor(v33, 0)
			tbl9.lastautoshoot = 0
			tbl9.lastresourcefarmjump = 0
			tbl9.lastboltcheck = 0
			for i = 6, #tbl7.items do
				table.insert(tbl7.newitems, tbl7.items[i])
			end
			local tool2 = game_:FindFirstChild("tool")
			for _, v50 in tool2:GetChildren() do
				tbl7.tooltypes[v50.Name] = require(v50)
			end
			local n25 = n23 + n24
			local n26 = n25 % 4294967296 - n25 % 4294967296 % 1
			for _, child in pairs(localPlayer.PlayerGui.SecondaryGui.PlayerList.List:GetChildren()) do
				if child:IsA("ImageButton") then
					if v25.TouchEnabled then
						local function fn6()
							
							
							local v50 = v19.Players:FindFirstChild(child.Name)
							if not v50 or not v50:FindFirstChild("Humanoid") then
								return
							end
							local playerFromCharacter = v18:GetPlayerFromCharacter(v50)
							if not playerFromCharacter then
								return
							end
							local spectating = tbl5.spectating
							if spectating and tbl5.spectatinglabel and tbl5.spectating ~= playerFromCharacter then
								tbl5.spectatinglabel.TextColor3 = Color3.new(1, 1, 1)
							end
							local v51 = tbl5
							v51.spectating = currentCamera.CameraSubject ~= v50.Humanoid and playerFromCharacter or nil
							local v52 = tbl5
							local cameraSubject = currentCamera.CameraSubject
							
							v52.spectatinglabel = cameraSubject ~= v50.Humanoid and child.NameLabel or nil
							currentCamera.CameraSubject = currentCamera.CameraSubject ~= v50.Humanoid and v50.Humanoid or humanoid
							if playerFromCharacter ~= localPlayer then
								local nameLabel = child.NameLabel
								nameLabel.TextColor3 = currentCamera.CameraSubject ~= v50.Humanoid and Color3.new(1, 1, 1) or Color3.new(1, 0, 0)
							end
						end
						tbl7.spectateconnections[child.Name] = library:connect(child.Activated, fn6)
					else
						local function fn6()
							
							
							
							local v50 = v19.Players:FindFirstChild(child.Name)
							if not v50 or not v50:FindFirstChild("Humanoid") then
								return
							end
							local playerFromCharacter = v18:GetPlayerFromCharacter(v50)
							if not playerFromCharacter then
								return
							end
							local spectatinglabel = tbl5.spectating and tbl5.spectatinglabel
							if spectatinglabel then
								local v51 = tbl5
								
								
								spectatinglabel = v51.spectating ~= playerFromCharacter
								
							end
							if spectatinglabel then
								tbl5.spectatinglabel.TextColor3 = Color3.new(1, 1, 1)
							end
							tbl5.spectating = currentCamera.CameraSubject ~= v50.Humanoid and playerFromCharacter or nil
							local v51 = tbl5
							local cameraSubject = currentCamera.CameraSubject
							
							v51.spectatinglabel = cameraSubject ~= v50.Humanoid and child.NameLabel or nil
							local v52 = currentCamera
							v52.CameraSubject = currentCamera.CameraSubject ~= v50.Humanoid and v50.Humanoid or humanoid
							if playerFromCharacter ~= localPlayer then
								child.NameLabel.TextColor3 = currentCamera.CameraSubject ~= v50.Humanoid and Color3.new(1, 1, 1) or Color3.new(1, 0, 0)
							end
						end
						local v50 = library:connect(child.MouseButton2Click, fn6)
						local v51 = bit32.bxor(v33 % 4294967296 - v33 % 4294967296 % 1, n24 % 4294967296 - n24 % 4294967296 % 1)
						tbl7.spectateconnections[child.Name] = v50
						v33 = bit32.bxor(v51, 2917080790)
					end
				end
			end
			moderatorLookup = createModeratorLookup(
 game:GetService("GroupService"), tbl7.modIds, tbl7.modGroups,
 function(message, duration) library:Notify({ text = message, time = duration }) end,
 function() return getgenv().library == library end, os.clock, task
)
library.moderatorLookupStats = moderatorLookup.stats
for _, player in ipairs(v18:GetPlayers()) do
 moderatorLookup.check(player, "A Moderator is in your server: ", "inf")
end
			updateinventory = function()table.clear( tbl7 .inventory);local r,e,P,b={},{},pairs;local b= localPlayer ;local X= table.pack (b.PlayerGui.MainGui.RightPanel.Inventory.List:GetChildren());for i,O in P( unpackCapturedArguments ( nil, X))do i=O:IsA("GuiBase");if i then b= tbl7 ;b.inventory[O.Name]=O.LayoutOrder;table.insert(e,{item=O.Name,order=O.LayoutOrder});end;end;table.sort(e,function(j,i)return j.order<i.order;end);for j,j in ipairs(e)do if j.item:find("Chest")then continue;end;table.insert(r,j.item);end;P=table.concat(r,"\0");b= tbl5 ;e=P~=b.lastinventory;if e then X= tbl5 ;X.lastinventory=P;b= tbl7 ;b.inventorylist=r;local j= tbl6 ;j.updateautodropdropdown=true;end;end
			updateinventory()
			Packets.ItemAdded.listen(function(j)local X,Y= inventory ;X.itemAdded( ItemIDS [j.itemID],j.quantity,j.index);updateinventory();end)
			Packets.ItemChanged.listen(function(j)local V local e= tbl7 ;local P,b,b=e.inventory.Bloodfruit;if P then local i,O= GameUtil ;O,b= tbl7 ,i.Data.inventory[ tbl7 .inventory.Bloodfruit];else b=P;end;if b then e,P= GameUtil ;P,V= tbl7 ,e.Data.inventory[ tbl7 .inventory.Bloodfruit].quantity;else end;e= inventory ;e.itemChanged(j.key,j.quantity);updateinventory();b= tbl7 ;if not b.inventory.Bloodfruit then return;end;P=nil;if V then b,j= GameUtil ;j,P= tbl7 ,b.Data.inventory[ tbl7 .inventory.Bloodfruit].quantity;else P=V;end;j=nil;if P then b,e= GameUtil ;e,j= tbl7 ,V>b.Data.inventory[ tbl7 .inventory.Bloodfruit].quantity;else j=P;end;e=nil;if j then b,P= GameUtil ;P,e= tbl7 ,b.Data.inventory[ tbl7 .inventory.Bloodfruit].quantity==1000;else e=j;end;j=nil;if e then j=e;else b,P= GameUtil ;P,j= tbl7 ,b.Data.inventory[ tbl7 .inventory.Bloodfruit].quantity==5000;end;if j then P= tbl6 ;P.sendlowbloodfruit=true;end;end)
			Packets.ItemRemoved.listen(function(j)local p= inventory ;p.itemRemoved(j);updateinventory();end)
			local function fn6()local r= tbl9 ;r.lastautofarmcache=tick();table.clear( tbl7 .plantboxes);table.clear( tbl7 .plants);local p,D,L,A={},{},false;r= library ;local A=r.flags.autoplantitem;local c,s=type(A)=="string";if c then r= ItemIDS ;local s,M=r[A];if s then local k= tbl7 ;M=k.inventory[A];else M=s;end;L=if M then true else L;else local s=type(A)=="table";if s then local s=ipairs;for M,k in s(A)do M= ItemIDS ;local V,s=M[k];if V then M= tbl7 ;s=M.inventory[k];else s=V;end;if s then L=true;break;end;end;else end;end;c=OverlapParams.new();c.FilterType=Enum.RaycastFilterType.Exclude;local V,s,s={};local s,s,s,s,s,s,s= v19 , v19 , v19 , v19 , v19 , v20 ; appendCapturedArguments ( nil, V,0, character , v19 .Terrain, v19 .Items, v19 .Rubble, v19 .Resources, v19 .Players, v20 :GetTagged("Contents"));c.FilterDescendantsInstances=V;local b,s,M=ipairs, v19 ;local M,k,R,z=CFrame.new( character :GetPivot().Position)-(Vector3.new(0, humanoid .HipHeight,0)+Vector3.new(0,2,0)),Vector3.new, library , library ;V= table.pack (s:GetPartBoundsInBox(M,k(R.flags.autofarmrange*2,15,z.flags.autofarmrange*2),c));for e,i in b( unpackCapturedArguments ( nil, V))do z=i:FindFirstAncestorWhichIsA("Model");if not z then continue;end;c= library ;L=c.flags.autoplant and L;k=nil;if L then R=nil;R,k= v19 ,z.Parent== v19 .Deployables;else k=L;end;if k then e=z.Name=="Plant Box"and z:FindFirstChild("collisionBox")and not z:FindFirstChild("Seed")and not p[z];if e then r=z.collisionBox.Position;i,A=(r- humanoidRootPart .Position).Magnitude, library ;s=i<=A.flags.autofarmrange;if s then p[z]=true;table.insert( tbl7 .plantboxes,{Model=z,Position=r,Distance=i});end;end;end;M= library ;e,i=M.flags.autoharvest and not D[z];if e then local j;j,i= v19 ,z.Parent~= v19 .Resources;else i=e;end;e=nil;if i then local j;j,e= v19 ,z.Parent~= v19 .Critters;else e=i;end;i=nil;if e then local j;j,i= v19 ,z.Parent~= v19 .Deployables;else i=e;end;e=nil;if i then local j;j,e= v19 ,z.Parent~= v19 .Rubble;else e=i;end;i=e and z.Name~="Plant Box"and(string.lower(z.Name):find("bush",1,true)or string.lower(z.Name):find("tree",1,true)or string.lower(z.Name):find("crop",1,true)or string.lower(z.Name):find("cacti",1,true));if i then e=z:GetPivot().Position;local j=(e- humanoidRootPart .Position).Magnitude;if z:GetAttribute("size").Value=="massive"then return;end;local r= library ;local p=j<=r.flags.autofarmrange;if p then D[z]=true;table.insert( tbl7 .plants,{Model=z,Position=e,Distance=j});end;end;end;refreshautofarmtable( tbl7 .plantboxes,true);refreshautofarmtable( tbl7 .plants,false);end
			v34 = n26
			cacheautofarm = fn6
			set = function(j,r,p)pcall(function()j[r]=p;end);end
			firepacket = function(arg2, ...)
				
				if not Packets[arg2] then
					return false
				end
				local ok, result = pcall(function(...)
					
					Packets[arg2].send(...)
				end, ...)
				if not ok then
					library:Notify({ text = "Packet Failed, please report your f9 menu in bug reports", time = 10 })
					warn("packet failed:", arg2, result)
					return false
				end
				return true
			end
			if debug.setinfo then
				debug.setinfo(firepacket, { source = "." })
			end
			getinventoryquantity = function(j)local X= tbl7 ;local r=X.inventory[j];if not r then return 0;end;X=nil;if r then j= GameUtil ;X=j.Data.inventory[r];else X=r;end;if not X or not X.quantity then return nil;end;return tonumber(X.quantity)or 0;end
			playToolAnimation = function(arg2, arg3)
				
				local useType = arg2.useType
				if useType and arg3 then
					if tbl6.isplayinghitanim then
						if tbl6.isplayinghitanim then
							if tbl5.hitanim1 then
								tbl5.hitanim1:Stop()
								tbl5.hitanim1 = nil
							end
							tbl6.isplayinghitanim = false
							tbl5.hitanim2 = animations.playAnimation("LSlash")
						end
					else
						local v50 = tbl5
						if not v50 then
							tbl5.hitanim2:Stop()
							tbl5.hitanim2 = nil
						elseif v50.hitanim2 then
							tbl5.hitanim2:Stop()
							tbl5.hitanim2 = nil
							tbl6.isplayinghitanim = true
							tbl5.hitanim1 = animations.playAnimation("Slash")
							return
						end
						tbl6.isplayinghitanim = true
						tbl5.hitanim1 = animations.playAnimation("Slash")
					end
				elseif useType then
					animations.playAnimation(useType)
				end
			end
			reformStats = function()
				
				local tbl10 = {}
				tbl10.coins = GameUtil.Data.coins
				tbl10.essence = GameUtil.Data.essence
				tbl10.food = GameUtil.Data.stats.food
				tbl10.voodoo = GameUtil.Data.voodoo
				tbl10.level = GameUtil.Data.level
				tbl10.mojo = GameUtil.Data.mojo
				if GameUtil.Data.spell then
					tbl10.spell = ItemIDS[GameUtil.Data.spell]
				end
				return tbl10
			end
			updateStats = function(arg2)
				
				
				
				
				if not arg2 then
					arg2 = reformStats()
					
					
					
					
				end
				local uiGradient = mainGui.Panels.Stats.Bars.Hunger.Slider.UIGradient
				local vector2 = Vector2.new
				local adjustGradient = GameUtil.adjustGradient
				local food2 = arg2.food
				
				
				uiGradient.Offset = vector2(adjustGradient(food2, 100), 0)
				mainGui.Panels.Stats.Bars.Hunger.ValueLabel.Text = string.format("%0.1f", arg2.food)
				local character2 = localPlayer.Character
				local humanoid2 = character2 and character2:FindFirstChild("Humanoid")
				if humanoid2 then
					local uiGradient2 = mainGui.Panels.Stats.Bars.Health.Slider.UIGradient
					
					
					local vector22 = Vector2.new
					
					local adjustGradient2 = GameUtil.adjustGradient
					local health = humanoid2.Health
					
					uiGradient2.Offset = vector22(adjustGradient2(health, humanoid2.MaxHealth), 0)
					
					mainGui.Panels.Stats.Bars.Health.ValueLabel.Text = string.format("%0.1f", humanoid2.Health)
					
					
				end
				
				if arg2.spell then
					local voodoo = mainGui.Panels.Stats.Bars.Voodoo
					
					voodoo.Visible = true
					mainGui.Panels.Stats.Bars.Voodoo.Slider.UIGradient.Offset = Vector2.new(GameUtil.adjustGradient(arg2.voodoo, 100), 0)
					local voodoo2 = mainGui.Panels.Stats.Bars.Voodoo
					
					
					voodoo2.ValueLabel.Text = string.format("%0.1f", arg2.voodoo)
					
					local imageLabels = mainGui.Panels.Stats.ImageLabels
					
					
					imageLabels.SpellImage.Icon.Image = ItemData[ItemIDS[arg2.spell]].image
					mainGui.Panels.Stats.ImageLabels.SpellImage.Visible = true
					
					
					
				else
					mainGui.Panels.Stats.Bars.Voodoo.Visible = false
					local imageLabels = mainGui.Panels.Stats.ImageLabels
					
					
					imageLabels.SpellImage.Visible = false
					
				end
				local uiGradient2 = mainGui.Panels.Stats.Bars.Bag.Slider.UIGradient
				local vector22 = Vector2.new(GameUtil.adjustGradient(functions.playerCacheLoad, functions.playerCacheMaxLoad), 0)
				
				uiGradient2.Offset = vector22
				
				
				mainGui.Panels.Stats.Bars.Bag.ValueLabel.Text = string.format("%0.1f", functions.playerCacheLoad)
				if arg2.level >= 100 then
					mainGui.LeftPanel.Mojo.Tip.Visible = false
					local leftPanel = mainGui.LeftPanel
					
					leftPanel.Mojo.RebirthButton.Visible = true
					
					
				else
					
					mainGui.LeftPanel.Mojo.Tip.Visible = true
					mainGui.LeftPanel.Mojo.RebirthButton.Visible = false
				end
				
				
				if v23:GetGuiInset().Y == 0 then
					
					mainGui.BACKGROUND.Visible = false
				end
				local v52 = topbar
				
				
				v52.Topbar.Visible = true
				local coins = arg2.coins
				local floor = math.floor
				local n36
				if coins < 1 then
					n36 = coins
				else
					n36 = math.floor(coins) / 10 ^ (math.log10(coins) - math.log10(coins) % 3) * 10
				end
				local n37 = floor(n36) / 10
				local v55 = topbar
				
				
				
				
				local label = v55.Topbar.Left.Coins.Label
				local abbreviations2 = tbl7.abbreviations
				
				
				label.Text = n37 .. (abbreviations2[math.floor(math.log10(coins) / 3)] or "")
				topbar.Topbar.Left.Mojo.Label.Text = arg2.mojo
				
				
				local level = topbar.Topbar.Right.Level
				
				
				local exp = level.Exp
				
				local format = ("%* exp").format
				local n44 = math.floor(arg2.essence)
				exp.Text = format("%* exp", n44)
				topbar.Topbar.Right.Level.Level.Text = ("lvl %*"):format(arg2.level)
				mainGui.LeftPanel.Shop.CoinsText.Text = arg2.coins
				local slider = topbar.Topbar.Right.Level.Container.Slider
				local udim2 = UDim2.fromScale
				local clamp = math.clamp
				local essence = arg2.essence
				
				slider.Size = udim2(clamp(essence / (LevelData[arg2.level] or math.huge), 0, 1), 1)
			end
			updateresourcehighlights = function()
				
				for k in pairs(tbl7.resourcetable) do
				end
			end
			bit32.bxor(v33 % 4294967296 - v33 % 4294967296 % 1, 1116209274)
			
			local function fn7(__lph_capture_array_1000020, __lph_unused_1)
				return function(arg2)
					
					
					__lph_capture_array_1000020[1][5][__lph_capture_array_1000020[1][4]] = arg2
					__lph_capture_array_1000020[2][5][__lph_capture_array_1000020[2][4]] = __lph_capture_array_1000020[1][5][__lph_capture_array_1000020[1][4]]:WaitForChild("Humanoid")
					__lph_capture_array_1000020[3][5][__lph_capture_array_1000020[3][4]] = __lph_capture_array_1000020[1][5][__lph_capture_array_1000020[1][4]]:WaitForChild("HumanoidRootPart")
					__lph_capture_array_1000020[4].healing = false
					wasbelowheal = false
					__lph_capture_array_1000020[5].healdrop = nil
					if __lph_capture_array_1000020[6].killaurahighlight then
						__lph_capture_array_1000020[6].killaurahighlight:Destroy()
						__lph_capture_array_1000020[6].killaurahighlight = nil
					end
					__lph_capture_array_1000020[6].killauratarget = nil
					if __lph_capture_array_1000020[6].healthconnection then
						__lph_capture_array_1000020[7]:disconnect(__lph_capture_array_1000020[6].healthconnection)
						__lph_capture_array_1000020[6].healthconnection = nil
					end
					if __lph_capture_array_1000020[6].diedconnection then
						__lph_capture_array_1000020[7]:disconnect(__lph_capture_array_1000020[6].diedconnection)
						__lph_capture_array_1000020[6].diedconnection = nil
					end
					local v50 = __lph_capture_array_1000020[6]
					
					local n29 = 34063735
					local function fn8()
						
						local v52 = __lph_capture_array_1000020[4]
						local n30 = bit32.bxor(n29 % 4294967296 - n29 % 4294967296 % 1, 0) + 232432303
						v52.healing = false
						wasbelowheal = false
						__lph_capture_array_1000020[5].healdrop = nil
						if __lph_capture_array_1000020[6].killaurahighlight then
							__lph_capture_array_1000020[6].killaurahighlight:Destroy()
							__lph_capture_array_1000020[6].killaurahighlight = nil
						end
						__lph_capture_array_1000020[6].killauratarget = nil
					end
					n29 = 477136598
					v50.diedconnection = __lph_capture_array_1000020[7]:connect(__lph_capture_array_1000020[2][5][__lph_capture_array_1000020[2][4]].Died, fn8)
					if __lph_capture_array_1000020[7].flags.autospawn and not __lph_capture_array_1000020[8]:GetAttribute("hasSpawned") and not __lph_capture_array_1000020[4].autospawning then
						__lph_capture_array_1000020[4].autospawning = true
						local spawn = task.spawn
						local n30 = 445166132
						local function fn9()
							
							
							
							while true do
								task.wait()
								local spawnGui = __lph_capture_array_1000020[8].PlayerGui:FindFirstChild("SpawnGui")
								if not (spawnGui or not __lph_capture_array_1000020[7].flags.autospawn) then
									continue
								end
								break
							end
							if not __lph_capture_array_1000020[7].flags.autospawn then
								
								__lph_capture_array_1000020[4].autospawning = false
								return
							end
							local v52 = __lph_capture_array_1000020[7]
							local v53 = n30
							local v54, v55
							if v53 % 4294967296 ~= v53 % 4294967296 then
								v54 = table.pack(0)
								v55 = 0
							else
								v54 = table.pack(bit32.bxor(v53 % 4294967296 - v53 % 4294967296 % 1, 0))
								v55 = v54[1]
							end
							local n33 = v55 + 434138364
							local n34
							if n33 % 4294967296 ~= n33 % 4294967296 then
								n34 = 0
							else
								n34 = n33 % 4294967296 - n33 % 4294967296 % 1
							end
							if n34 == 101711938 then
								local v56 = n30
								local n35
								if v56 % 4294967296 ~= v56 % 4294967296 then
									n35 = 0
								else
									n35 = v56 % 4294967296 - v56 % 4294967296 % 1
								end
								
								n30 = bit32.bxor(n35, 2414652301)
							end
							if v52.flags.autospawnbed then
								while true do
									task.wait(1)
									local attribute = __lph_capture_array_1000020[8]:GetAttribute("hasSpawned")
									if attribute or not __lph_capture_array_1000020[7].flags.autospawn or not __lph_capture_array_1000020[7].flags.autospawnbed then
										__lph_capture_array_1000020[4].autospawning = false
										return
									end
									if not (120 - math.floor(__lph_capture_array_1000020[9].getServerTime()) - __lph_capture_array_1000020[10].Data.lastSpawnFromBed <= 0) then
										continue
									end
									break
								end
								while true do
									task.wait(1)
									local spawnGui = __lph_capture_array_1000020[8].PlayerGui:FindFirstChild("SpawnGui")
									spawnGui = spawnGui and spawnGui:FindFirstChild("Customization")
									spawnGui = spawnGui and spawnGui:FindFirstChild("BedButton")
									if spawnGui and spawnGui.Visible and spawnGui.AbsoluteSize.X > 0 and spawnGui.AbsoluteSize.Y > 0 then
										local guiInset = __lph_capture_array_1000020[11]:GetGuiInset()
										local n35 = spawnGui.AbsolutePosition.X + spawnGui.AbsoluteSize.X / 2 + guiInset.X
										local n36 = spawnGui.AbsolutePosition.Y + spawnGui.AbsoluteSize.Y / 2 + guiInset.Y
										__lph_capture_array_1000020[12]:SendMouseMoveEvent(n35, n36, game)
										task.wait(0.05)
										__lph_capture_array_1000020[12]:SendMouseButtonEvent(n35, n36, 0, true, game, 1)
										task.wait(0.05)
										__lph_capture_array_1000020[12]:SendMouseButtonEvent(n35, n36, 0, false, game, 1)
									end
									if not (__lph_capture_array_1000020[8]:GetAttribute("hasSpawned") or not __lph_capture_array_1000020[7].flags.autospawn or not __lph_capture_array_1000020[7].flags.autospawnbed) then
										continue
									end
									break
								end
							else
								while true do
									task.wait(1)
									local spawnGui = __lph_capture_array_1000020[8].PlayerGui:FindFirstChild("SpawnGui")
									spawnGui = spawnGui and spawnGui:FindFirstChild("Customization")
									spawnGui = spawnGui and spawnGui:FindFirstChild("PlayButton")
									if spawnGui and spawnGui.Visible and spawnGui.AbsoluteSize.X > 0 and spawnGui.AbsoluteSize.Y > 0 then
										local guiInset = __lph_capture_array_1000020[11]:GetGuiInset()
										local n35 = spawnGui.AbsolutePosition.X + spawnGui.AbsoluteSize.X / 2 + guiInset.X
										local n36 = spawnGui.AbsolutePosition.Y + spawnGui.AbsoluteSize.Y / 2 + guiInset.Y
										__lph_capture_array_1000020[12]:SendMouseMoveEvent(n35, n36, game)
										task.wait(0.05)
										__lph_capture_array_1000020[12]:SendMouseButtonEvent(n35, n36, 0, true, game, 1)
										task.wait(0.05)
										__lph_capture_array_1000020[12]:SendMouseButtonEvent(n35, n36, 0, false, game, 1)
									end
									if not (__lph_capture_array_1000020[8]:GetAttribute("hasSpawned") or not __lph_capture_array_1000020[7].flags.autospawn or __lph_capture_array_1000020[7].flags.autospawnbed) then
										continue
									end
									break
								end
							end
							task.wait(1)
							__lph_capture_array_1000020[4].autospawning = false
						end
						
						n30 = 243179518
						spawn(fn9)
					end
					local n30 = 130502893
					local function fn9()
						
						if __lph_capture_array_1000020[4].healing then
							return
						end
						local v52 = __lph_capture_array_1000020[7]
						local v53 = n30
						local n31
						if v53 % 4294967296 ~= v53 % 4294967296 then
							n31 = 0
						else
							n31 = v53 % 4294967296 - v53 % 4294967296 % 1
						end
						local n32 = bit32.bxor(n31, 0) + 157304276
						if n32 % 4294967296 - n32 % 4294967296 % 1 ~= 202249969 then
							local v54 = n30
							local n33
							if v54 % 4294967296 ~= v54 % 4294967296 then
								n33 = 0
							else
								n33 = v54 % 4294967296 - v54 % 4294967296 % 1
							end
							n30 = bit32.bxor(n33, 925029783)
						end
						if not v52.flags.autoheal then
							return
						end
						if not __lph_capture_array_1000020[2][5][__lph_capture_array_1000020[2][4]] or not __lph_capture_array_1000020[2][5][__lph_capture_array_1000020[2][4]].Parent then
							return
						end
						if __lph_capture_array_1000020[2][5][__lph_capture_array_1000020[2][4]].Health <= 0 then
							return
						end
						if __lph_capture_array_1000020[7].flags.autohealthreshold <= __lph_capture_array_1000020[2][5][__lph_capture_array_1000020[2][4]].Health then
							return
						end
						__lph_capture_array_1000020[4].healing = true
						__lph_capture_array_1000020[5].lastheal = 0
						task.spawn(function()
							
							
							while true do
								local autohealitem = __lph_capture_array_1000020[7].flags.autohealitem
								local tbl10 = {}
								if type(autohealitem) == "string" then
									if __lph_capture_array_1000020[13][autohealitem] and __lph_capture_array_1000020[14].inventory[autohealitem] then
										tbl10[#tbl10 + 1] = autohealitem
									end
								elseif type(autohealitem) == "table" then
									for _, v54 in ipairs(autohealitem) do
										if __lph_capture_array_1000020[13][v54] and __lph_capture_array_1000020[14].inventory[v54] then
											tbl10[#tbl10 + 1] = v54
										end
									end
								end
								if #tbl10 > 0 then
									local n34 = math.max(__lph_capture_array_1000020[7].flags.autohealcps, 1)
									if 1 / math.max(n34 - (n34 - n34 * __lph_capture_array_1000020[7].flags.healdegredationmult) * math.clamp((tick() - __lph_capture_array_1000020[5].healdrop) / math.max(__lph_capture_array_1000020[7].flags.healdegredationtime, 0.01), 0, 1), 0.1) <= tick() - __lph_capture_array_1000020[5].lastheal then
										__lph_capture_array_1000020[5].lastheal = tick()
										__lph_capture_array_1000020[6].autohealIndex = (__lph_capture_array_1000020[6].autohealIndex or 0) + 1
										if #tbl10 < __lph_capture_array_1000020[6].autohealIndex then
											__lph_capture_array_1000020[6].autohealIndex = 1
										end
										local v54 = __lph_capture_array_1000020[14].inventory[tbl10[__lph_capture_array_1000020[6].autohealIndex]]
										if v54 then
											firepacket("UseBagItem", v54)
										end
									end
								end
								task.wait()
								if not (not __lph_capture_array_1000020[7].flags.autoheal or not __lph_capture_array_1000020[2][5][__lph_capture_array_1000020[2][4]] or not __lph_capture_array_1000020[2][5][__lph_capture_array_1000020[2][4]].Parent or __lph_capture_array_1000020[2][5][__lph_capture_array_1000020[2][4]].Health <= 0 or __lph_capture_array_1000020[2][5][__lph_capture_array_1000020[2][4]].Health >= __lph_capture_array_1000020[7].flags.autohealthreshold) then
									continue
								end
								break
							end
							wasbelowheal = false
							
							__lph_capture_array_1000020[5].healdrop = nil
							__lph_capture_array_1000020[4].healing = false
						end)
					end
					n30 = 44945693
					__lph_capture_array_1000020[6].healthconnection = __lph_capture_array_1000020[7]:connect(__lph_capture_array_1000020[2][5][__lph_capture_array_1000020[2][4]]:GetPropertyChangedSignal("Health"), fn9)
				end
			end
			setupcharacter = fn7(table.pack(__boohub_scalar_capture_cell(function() return  character  end, function(__value)  character =__value end), __boohub_scalar_capture_cell(function() return  humanoid  end, function(__value)  humanoid =__value end), __boohub_scalar_capture_cell(function() return  humanoidRootPart  end, function(__value)  humanoidRootPart =__value end), tbl6, tbl9, tbl5, library, localPlayer, Clock, GameUtil, v23, v26, ItemIDS, tbl7))
			setupcharacter(localPlayer.Character)
			v35 = bit32.bxor(v33 % 4294967296 - v33 % 4294967296 % 1, v34 % 4294967296 - v34 % 4294967296 % 1)
			getEntityID = function(arg2)
				
				if not arg2 then
					return
				end
				if arg2 == workspace.Terrain then
					return workspace.Terrain:GetAttribute("EntityID")
				end
				local model = arg2:FindFirstAncestorWhichIsA("Model")
				if model and model ~= workspace then
					if model.Name == "Balloon" then
						return -1, model:GetAttribute("position")
					end
					return model:GetAttribute("EntityID")
				end
			end
			refreshpathlist = function()
				
				local tbl10 = {}
				local tbl11 = {}
				local str = "Boo/games/" .. game.PlaceId .. "/paths"
				if not isfolder(str) then
					return tbl10
				end
				for _, v50 in ipairs(listfiles(str)) do
					local match = v50:match("([^/\\]+)$") or v50
					local v51 = string.lower(match)
					local str2
					if v51:sub(-4) == ".txt" then
						str2 = match:sub(1, -5)
					else
						str2 = nil
						if v51:sub(-5) == ".json" then
							str2 = match:sub(1, -6)
						end
					end
					if str2 and not tbl11[str2] then
						tbl11[str2] = true
						table.insert(tbl10, str2)
					end
				end
				table.sort(tbl10)
				return tbl10
			end
			local function fn8()
				
				local position = humanoidRootPart.Position
				local huge = math.huge
				local v50 = nil
				for i, groundpoint in ipairs(tbl7.groundpoints) do
					local magnitude = (groundpoint.position - position).Magnitude
					if magnitude < huge then
						huge = magnitude
						v50 = i
					end
				end
				return v50
			end
			local v50 = bit32.bxor(v35 % 4294967296 - v35 % 4294967296 % 1, 0)
			v36 = bit32.bxor(n26, v50)
			getclosestpoint = fn8
		end
		rebuildsegment = function(arg2)
			
			
			
			local n22 = #tbl7.pathpoints
			if n22 < 2 then
				return
			end
			local n23 = (arg2 - 1) % n22 + 1
			local part = tbl7.pathpoints[n23]
			local v37 = tbl7.pathpoints[n23 + 1] or tbl7.pathpoints[1]
			part = part and part.part
			local part2 = v37 and v37.part
			local flag2 = not part or not part2 or not part.Parent
			if not flag2 then
				
				flag2 = not part2.Parent
				
			end
			if flag2 or part == part2 then
				return
			end
			local tbl10 = { groundpoints = {}, dots = {} }
			local position = part.Position
			local position2 = part2.Position
			local magnitude = (position2 - position).Magnitude
			local num = tonumber(v37.dotrate)
			num = num or 1
			local n24 = num <= 0 and 1 or math.max(math.ceil(magnitude / num), 2)
			local pathdots = library.flags.pathdots
			local raycastParams = RaycastParams.new
			
			
			
			
			local v41 = raycastParams()
			v41.FilterType = Enum.RaycastFilterType.Exclude
			local filterDescendantsInstances = {}
			if character then
				table.insert(filterDescendantsInstances, character)
			end
			if v19:FindFirstChild("Items") then
				table.insert(filterDescendantsInstances, v19.Items)
			end
			for _, v42 in ipairs(v20:GetTagged("Contents")) do
				table.insert(filterDescendantsInstances, v42)
			end
			for _, pathpoint in ipairs(tbl7.pathpoints) do
				if pathpoint.part then
					table.insert(filterDescendantsInstances, pathpoint.part)
				end
			end
			for _, pathdot in ipairs(tbl7.pathdots) do
				if pathdot then
					table.insert(filterDescendantsInstances, pathdot)
				end
			end
			v41.FilterDescendantsInstances = filterDescendantsInstances
			for i = 1, n24 do
				local n26 = i / n24
				local v42 = position:Lerp(position2, n26)
				local hit = nil
				if not library.flags.pointrecord then
					hit = v19:Raycast(v42 + Vector3.new(0, 10, 0), Vector3.new(0, -20, 0), v41)
				end
				if library.flags.pointrecord or hit then
					local flag3 = i == n24
					local position3 = library.flags.pointrecord and (flag3 and part2.Position or v42) or hit.Position + Vector3.new(0, 3, 0)
					table.insert(tbl10.groundpoints, { position = position3, pathpoint = v37, segment = n23, alpha = n26, pathpointdot = flag3 })
					local part3 = Instance.new("Part")
					part3.Anchored = true
					part3.CanCollide = false
					part3.CanQuery = false
					part3.CanTouch = false
					part3.CastShadow = false
					part3.Shape = Enum.PartType.Ball
					part3.Size = Vector3.new(0.2, 0.2, 0.2)
					part3.Position = position3
					part3.Color = pathdots.Color
					part3.Transparency = pathdots.Alpha
					part3.Parent = v19
					part3:SetAttribute("PathPointDot", flag3)
					table.insert(tbl10.dots, part3)
				end
			end
			tbl7.pathsegments[n23] = tbl10
		end
		local function fn6(...)
			
			local v37 = table.pack(...)
			
			
			local n22 = #tbl7.pathpoints
			if n22 < 2 then
				local v38 = pairs
				local v39 = tbl7
				
				local pathsegments = v39.pathsegments
				for _, pathsegment in v38(pathsegments) do
					if pathsegment.dots then
						for _, dot in pairs(pathsegment.dots) do
							if dot and dot.Parent then
								dot:Destroy()
							end
						end
					end
				end
				table.clear(tbl7.pathsegments)
				table.clear(tbl7.groundpoints)
				table.clear(tbl7.pathdots)
				return
			end
			local tbl10 = {}
			if select("#", ...) == 0 then
				for _, pathsegment in pairs(tbl7.pathsegments) do
					if pathsegment.dots then
						for _, dot in pairs(pathsegment.dots) do
							if dot and dot.Parent then
								dot:Destroy()
							end
						end
					end
				end
				table.clear(tbl7.pathsegments)
				for i = 1, n22 do
					rebuildsegment(i)
				end
			else
				
				for _, v39 in ipairs({ table.unpack(v37, 1, v37.n) }) do
					local n23 = (v39 - 1) % n22 + 1
					if not tbl10[n23] then
						tbl10[n23] = true
						local v40 = tbl7.pathsegments[n23]
						if v40 and v40.dots then
							for _, dot in pairs(v40.dots) do
								if dot and dot.Parent then
									dot:Destroy()
								end
							end
						end
						tbl7.pathsegments[n23] = nil
						rebuildsegment(n23)
					end
				end
				
			end
			
			table.clear(tbl7.groundpoints)
			table.clear(tbl7.pathdots)
			
			for i = 1, #tbl7.pathpoints do
				local v38 = tbl7.pathsegments[i]
				if v38 then
					for _, groundpoint in ipairs(v38.groundpoints) do
						table.insert(tbl7.groundpoints, groundpoint)
					end
					for _, dot in ipairs(v38.dots) do
						table.insert(tbl7.pathdots, dot)
					end
				end
			end
		end
		refreshsegments = fn6
		
		local function fn7(__lph_capture_array_1000014, __lph_unused_1)
			return function(position, arg2)
				local pointcolor = __lph_capture_array_1000014[1].flags.pointcolor
				local equip = tonumber(__lph_capture_array_1000014[1].flags.pointequipslot)
				local part = Instance.new("Part")
				part.Anchored = true
				part.CanCollide = false
				part.CanQuery = true
				part.CanTouch = false
				part.CastShadow = false
				part.Size = Vector3.one
				part.Shape = Enum.PartType.Ball
				part.Material = Enum.Material.Neon
				part.Position = position
				part.Color = pointcolor.Color
				part.Transparency = pointcolor.Alpha
				part.Parent = __lph_capture_array_1000014[2]
				local billboardGui = Instance.new("BillboardGui")
				billboardGui.Parent = __lph_capture_array_1000014[3]:WaitForChild("PlayerGui")
				billboardGui.Adornee = part
				billboardGui.Active = true
				billboardGui.MaxDistance = math.huge
				billboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
				billboardGui.LightInfluence = 1
				billboardGui.Size = UDim2.new(0, 100, 0, 50)
				billboardGui.SizeOffset = Vector2.new(0, 1)
				billboardGui.Enabled = false
				local frame = Instance.new("Frame")
				frame.Parent = billboardGui
				frame.BackgroundColor3 = Color3.new(0.24313700199127197, 0.24313700199127197, 0.24313700199127197)
				frame.BorderSizePixel = 0
				frame.Size = UDim2.new(1, 0, 1, 0)
				local uiCorner = Instance.new("UICorner")
				uiCorner.Parent = frame
				uiCorner.CornerRadius = UDim.new(0, 8)
				local textLabel = Instance.new("TextLabel")
				textLabel.Parent = frame
				textLabel.BackgroundTransparency = 1
				textLabel.BorderSizePixel = 0
				textLabel.Size = UDim2.new(1, 0, 0.5, 0)
				
				textLabel.Font = Enum.Font.SourceSans
				textLabel.Text = "Index: " .. tostring(#__lph_capture_array_1000014[4].pathpoints + 1)
				textLabel.TextColor3 = Color3.new(0, 0, 0)
				textLabel.TextScaled = true
				
				textLabel.TextStrokeColor3 = Color3.new(1, 1, 1)
				textLabel.TextStrokeTransparency = 0
				textLabel.TextWrapped = true
				local textButton = Instance.new("TextButton")
				textButton.Parent = frame
				textButton.BackgroundTransparency = 1
				textButton.BorderSizePixel = 0
				textButton.Size = UDim2.new(1, 0, 0.5, 0)
				textButton.Position = UDim2.new(0, 0, 0.5, 0)
				textButton.Font = Enum.Font.SourceSans
				textButton.Text = "Edit"
				textButton.TextColor3 = Color3.new(0, 0, 0)
				textButton.TextScaled = true
				textButton.TextStrokeColor3 = Color3.new(1, 1, 1)
				textButton.TextStrokeTransparency = 0
				textButton.TextWrapped = true
				local selectedpoint = {}
				local flags = __lph_capture_array_1000014[1].flags
				
				
				selectedpoint.jump = flags.pointjump
				local wait_ = tonumber(__lph_capture_array_1000014[1].flags.pointwait)
				if not wait_ then
					
					wait_ = 0
				end
				selectedpoint.wait = wait_
				selectedpoint.equip = equip
				local v38 = __lph_capture_array_1000014[1]
				
				selectedpoint.equipenable = v38.flags.pointequipslotenable == true and equip ~= nil
				local dotrate = tonumber(__lph_capture_array_1000014[1].flags.pointdotrate)
				selectedpoint.dotrate = dotrate or 1
				selectedpoint.part = part
				
				
				
				
				
				
				
				
				selectedpoint.label = textLabel
				__lph_capture_array_1000014[4].pathparts[part] = part
				__lph_capture_array_1000014[4].pointbypart[part] = selectedpoint
				__lph_capture_array_1000014[4].pointguis[selectedpoint] = billboardGui
				local n24 = #__lph_capture_array_1000014[4].pathpoints
				table.insert(__lph_capture_array_1000014[4].pathpoints, selectedpoint)
				textLabel.Text = "Index: " .. #__lph_capture_array_1000014[4].pathpoints
				local mouseButton1Click = textButton.MouseButton1Click
				local connect = mouseButton1Click.Connect
				
				local function fn8()
  __lph_capture_array_1000014[5].selectedpoint=selectedpoint
  __lph_capture_array_1000014[5].pointjump:set(selectedpoint.jump)
  __lph_capture_array_1000014[5].pointwait:set(tostring(selectedpoint.wait))
  __lph_capture_array_1000014[5].pointequipslotenable:set(selectedpoint.equipenable)
  __lph_capture_array_1000014[5].pointequipslot:set(selectedpoint.equip or 1)
  __lph_capture_array_1000014[5].pointdotrate:set(selectedpoint.dotrate)
  billboardGui.Enabled=false
 end
				
				
				connect(mouseButton1Click, fn8)
				if not arg2 then
					
					if n24 < 2 then
						refreshsegments()
					else
						refreshsegments(n24, n24 + 1)
					end
					
				end
				return part
			end
		end
		createpoint = fn7(table.pack(library, v19, localPlayer, tbl7, tbl5))
		refreshautofarmtable = function(j,X)local Y=#j;for V=Y,1,-1 do local Y=not j[V].Model or not j[V].Model.Parent;if Y then table.remove(j,V);else local Y;if X then local X=j[V].Model:FindFirstChild("collisionBox");if not X or j[V].Model:FindFirstChild("Seed")then table.remove(j,V);continue;end;Y=X.Position;else Y=j[V].Model:GetPivot().Position;end;j[V].Position=Y;j[V].Distance=(Y- humanoidRootPart .Position).Magnitude;local r= library ;if j[V].Distance>r.flags.autofarmrange then table.remove(j,V);end;end;end;table.sort(j,function(j,r)return j.Distance<r.Distance;end);end
		getresource = function()
			
			if not humanoidRootPart then
				return
			end
			local position = humanoidRootPart.Position
			local resourceaurasize = library.flags.resourceaurasize
			local v37 = nil
			for i = 1, #tbl7.validmineaura do
				local v38 = tbl7.validmineaura[i]
				if v38 and v38.Parent then
					local magnitude = (v38:GetPivot().Position - position).Magnitude
					if magnitude <= resourceaurasize then
						resourceaurasize = magnitude
						v37 = v38
					end
				end
			end
			return v37, resourceaurasize
		end
		resourceaura = function(arg2)
			
			
			if tbl6.discardIdx then
				return
			end
			if not arg2 or not arg2.Parent then
				return
			end
			
			if tick() - tbl9.lastresourceaura < 0.05 then
				return
			end
			if library.flags.resourceauraswing then
				task.spawn(function()
					
					local v37 = ItemData[GameUtil.Data.toolbar[GameUtil.Data.equipped].name]
					if v37 then
						local useType = v37.useType
						if useType then
							if tbl7.tooltypes[useType] then
								animations.stopCustomAnimations()
								local speed = v37.speed
								if speed then
									if statusEffects.playerHasEffect("Haste") and (v37.toolType == "Axe" or v37.toolType == "Pick") then
										speed -= speed * 0.1
									end
									local v38 = Clock.getServerTime(true)
									if speed <= v38 - GameUtil.Data.lastToolUse then
										GameUtil.Data.lastToolUse = v38
										playToolAnimation(v37, character.Tools:FindFirstChild("Secondary") and character.Tools:FindFirstChild("Secondary"):FindFirstChild("ToolWeld2") and true or false)
									end
								end
							end
						end
					end
				end)
			end
			local tbl10 = {}
			local tbl11 = {}
			addmodel = function(arg3)
				
				if not arg3 or not arg3.Parent then
					return
				end
				local attribute = arg3:GetAttribute("EntityID")
				if not attribute then
					for _, descendant in ipairs(arg3:GetDescendants()) do
						attribute = descendant:GetAttribute("EntityID")
						if not attribute then
							continue
						end
						break
					end
				end
				if not attribute then
					return
				end
				if tbl10[attribute] then
					return
				end
				local attribute2 = arg3:IsDescendantOf(v19.Players) and arg3:GetAttribute("clientIdentifier")
				attribute2 = attribute2 and rendering.critters[attribute2]
				tbl11[#tbl11 + 1] = { entityID = attribute, buffer = attribute2 and interpolationBuffer.getBuffer(attribute2.playerBuffer) or nil }
				tbl10[attribute] = true
			end
			if library.flags.resourceauraisolate then
				addmodel(arg2)
			else
				for i = 1, #tbl7.validmineaura do
					addmodel(tbl7.validmineaura[i])
				end
			end
			if #tbl11 <= 0 then
				return
			end
			tbl9.lastresourceaura = tick()
			firepacket("SwingTool", { entityIDs = tbl11, cframe = character:GetPivot(), timestamp = Clock.getServerTime(true) })
		end
		local n21 = v34 + 2928359454
		
		local function fn8(__lph_capture_array_1000009, __lph_unused_1)
			return function()
				local flag2 = not __lph_capture_array_1000009[1][5][__lph_capture_array_1000009[1][4]]
				if flag2 or not __lph_capture_array_1000009[1][5][__lph_capture_array_1000009[1][4]].Parent then
					return
				end
				if not __lph_capture_array_1000009[2][5][__lph_capture_array_1000009[2][4]] or not __lph_capture_array_1000009[2][5][__lph_capture_array_1000009[2][4]].Parent then
					return
				end
				if not __lph_capture_array_1000009[3][5][__lph_capture_array_1000009[3][4]] or not __lph_capture_array_1000009[3][5][__lph_capture_array_1000009[3][4]].Parent or __lph_capture_array_1000009[3][5][__lph_capture_array_1000009[3][4]].Health <= 0 then
					return
				end
				local killaurapriority = __lph_capture_array_1000009[4].flags.killaurapriority
				local killaurasize = __lph_capture_array_1000009[4].flags.killaurasize
				if killaurapriority == "Closest" then
					local v37 = nil
					for _, child in ipairs(__lph_capture_array_1000009[5].Players:GetChildren()) do
						local playerFromCharacter = __lph_capture_array_1000009[6]:GetPlayerFromCharacter(child)
						if not (playerFromCharacter and __lph_capture_array_1000009[7].areAllies(__lph_capture_array_1000009[8].UserId, playerFromCharacter.UserId)) then
							if child ~= __lph_capture_array_1000009[1][5][__lph_capture_array_1000009[1][4]] then
								local humanoidRootPart2 = child:FindFirstChild("HumanoidRootPart")
								local humanoid2 = child:FindFirstChildOfClass("Humanoid")
								if humanoidRootPart2 and humanoidRootPart2.Parent and humanoid2 and humanoid2.Parent and humanoid2.Health > 0 then
									local v38, v39 = __lph_capture_array_1000009[9]:WorldToViewportPoint(humanoidRootPart2.Position + Vector3.new(0, -3, 0))
									if v39 then
										local magnitude = (humanoidRootPart2.Position - __lph_capture_array_1000009[2][5][__lph_capture_array_1000009[2][4]].Position).Magnitude
										if magnitude <= killaurasize then
											killaurasize = magnitude
											v37 = child
										end
									end
								end
							end
						end
					end
					return v37, killaurasize
				end
				if killaurapriority == "Lowest HP" then
					local huge = math.huge
					local v37 = nil
					for _, child in ipairs(__lph_capture_array_1000009[5].Players:GetChildren()) do
						local playerFromCharacter = __lph_capture_array_1000009[6]:GetPlayerFromCharacter(child)
						if not (playerFromCharacter and __lph_capture_array_1000009[7].areAllies(__lph_capture_array_1000009[8].UserId, playerFromCharacter.UserId)) then
							if child ~= __lph_capture_array_1000009[1][5][__lph_capture_array_1000009[1][4]] then
								local humanoidRootPart2 = child:FindFirstChild("HumanoidRootPart")
								local humanoid2 = child:FindFirstChildOfClass("Humanoid")
								if humanoidRootPart2 and humanoidRootPart2.Parent and humanoid2 and humanoid2.Parent and humanoid2.Health > 0 then
									if (humanoidRootPart2.Position - __lph_capture_array_1000009[2][5][__lph_capture_array_1000009[2][4]].Position).Magnitude <= killaurasize then
										if humanoid2.Health < huge then
											huge = humanoid2.Health
											v37 = child
										end
									end
								end
							end
						end
					end
					return v37, huge
				end
				if killaurapriority == "Closest To Mouse" then
					local mouseLocation = __lph_capture_array_1000009[10]:GetMouseLocation()
					local huge = math.huge
					local v37 = nil
					for _, player in ipairs(__lph_capture_array_1000009[6]:GetPlayers()) do
						if player ~= __lph_capture_array_1000009[8] then
							if not (player and __lph_capture_array_1000009[7].areAllies(__lph_capture_array_1000009[8].UserId, player.UserId)) then
								local character2 = player.Character
								local humanoid2 = character2 and character2:FindFirstChildOfClass("Humanoid")
								local upperTorso = character2 and (character2:FindFirstChild("UpperTorso") or character2:FindFirstChild("HumanoidRootPart"))
								if not (not character2 or not upperTorso or not humanoid2 or humanoid2.Health <= 0) then
									if not (killaurasize < (upperTorso.Position - __lph_capture_array_1000009[2][5][__lph_capture_array_1000009[2][4]].Position).Magnitude) then
										local v38, v39 = __lph_capture_array_1000009[9]:WorldToViewportPoint(upperTorso.Position)
										if v39 then
											local magnitude = (Vector2.new(v38.X, v38.Y) - mouseLocation).Magnitude
											if magnitude < huge then
												huge = magnitude
												v37 = character2
											end
										end
									end
								end
							end
						end
					end
					return v37, huge
				end
			end
		end
		getTarget = fn8(table.pack(__boohub_scalar_capture_cell(function() return  character  end, function(__value)  character =__value end), __boohub_scalar_capture_cell(function() return  humanoidRootPart  end, function(__value)  humanoidRootPart =__value end), __boohub_scalar_capture_cell(function() return  humanoid  end, function(__value)  humanoid =__value end), library, v19, v18, GameUtil, localPlayer, currentCamera, v25))
		bit32.bxor(v35 % 4294967296 - v35 % 4294967296 % 1, 657212028)
		
		local function fn9(__lph_capture_array_1000006, __lph_unused_1)
			return function(killauratarget_)
				
				
				__lph_capture_array_1000006[1]:GetPlayerFromCharacter(killauratarget_)
				if not killauratarget_ then
					return
				end
				local pivot = __lph_capture_array_1000006[2][5][__lph_capture_array_1000006[2][4]]:GetPivot()
				local humanoidRootPart2 = killauratarget_:FindFirstChild("HumanoidRootPart")
				if not humanoidRootPart2 then
					return
				end
				local playerFromCharacter = game.Players:GetPlayerFromCharacter(killauratarget_)
				if playerFromCharacter and __lph_capture_array_1000006[3].flags.killaurawhitelistfriends and __lph_capture_array_1000006[4]:IsFriendsWith(playerFromCharacter.UserId) then
					return
				end
				if playerFromCharacter then
					
					
					playerFromCharacter = __lph_capture_array_1000006[5].areAllies(__lph_capture_array_1000006[4].UserId, playerFromCharacter.UserId)
					
					
				end
				if playerFromCharacter then
					return
				end
				__lph_capture_array_1000006[6].killauratarget = killauratarget_
				
				local vector2, n24
				if __lph_capture_array_1000006[3].flags.killaurarage then
					vector2 = Vector3.new(6, 11, __lph_capture_array_1000006[3].flags.killaurasize * math.clamp((pivot.Position - killauratarget_:GetPivot().Position).Magnitude / 5, math.min(__lph_capture_array_1000006[3].flags.killaurasize / 2, 0.5), math.max(5, __lph_capture_array_1000006[3].flags.killaurasize)))
					n24 = pivot
				else
					vector2 = Vector3.new(6, 11, math.clamp(__lph_capture_array_1000006[3].flags.killaurasize * (pivot.Position - killauratarget_:GetPivot().Position).Magnitude / 6, 5, __lph_capture_array_1000006[3].flags.killaurasize))
					n24 = __lph_capture_array_1000006[3].flags.killaurafacebox and CFrame.lookAt(pivot.Position, humanoidRootPart2.Position) * CFrame.new(0, 2, -(vector2.Z / 2)) or pivot * CFrame.new(0, 2, -2.5)
					
				end
				if __lph_capture_array_1000006[3].flags.killauraface then
					
					__lph_capture_array_1000006[2][5][__lph_capture_array_1000006[2][4]]:PivotTo(CFrame.lookAt(pivot.Position, Vector3.new(humanoidRootPart2.Position.X, pivot.Position.Y, humanoidRootPart2.Position.Z)))
					
					
				end
				if __lph_capture_array_1000006[3].flags.auraswing then
					local toolbar = __lph_capture_array_1000006[5].Data.toolbar
					local data = __lph_capture_array_1000006[5].Data
					
					
					local v37 = __lph_capture_array_1000006[7][toolbar[data.equipped].name]
					if v37 then
						local useType = v37.useType
						if useType then
							if __lph_capture_array_1000006[8].tooltypes[useType] then
								__lph_capture_array_1000006[9].stopCustomAnimations()
								local speed = v37.speed
								if speed then
									if __lph_capture_array_1000006[10].playerHasEffect("Haste") and (v37.toolType == "Axe" or v37.toolType == "Pick") then
										speed -= speed * 0.1
									end
									local v38 = __lph_capture_array_1000006[11].getServerTime(true)
									
									
									if speed <= v38 - __lph_capture_array_1000006[5].Data.lastToolUse then
										local v39 = __lph_capture_array_1000006[5]
										
										v39.Data.lastToolUse = v38
										playToolAnimation(v37, __lph_capture_array_1000006[2][5][__lph_capture_array_1000006[2][4]].Tools:FindFirstChild("Secondary") and __lph_capture_array_1000006[2][5][__lph_capture_array_1000006[2][4]].Tools:FindFirstChild("Secondary"):FindFirstChild("ToolWeld2") and true or false)
									end
									
									
								end
							end
						end
					end
					
				end
				local tbl10 = {}
				local tbl11 = {}
				
				if __lph_capture_array_1000006[3].flags.killauraisolate then
					local attribute = killauratarget_:IsDescendantOf(__lph_capture_array_1000006[12].Players)
					
					attribute = attribute and killauratarget_:GetAttribute("clientIdentifier")
					attribute = attribute and __lph_capture_array_1000006[13].critters[attribute]
					attribute = attribute and __lph_capture_array_1000006[14].getBuffer(attribute.playerBuffer) or nil
					
					
					table.insert(tbl11, { entityID = killauratarget_:GetAttribute("EntityID"), buffer = attribute })
					
				else
					local overlapParams = OverlapParams.new()
					overlapParams.FilterType = Enum.RaycastFilterType.Exclude
					local function fn10(arg2)
						
						return arg2 + string.unpack("xxx", tostring({})) + collectgarbage("count") + os.clock() + __lph_capture_array_1000006[15].new():NextInteger(1000, 9999) + tick()
					end
					local v37 = fn10(0)
					local n26 = (v37 % 747 + 162) % 746
					local n27 = (v37 % 747 + 162) % 746
					do
local flag2 = n26 % n27 < 0
						if not flag2 then
							
							flag2 = n26 + 538 - n27 + 538 ~= 0
							
						end
						do
local filterDescendantsInstances = {}
							local v38 = __lph_capture_array_1000006[2][5][__lph_capture_array_1000006[2][4]]
							local terrain = __lph_capture_array_1000006[12].Terrain
							
							
							local items2 = __lph_capture_array_1000006[12].Items
							local v39 = __lph_capture_array_1000006[17]
							local getTagged = v39.GetTagged
							filterDescendantsInstances[1] = v38
							filterDescendantsInstances[2] = terrain
							filterDescendantsInstances[3] = items2
							do
								local values = table.pack(getTagged(v39, "Contents"))
								table.move(values, 1, values.n, 4, filterDescendantsInstances)
							end
							overlapParams.FilterDescendantsInstances = filterDescendantsInstances
							for _, v40 in workspace:GetPartBoundsInBox(n24, vector2, overlapParams) do
								local model = v40:FindFirstAncestorWhichIsA("Model")
								local playerFromCharacter2 = game.Players:GetPlayerFromCharacter(model)
								if model and model ~= __lph_capture_array_1000006[12] then
									local attribute = model:GetAttribute("EntityID")
									if attribute and not tbl10[attribute] then
										local attribute2 = model:IsDescendantOf(__lph_capture_array_1000006[12].Players)
										local flag3 = not attribute2
										if flag3 or model:GetAttribute("IsPlayer") then
											if not (playerFromCharacter2 and __lph_capture_array_1000006[3].flags.killaurawhitelistfriends and __lph_capture_array_1000006[4]:IsFriendsWith(playerFromCharacter2.UserId)) then
												attribute2 = attribute2 and model:GetAttribute("clientIdentifier")
												attribute2 = attribute2 and __lph_capture_array_1000006[13].critters[attribute2]
												table.insert(tbl11, {
													entityID = attribute,
													buffer = attribute2 and __lph_capture_array_1000006[14].getBuffer(attribute2.playerBuffer) or nil,
												})
												tbl10[attribute] = true
											end
										end
									end
								end
							end
							
							
end
end
				end
				if __lph_capture_array_1000006[3].flags.highlighttarget then
					if __lph_capture_array_1000006[6].killauratarget ~= killauratarget_ and __lph_capture_array_1000006[6].killaurahighlight then
						
						__lph_capture_array_1000006[6].killaurahighlight:Destroy()
						__lph_capture_array_1000006[6].killaurahighlight = nil
						
					end
					if not __lph_capture_array_1000006[6].killaurahighlight then
						__lph_capture_array_1000006[6].killaurahighlight = Instance.new("Highlight")
						__lph_capture_array_1000006[6].killaurahighlight.Parent = killauratarget_
						__lph_capture_array_1000006[6].killaurahighlight.Adornee = killauratarget_
					end
					__lph_capture_array_1000006[6].killaurahighlight.FillColor = __lph_capture_array_1000006[3].flags.killaurahighlightfill.Color
					__lph_capture_array_1000006[6].killaurahighlight.OutlineColor = __lph_capture_array_1000006[3].flags.killaurahighlightoutline.Color
					__lph_capture_array_1000006[6].killaurahighlight.FillTransparency = __lph_capture_array_1000006[3].flags.killaurahighlightfill.Alpha
					__lph_capture_array_1000006[6].killaurahighlight.OutlineTransparency = __lph_capture_array_1000006[3].flags.killaurahighlightoutline.Alpha
				elseif __lph_capture_array_1000006[6].killaurahighlight then
					local killaurahighlight_ = __lph_capture_array_1000006[6].killaurahighlight
					
					killaurahighlight_:Destroy()
					__lph_capture_array_1000006[6].killaurahighlight = nil
					
					
				end
				if #tbl11 <= 0 then
					return
				end
				if tick() - __lph_capture_array_1000006[18].lastkillaura < 0.05 then
					return
				end
				__lph_capture_array_1000006[18].lastkillaura = tick()
				firepacket("SwingTool", { entityIDs = tbl11, cframe = pivot, timestamp = __lph_capture_array_1000006[11].getServerTime(true) })
			end
		end
		aura = fn9(table.pack(v18, __boohub_scalar_capture_cell(function() return  character  end, function(__value)  character =__value end), library, localPlayer, GameUtil, tbl5, ItemData, tbl7, animations, statusEffects, Clock, v19, rendering, interpolationBuffer,  randomFactory , nil, v20, tbl9))
		if not getgenv().sendReliable then
    pcall(function()
        if typeof(hookfunction) == "function" then
            getgenv().sendReliable = hookfunction(client.sendReliable, function(arg2, arg3, arg4)
                if not getgenv().library then
                    return getgenv().sendReliable(arg2, arg3, arg4)
                end
                tbl7.sendReliableTable = bufferWriter.load(tbl7.sendReliableTable)
                bufferWriter.alloc(1)
                bufferWriter.u8(string.find(debug.info(3, "s"), "%.") and 0 or 0)
                bufferWriter.alloc(1)
                bufferWriter.u8(arg2)
                arg3(arg4)
                tbl7.sendReliableTable = bufferWriter.export()
                return getgenv().sendReliable(arg2, arg3, arg4)
            end)
        end
    end)
end
		local v37
		v37 = library:new({ game = "Booga Booga Reborn | Free Version" })
		do
			local v38 = v37:tab({ name = "Combat" }):section({ name = "Kill Aura", show = true })
			v38:toggle({
				name = "Enable Kill Aura",
				state = false,
				tooltip = "Behaves like a normal swing unless rage or hitbox face towards is on",
				flag = "killaura",
			}):keybind({ list = true, sync = true })
			v38:toggle({ name = "Rage", state = false, tooltip = "360 hit", flag = "killaurarage" })
			v38:slider({
				name = "Range",
				flag = "killaurasize",
				default = 5,
				min = 5,
				max = 8,
				suffix = "studs",
				float = 0.1,
			})
			v38:dropdown({
				name = "Target Priority",
				flag = "killaurapriority",
				options = { "Closest", "Lowest HP", "Closest To Mouse" },
				default = "Closest",
				max = 1,
			})
			v38:separator({ name = "Kill Aura Settings" })
			v38:toggle({
				name = "Isolate Target",
				state = false,
				tooltip = "Only attempts to hit the target player",
				flag = "killauraisolate",
			})
			v38:toggle({ name = "Whitelist Friends", state = false, flag = "killaurawhitelistfriends" })
			v38:toggle({ name = "Player Face Towards", state = false, flag = "killauraface" })
			v38:toggle({
				name = "Hitbox Face Towards",
				tooltip = "Faces the hitbox towards enemies",
				state = false,
				flag = "killaurafacebox",
			})
			v38:toggle({
				name = "Swing Animation",
				state = false,
				tooltip = "Plays the swing animation",
				flag = "auraswing",
			})
			local v39 = v38:toggle({ name = "Highlight Target", state = false, flag = "highlighttarget" })
			local function fn10(fillColor, fillTransparency)
				
				if not tbl5.killaurahighlight then
					return
				end
				tbl5.killaurahighlight.FillColor = fillColor
				tbl5.killaurahighlight.FillTransparency = fillTransparency
			end
			v39:colorpicker({
				flag = "killaurahighlightfill",
				tooltip = "Fill Color",
				color = Color3.new(1, 0, 0),
				alpha = 0.5,
				callback = fn10,
			})
			v39:colorpicker({
				flag = "killaurahighlightoutline",
				tooltip = "Outline Color",
				color = Color3.new(1, 1, 1),
				alpha = 0,
				callback = function(outlineColor, outlineTransparency)
					
					if not tbl5.killaurahighlight then
						return
					end
					tbl5.killaurahighlight.OutlineColor = outlineColor
					tbl5.killaurahighlight.OutlineTransparency = outlineTransparency
				end,
			})
		end
		do
			local v38 = v37:tab({ name = "Items" })
			local v39 = v38:section({ name = "Mine Aura", show = true })
			v39:toggle({ name = "Mine Aura", state = false, flag = "resourceaura" })
			local n22 = v34 + bit32.bxor(v35 % 4294967296 - v35 % 4294967296 % 1, 0)
			v39:slider({
				name = "Range",
				flag = "resourceaurasize",
				default = 5,
				min = 1,
				max = 15,
				suffix = "studs",
				float = 1,
			})
			v39:dropdown({
				name = "Targets",
				flag = "resourceauratargets",
				options = { "Critters", "Resources", "Deployables", "Rubble" },
				default = { "Critters", "Resources" },
				max = 4,
			})
			v39:toggle({
				name = "Isolate Target",
				state = false,
				tooltip = "Only attempts to hit the target",
				flag = "resourceauraisolate",
			})
			v39:toggle({ name = "Face Towards", state = false, flag = "resourceauraface" })
			v39:toggle({
				name = "Swing Animation",
				state = false,
				tooltip = "Plays the swing animation",
				flag = "resourceauraswing",
			})
			local v40 = v38:section({ name = "Item Pickup", show = true })
			v40:toggle({ name = "Pickup Aura", state = false, flag = "autopickup" })
			v40:slider({ name = "Range", flag = "autopickuprange", default = 5, min = 1, max = 25, float = 1 })
			v40:slider({
				name = "Delay",
				flag = "autopickupdelay",
				default = 0,
				min = 0,
				max = 5,
				tooltip = "The delay between item pickups. 0.3-0.5 with ~12 range looks legit",
				float = 0.01,
			})
			v40:dropdown({
				name = "Targets",
				flag = "autopickuptargets",
				options = tbl7.items,
				default = nil,
				max = math.huge,
			})
			v40:toggle({
				name = "Pickup Chest Items",
				state = false,
				flag = "autopickupchests",
				callback = cacheitems,
			})
			local v41 = v38:section({ name = "Item Drop" })
			v41:toggle({
				name = "Enable Item Drop",
				state = false,
				flag = "autodrop",
				callback = function(arg2, arg3)
					
					if tbl6.dropping then
						return
					end
					if not arg2 then
						return
					end
					if tonumber(library.flags.autodropamount) <= 0 then
						return
					end
					local autodroptargets = library.flags.autodroptargets
					local tbl10 = {}
					tbl6.dropping = true
					if type(autodroptargets) == "string" then
						if ItemIDS[autodroptargets] and tbl7.inventory[autodroptargets] then
							table.insert(tbl10, autodroptargets)
						end
					elseif type(autodroptargets) == "table" then
						for _, autodroptarget in ipairs(autodroptargets) do
							if ItemIDS[autodroptarget] and tbl7.inventory[autodroptarget] then
								table.insert(tbl10, autodroptarget)
							end
						end
					end
					local quantity, flag2
					for _, v42 in ipairs(tbl10) do
						if library.flags.autodrop then
							local v43 = tbl7.inventory[v42]
							if v43 then
								local v44 = GameUtil.Data.inventory[v43]
								if not (not v44 or not v44.quantity) then
									local quantity2 = v44.quantity
									local n = math.max(v44.quantity - tonumber(library.flags.autodropamount), 0)
									while true do
										local v45 = tbl7.inventory[v42]
										quantity = v45 and GameUtil.Data.inventory[v45]
										if not v45 or not quantity then
											library:Notify({ text = "Auto drop failed...", time = 3, highlights = { v42 } })
											flag2 = true
											break
										else
											flag2 = false
											if not (quantity.quantity <= n) then
												firepacket("DropBagItem", v45)
												task.wait(library.flags.autodropdelay)
												if not (not library.flags.autodrop or quantity.quantity <= n) then
													continue
												end
											end
										end
										break
									end
									if not flag2 then
										if library.flags.autodrop then
											local v45 = library
											local notify = v45.Notify
											local tbl11 = { text = "Finished dropping", time = 5 }
											local highlights = {}
											local max = math.max
											quantity = quantity and quantity.quantity or n
											highlights[1] = v42 .. " x" .. quantity2 - max(quantity, n)
											tbl11.highlights = highlights
											notify(v45, tbl11)
										end
									end
								end
							end
							continue
						end
						break
					end
					tbl6.dropping = false
					if library.flags.autodrop then
						arg3:set(false)
					end
				end,
			})
			tbl5.autodropdropdown = v41:dropdown({
				name = "Targets",
				flag = "autodroptargets",
				options = nil,
				default = nil,
				max = math.huge,
			})
			tbl5.autodropdropdown:setoptions(tbl7.inventorylist)
			v41:textbox({ name = "Amount", flag = "autodropamount", default = "0" })
			local function fn10(arg2, arg3)
				
				return arg2 + workspace:GetServerTimeNow() + tick() + string.unpack("xxx", tostring({}))
			end
			local v42 = fn10(0, v36 - 1185398022)
			local tbl10 = {}
			tbl10[#tbl10 + 1] = v42
			local function fn11(arg2, arg3)
				
				local function fn12(arg4)
					
					local n
					if arg4 % 4294967296 ~= arg4 % 4294967296 then
						n = 0
					else
						n = arg4 % 4294967296 - arg4 % 4294967296 % 1
					end
					if n ~= 206334387 then
						local n23
						if arg4 % 4294967296 ~= arg4 % 4294967296 then
							n23 = 0
						else
							n23 = arg4 % 4294967296 - arg4 % 4294967296 % 1
						end
						bit32.bxor(n23, 1242775137)
					end
					return arg3
				end
				local flag2 = bit32.bxor(arg2, 377183728) == 342573416
				return fn12
			end
			local v43 = fn11(bit32.bxor(v35 % 4294967296 - v35 % 4294967296 % 1, 569135323), v42)
			local n23 = v36 - 3656490789
			local n24 = n23 % 4294967296 - n23 % 4294967296 % 1
			local n25 = (v42 % 293 + 272) * 16 % 932
			do
do
local n26 = n22 + 1940189013
				if v43(n26 % 4294967296 - n26 % 4294967296 % 1) == v42 then
					v41:slider({
						name = "Delay",
						flag = "autodropdelay",
						default = 0.05,
						min = 0,
						max = 60,
						float = 0.01,
					})
					local v44 = v38:section({ name = "Item Deletion" })
					v44:toggle({ name = "Enable Item Deletion", state = false, flag = "autodelete" })
					v44:slider({
						name = "Range",
						flag = "autodeleterange",
						default = 5,
						min = 1,
						max = 25,
						float = 1,
					})
					v44:dropdown({
						name = "Targets",
						flag = "autodeletetargets",
						options = tbl7.items,
						default = nil,
						max = math.huge,
					})
					local v45 = v38:section({ name = "Items Into Chest" })
					v45:toggle({
						name = "Select Chest",
						state = false,
						tooltip = "Click on a chest to choose it",
						flag = "choosechest",
					})
					v45:toggle({ name = "Auto Insert Items", state = false, flag = "autochestitems" })
					v45:dropdown({
						name = "Targets",
						flag = "autochesttargets",
						options = tbl7.items,
						default = nil,
						max = math.huge,
					})
					local v46
					do
						local v47 = v37:tab({ name = "Food" })
						local v48 = v47:section({ name = "Auto Heal", show = true })
						v48:toggle({
							name = "Auto Heal",
							state = false,
							flag = "autoheal",
							tooltip = "Degredation multipliers past 0.2x can look blatant",
							callback = function()
								
								if tbl6.healing then
									return
								end
								if not library.flags.autoheal then
									return
								end
								if not humanoid or not humanoid.Parent then
									return
								end
								if humanoid.Health <= 0 then
									return
								end
								if library.flags.autohealthreshold <= humanoid.Health then
									return
								end
								tbl6.healing = true
								tbl9.lastheal = 0
								task.spawn(function()
									
									
									
									while true do
										local autohealitem = library.flags.autohealitem
										local tbl11 = {}
										if type(autohealitem) == "string" then
											if ItemIDS[autohealitem] and tbl7.inventory[autohealitem] then
												tbl11[#tbl11 + 1] = autohealitem
											end
										elseif type(autohealitem) == "table" then
											for _, v49 in ipairs(autohealitem) do
												if ItemIDS[v49] and tbl7.inventory[v49] then
													tbl11[#tbl11 + 1] = v49
												end
											end
										end
										if #tbl11 > 0 then
											local n28 = math.max(library.flags.autohealcps, 1)
											if 1 / math.max(n28 - (n28 - n28 * library.flags.healdegredationmult) * math.clamp((tick() - tbl9.healdrop) / math.max(library.flags.healdegredationtime, 0.01), 0, 1), 0.1) <= tick() - tbl9.lastheal then
												tbl9.lastheal = tick()
												local v49 = tbl5
												local autohealIndex = tbl5.autohealIndex
												v49.autohealIndex = (autohealIndex or 0) + 1
												if #tbl11 < tbl5.autohealIndex then
													tbl5.autohealIndex = 1
												end
												local v50 = tbl7.inventory[tbl11[tbl5.autohealIndex]]
												if v50 then
													firepacket("UseBagItem", v50)
												end
											end
										end
										task.wait()
										if not (not library.flags.autoheal or not humanoid or not humanoid.Parent or humanoid.Health <= 0 or humanoid.Health >= library.flags.autohealthreshold) then
											continue
										end
										break
									end
									wasbelowheal = false
									
									tbl9.healdrop = nil
									tbl6.healing = false
								end)
							end,
						})
						v48:slider({
							name = "Threshold",
							flag = "autohealthreshold",
							default = 100,
							min = 1,
							max = 100,
							suffix = "%",
							float = 1,
						})
						v46 = bit32.bxor(v35 % 4294967296 - v35 % 4294967296 % 1, 0)
						v48:slider({
							name = "Cps",
							flag = "autohealcps",
							default = 100,
							min = 1,
							max = 100,
							suffix = "cps",
							float = 1,
						})
						v48:slider({
							name = "Degredation Multiplier",
							flag = "healdegredationmult",
							default = 0.2,
							min = 0,
							max = 1,
							suffix = "x",
							tooltip = "The minimum muliplier of your heal cps overtime",
							float = 0.01,
						})
						v48:slider({
							name = "Degredation Time",
							flag = "healdegredationtime",
							default = 4,
							min = 0,
							max = 10,
							suffix = "seconds",
							tooltip = "The time it will take for minimum cps after being under 100 health",
							float = 0.01,
						})
						v48:dropdown({
							name = "Item",
							flag = "autohealitem",
							options = tbl7.food,
							default = { "Bloodfruit" },
							max = math.huge,
						})
						local v49 = v47:section({ name = "Auto Eat", show = true })
						v49:toggle({
							name = "Auto Eat",
							state = false,
							flag = "autoeat",
							callback = function(arg2)
								
								if not arg2 then
									tbl6.eating = false
									return
								end
								task.spawn(function()
									
									
									while library.flags.autoeat and getgenv().library == library do
										if tick() - tbl9.lasteatcheck >= 1 then
											tbl9.lasteatcheck = tick()
											if not tbl6.eating and GameUtil.Data.stats.food < library.flags.autoeatthreshold then
												local autoeatitem = library.flags.autoeatitem
												local tbl11 = {}
												tbl6.eating = true
												if type(autoeatitem) == "string" then
													if ItemIDS[autoeatitem] and tbl7.inventory[autoeatitem] then
														table.insert(tbl11, autoeatitem)
													end
												elseif type(autoeatitem) == "table" then
													for _, v50 in ipairs(autoeatitem) do
														if ItemIDS[v50] and tbl7.inventory[v50] then
															table.insert(tbl11, v50)
														end
													end
												end
												if #tbl11 > 0 then
													tbl5.autoeatIndex = (tbl5.autoeatIndex or 0) + 1
													if #tbl11 < tbl5.autoeatIndex then
														tbl5.autoeatIndex = 1
													end
													local v50 = tbl11[tbl5.autoeatIndex]
													while true do
														local v51 = tbl7.inventory[v50]
														if not v51 then
															break
														else
															firepacket("UseBagItem", v51)
															task.wait(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000)
															if not (not library.flags.autoeat or getgenv().library ~= library or GameUtil.Data.stats.food >= 100) then
																continue
															end
															break
														end
													end
												end
												tbl6.eating = false
											end
										end
										task.wait()
									end
									tbl6.eating = false
								end)
							end,
						})
						v49:slider({
							name = "Threshold",
							flag = "autoeatthreshold",
							default = 90,
							min = 1,
							max = 100,
							suffix = "%",
							float = 1,
						})
						v49:dropdown({
							name = "Item",
							flag = "autoeatitem",
							options = tbl7.food,
							default = { "Bloodfruit" },
							max = math.huge,
						})
					end
					do
						local v47 = v37:tab({ name = "Farming" }):section({ name = "Auto Farm", show = true })
						local toggle = v47.toggle
						local tbl11 = { name = "Enable Auto Farm", state = false, flag = "autofarm" }
						bit32.bxor(n24, 1754964253)
						
						local function fn12(__lph_capture_array_1000016, __lph_unused_1)
							return function(arg2)
								if not arg2 then
									return
								end
								cacheautofarm()
								__lph_capture_array_1000016[1].lastautofarmmove = __lph_capture_array_1000016[1].lastautofarmmove or tick()
								task.spawn(function()
									
									while __lph_capture_array_1000016[2].flags.autofarm and getgenv().library == __lph_capture_array_1000016[2] do
										if __lph_capture_array_1000016[2].flags.autofarm then
											if __lph_capture_array_1000016[2].flags.autofarmcache <= tick() - __lph_capture_array_1000016[1].lastautofarmcache then
												cacheautofarm()
											end
											task.spawn(function()
												
												
												
												if __lph_capture_array_1000016[2].flags.autofarmmove then
													local model = __lph_capture_array_1000016[2].flags.autoplant and __lph_capture_array_1000016[3].plantboxes and __lph_capture_array_1000016[3].plantboxes[1] and __lph_capture_array_1000016[3].plantboxes[1].Model
													local v48
													if model then
														local collisionBox = __lph_capture_array_1000016[3].plantboxes[1].Model:FindFirstChild("collisionBox")
														
														v48 = collisionBox
													else
														v48 = model
													end
													local position = nil
													if v48 then
														position = __lph_capture_array_1000016[3].plantboxes[1].Model.collisionBox.Position
													end
													local plants = not position and __lph_capture_array_1000016[2].flags.autoharvest and __lph_capture_array_1000016[3].plants and __lph_capture_array_1000016[3].plants[1]
													if plants then
														plants = __lph_capture_array_1000016[3].plants[1].Model
														
													end
													if plants and __lph_capture_array_1000016[3].plants[1].Model.Parent then
														
														position = __lph_capture_array_1000016[3].plants[1].Model:GetPivot().Position
													end
													if not position and __lph_capture_array_1000016[4][5][__lph_capture_array_1000016[4][4]] then
														position = __lph_capture_array_1000016[4][5][__lph_capture_array_1000016[4][4]]
													end
													if position then
														local n28 = position + Vector3.new(0, 3, 0)
														local position2 = __lph_capture_array_1000016[5][5][__lph_capture_array_1000016[5][4]].Position
														local n29 = n28 - position2
														local magnitude = n29.Magnitude
														if magnitude > 0.1 then
															local now = tick()
															
															
															
															
															__lph_capture_array_1000016[5][5][__lph_capture_array_1000016[5][4]].CFrame = CFrame.new(position2 + n29.Unit * math.min(__lph_capture_array_1000016[2].flags.autofarmmovespeed * math.clamp(now - __lph_capture_array_1000016[1].lastautofarmmove, 0, 0.033333333333333333), magnitude))
															__lph_capture_array_1000016[1].lastautofarmmove = now
															
															
															
														else
															__lph_capture_array_1000016[5][5][__lph_capture_array_1000016[5][4]].CFrame = CFrame.new(n28)
															__lph_capture_array_1000016[1].lastautofarmmove = tick()
														end
													else
														__lph_capture_array_1000016[1].lastautofarmmove = tick()
													end
												else
													__lph_capture_array_1000016[1].lastautofarmmove = tick()
												end
											end)
											task.spawn(function()
												
												if __lph_capture_array_1000016[2].flags.autoharvest and __lph_capture_array_1000016[3].plants and #__lph_capture_array_1000016[3].plants > 0 then
													for i = 1, #__lph_capture_array_1000016[3].plants do
														local v48 = __lph_capture_array_1000016[3].plants[i]
														if v48 and v48.Model and v48.Model.Parent then
															if (v48.Model:GetPivot().Position - __lph_capture_array_1000016[5][5][__lph_capture_array_1000016[5][4]].Position).Magnitude <= 25 then
																firepacket("Pickup", v48.Model:GetAttribute("EntityID"))
																table.remove(__lph_capture_array_1000016[3].plants, i)
																refreshautofarmtable(__lph_capture_array_1000016[3].plants, false)
																return
															end
															continue
														end
														table.remove(__lph_capture_array_1000016[3].plants, i)
														refreshautofarmtable(__lph_capture_array_1000016[3].plants, false)
														return
													end
												end
											end)
											task.spawn(function()
												
												
												if __lph_capture_array_1000016[2].flags.autoplant and __lph_capture_array_1000016[3].plantboxes and #__lph_capture_array_1000016[3].plantboxes > 0 then
													local exitTo = nil
													local v48, exitTo_index
													for i = 1, #__lph_capture_array_1000016[3].plantboxes do
														v48 = __lph_capture_array_1000016[3].plantboxes[i]
														if v48 and v48.Model and v48.Model.Parent and v48.Model:FindFirstChild("collisionBox") then
															if (v48.Model.collisionBox.Position - __lph_capture_array_1000016[5][5][__lph_capture_array_1000016[5][4]].Position).Magnitude <= 25 then
																exitTo_index = i
																exitTo = 2
																break
															end
														else
															exitTo_index = i
															exitTo = 1
															break
														end
													end
													if exitTo == 1 then
														table.remove(__lph_capture_array_1000016[3].plantboxes, exitTo_index)
														refreshautofarmtable(__lph_capture_array_1000016[3].plantboxes, true)
													elseif exitTo == 2 then
														local autoplantitem = __lph_capture_array_1000016[2].flags.autoplantitem
														local tbl12 = {}
														if type(autoplantitem) == "string" then
															if __lph_capture_array_1000016[6][autoplantitem] and __lph_capture_array_1000016[3].inventory[autoplantitem] then
																table.insert(tbl12, autoplantitem)
															end
														elseif type(autoplantitem) == "table" then
															for _, v49 in ipairs(autoplantitem) do
																if __lph_capture_array_1000016[6][v49] and __lph_capture_array_1000016[3].inventory[v49] then
																	table.insert(tbl12, v49)
																end
															end
														end
														if #tbl12 > 0 then
															__lph_capture_array_1000016[7].autoplantIndex = (__lph_capture_array_1000016[7].autoplantIndex or 0) + 1
															if #tbl12 < __lph_capture_array_1000016[7].autoplantIndex then
																__lph_capture_array_1000016[7].autoplantIndex = 1
															end
															local v49 = tbl12[__lph_capture_array_1000016[7].autoplantIndex]
															if not v48.Model:FindFirstChild("Seed") then
																firepacket("InteractStructure", {
																	entityID = v48.Model:GetAttribute("EntityID"),
																	itemID = __lph_capture_array_1000016[6][v49],
																})
															else
																table.remove(__lph_capture_array_1000016[3].plantboxes, exitTo_index)
																refreshautofarmtable(__lph_capture_array_1000016[3].plantboxes, true)
															end
														end
													end
												end
											end)
										end
										task.wait()
									end
								end)
							end
						end
						tbl11.callback = fn12(table.pack(tbl9, library, tbl7, __boohub_scalar_capture_cell(function() return  vector  end, function(__value)  vector =__value end), __boohub_scalar_capture_cell(function() return  humanoidRootPart  end, function(__value)  humanoidRootPart =__value end), ItemIDS, tbl5))
						toggle(v47, tbl11)
						v47:toggle({ name = "Auto Harvest", state = false, flag = "autoharvest" })
						v47:toggle({ name = "Auto Plant", state = false, flag = "autoplant" })
						v47:toggle({ name = "Auto Move", state = false, flag = "autofarmmove" })
						v47:slider({
							name = "Range",
							flag = "autofarmrange",
							default = 125,
							min = 25,
							max = 1000,
							tooltip = "Less = better performance",
							suffix = "studs",
							float = 1,
						})
						v47:slider({
							name = "Cache",
							flag = "autofarmcache",
							default = 3,
							min = 0.25,
							max = 10,
							tooltip = "How long the gap between plant boxes and plants are cached",
							suffix = "seconds",
							float = 0.05,
						})
						v47:dropdown({
							name = "Auto Plant Item",
							flag = "autoplantitem",
							options = {
								"Berry",
								"Oddberry",
								"Cloudberry",
								"Bluefruit",
								"Bloodfruit",
								"Strawberry",
								"Sunfruit",
								"Strangefruit",
								"Petrified Berry",
								"Jelly",
								"Frostfruit",
								"Blossom",
								"Banana",
								"Apple",
								"Lemon",
								"Orange",
								"Mango",
								"Watermelon",
								"Pumpkin",
								"Pumpkins",
								"Prickly Pear",
								"Carrot",
								"Carrots",
								"Corn",
								"Barley",
								"Coconut",
							},
							default = { "Bloodfruit" },
							max = math.huge,
						})
						v47:slider({
							name = "Move Speed",
							flag = "autofarmmovespeed",
							default = 17,
							min = 1,
							max = 17,
							suffix = "studs/s",
							float = 0.1,
						})
						v47:button({
							name = "Set Rest Point",
							tooltip = "The point at which your character will move to if no plants or plant boxes are found",
							callback = function()
								
								vector = character:GetPivot().Position
								writefile("Boo/games/" .. game.PlaceId .. "/restpoints/" .. (library.flags.streamermode and tbl5.oldLPId or localPlayer.UserId) .. "/restpoint.txt", vector.X .. ", " .. vector.Y .. ", " .. vector.Z)
								library:Notify({ text = "Saved Rest Point", time = 3, highlights = { tostring(vector) } })
							end,
						})
					end
					local v47 = v37:tab({ name = "Building" }):section({ name = "Build", show = true })
					v47:toggle({
						name = "Plant Box-Build Walk",
						state = false,
						flag = "plantboxwalk",
						callback = function(arg2, arg3)
							
							task.spawn(function()
								
								while true do
									if library.flags.plantboxwalk then
										if not GameUtil.canCraftItem("Plant Box", nil, true) then
											library:Notify({
												text = "Cannot Build",
												time = 3,
												highlights = { "Check if you have the necessary materials" },
											})
											if library.flags.plantboxwalk then
												arg3:set(false)
											end
											return
										end
										local raycastParams = RaycastParams.new()
										raycastParams.FilterType = Enum.RaycastFilterType.Exclude
										local filterDescendantsInstances = {}
										local v48 = character
										local deployables = v19.Deployables
										filterDescendantsInstances[1] = v48
										filterDescendantsInstances[2] = deployables
										raycastParams.FilterDescendantsInstances = filterDescendantsInstances
										local hit = workspace:Raycast(character:GetPivot().Position, Vector3.new(0, -50, 0), raycastParams)
										if not hit then
											break
										end
										local lookVector = humanoidRootPart.CFrame.LookVector
										if not firepacket("PlaceStructure", {
											buildingName = "Plant Box",
											cframe = library.flags.lockbuilddirection and CFrame.new(hit.Position) or CFrame.lookAt(hit.Position, hit.Position + Vector3.new(lookVector.X, 0, lookVector.Z)),
										}) then
											library:Notify({ text = "Failed to place structure", time = 3 })
											placed = true
										end
										task.wait()
									else
										return
									end
								end
							end)
						end,
					})
					v47:toggle({ name = "Lock Direction", state = true, flag = "lockbuilddirection" })
					local v48
					v48 = v37:tab({ name = "Client" })
					local v49 = v48:section({ name = "Character", show = true })
					v49:toggle({ name = "Enable WalkSpeed", state = false, flag = "enablewalkspeed" })
					v49:slider({
						name = "Walkspeed",
						flag = "walkspeed",
						default = humanoid.WalkSpeed,
						min = 16,
						max = 19,
						float = 0.1,
					})
					v49:slider({
						name = "JumpPower",
						flag = "jumppower",
						default = humanoid.JumpPower,
						min = 50,
						max = 75,
						float = 0.1,
					})
					v49:slider({
						name = "Hip Height",
						flag = "hipheight",
						default = humanoid.HipHeight,
						min = 0.1,
						max = 5,
						float = 0.1,
					})
					v49:slider({
						name = "Max Slope Angle",
						flag = "maxslopeangle",
						default = humanoid.MaxSlopeAngle,
						min = 0,
						max = 89.9,
						float = 0.1,
					})
					v49:toggle({
						name = "No Clip",
						state = false,
						flag = "noclip",
						callback = function(arg2)
							
							if arg2 then
								task.spawn(function()
									
									while library.flags.noclip do
										for _, descendant in pairs(character:GetDescendants()) do
											if descendant:IsA("BasePart") and descendant.CanCollide then
												descendant.CanCollide = false
											end
										end
										task.wait()
									end
								end)
							end
							if not arg2 then
								task.delay(0.1, function()
									
									for _, descendant in pairs(character:GetDescendants()) do
										if descendant:IsA("BasePart") and descendant.CanCollide then
											descendant.CanCollide = true
										end
									end
								end)
							end
						end,
					})
					v49:toggle({
						name = "Infinite Jump",
						state = false,
						flag = "infinitejump",
						callback = function(arg2)
							
							if arg2 then
								tbl5.infiniteJumpConnection = library:connect(v25.JumpRequest, function()local j= library ;if not j.flags.infinitejump then return;end;j=not  humanoid or not  humanoid .Parent;if j then return;end;j= humanoid :GetState()==Enum.HumanoidStateType.Freefall;if j then  humanoid :ChangeState(Enum.HumanoidStateType.Jumping);end;end)
							elseif tbl5.infiniteJumpConnection then
								tbl5.infiniteJumpConnection:Disconnect()
								tbl5.infiniteJumpConnection = nil
							end
						end,
					})
					do
						local v50 = v48:section({ name = "Game", show = true })
						v50:slider({
							name = "Max Zoom",
							flag = "maxzoom",
							default = localPlayer.CameraMaxZoomDistance,
							min = 1,
							max = 10000,
							suffix = "studs",
							float = 1,
						})
						v50:toggle({ name = "No Fog", state = false, flag = "nofog" })
						v50:toggle({
							name = "No Clip Camera",
							state = false,
							flag = "noclipcamera",
							callback = function(arg2)
								
								localPlayer.DevCameraOcclusionMode = arg2 and Enum.DevCameraOcclusionMode.Invisicam or Enum.DevCameraOcclusionMode.Zoom
							end,
						})
						local toggle = v50.toggle
						local tbl11 = { name = "Streamer Mode", state = false, flag = "streamermode" }
						local n = v46 + 3777774028
						
						local function fn12(__lph_capture_array_1000007, __lph_unused_1)
							return function()
								
								
								
								if __lph_capture_array_1000007[1].flags.streamermode then
									__lph_capture_array_1000007[2].PlayerGui.Topbar.Topbar.Left.Coins.Label.Text = "inf (because of boo hub)"
									local topbar2 = __lph_capture_array_1000007[2].PlayerGui.Topbar
									
									topbar2.Topbar.Left.Mojo.Label.Text = "inf"
									__lph_capture_array_1000007[3].Panels.Stats.Bars.Bag.ValueLabel.Text = "inf"
									__lph_capture_array_1000007[4].Topbar.Right.Level.Exp.Text = "inf"
									
									if __lph_capture_array_1000007[3].Panels.Toolbar.Container.Boosts:FindFirstChild("Clan EXP") then
										__lph_capture_array_1000007[3].Panels.Toolbar.Container.Boosts:FindFirstChild("Clan EXP").Visible = false
									else
										local spawn = task.spawn
										local n32 = 520021853
										local function fn13()
											
											repeat
												task.wait()
											until __lph_capture_array_1000007[3].Panels.Toolbar.Container.Boosts:FindFirstChild("Clan EXP")
											local boosts = __lph_capture_array_1000007[3].Panels.Toolbar.Container.Boosts
											local v51 = n32
											local n33
											if v51 % 4294967296 ~= v51 % 4294967296 then
												n33 = 0
											else
												n33 = v51 % 4294967296 - v51 % 4294967296 % 1
											end
											local n34 = bit32.bxor(n33, 0) + 379262343
											if n34 % 4294967296 - n34 % 4294967296 % 1 == 456520894 then
												local v52 = n32
												local n35
												if v52 % 4294967296 ~= v52 % 4294967296 then
													n35 = 0
												else
													n35 = v52 % 4294967296 - v52 % 4294967296 % 1
												end
												n32 = bit32.bxor(n35, 2233634107)
											end
											boosts:FindFirstChild("Clan EXP").Visible = true
										end
										
										n32 = 362879502
										spawn(fn13)
									end
									
									
									
									__lph_capture_array_1000007[2].PlayerGui.MainGui.Panels.Target.HealthBackdrop.Title.Text = "Boo Hub"
									local v51 = __lph_capture_array_1000007[5]
									local v52 = __lph_capture_array_1000007[2]
									
									
									
									
									
									
									
									
									v51.oldLPId = v52.UserId
									__lph_capture_array_1000007[5].oldLPName = __lph_capture_array_1000007[2].Name
									__lph_capture_array_1000007[5].oldLPDisplay = __lph_capture_array_1000007[2].DisplayName
									__lph_capture_array_1000007[2].UserId = 0
									__lph_capture_array_1000007[2].Name = "Boo Hub"
									__lph_capture_array_1000007[2].DisplayName = "Boo Hub"
									
									
									
									for _, child in pairs(__lph_capture_array_1000007[6].Players:GetChildren()) do
										if child.HumanoidRootPart and child.HumanoidRootPart:FindFirstChild("NameGui") then
											child.HumanoidRootPart:FindFirstChild("NameGui").Enabled = false
										end
									end
									local v60, v61, v62 = pairs(__lph_capture_array_1000007[2].PlayerGui.SecondaryGui.PlayerList.List:GetChildren())
									
									for _, v64 in v60, v61, v62 do
										if v64:IsA("ImageButton") then
											__lph_capture_array_1000007[7].oldnames[v64] = v64:FindFirstChild("NameLabel") and v64:FindFirstChild("NameLabel").Text
											local nameLabel = v64:FindFirstChild("NameLabel")
											local flag2 = v64:FindFirstChild("NameLabel").Text ~= __lph_capture_array_1000007[2].Name
											nameLabel.Text = flag2 and "Boo Hub" or "Boo Hub User"
										end
									end
									for _, child in pairs(__lph_capture_array_1000007[2].PlayerGui.Topbar.Topbar.Left:GetChildren()) do
										if child:IsA("Frame") and child:FindFirstChild("Label") then
											local v64 = __lph_capture_array_1000007[1]
											local connect = v64.connect
											local signal = child.Label:GetPropertyChangedSignal("Text")
											local n39 = 443166883
											local function fn13()
												
												local streamermode = __lph_capture_array_1000007[1].flags.streamermode
												local v65 = n39
												local n40
												if v65 % 4294967296 ~= v65 % 4294967296 then
													n40 = 0
												else
													n40 = v65 % 4294967296 - v65 % 4294967296 % 1
												end
												if bit32.bxor(n40, 0) == 201270476 then
													local v66 = n39
													local n41
													if v66 % 4294967296 ~= v66 % 4294967296 then
														n41 = 0
													else
														n41 = v66 % 4294967296 - v66 % 4294967296 % 1
													end
													n39 = bit32.bxor(n41, 3256676109)
												end
												if streamermode then
													child.Label.Text = child.Name == "Coins" and "inf (because of boo hub)" or "inf"
												end
											end
											
											n39 = 397938892
											local v66 = connect(v64, signal, fn13)
											table.insert(__lph_capture_array_1000007[8].spoofconnections, v66)
										end
										
										local n40 = 0
										local n41 = 1
										local exitTo = nil
										for _, v64 in { [{}] = 23, [{}] = 88, [{}] = 18, [{}] = 3, [{}] = 19 }, nil, nil do
											n40 += 1
											if n40 >= 3 then
												exitTo = 1
												break
											else
												n41 += n40 * v64
											end
										end
										if exitTo == 1 then
											n41 = n41 % 113 * 6 + n41 % 659 + 55
										end
										if not (n41 % 0 > 0 or -357 - n41 - 357 ~= 0) then
											continue
										end
										
									end
									
									for _, child in pairs(__lph_capture_array_1000007[3].Panels.Toolbar.List:GetChildren()) do
										if child:IsA("ImageButton") and child:FindFirstChild("Quantity") then
											if __lph_capture_array_1000007[1].flags.streamermode then
												child:FindFirstChild("Quantity").Text = "inf"
											end
										end
									end
									for _, child in pairs(__lph_capture_array_1000007[3].Panels.Toolbar.List:GetChildren()) do
										if child:IsA("ImageButton") and child:FindFirstChild("Quantity") then
											local v64 = __lph_capture_array_1000007[1]
											local connect = v64.connect
											local signal = child:FindFirstChild("Quantity"):GetPropertyChangedSignal("Text")
											
											local n41 = 495071483
											local function fn13()
												
												local flags = __lph_capture_array_1000007[1].flags
												local v65 = n41
												local n42
												if v65 % 4294967296 ~= v65 % 4294967296 then
													n42 = 0
												else
													n42 = v65 % 4294967296 - v65 % 4294967296 % 1
												end
												if bit32.bxor(n42, 0) ~= 93795737 then
													local v66 = n41
													local n43
													if v66 % 4294967296 ~= v66 % 4294967296 then
														n43 = 0
													else
														n43 = v66 % 4294967296 - v66 % 4294967296 % 1
													end
													n41 = bit32.bxor(n43, 3198217447)
												end
												if flags.streamermode then
													child:FindFirstChild("Quantity").Text = "inf"
												end
											end
											
											n41 = 93795737
											local v65 = connect(v64, signal, fn13)
											table.insert(__lph_capture_array_1000007[8].spoofconnections, v65)
										end
									end
									local v64 = __lph_capture_array_1000007[1]:connect(__lph_capture_array_1000007[3].Panels.Target.HealthBackdrop.Title:GetPropertyChangedSignal("Text"), (function(__lph_raw_capture_1,__lph_raw_capture_2,__lph_raw_capture_3) return function()local j= __lph_raw_capture_1 ;local r=j.flags.streamermode;if r then j= __lph_raw_capture_2 ;local r,p=j.Panels.Target.HealthBackdrop.Title;local j= __lph_raw_capture_3 ;if j:FindFirstChild(r.Text)then r.Text="Boo Hub";end;end;end
									end)(__lph_capture_array_1000007[1],__lph_capture_array_1000007[3],__lph_capture_array_1000007[10]))
									table.insert(__lph_capture_array_1000007[8].spoofconnections, v64)
									local v65 = __lph_capture_array_1000007[1]:connect(__lph_capture_array_1000007[6].Players.ChildAdded, (function(__lph_raw_capture_1) return function(j)local p= __lph_raw_capture_1 ;local X=p.flags.streamermode;if X then p=j:FindFirstChild("HumanoidRootPart")and j:FindFirstChild("HumanoidRootPart"):FindFirstChild("NameGui");if p then local p;p,j:FindFirstChild("HumanoidRootPart"):FindFirstChild("NameGui").Enabled= __lph_raw_capture_1 ,not  __lph_raw_capture_1 .flags.streamermode;end;end;end
									end)(__lph_capture_array_1000007[1]))
									table.insert(__lph_capture_array_1000007[8].spoofconnections, v65)
									local v66 = __lph_capture_array_1000007[1]
									local connect = v66.connect
									local signal = __lph_capture_array_1000007[3].Panels.Stats.Bars.Bag.ValueLabel:GetPropertyChangedSignal("Text")
									local v67 = 144648142
									local function fn13()
										
										local v68 = __lph_capture_array_1000007[1]
										local v69 = v67
										local n40
										if v69 % 4294967296 ~= v69 % 4294967296 then
											n40 = 0
										else
											n40 = v69 % 4294967296 - v69 % 4294967296 % 1
										end
										if bit32.bxor(n40, 0) == 430694302 then
											local v70 = v67
											local n41
											if v70 % 4294967296 ~= v70 % 4294967296 then
												n41 = 0
											else
												n41 = v70 % 4294967296 - v70 % 4294967296 % 1
											end
											v67 = bit32.bxor(n41, 1415112163)
										end
										if v68.flags.streamermode then
											__lph_capture_array_1000007[3].Panels.Stats.Bars.Bag.ValueLabel.Text = "inf"
										end
									end
									
									v67 = 198994727
									local v68 = connect(v66, signal, fn13)
									local insert = table.insert
									local v69 = __lph_capture_array_1000007[8]
									
									
									
									
									
									
									insert(v69.spoofconnections, v68)
									local v76 = __lph_capture_array_1000007[1]:connect(__lph_capture_array_1000007[4].Topbar.Right.Level.Exp:GetPropertyChangedSignal("Text"), function()
										
										if __lph_capture_array_1000007[1].flags.streamermode then
											__lph_capture_array_1000007[4].Topbar.Right.Level.Exp.Text = "inf"
										end
									end)
									table.insert(__lph_capture_array_1000007[8].spoofconnections, v76)
								else
									if __lph_capture_array_1000007[5].oldLPId and __lph_capture_array_1000007[5].oldLPName and __lph_capture_array_1000007[5].oldLPDisplay then
										__lph_capture_array_1000007[2].UserId = __lph_capture_array_1000007[5].oldLPId
										
										__lph_capture_array_1000007[2].Name = __lph_capture_array_1000007[5].oldLPName
										__lph_capture_array_1000007[2].DisplayName = __lph_capture_array_1000007[5].oldLPDisplay
										
										
									end
									local v51 = pairs
									local v52 = __lph_capture_array_1000007[6]
									
									
									for _, child in v51(v52.Players:GetChildren()) do
										if child.HumanoidRootPart and child.HumanoidRootPart:FindFirstChild("NameGui") then
											child.HumanoidRootPart:FindFirstChild("NameGui").Enabled = true
										end
									end
									if __lph_capture_array_1000007[3].Panels.Toolbar.Container.Boosts:FindFirstChild("Clan EXP") then
										__lph_capture_array_1000007[3].Panels.Toolbar.Container.Boosts:FindFirstChild("Clan EXP").Visible = true
									else
										local function fn13()
											
											repeat
												task.wait()
											until __lph_capture_array_1000007[3].Panels.Toolbar.Container.Boosts:FindFirstChild("Clan EXP")
											__lph_capture_array_1000007[3].Panels.Toolbar.Container.Boosts:FindFirstChild("Clan EXP").Visible = true
										end
										task.spawn(fn13)
									end
									for _, spoofconnection in pairs(__lph_capture_array_1000007[8].spoofconnections) do
										__lph_capture_array_1000007[1]:disconnect(spoofconnection)
									end
									table.clear(__lph_capture_array_1000007[8].spoofconnections)
									updateStats()
									local v55 = ipairs
									local panels = __lph_capture_array_1000007[3].Panels
									
									for _, child in v55(panels.Toolbar.List:GetChildren()) do
										if child:IsA("ImageButton") and child:FindFirstChild("Quantity") then
											local num = tonumber(child.Name)
											num = num and __lph_capture_array_1000007[11].Data.toolbar[num]
											if num then
												child.Quantity.Text = tostring(num.quantity or 0)
											else
												child.Quantity.Text = ""
											end
										end
									end
									__lph_capture_array_1000007[3].Panels.Stats.Bars.Bag.ValueLabel.Text = string.format("%0.1f", __lph_capture_array_1000007[12].playerCacheLoad)
									
									
									for _, child in pairs(__lph_capture_array_1000007[2].PlayerGui.SecondaryGui.PlayerList.List:GetChildren()) do
										if child:IsA("ImageButton") then
											if __lph_capture_array_1000007[7].oldnames[child] and child:FindFirstChild("NameLabel") then
												child:FindFirstChild("NameLabel").Text = __lph_capture_array_1000007[7].oldnames[child]
											end
										end
									end
									table.clear(__lph_capture_array_1000007[7].oldnames)
									
								end
							end
						end
						tbl11.callback = fn12(table.pack(library, localPlayer, mainGui, topbar, tbl5, v19, tbl7, tbl8, nil, v18, GameUtil, functions))
						toggle(v50, tbl11)
						local toggle2 = v50.toggle
						local tbl12 = { name = "Freecam", state = false, flag = "freecam" }
						bit32.bxor(v35 % 4294967296 - v35 % 4294967296 % 1, 657212028)
						
						local function fn13(__lph_capture_array_1000018, __lph_unused_1)
							return function(arg2)
								
								
								if arg2 then
									if not __lph_capture_array_1000018[1][5][__lph_capture_array_1000018[1][4]] or not __lph_capture_array_1000018[1][5][__lph_capture_array_1000018[1][4]].Parent then
										return
									end
									if not __lph_capture_array_1000018[2][5][__lph_capture_array_1000018[2][4]] or not __lph_capture_array_1000018[3][5][__lph_capture_array_1000018[3][4]] then
										return
									end
									
									
									__lph_capture_array_1000018[4].freecamCFrame = __lph_capture_array_1000018[5].CurrentCamera.CFrame
									local v51, v52 = __lph_capture_array_1000018[4].freecamCFrame:ToOrientation()
									__lph_capture_array_1000018[4].freecamvars.freecamPitch = v51
									__lph_capture_array_1000018[4].freecamvars.freecamYaw = v52
									local currentCamera2 = __lph_capture_array_1000018[5].CurrentCamera
									
									local scriptable = Enum.CameraType.Scriptable
									
									currentCamera2.CameraType = scriptable
									if __lph_capture_array_1000018[6].TouchEnabled then
										MobileFreecamLeft.Visible = true
										local v53 = (function(__lph_raw_capture_1) return function(j,p)if j.UserInputType~=Enum.UserInputType.MouseButton1 and j.UserInputType~=Enum.UserInputType.Touch then return;end;local p,X,Y=MobileFreecamLeft.AbsolutePosition,MobileFreecamLeft.AbsoluteSize;j= __lph_raw_capture_1 ;j.freecamMoveCenter=Vector2.new(p.X+X.X/2,p.Y+X.Y/2);j= __lph_raw_capture_1 ;j.freecamdir=Vector3.new(0.0,0.0,0.0);mouseHoldingJoystick=true;end
										end)(__lph_capture_array_1000018[4])
										local v54 = __lph_capture_array_1000018[7]:connect(MobileFreecamLeft.InputBegan, v53)
										table.insert(__lph_capture_array_1000018[8].freecamconnections, v54)
										local v55 = __lph_capture_array_1000018[7]:connect(MobileFreecamLeft.InputChanged, (function(__lph_raw_capture_1,__lph_raw_capture_2,__lph_raw_capture_3) return function(j,Y)if j.UserInputType~=Enum.UserInputType.MouseMovement and j.UserInputType~=Enum.UserInputType.Touch then return;end;local Y,V,e=not mouseHoldingJoystick;if Y then V=Y;else local e= __lph_raw_capture_1 ;V=not e.freecamMoveCenter;end;if V then return;end;V,Y=j.UserInputType==Enum.UserInputType.Touch and Vector2.new(j.Position.X,j.Position.Y);if V then Y=V;else local e,P,P= __lph_raw_capture_2 ;P,Y= __lph_raw_capture_3 ,e:GetMouseLocation()- __lph_raw_capture_3 :GetGuiInset();end;j= __lph_raw_capture_1 ;V=Y-j.freecamMoveCenter;Y=math.min(V.Magnitude,60);local j,p=Y>0 and V.Unit or Vector2.new(0,0), __lph_raw_capture_1 ;p.freecamdir=Vector3.new(j.X,0,j.Y);MobileFreecamLeftStick.Position=UDim2.new(0.5,j.X*Y,0.5,j.Y*Y);end
										end)(__lph_capture_array_1000018[4],__lph_capture_array_1000018[6],__lph_capture_array_1000018[9]))
										table.insert(__lph_capture_array_1000018[8].freecamconnections, v55)
										local v56 = __lph_capture_array_1000018[7]:connect(MobileFreecamLeft.InputEnded, (function(__lph_raw_capture_1) return function(j,p)if j.UserInputType~=Enum.UserInputType.MouseButton1 and j.UserInputType~=Enum.UserInputType.Touch then return;end;mouseHoldingJoystick=false;j= __lph_raw_capture_1 ;j.freecamdir=Vector3.new(0.0,0.0,0.0);j= __lph_raw_capture_1 ;j.freecamMoveCenter=nil;MobileFreecamLeftStick.Position=UDim2.new(0.5,0,0.5,0);end
										end)(__lph_capture_array_1000018[4]))
										table.insert(__lph_capture_array_1000018[8].freecamconnections, v56)
									end
								else
									__lph_capture_array_1000018[6].MouseBehavior = Enum.MouseBehavior.Default
									__lph_capture_array_1000018[5].CurrentCamera.CameraType = Enum.CameraType.Custom
									__lph_capture_array_1000018[10].freecamMoveFromJoystick = false
									__lph_capture_array_1000018[4].freecamdir = Vector3.zero
									__lph_capture_array_1000018[4].freecamMoveCenter = nil
									local v51 = __lph_capture_array_1000018[4]
									
									v51.freecamlook = nil
									__lph_capture_array_1000018[10].freecamLookFromJoystick = false
									__lph_capture_array_1000018[4].lastfreecampos = nil
									
									if __lph_capture_array_1000018[6].TouchEnabled then
										MobileFreecamLeft.Visible = false
										for _, freecamconnection in pairs(__lph_capture_array_1000018[8].freecamconnections) do
											if freecamconnection then
												__lph_capture_array_1000018[7]:disconnect(freecamconnection)
											end
										end
										table.clear(__lph_capture_array_1000018[8].freecamconnections)
									end
									table.clear(__lph_capture_array_1000018[11].freecamKeys)
									__lph_capture_array_1000018[11].freecamKeys.W = false
									__lph_capture_array_1000018[11].freecamKeys.A = false
									__lph_capture_array_1000018[11].freecamKeys.S = false
									__lph_capture_array_1000018[11].freecamKeys.D = false
									__lph_capture_array_1000018[11].freecamKeys.Q = false
									__lph_capture_array_1000018[11].freecamKeys.E = false
									__lph_capture_array_1000018[11].freecamKeys.Shift = false
									
								end
							end
						end
						tbl12.callback = fn13(table.pack(__boohub_scalar_capture_cell(function() return  character  end, function(__value)  character =__value end), __boohub_scalar_capture_cell(function() return  humanoid  end, function(__value)  humanoid =__value end), __boohub_scalar_capture_cell(function() return  humanoidRootPart  end, function(__value)  humanoidRootPart =__value end), tbl5, v19, v25, library, tbl8, v23, tbl6, tbl7))
						toggle2(v50, tbl12)
						v50:slider({
							name = "Freecam Sensitivity",
							flag = "freecamsensitivity",
							default = 3,
							min = 1,
							max = 25,
							float = 0.1,
						})
						v50:slider({
							name = "Freecam Speed",
							flag = "freecamspeed",
							default = 250,
							min = 50,
							max = 1000,
							float = 1,
						})
					end
					local v50 = v48:section({ name = "Optimization" })
					v50:toggle({
						name = "No Shadows",
						state = false,
						flag = "noshadows",
						callback = function(arg2)
							
							v24.GlobalShadows = not arg2
						end,
					})
					v50:toggle({
						name = "Disable Rendering",
						state = false,
						flag = "disablerendering",
						callback = function(arg2)
							
							v16:Set3dRenderingEnabled(not arg2)
						end,
					})
					local v51, v52
					do
						local v53 = v37:tab({ name = "Visuals" }):section({ name = "Player Visuals", show = true })
						v53:toggle({
							name = "Enable Players",
							state = false,
							flag = "enableesp",
							callback = function(arg2)
								
								tbl2:SetEnabled(arg2)
							end,
						})
						v53:toggle({
							name = "Box",
							state = false,
							flag = "enableespbox",
							callback = function(enabled)
								
								tbl2.settings.box.enabled = enabled
							end,
						}):colorpicker({
							flag = "espboxcolorpicker",
							color = Color3.new(1, 1, 1),
							alpha = 0,
							callback = function(color, arg2)
								
								tbl2.settings.box.color = color
								tbl2.settings.box.transparency = 1 - arg2
							end,
						})
						v53:toggle({
							name = "Name",
							state = false,
							flag = "enableespname",
							callback = function(nameEnabled)
								
								tbl2.settings.text.nameEnabled = nameEnabled
							end,
						}):colorpicker({
							flag = "espnamecolorpicker",
							color = Color3.new(1, 1, 1),
							callback = function(color)
								
								tbl2.settings.text.color = color
							end,
						})
						v53:toggle({
							name = "Distance",
							state = false,
							flag = "enableespdistance",
							callback = function(distanceEnabled)
								
								tbl2.settings.text.distanceEnabled = distanceEnabled
							end,
						})
						v53:toggle({
							name = "Health Bar",
							state = false,
							flag = "enableesphealthbar",
							callback = function(enabled)
								
								tbl2.settings.healthbar.enabled = enabled
							end,
						}):colorpicker({
							flag = "espbarcolorpicker",
							color = Color3.new(0, 0, 0),
							callback = function(color)
								
								tbl2.settings.healthbar.background.color = color
							end,
						})
						local function fn12(color)
							
							tbl2.settings.healthtext.color = color
						end
						v53:toggle({
							name = "Health Text",
							state = false,
							flag = "enableesphealthtext",
							callback = function(enabled)
								
								tbl2.settings.healthtext.enabled = enabled
							end,
						}):colorpicker({
							flag = "esphealthtextcolorpicker",
							color = Color3.new(1, 1, 1),
							callback = fn12,
						})
						local v54 = v53:toggle({
							name = "Highlight",
							state = false,
							flag = "enableesphighlight",
							callback = function(enabled)
								
								tbl2.settings.highlight.enabled = enabled
								if not enabled then
									for _, v54 in pairs(tbl3) do
										if v54 and v54.hide then
											v54.hide()
										end
									end
								end
							end,
						})
						v51 = bit32.bxor(v35 % 4294967296 - v35 % 4294967296 % 1, 777427014)
						v54:colorpicker({
							flag = "esphighlightcolorpickerfill",
							color = Color3.new(1, 1, 1),
							alpha = 0.5,
							callback = function(fillColor, fillTransparency)
								
								tbl2.settings.highlight.fillColor = fillColor
								tbl2.settings.highlight.fillTransparency = fillTransparency
							end,
						})
						local function fn13(outlineColor, outlineTransparency)
							
							
							tbl2.settings.highlight.outlineColor = outlineColor
							
							local n28 = 0
							local n29 = 1
							local exitTo = nil
							for _, v55 in { [{}] = 43, [{}] = 75, [{}] = 4, [{}] = 34 }, nil, nil do
								n28 += 1
								if n28 >= 3 then
									exitTo = 1
									break
								else
									n29 += n28 * v55
								end
							end
							if exitTo == 1 then
								n29 = n29 % 113 * 6 + n29 % 659 + 55
							end
							if 1608 == n29 + 804 + n29 + 804 then
								tbl2.settings.highlight.outlineTransparency = outlineTransparency
								return
							end
							
						end
						v54:colorpicker({
							flag = "esphighlightcolorpickeroutline",
							color = Color3.new(0, 0, 0),
							alpha = 0,
							callback = fn13,
						})
						v53:toggle({
							name = "God Indicator",
							state = false,
							flag = "enableespgodindicator",
							callback = function(godindicator)
								
								tbl2.settings.text.godindicator = godindicator
							end,
						})
						v53:toggle({
							name = "Text Outlines",
							state = false,
							flag = "enableesptextoutlines",
							callback = function(outline)
								
								tbl2.settings.text.outline = outline
								tbl2.settings.itemtext.outline = outline
								tbl2.settings.healthtext.outline = outline
							end,
						}):colorpicker({
							flag = "esptextoutlinecolorpicker",
							color = Color3.new(0, 0, 0),
							callback = function(outlineColor)
								
								tbl2.settings.text.outlineColor = outlineColor
								tbl2.settings.itemtext.outlineColor = outlineColor
								tbl2.settings.healthtext.outlineColor = outlineColor
							end,
						})
						v53:toggle({
							name = "Tribe Colors",
							state = false,
							tooltip = "Changes box and text colors based off of a player's tribe",
							flag = "esptribecolors",
						})
						local function fn14(size)
							
							tbl2.settings.text.size = size
							tbl2.settings.itemtext.size = size
							tbl2.settings.healthtext.size = size
						end
						v53:slider({
							name = "Text Size",
							flag = "esptextsize",
							default = 16,
							min = 5,
							max = 25,
							float = 1,
							callback = fn14,
						})
						v52 = bit32.band(n24, v46)
						v53:slider({
							name = "Esp Fps",
							flag = "espfps",
							default = 144,
							min = 1,
							max = 240,
							float = 1,
						})
						local function fn15(maxDistance)
							
							tbl2.settings.maxDistance = maxDistance
						end
						v53:slider({
							name = "Max Distance",
							flag = "espmaxdistance",
							default = 1000,
							min = 10,
							max = 10000,
							float = 1,
							callback = fn15,
						})
					end
					local v53, n27
					do
						local v54 = v37:tab({ name = "Automation" })
						local v55 = nil
						local v56 = nil
						local v57 = v54:section({ name = "Auto Coin Press", show = true })
						v57:toggle({
							name = "Enable Auto Coin Press",
							state = false,
							flag = "autocoinpress",
							callback = function(r,D)local L= tbl6 ;if L.coinpressing then return;end;if not r then return;end;r,L= library ,tonumber( library .flags.autocoinpressamount);if L<0 then return;end; v55 :set("Gold used: 0"); v56 :set("Coins pressed: 0");L= tbl6 ;L.coinpressing=true;local r,A=ipairs;L= v19 ;local e,A,c= table.pack (L.Deployables:GetChildren()),20;for s,M in r( unpackCapturedArguments ( nil, e))do s=M.Name=="Coin Press";if s then L=(M:GetPivot().Position- humanoidRootPart .Position).Magnitude;if L<A then A,c=L,M;else end;else end;end;e=not c;if e then r= library ;r:Notify({text="No Coin Press Found",time=3});L= tbl6 ;L.coinpressing=false;local j= library ;if j.flags.autocoinpress then D:set(false);end;return;end;L= tbl7 ;local j,P,P=L.inventory.Gold;if j then e= GameUtil ;P=e.Data.inventory[j];else P=j;end;r=not P or not P.quantity;if r then e= tbl6 ;e.coinpressing=false;L= library ;if L.flags.autocoinpress then D:set(false);end;return;end;e=P.quantity;r,L= library ,math.max(e-tonumber( library .flags.autocoinpressamount),0);while true do  local r= library ;if not r.flags.autocoinpress then break;end;r= tbl7 ;j=r.inventory.Gold;if j then r= GameUtil ;P=r.Data.inventory[j];else P=j;end;if not P or not P.quantity then break;end;if P.quantity<=L then break;end;local A,s=P.quantity;local s,M,k=firepacket,{entityID=c:GetAttribute("EntityID")}, ItemIDS ;M.itemID= ItemIDS .Gold;s("InteractStructure",M);task.wait( library .flags.autocoinpressdelay);s= tbl7 ;j=s.inventory.Gold;if j then s= GameUtil ;P=s.Data.inventory[j];else P=j;end;M=P and P.quantity;if M then s=e-P.quantity;r=s*5; v55 :set("Gold used: "..tostring(s)); v56 :set("Coins pressed: "..tostring(r));if P.quantity>=A then task.wait();end;end;s= library ;if not s.flags.autocoinpress or not P or not P.quantity or P.quantity<=L then break;end;end;local r= tbl6 ;r.coinpressing=false;r= library ;local p=r.flags.autocoinpress;if p then r= tbl7 ;j=r.inventory.Gold;if j then local r= GameUtil ;P=r.Data.inventory[j];else P=j;end;local j=(e-(P and P.quantity or L))*5;local r=j>0;if r then local r= library ;r:Notify({text="Finished Coin Pressing",time=3,highlights={"Coins Pressed: "..tostring(j)}});end;D:set(false);end;end,
						})
						v57:textbox({ name = "Amount", flag = "autocoinpressamount", default = "10" })
						v57:slider({
							name = "Delay",
							flag = "autocoinpressdelay",
							default = 0.05,
							min = 0,
							max = 10,
							float = 0.01,
						})
						v55 = v57:label({ name = "Gold used: 0" })
						v56 = v57:label({ name = "Coins pressed: 0" })
						local v58 = v54:section({ name = "Auto Campfire" })
						v58:toggle({
							name = "Enable Auto Campfire",
							state = false,
							flag = "autocampfire",
							callback = function()
								
								task.spawn(function()
									
									while library.flags.autocampfire do
										if library.flags.autocampfire and tick() - tbl9.lastcampfirecheck >= 1 then
											tbl9.lastcampfirecheck = tick()
											task.spawn(function()
												
												for _, child in ipairs(v19.Deployables:GetChildren()) do
													if child.Name == "Campfire" then
														if not (library.flags.autocampfirerange < (child:GetPivot().Position - humanoidRootPart.Position).Magnitude) then
															if not (tonumber(child.Board.Billboard.Backdrop.TextLabel.Text) >= library.flags.autocampfirethreshold) then
																local autocampfireitem = library.flags.autocampfireitem
																local tbl11 = {}
																if type(autocampfireitem) == "string" then
																	if ItemIDS[autocampfireitem] and tbl7.inventory[autocampfireitem] then
																		table.insert(tbl11, autocampfireitem)
																	end
																elseif type(autocampfireitem) == "table" then
																	for _, v59 in ipairs(autocampfireitem) do
																		if ItemIDS[v59] and tbl7.inventory[v59] then
																			table.insert(tbl11, v59)
																		end
																	end
																end
																if #tbl11 > 0 then
																	while true do
																		tbl5.autocampfireIndex = (tbl5.autocampfireIndex or 0) + 1
																		if #tbl11 < tbl5.autocampfireIndex then
																			tbl5.autocampfireIndex = 1
																		end
																		local v59 = tbl11[tbl5.autocampfireIndex]
																		firepacket("InteractStructure", { entityID = child:GetAttribute("EntityID"), itemID = ItemIDS[v59] })
																		task.wait(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000)
																		if not (not library.flags.autocampfire or tonumber(child.Board.Billboard.Backdrop.TextLabel.Text) >= library.flags.autocampfirethreshold or not child.Parent) then
																			continue
																		end
																		break
																	end
																end
															end
														end
													end
												end
											end)
										end
										task.wait()
									end
								end)
							end,
						})
						v58:slider({
							name = "Range",
							flag = "autocampfirerange",
							default = 10,
							min = 1,
							max = 30,
							suffix = "studs",
							float = 1,
						})
						v58:dropdown({
							name = "Item",
							flag = "autocampfireitem",
							options = { "Leaves", "Wood", "Log", "Coal" },
							default = { "Leaves" },
							max = math.huge,
						})
						v58:slider({
							name = "Threshold",
							flag = "autocampfirethreshold",
							default = 200,
							min = 50,
							max = 250,
							float = 1,
						})
						local v59 = v54:section({ name = "Auto Craft" })
						v59:toggle({
							name = "Enable Auto Craft",
							state = false,
							flag = "autocraft",
							tooltip = "Crafts the amount chosen, starting from your current inventory count",
							callback = function(j,V)local e= tbl6 ;if e.crafting then return;end;e= library ;local P,b,b=e.flags.autocraftuseamount;if P then if not j then return;end;local j,j= library ,tonumber( library .flags.autocraftamount);if not j or j<=0 then return;end;e= library ;local P,b=e.flags.autocraftobject, ItemIDS ;local e=not b[P];if e then b= library ;b:Notify({text="Invalid Item",time=3});return;end;b= tbl6 ;b.crafting=true;e=getinventoryquantity(P);b=not e;if b then local i= tbl6 ;i.crafting=false;i= library ;if i.flags.autocraft then V:set(false);end;return;end;local i,O=e+j,e;while O<i do b= GameUtil ;local i,D=not b.canCraftItem(P,nil,true),O;if i then j= library ;local L=j.flags.autocraftdelay>0;if L then task.wait( library .flags.autocraftdelay);else task.wait();end;O=getinventoryquantity(P)or 0;continue;end;i= library ;local L=not i.flags.autocraft;if L then i= tbl6 ;i.crafting=false;return;end;firepacket("CraftItem", ItemIDS [P]);i= library ;L=i.flags.autocraftdelay>0;if L then task.wait( library .flags.autocraftdelay);end;i=tick();O=D;while true do  O=getinventoryquantity(P)or 0;task.wait();L= library ;if not L.flags.autocraft or O~=D or tick()-i>=3 then break;end;end;end;b= library ;j=b.flags.autocraft;if j then b= library ;b:Notify({text="Finished crafting",time=5,highlights={P.." x"..math.max(O-e,0)}});end;O= tbl6 ;O.crafting=false;e= library ;if e.flags.autocraft then V:set(false);end;else task.spawn(function()while true do  local j= library ;if not j.flags.autocraft then break;end;j= library ;local r,e=j.flags.autocraftobject, ItemIDS ;j=not e[r];if j then e= library ;if e.flags.autocraft then V:set(false);end;local V= library ;V:Notify({text="Invalid Item",time=3});end;j= GameUtil ;e=j.canCraftItem(r,nil,true);if e then firepacket("CraftItem", ItemIDS [r]);end;e= library ;j=e.flags.autocraftdelay>0;if j then task.wait( library .flags.autocraftdelay);end;end;end);end;end,
						})
						local v60 = v59:toggle({
							name = "Use Amount",
							state = false,
							flag = "autocraftuseamount",
							tooltip = "Crafts the amount chosen, starting from your current inventory count",
							callback = function(arg2, arg3)
								
								arg3:toggleaddons(arg2)
							end,
						})
						v59:textbox({ name = "Object", flag = "autocraftobject", default = "None" })
						v53 = bit32.bxor(v51, v52 % 4294967296 - v52 % 4294967296 % 1)
						v60:textbox({ name = "Amount", flag = "autocraftamount", default = "0" })
						v59:slider({
							name = "Delay",
							flag = "autocraftdelay",
							default = 0.05,
							min = 0.01,
							max = 10,
							float = 0.01,
						})
						local v61 = v54:section({ name = "Auto Spawn" })
						v61:toggle({
							name = "Enable Auto Spawn",
							tooltip = "This only works if nothing is blocking the spawn buttons",
							state = false,
							flag = "autospawn",
							callback = function()
								
								if library.flags.autospawn and not localPlayer:GetAttribute("hasSpawned") and not tbl6.autospawning then
									tbl6.autospawning = true
									task.spawn(function()
										
										
										
										local str, playerGui
										repeat
											task.wait()
											playerGui = localPlayer.PlayerGui
											str = "SpawnGui"
										until playerGui:FindFirstChild(str)
										local v62
										while true do
											v62 = library
											if not v62 then
											end
											local n29
											if str % 4294967296 ~= str % 4294967296 then
												n29 = 0
											else
												n29 = str % 4294967296 - str % 4294967296 % 1
											end
											str = n29 == 344985763
											if str then
												continue
											end
											break
										end
										if v62.flags.autospawnbed then
											while true do
												task.wait(1)
												if localPlayer:GetAttribute("hasSpawned") or not library.flags.autospawn or not library.flags.autospawnbed then
													tbl6.autospawning = false
													return
												end
												if not (120 - math.floor(Clock.getServerTime()) - GameUtil.Data.lastSpawnFromBed <= 0) then
													continue
												end
												break
											end
											while true do
												task.wait(1)
												local spawnGui = localPlayer.PlayerGui:FindFirstChild("SpawnGui")
												spawnGui = spawnGui and spawnGui:FindFirstChild("Customization")
												local bedButton = spawnGui and spawnGui:FindFirstChild("BedButton")
												if bedButton then
													local n29 = bedButton.AbsolutePosition.X + bedButton.AbsoluteSize.X / 2
													local n30 = bedButton.AbsolutePosition.Y + bedButton.AbsoluteSize.Y / 2
													v26:SendMouseMoveEvent(n29, n30, game)
													task.wait(0.05)
													v26:SendMouseButtonEvent(n29, n30, 0, true, game, 0)
													task.wait(0.05)
													v26:SendMouseButtonEvent(n29, n30, 0, false, game, 0)
												end
												if not (localPlayer:GetAttribute("hasSpawned") or not library.flags.autospawn or not library.flags.autospawnbed) then
													continue
												end
												break
											end
										else
											while true do
												task.wait(1)
												local spawnGui = localPlayer.PlayerGui:FindFirstChild("SpawnGui")
												spawnGui = spawnGui and spawnGui:FindFirstChild("Customization")
												spawnGui = spawnGui and spawnGui:FindFirstChild("PlayButton")
												if spawnGui then
													local n29 = spawnGui.AbsolutePosition.X + spawnGui.AbsoluteSize.X / 2
													local n30 = spawnGui.AbsolutePosition.Y + spawnGui.AbsoluteSize.Y / 2
													v26:SendMouseMoveEvent(n29, n30, game)
													task.wait(0.05)
													v26:SendMouseButtonEvent(n29, n30, 0, true, game, 0)
													task.wait(0.05)
													v26:SendMouseButtonEvent(n29, n30, 0, false, game, 0)
												end
												if not (localPlayer:GetAttribute("hasSpawned") or not library.flags.autospawn or library.flags.autospawnbed) then
													continue
												end
												break
											end
										end
										
										task.wait(1)
										tbl6.autospawning = false
									end)
								end
							end,
						})
						v61:toggle({ name = "Spawn Bed", state = false, flag = "autospawnbed" })
						v54:section({ name = "Auto Rebirth" }):toggle({
							name = "Enable Auto Rebirth",
							state = false,
							flag = "autorebirth",
							callback = function(arg2)
								
								if not arg2 then
									return
								end
								if tbl6.autorebirthloop then
									return
								end
								tbl6.autorebirthloop = true
								task.spawn(function()
  while library.flags.autorebirth and getgenv().library==library do
   if not tbl6.rebirthing and tick()-tbl9.lastrebirthcheck>=1 then
    tbl9.lastrebirthcheck=tick()
    if GameUtil.Data.level==100 then firepacket('Rebirth')end
   end
   task.wait(1)
  end
  tbl6.rebirthing=false
  tbl6.autorebirthloop=false
 end)
							end,
						})
						local v62 = v54:section({ name = "Auto Dig" })
						v62:toggle({
							name = "Enable Auto Dig",
							state = false,
							flag = "autodig",
							callback = function(r)task.spawn(function()while true do  local r= library ;if not r.flags.autodig then break;end;local b,i= humanoidRootPart .Position+ humanoidRootPart .CFrame.LookVector*5+Vector3.new(0,3,0),Vector3.new(0,-8,0);local O,D={ character };r= v19 ;local D=r:FindFirstChild("Resources");if D then r=D:GetChildren();local L=#r;for A=1,L,1 do local L=r[A];A=L and L.Parent and L.Name=="Sand Mound";if A then local A=(L:GetPivot().Position- humanoidRootPart .Position).Magnitude<=10;if A then table.insert(O,L);local L=#O>=25;if L then local L= GameUtil ;local A,A= library ,L.Data.toolbar[tonumber( library .flags.autodigslot)];if A then while true do  L= character .Tools:FindFirstChildOfClass("Model");if L and L.Name==A.name then break;end;firepacket("EquipTool",tonumber( library .flags.autodigslot));task.wait(0.5);local c= library ;local s=not c.flags.autodig or  character .Tools:FindFirstChildOfClass("Model")and  character .Tools:FindFirstChildOfClass("Model").Name==A.name;if s then break;end;end;local c= tool ;c.swingTool();end;A,L=ipairs, v19 ;local V,P,c= table.pack (L.Players:GetChildren()),10;for s,M in A( unpackCapturedArguments ( nil, V))do s=M~= character ;if s then local j,s=M:FindFirstChild("HumanoidRootPart"),M:FindFirstChildOfClass("Humanoid");L=j and j.Parent and s and s.Parent and s.Health>0;if L then s=(j.Position- humanoidRootPart .Position).Magnitude;if s<=P then P,c=s,M;else end;else end;else end;end;if c then repeat task.wait(0.1);until not c or not c.Parent;end;L,V=pairs, GameUtil ;A=V.Data.toolbar;for j,X in L(A)do V=X.name=="Shovel";if V then while true do  local V= character .Tools:FindFirstChildOfClass("Model");if V and V.Name==X.name then break;end;firepacket("EquipTool",j);task.wait(0.5);V= library ;local j=not V.flags.autodig or  character .Tools:FindFirstChildOfClass("Model")and  character .Tools:FindFirstChildOfClass("Model").Name==X.name;if j then break;end;end;break;end;end;end;end;end;end;end;r= character .Tools:FindFirstChildOfClass("Model");if r and r.Name=="Shovel"then D=RaycastParams.new();D.FilterType=Enum.RaycastFilterType.Exclude;D.FilterDescendantsInstances=O;D.IgnoreWater=true;local j=workspace:Raycast(b,i,D);if j then local r=j.Instance:FindFirstAncestorWhichIsA("Model");if r and r.Name=="_MOUND"then local p=r:GetAttribute("EntityID");if p then firepacket("Dig",{point=j.Position,mound=p});end;elseif j.Instance==workspace.Terrain and j.Material==Enum.Material.Sand then firepacket("Dig",{point=j.Position});end;end;end;task.wait(0.1);end;end);end,
						})
						v62:slider({
							name = "Break slot",
							flag = "autodigslot",
							default = 1,
							min = 1,
							max = 6,
							tooltip = "The slot that will be equipped to break the sand",
							float = 1,
						})
						v54:section({ name = "Achievements" }):toggle({
							name = "Enable Auto Reset",
							state = false,
							flag = "autobuyincreasestoragemojo",
							callback = function()
								
								task.spawn(function()
									
									while library.flags.autobuyincreasestoragemojo do
										if character and character.Parent and humanoid and humanoid.Health > 0 then
											character:BreakJoints()
										end
										task.wait()
									end
								end)
							end,
						})
						local v63 = v54:section({ name = "Auto Potions" })
						local n = v52 - v46
						n27 = n % 4294967296 - n % 4294967296 % 1
						local toggle = v63.toggle
						local tbl11 = { name = "Start Auto Potions", state = false, flag = "autopotions" }
						bit32.bxor(n27, 3906119140)
						
						local function fn12(__lph_capture_array_1000011, __lph_unused_1)
							return function(arg2, arg3)
								if not arg2 then
									return
								end
								if __lph_capture_array_1000011[1].autopotioning then
									return
								end
								task.spawn(function()
									
									while __lph_capture_array_1000011[2].flags.autopotions do
										if __lph_capture_array_1000011[2].flags.autopotions then
											__lph_capture_array_1000011[1].autopotioning = true
											local tbl12 = {}
											for _, child in pairs(__lph_capture_array_1000011[3].Deployables:GetChildren()) do
												if child.Name == "Cauldron" and (child:GetPivot().Position - __lph_capture_array_1000011[4][5][__lph_capture_array_1000011[4][4]]:GetPivot().Position).Magnitude <= 25 then
													table.insert(tbl12, child)
												end
											end
											for _, v64 in pairs(tbl12) do
												if v64.Name == "Cauldron" then
													local position = v64:FindFirstChild("Hitbox").Position
													if not __lph_capture_array_1000011[2].flags.autopotions then
														__lph_capture_array_1000011[1].autopotioning = false
														arg3:set(false)
														task.wait(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000)
														v64.Hitbox.Position = position
														break
													else
														v64.Hitbox.CFrame = __lph_capture_array_1000011[5][5][__lph_capture_array_1000011[5][4]].CFrame * CFrame.new(0, 2, -6)
														for i = 1, 3 do
															slot = __lph_capture_array_1000011[6].inventory["Ice Cube"]
															item = __lph_capture_array_1000011[7].Data.inventory[slot]
															if not item.quantity or item.quantity <= 0 then
																__lph_capture_array_1000011[2]:Notify({ text = "Insufficient Ice Cubes", time = 3 })
																__lph_capture_array_1000011[1].autopotioning = false
																arg3:set(false)
																task.wait(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000)
																v64.Hitbox.Position = position
																break
															else
																firepacket("DropBagItem", slot)
																task.wait(task.wait(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000))
															end
														end
														task.wait(task.wait(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000))
														v64.Hitbox.Position = position
													end
												end
											end
											for _, v64 in pairs(tbl12) do
												if v64.Name ~= "Cauldron" then
													continue
												elseif __lph_capture_array_1000011[2].flags.autopotions then
													local position = v64:FindFirstChild("Hitbox").Position
													v64.Hitbox.CFrame = __lph_capture_array_1000011[5][5][__lph_capture_array_1000011[5][4]].CFrame * CFrame.new(0, 2, -6)
													while true do
														task.wait(task.wait(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000))
														if not (not __lph_capture_array_1000011[2].flags.autopotions or #v64.base:GetChildren() == 0) then
															continue
														end
														break
													end
													if not __lph_capture_array_1000011[2].flags.autopotions then
														__lph_capture_array_1000011[1].autopotioning = false
														arg3:set(false)
														task.wait(task.wait(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000))
														v64.Hitbox.Position = position
														break
													else
														task.wait(task.wait(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000))
														if __lph_capture_array_1000011[6].potions[__lph_capture_array_1000011[2].flags.autopotionitem] then
															for k, v65 in pairs(__lph_capture_array_1000011[6].potions[__lph_capture_array_1000011[2].flags.autopotionitem]) do
																slot = __lph_capture_array_1000011[6].inventory[k]
																local v66 = __lph_capture_array_1000011[7].Data.inventory[slot]
																if not v66 or not v66.quantity or v66.quantity <= 0 then
																	__lph_capture_array_1000011[2]:Notify({ text = "Insufficient Items", time = 3 })
																	__lph_capture_array_1000011[1].autopotioning = false
																	arg3:set(false)
																	task.wait(0.1)
																	v64.Hitbox.Position = position
																	break
																else
																	for i = 1, v65 do
																		if not v66 or not v66.quantity or v66.quantity <= 0 then
																			__lph_capture_array_1000011[2]:Notify({ text = "Insufficient Items", time = 3 })
																			__lph_capture_array_1000011[1].autopotioning = false
																			arg3:set(false)
																			task.wait(0.1)
																			v64.Hitbox.Position = position
																			break
																		else
																			firepacket("DropBagItem", slot)
																			task.wait(task.wait(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000))
																		end
																	end
																end
															end
															task.wait(0.2)
															v64.Hitbox.Position = position
															continue
														else
															__lph_capture_array_1000011[2]:Notify({ text = "No Potion Selected", time = 3 })
															__lph_capture_array_1000011[1].autopotioning = false
															arg3:set(false)
															task.wait(0.1)
															v64.Hitbox.Position = position
															break
														end
													end
												end
												break
											end
											for _, v64 in pairs(tbl12) do
												if v64.Name ~= "Cauldron" then
													continue
												elseif __lph_capture_array_1000011[2].flags.autopotions then
													if not v64:FindFirstChild("Hitbox") or not v64:FindFirstChild("Liquid") or not v64:FindFirstChild("Hitbox"):FindFirstChild("ParticleEmitter") or not v64:GetAttribute("EntityID") then
														continue
													else
														while true do
															task.wait(0.1)
															if not (not __lph_capture_array_1000011[2].flags.autopotions or v64:FindFirstChild("Hitbox"):FindFirstChild("ParticleEmitter").Enabled == true) then
																continue
															end
															break
														end
														if __lph_capture_array_1000011[2].flags.autopotions then
															firepacket("SweepPotion", v64:GetAttribute("EntityID"))
															while true do
																task.wait(0.1)
																if not (not __lph_capture_array_1000011[2].flags.autopotions or v64:FindFirstChild("Hitbox"):FindFirstChild("ParticleEmitter").Enabled == false or v64:FindFirstChild("Liquid").Transparency ~= 0.25) then
																	continue
																end
																break
															end
															task.wait(task.wait(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000))
															continue
														end
													end
												end
												break
											end
											__lph_capture_array_1000011[1].autopotioning = false
											task.wait(3)
											continue
										end
										break
									end
								end)
							end
						end
						tbl11.callback = fn12(table.pack(tbl6, library, v19, __boohub_scalar_capture_cell(function() return  character  end, function(__value)  character =__value end), __boohub_scalar_capture_cell(function() return  humanoidRootPart  end, function(__value)  humanoidRootPart =__value end), tbl7, GameUtil))
						toggle(v63, tbl11)
						v63:dropdown({
							name = "Potion",
							flag = "autopotionitem",
							options = { "Swift", "Strength", "Healing", "Haste" },
							default = "Strength",
							max = 1,
						})
					end
					local n28
					do
						local v54 = v37:tab({ name = "Paths" })
						local v55 = v54:section({ name = "Path Creation", show = true })
						local v56 = v55:toggle({ name = "Build", state = false, flag = "pointbuild" })
						local function fn12(color, transparency)
							
							for _, pathpoint in ipairs(tbl7.pathpoints) do
								if pathpoint.part then
									pathpoint.part.Color = color
									pathpoint.part.Transparency = transparency
								end
							end
						end
						v56:colorpicker({
							flag = "pointcolor",
							color = Color3.new(1, 1, 1),
							alpha = 0,
							callback = fn12,
						})
						v56:colorpicker({
							flag = "pathdots",
							color = Color3.new(1, 1, 1),
							alpha = 0,
							callback = function(color, transparency)
								
								for _, pathdot in ipairs(tbl7.pathdots) do
									pathdot.Color = color
									pathdot.Transparency = transparency
								end
							end,
						})
						v55:toggle({
							name = "Record",
							state = false,
							flag = "pointrecord",
							callback = function(arg2, arg3)
								
								arg3:toggleaddons(arg2)
								if not arg2 then
									return
								end
								local v57 = nil
								task.spawn(function()
									
									while library.flags.pointrecord do
										local position = humanoidRootPart and humanoidRootPart.Position
										if position then
											local n = tonumber(library.flags.pathrecordinterval) or 1
											if not v57 or (v57 - position).Magnitude >= n then
												createpoint(position)
												v57 = position
												refreshsegments(#tbl7.pathpoints, #tbl7.pathpoints + 1)
											end
										end
										task.wait()
									end
								end)
							end,
						}):slider({
							name = "Interval",
							flag = "pathrecordinterval",
							default = 3,
							min = 1,
							max = 10,
							suffix = "studs",
							float = 0.1,
						})
						v55:toggle({ name = "Move", state = false, flag = "pointmove" })
						v55:toggle({ name = "Delete", state = false, flag = "pointdelete" })
						v55:button({
							name = "Clear Points",
							confirm = true,
							callback = function()
  tbl6.goldfarmbyZachloaded=false
  for _,point in ipairs(tbl7.pathpoints)do
   if point.part and point.part.Parent then point.part:Destroy()end
   if tbl7.pointguis[point]and tbl7.pointguis[point].Parent then tbl7.pointguis[point]:Destroy()end
  end
  for _,segment in pairs(tbl7.pathsegments)do
   if segment.dots then
    for _,dot in pairs(segment.dots)do
     if dot and dot.Parent then dot:Destroy()end
    end
   end
  end
  table.clear(tbl7.pathpoints)
  table.clear(tbl7.pathparts)
  table.clear(tbl7.pointbypart)
  table.clear(tbl7.pointguis)
  table.clear(tbl7.pathdots)
  table.clear(tbl7.groundpoints)
  table.clear(tbl7.pathsegments)
  tbl5.selectedpoint=nil
  tbl5.draggingpoint=nil
  tbl5.draggingpart=nil
 end,
						})
						local v57 = v54:section({ name = "Movement", show = true })
						local function fn13(j,i)if not j then return;end;j= tbl6 ;if j.pathrunning then return;end;j= tbl6 ;j.pathrunning=true;task.spawn(function()local j= tbl7 ;local O,D=#j.groundpoints<=0;if O then j= library ;j:Notify({text="No Points Exist",time=3});i:set(false);else while true do  local O= library ;if not O.flags.startpath then break;end;O= tbl7 ;if#O.groundpoints<=0 then break;end;local D,L,L=getclosestpoint()or 1, library ,tonumber( library .flags.pathmovespeed)or 19;O=D;while true do  D= library ;local A,c=D.flags.startpath;if A then local D= tbl7 ;c=#D.groundpoints>0;else c=A;end;if not c then break;end;A=not  humanoidRootPart or not  humanoidRootPart .Parent;if A then break;end;local D,s,M= humanoidRootPart .Position,{}, tbl7 ;c=M.groundpoints[O];local k,R,z=c and c.pathpoint,0;if c then z=O;M=D;repeat A= tbl7 ;local E=A.groundpoints[z];if not E or E.pathpoint~=k then break;end;table.insert(s,E);if E.position then local K=E.position;M,R=K,R+(K-M).Magnitude;else end;E= tbl7 ;z=z%#E.groundpoints+1;until z==O;else z=O;end;if#s<=0 then break;end;D=ipairs;for p,E in D(s)do R=E.position;if not R then continue;end;while true do  p= library ;c=p.flags.startpath and  humanoidRootPart and  humanoidRootPart .Parent;if not c then break;end;M,E=task.wait(), humanoidRootPart .Position;A=R-E;local K,o=A.Magnitude,L*M;local L=K<=o or K<=0.1;if L then  humanoidRootPart .CFrame=CFrame.new(R)*( humanoidRootPart .CFrame-E);break;end;K=A.Unit;local L,n=E+K*o,Vector3.new(K.X,0,K.Z);o=n.Magnitude>0.01;if o then  humanoidRootPart .CFrame=CFrame.lookAt(L,L+n.Unit);else  humanoidRootPart .CFrame=CFrame.new(L)*( humanoidRootPart .CFrame-E);end; humanoidRootPart .AssemblyLinearVelocity=Vector3.new(0.0,0.0,0.0);end;p= library ;if not p.flags.startpath then break;end;end;R= library ;if not R.flags.startpath then break;end;if k then A=k.jump and  humanoid ;if A then  humanoid .Jump=true; humanoid :ChangeState(Enum.HumanoidStateType.Jumping);end;M=k.equipenable;if M then c=tonumber(k.equip);D=nil;if c then s= GameUtil ;D=s.Data.toolbar[c];else D=c;end;R= character and  character .Tools and  character .Tools:FindFirstChildOfClass("Model");local p=D and(not R or D.name~=R.Name);if p then local p= Packets ;p.EquipTool.send(c);end;end;local p=k.wait and k.wait>0;if p then local p=tick();while true do  local V= library ;if not(V.flags.startpath and tick()-p<k.wait)then break;end;task.wait();end;end;end;s= humanoidRootPart ;if s then  humanoidRootPart .AssemblyLinearVelocity=Vector3.new(0, humanoidRootPart .AssemblyLinearVelocity.Y,0);end;task.wait();O=z;end;task.wait();end;end;j= tbl6 ;j.pathrunning=false;j= library ;if j.flags.startpath then i:set(false);end;end);end
						v57:toggle({ name = "Start", state = false, flag = "startpath", callback = fn13 })
						v57:slider({
							name = "Move Speed",
							flag = "pathmovespeed",
							default = 18,
							min = 1,
							max = 17,
							suffix = " studs/s",
							float = 0.1,
						})
						local v58 = v54:section({ name = "Point Editing" })
						local function fn14(jump)
							
							if not tbl5.selectedpoint then
								return
							end
							tbl5.selectedpoint.jump = jump
						end
						tbl5.pointjump = v58:toggle({ name = "Jump", state = false, flag = "pointjump", callback = fn14 })
						tbl5.pointwait = v58:textbox({
							name = "Wait",
							flag = "pointwait",
							default = "0",
							callback = function(arg2)
								
								if not tbl5.selectedpoint then
									return
								end
								tbl5.selectedpoint.wait = tonumber(arg2)
							end,
						})
						tbl5.pointequipslotenable = v58:toggle({
							name = "Equip Tool",
							state = false,
							flag = "pointequipslotenable",
							callback = function(equipenable)
								
								if not tbl5.selectedpoint then
									return
								end
								tbl5.selectedpoint.equipenable = equipenable
							end,
						})
						tbl5.pointequipslot = v58:slider({
							name = "Equip Slot",
							flag = "pointequipslot",
							default = 1,
							min = 1,
							max = 6,
							float = 1,
							callback = function(equip)
								
								if not tbl5.selectedpoint then
									return
								end
								tbl5.selectedpoint.equip = equip
							end,
						})
						tbl5.pointdotrate = v58:slider({
							name = "Dot Rate",
							flag = "pointdotrate",
							default = 1,
							min = 0,
							max = 25,
							float = 0.1,
							suffix = " per stud",
							callback = function(arg2)
								
								if not tbl5.selectedpoint then
									return
								end
								tbl5.selectedpoint.dotrate = tonumber(arg2) or 1
								tbl9.lastdotratechange = tick()
								local lastdotratechange = tbl9.lastdotratechange
								local selectedpoint = tbl5.selectedpoint
								task.delay(0.25, function()
									
									if lastdotratechange ~= tbl9.lastdotratechange then
										return
									end
									if not selectedpoint then
										return
									end
									if not table.find(tbl7.pathpoints, selectedpoint) then
										return
									end
									local v59 = table.find(tbl7.pathpoints, selectedpoint)
									if not v59 then
										return
									end
									refreshsegments(v59 - 1)
								end)
							end,
						})
						v58:button({
							name = "Reset Editing",
							tooltip = "Stops editing the point you chose to edit and the creation settings to back to its defaults",
							callback = function()
								
								tbl5.selectedpoint = nil
								tbl5.pointjump:set(false)
								tbl5.pointwait:set(0)
								tbl5.pointequipslotenable:set(false)
								tbl5.pointequipslot:set(0)
								tbl5.pointdotrate:set(1)
							end,
						})
						local v59 = v54:section({ name = "Path Saving" })
						n28 = v46 // 6
						v59:textbox({ name = "Path Name", flag = "pathname", default = "Path" })
						local v60 = v59:dropdown({
							name = "Paths",
							flag = "selectedpath",
							items = refreshpathlist(),
							default = nil,
						})
						v60:setoptions(refreshpathlist())
						v59:button({
							name = "Create",
							callback = function()
								
								
								
								local pathname = library.flags.pathname
								if pathname == "goldfarmbyZach&rinn" then
									library:Notify({ text = "Cannot overwrite default paths", time = 5 })
									return
								end
								if not pathname or pathname == "" then
									library:Notify({ text = "No Path Name", time = 3 })
									return
								end
								if #tbl7.pathpoints <= 0 then
									library:Notify({ text = "No Points To Save", time = 3 })
									return
								end
								local str = "Boo/games/" .. game.PlaceId .. "/paths"
								local v61 = isfolder
								
								if not v61("Boo") then
									makefolder("Boo")
								end
								if not isfolder("Boo/games") then
									makefolder("Boo/games")
								end
								if not isfolder("Boo/games/" .. game.PlaceId) then
									makefolder("Boo/games/" .. game.PlaceId)
								end
								if not isfolder(str) then
									makefolder(str)
								end
								
								local flag2 = not string.lower(pathname):match("%.txt$")
								
								if flag2 and not string.lower(pathname):match("%.json$") then
									pathname ..= ".txt"
								end
								local tbl11 = {}
								for _, pathpoint in ipairs(tbl7.pathpoints) do
									if pathpoint.part then
										local position = pathpoint.part.Position
										local insert = table.insert
										local tbl12 = { x = position.X, y = position.Y, z = position.Z, jump = pathpoint.jump == true }
										tbl12.wait = tonumber(pathpoint.wait) or 0
										tbl12.dotrate = tonumber(pathpoint.dotrate) or 1
										tbl12.equipenable = pathpoint.equipenable == true
										tbl12.equip = tonumber(pathpoint.equip)
										insert(tbl11, tbl12)
									end
								end
								writefile(str .. "/" .. pathname, httpService:JSONEncode(tbl11))
								v60:setoptions(refreshpathlist())
								v60:set(pathname)
								library:Notify({ text = "Created Path", highlights = { pathname }, time = 3 })
							end,
						})
						v59:button({
							name = "Save",
							confirm = true,
							callback = function()
								
								
								
								
								local selectedpath = library.flags.selectedpath
								if not selectedpath or selectedpath == "" then
									library:Notify({ text = "No Path Selected", time = 3 })
									return
								end
								
								if #tbl7.pathpoints <= 0 then
									library:Notify({ text = "No Points To Save", time = 3 })
									return
								end
								if selectedpath == "goldfarmbyZach&rinn" then
									library:Notify({ text = "Cannot save default paths", time = 5 })
									return
								end
								local str = "Boo/games/" .. game.PlaceId .. "/paths"
								if not isfolder("Boo") then
									makefolder("Boo")
								end
								
								if not isfolder("Boo/games") then
									makefolder("Boo/games")
								end
								if not isfolder("Boo/games/" .. game.PlaceId) then
									makefolder("Boo/games/" .. game.PlaceId)
								end
								if not isfolder(str) then
									makefolder(str)
								end
								if not string.lower(selectedpath):match("%.txt$") and not string.lower(selectedpath):match("%.json$") then
									selectedpath ..= ".txt"
								end
								local tbl11 = {}
								local v61, v62, v63 = ipairs(tbl7.pathpoints)
								
								for _, v65 in v61, v62, v63 do
									if v65.part then
										local position = v65.part.Position
										local insert = table.insert
										local tbl12 = {
											x = position.X,
											y = position.Y,
											z = position.Z,
											jump = v65.jump == true,
											wait = tonumber(v65.wait) or 0,
											dotrate = tonumber(v65.dotrate) or 1,
											equipenable = v65.equipenable == true,
										}
										tbl12.equip = tonumber(v65.equip)
										insert(tbl11, tbl12)
									end
								end
								
								writefile(str .. "/" .. selectedpath, httpService:JSONEncode(tbl11))
								v60:setoptions(refreshpathlist())
								v60:set(selectedpath)
								library:Notify({ text = "Saved Path", highlights = { selectedpath }, time = 3 })
							end,
						})
						local button = v59.button
						local tbl11 = { name = "Load", confirm = true }
						local n = n28 - 4098953024
						
						local function fn15(__lph_capture_array_1000017, __lph_unused_1)
							return function()
								
								
								
								
								
								
								__lph_capture_array_1000017[1].goldfarmbyZachloaded = false
								local selectedpath = __lph_capture_array_1000017[2].flags.selectedpath
								if not selectedpath or selectedpath == "" then
									__lph_capture_array_1000017[2]:Notify({ text = "No Path Selected", time = 3 })
									return
								end
								local str = "Boo/games/" .. game.PlaceId .. "/paths"
								local str2 = str .. "/" .. selectedpath
								local flag2 = not string.lower(selectedpath):match("%.txt$")
								if flag2 then
									local v61 = string.lower(selectedpath)
									
									flag2 = not v61:match("%.json$")
									
								end
								if flag2 then
									if isfile(str .. "/" .. selectedpath .. ".txt") then
										str2 = str .. "/" .. selectedpath .. ".txt"
									else
										str2 = str .. "/" .. selectedpath .. ".json"
									end
								end
								if not isfile(str2) then
									__lph_capture_array_1000017[2]:Notify({ text = "Path Not Found", highlights = { selectedpath }, time = 3 })
									return
								end
								local v61 = pcall
								local v62 = 372883678
								local function fn16()
									
									local flag3 = selectedpath ~= "goldfarmbyZach&rinn"
									local v63 = v62
									local n35
									if v63 % 4294967296 ~= v63 % 4294967296 then
										n35 = 0
									else
										n35 = v63 % 4294967296 - v63 % 4294967296 % 1
									end
									if bit32.bxor(n35, 0) ~= 149646175 then
										local v64 = v62
										local n36
										if v64 % 4294967296 ~= v64 % 4294967296 then
											n36 = 0
										else
											n36 = v64 % 4294967296 - v64 % 4294967296 % 1
										end
										v62 = bit32.bxor(n36, 2445277435)
									end
									if flag3 then
										__lph_capture_array_1000017[1].goldfarmbyZachloaded = false
										return __lph_capture_array_1000017[3]:JSONDecode(readfile(str2))
									end
									__lph_capture_array_1000017[1].goldfarmbyZachloaded = true
									return __lph_capture_array_1000017[3]:JSONDecode("                        [{\"y\":-35.13190460205078,\"x\":-138.8435516357422,\"equip\":1,\"z\":-142.2435760498047,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-33.43061828613281,\"x\":-149.43310546875,\"equip\":1,\"z\":-168.49386596679688,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-34.606929779052737,\"x\":-142.28079223632813,\"equip\":1,\"z\":-168.51580810546876,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-34.746986389160159,\"x\":-139.31407165527345,\"equip\":1,\"z\":-172.37612915039063,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":1},{\"y\":-33.93537139892578,\"x\":-139.96327209472657,\"equip\":1,\"z\":-179.06390380859376,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-31.8775634765625,\"x\":-143.10386657714845,\"equip\":1,\"z\":-181.93167114257813,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-26.835723876953126,\"x\":-111.54895782470703,\"equip\":1,\"z\":-184.6226806640625,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-26.486154556274415,\"x\":-111.3729019165039,\"equip\":1,\"z\":-189.75445556640626,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":1},{\"y\":-25.929439544677736,\"x\":-118.81073760986328,\"equip\":1,\"z\":-192.9115447998047,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-13.07543659210205,\"x\":-118.60652160644531,\"equip\":1,\"z\":-193.81683349609376,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-10.891876220703125,\"x\":-137.84104919433595,\"equip\":1,\"z\":-200.9855499267578,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":1},{\"y\":-8.036247253417969,\"x\":-143.0841827392578,\"equip\":1,\"z\":-203.06414794921876,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-5.9455695152282719,\"x\":-126.00572967529297,\"equip\":1,\"z\":-209.9382781982422,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-1.3267006874084473,\"x\":-112.98716735839844,\"equip\":1,\"z\":-214.3895721435547,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-3,\"x\":-75.92047119140625,\"equip\":1,\"z\":-229.22776794433595,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-3.1321563720703127,\"x\":112.48785400390625,\"equip\":1,\"z\":-283.1126708984375,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-3.3489837646484377,\"x\":173.0898895263672,\"equip\":1,\"z\":-256.7090759277344,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-3.5830230712890627,\"x\":200.8354034423828,\"equip\":1,\"z\":-232.65081787109376,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-3,\"x\":214.5748291015625,\"equip\":1,\"z\":-200.2581329345703,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-2.9999847412109377,\"x\":248.29115295410157,\"equip\":1,\"z\":-135.0506591796875,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-4.999992370605469,\"x\":274.5215759277344,\"equip\":1,\"z\":-80.81613159179688,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-5.000003814697266,\"x\":304.5450744628906,\"equip\":1,\"z\":-24.76930809020996,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-5,\"x\":361.5514221191406,\"equip\":1,\"z\":54.125770568847659,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-4.999996185302734,\"x\":398.5390930175781,\"equip\":1,\"z\":97.56704711914063,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-3,\"x\":557.6434326171875,\"equip\":1,\"z\":303.81829833984377,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":14.719314575195313,\"x\":571.2877807617188,\"equip\":1,\"z\":306.9266662597656,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":16.950119018554689,\"x\":576.60107421875,\"equip\":1,\"z\":308.5508728027344,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":12.425743103027344,\"x\":589.50341796875,\"equip\":1,\"z\":320.2024841308594,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":11.949150085449219,\"x\":592.635009765625,\"equip\":1,\"z\":316.9793395996094,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0.5},{\"y\":12.747566223144532,\"x\":597.6547241210938,\"equip\":1,\"z\":325.2178649902344,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":11.228626251220704,\"x\":577.9967041015625,\"equip\":1,\"z\":400.2611083984375,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":13.13067626953125,\"x\":576.2879028320313,\"equip\":1,\"z\":408.8326110839844,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":12.883865356445313,\"x\":616.3388061523438,\"equip\":1,\"z\":352.9373779296875,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":1},{\"y\":10.804893493652344,\"x\":636.458251953125,\"equip\":1,\"z\":336.2169494628906,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-3.3076629638671877,\"x\":662.769287109375,\"equip\":1,\"z\":326.47216796875,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-1.3060486316680909,\"x\":945.2998046875,\"equip\":1,\"z\":430.9941711425781,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":1.2595672607421876,\"x\":1099.3314208984376,\"equip\":1,\"z\":483.74639892578127,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-3.4038009643554689,\"x\":1192.62646484375,\"equip\":1,\"z\":556.7800903320313,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-3.354206085205078,\"x\":1209.52783203125,\"equip\":1,\"z\":557.1412353515625,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-8.461579322814942,\"x\":1193.4010009765626,\"equip\":1,\"z\":543.5983276367188,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-11.942306518554688,\"x\":1262.509765625,\"equip\":1,\"z\":511.3648681640625,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-15.08743667602539,\"x\":1229.9666748046876,\"equip\":1,\"z\":445.59710693359377,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-15.33437728881836,\"x\":1237.5950927734376,\"equip\":1,\"z\":444.19537353515627,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0.5},{\"y\":-15.001731872558594,\"x\":1236.03369140625,\"equip\":1,\"z\":459.79998779296877,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-15.10922622680664,\"x\":1240.847900390625,\"equip\":1,\"z\":463.99981689453127,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-17.895217895507814,\"x\":1247.80859375,\"equip\":1,\"z\":458.7276611328125,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-21.99985122680664,\"x\":1263.3206787109376,\"equip\":1,\"z\":454.2604064941406,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-26.78921890258789,\"x\":1343.1868896484376,\"equip\":1,\"z\":440.291259765625,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-15.283821105957032,\"x\":1327.8668212890626,\"equip\":1,\"z\":396.6335144042969,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-1.9230976104736329,\"x\":1188.72021484375,\"equip\":1,\"z\":340.5241394042969,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-5.000007629394531,\"x\":754.36279296875,\"equip\":1,\"z\":-134.19113159179688,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-5,\"x\":724.7297973632813,\"equip\":1,\"z\":-138.10574340820313,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":13.830828666687012,\"x\":705.4959106445313,\"equip\":1,\"z\":-171.27452087402345,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":31.87156867980957,\"x\":686.2168579101563,\"equip\":1,\"z\":-181.47427368164063,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":31.942161560058595,\"x\":655.4163818359375,\"equip\":1,\"z\":-188.21438598632813,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0.5},{\"y\":32.43442153930664,\"x\":683.9235229492188,\"equip\":1,\"z\":-184.47091674804688,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":24.589515686035158,\"x\":718.4014892578125,\"equip\":1,\"z\":-213.27325439453126,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":22.23458480834961,\"x\":733.0404052734375,\"equip\":1,\"z\":-256.13641357421877,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":24.99228286743164,\"x\":719.3155517578125,\"equip\":1,\"z\":-299.447265625,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":35.145973205566409,\"x\":698.84326171875,\"equip\":1,\"z\":-312.0693359375,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":55.94841003417969,\"x\":686.852783203125,\"equip\":1,\"z\":-332.1172790527344,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":78.68881225585938,\"x\":675.767822265625,\"equip\":1,\"z\":-377.876220703125,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":78.55144500732422,\"x\":680.2925415039063,\"equip\":1,\"z\":-388.16229248046877,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0.5},{\"y\":79.04715728759766,\"x\":671.9559936523438,\"equip\":1,\"z\":-387.0789794921875,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":53.37715530395508,\"x\":614.6017456054688,\"equip\":1,\"z\":-380.2009582519531,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":12.533447265625,\"x\":569.54736328125,\"equip\":1,\"z\":-359.0424499511719,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":14.275060653686524,\"x\":583.6427612304688,\"equip\":1,\"z\":-347.5664367675781,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-7.230224609375,\"x\":603.563720703125,\"equip\":1,\"z\":-353.9355773925781,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-5.532473087310791,\"x\":614.521728515625,\"equip\":1,\"z\":-348.44451904296877,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-7.335209369659424,\"x\":619.490966796875,\"equip\":1,\"z\":-355.1043395996094,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-3.803314685821533,\"x\":624.306884765625,\"equip\":1,\"z\":-356.8699035644531,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-7.3033671379089359,\"x\":624.4445190429688,\"equip\":1,\"z\":-360.5807189941406,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0.5},{\"y\":-5.744186878204346,\"x\":641.1807861328125,\"equip\":1,\"z\":-369.5819091796875,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0.5},{\"y\":-3.8364992141723635,\"x\":644.57861328125,\"equip\":1,\"z\":-377.3958435058594,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-4.338809967041016,\"x\":615.610107421875,\"equip\":1,\"z\":-393.7859802246094,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-6.311195373535156,\"x\":607.8247680664063,\"equip\":1,\"z\":-384.6204528808594,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0.5},{\"y\":-1.1836798191070557,\"x\":585.98486328125,\"equip\":1,\"z\":-385.2772216796875,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":8.79036808013916,\"x\":564.4688110351563,\"equip\":1,\"z\":-394.02325439453127,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":10.765023231506348,\"x\":551.8667602539063,\"equip\":1,\"z\":-391.0522766113281,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":6.855417251586914,\"x\":519.4808349609375,\"equip\":1,\"z\":-412.0830078125,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-2.5153472423553469,\"x\":485.9485778808594,\"equip\":1,\"z\":-418.8196716308594,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-3.000000476837158,\"x\":150.69192504882813,\"equip\":1,\"z\":-552.077880859375,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-3.0116937160491945,\"x\":104.45276641845703,\"equip\":1,\"z\":-548.0693359375,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-3.000000238418579,\"x\":-50.11766815185547,\"equip\":1,\"z\":-553.5484619140625,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-2.4691386222839357,\"x\":-98.4654312133789,\"equip\":1,\"z\":-573.0521240234375,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":4.9504594802856449,\"x\":-191.9187469482422,\"equip\":1,\"z\":-614.7230834960938,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":20.407915115356447,\"x\":-208.625244140625,\"equip\":1,\"z\":-624.6954345703125,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":24.253612518310548,\"x\":-211.59347534179688,\"equip\":1,\"z\":-629.0078125,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":20.314960479736329,\"x\":-216.6365509033203,\"equip\":1,\"z\":-624.354736328125,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-2.6903741359710695,\"x\":-248.98463439941407,\"equip\":1,\"z\":-616.652587890625,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-3.1778321266174318,\"x\":-290.9718322753906,\"equip\":1,\"z\":-603.2835083007813,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-3.000000238418579,\"x\":-332.8497009277344,\"equip\":1,\"z\":-612.1715698242188,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-6.500301837921143,\"x\":-377.6502380371094,\"equip\":1,\"z\":-611.2145385742188,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-25.442546844482423,\"x\":-405.8098449707031,\"equip\":1,\"z\":-601.6856689453125,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-38.551116943359378,\"x\":-418.5211486816406,\"equip\":1,\"z\":-548.9586791992188,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-43.33993911743164,\"x\":-385.77777099609377,\"equip\":1,\"z\":-557.4585571289063,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-43.26174545288086,\"x\":-379.8781433105469,\"equip\":1,\"z\":-554.2053833007813,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-43.76557540893555,\"x\":-376.55340576171877,\"equip\":1,\"z\":-561.0226440429688,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0.5},{\"y\":-47.163082122802737,\"x\":-339.169189453125,\"equip\":1,\"z\":-566.7299194335938,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-48.4087028503418,\"x\":-317.281982421875,\"equip\":1,\"z\":-567.5774536132813,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-56.746337890625,\"x\":-296.470458984375,\"equip\":1,\"z\":-571.9732055664063,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-56.382232666015628,\"x\":-263.0000915527344,\"equip\":1,\"z\":-554.3634033203125,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-59.58250427246094,\"x\":-231.95631408691407,\"equip\":1,\"z\":-543.1199951171875,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-59.014286041259769,\"x\":-218.91433715820313,\"equip\":1,\"z\":-530.2526245117188,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-59.0460319519043,\"x\":-212.2266387939453,\"equip\":1,\"z\":-524.7462768554688,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-60.48321533203125,\"x\":-204.04396057128907,\"equip\":1,\"z\":-539.8779296875,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-63.74665832519531,\"x\":-176.48263549804688,\"equip\":1,\"z\":-551.3212890625,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-65.1943588256836,\"x\":-159.3333740234375,\"equip\":1,\"z\":-591.2775268554688,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-64.2606430053711,\"x\":-169.1815643310547,\"equip\":1,\"z\":-609.8347778320313,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-60.62080764770508,\"x\":-214.01002502441407,\"equip\":1,\"z\":-624.61865234375,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-60.10873794555664,\"x\":-214.75119018554688,\"equip\":1,\"z\":-631.7476196289063,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-64.4166259765625,\"x\":-162.25680541992188,\"equip\":1,\"z\":-608.0181274414063,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-63.07737350463867,\"x\":-159.60842895507813,\"equip\":1,\"z\":-587.1376953125,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-63.33266830444336,\"x\":-178.58995056152345,\"equip\":1,\"z\":-550.82666015625,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-63.10444259643555,\"x\":-165.25323486328126,\"equip\":1,\"z\":-517.6795654296875,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-64.1492691040039,\"x\":-172.28628540039063,\"equip\":1,\"z\":-489.211181640625,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-69.81143188476563,\"x\":-179.1321563720703,\"equip\":1,\"z\":-451.2427978515625,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-72.29277038574219,\"x\":-174.35069274902345,\"equip\":1,\"z\":-454.0025939941406,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-97.04940795898438,\"x\":-161.3256378173828,\"equip\":1,\"z\":-471.11846923828127,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-100.61099243164063,\"x\":-160.59828186035157,\"equip\":1,\"z\":-500.94403076171877,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-103.00000762939453,\"x\":-182.9207763671875,\"equip\":1,\"z\":-506.4500427246094,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-103.16866302490235,\"x\":-191.49151611328126,\"equip\":1,\"z\":-504.5206604003906,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-103.31836700439453,\"x\":-194.98609924316407,\"equip\":1,\"z\":-491.199462890625,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-103.26477813720703,\"x\":-190.0321502685547,\"equip\":1,\"z\":-474.1479187011719,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-103.43378448486328,\"x\":-187.0658721923828,\"equip\":1,\"z\":-454.3406066894531,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":1},{\"y\":-103.29632568359375,\"x\":-191.29940795898438,\"equip\":1,\"z\":-474.72705078125,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-103.36579895019531,\"x\":-195.34539794921876,\"equip\":1,\"z\":-493.66107177734377,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-103.21434020996094,\"x\":-189.5367431640625,\"equip\":1,\"z\":-505.46331787109377,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-102.54376220703125,\"x\":-175.937744140625,\"equip\":1,\"z\":-506.1109313964844,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-99.50606536865235,\"x\":-164.77207946777345,\"equip\":1,\"z\":-502.48406982421877,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-97.97051239013672,\"x\":-145.2169647216797,\"equip\":1,\"z\":-493.7679748535156,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-103.00000762939453,\"x\":-107.86607360839844,\"equip\":1,\"z\":-480.5359802246094,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-103.00000762939453,\"x\":-39.21729278564453,\"equip\":1,\"z\":-456.6504821777344,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-100.0069351196289,\"x\":17.053058624267579,\"equip\":1,\"z\":-409.47589111328127,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-99.00000762939453,\"x\":23.08147621154785,\"equip\":1,\"z\":-383.23321533203127,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-95.61363983154297,\"x\":41.75634002685547,\"equip\":1,\"z\":-372.2613220214844,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-98.21893310546875,\"x\":59.76584243774414,\"equip\":1,\"z\":-361.8006286621094,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-97.10460662841797,\"x\":58.038639068603519,\"equip\":1,\"z\":-352.1005554199219,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0.5},{\"y\":-99.1119613647461,\"x\":36.01699447631836,\"equip\":1,\"z\":-366.72027587890627,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-99.00000762939453,\"x\":22.80565071105957,\"equip\":1,\"z\":-384.9761962890625,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-100.21601104736328,\"x\":16.455093383789064,\"equip\":1,\"z\":-410.1782531738281,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-102.89031982421875,\"x\":11.485198974609375,\"equip\":1,\"z\":-414.0020446777344,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-103.00000762939453,\"x\":-4.664604187011719,\"equip\":1,\"z\":-415.87786865234377,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-103.01253509521485,\"x\":-99.35933685302735,\"equip\":1,\"z\":-362.3749084472656,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-92.98947143554688,\"x\":-112.60714721679688,\"equip\":1,\"z\":-300.58349609375,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-87.35938262939453,\"x\":-146.53924560546876,\"equip\":1,\"z\":-264.323486328125,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-87.35938262939453,\"x\":-186.77456665039063,\"equip\":1,\"z\":-258.7982177734375,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-86.4328842163086,\"x\":-209.0652618408203,\"equip\":1,\"z\":-255.96792602539063,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-83.00891876220703,\"x\":-228.87620544433595,\"equip\":1,\"z\":-253.16090393066407,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-83,\"x\":-243.84481811523438,\"equip\":1,\"z\":-247.16481018066407,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":1},{\"y\":-83,\"x\":-249.9613494873047,\"equip\":1,\"z\":-234.53280639648438,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-95.35968780517578,\"x\":-230.9480743408203,\"equip\":1,\"z\":-191.8265380859375,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-95.50447845458985,\"x\":-217.54080200195313,\"equip\":1,\"z\":-177.99632263183595,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-95.50485229492188,\"x\":-244.17031860351563,\"equip\":1,\"z\":-129.70852661132813,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-99.11929321289063,\"x\":-280.3130798339844,\"equip\":1,\"z\":-74.5643310546875,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-91.37126159667969,\"x\":-323.2608337402344,\"equip\":1,\"z\":-64.1614990234375,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-91.01546478271485,\"x\":-336.3085632324219,\"equip\":1,\"z\":-47.290382385253909,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0.5},{\"y\":-91.48456573486328,\"x\":-334.6069641113281,\"equip\":1,\"z\":-39.712188720703128,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-91.01563262939453,\"x\":-342.4624328613281,\"equip\":1,\"z\":-45.37606430053711,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-90.8072509765625,\"x\":-328.9414978027344,\"equip\":1,\"z\":-68.18278503417969,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-85.8760986328125,\"x\":-325.9907531738281,\"equip\":1,\"z\":-99.80419921875,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-83.93140411376953,\"x\":-320.13275146484377,\"equip\":1,\"z\":-114.49515533447266,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-79.35810852050781,\"x\":-309.3922119140625,\"equip\":1,\"z\":-110.20948791503906,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-76.1257553100586,\"x\":-303.49688720703127,\"equip\":1,\"z\":-99.10836029052735,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-70.87893676757813,\"x\":-281.2503356933594,\"equip\":1,\"z\":-88.7996826171875,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-71.1072006225586,\"x\":-260.5174255371094,\"equip\":1,\"z\":-79.83052062988281,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-71.42316436767578,\"x\":-251.06199645996095,\"equip\":1,\"z\":-79.61898040771485,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-71.66569519042969,\"x\":-236.75448608398438,\"equip\":1,\"z\":-86.93795013427735,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-71.51913452148438,\"x\":-228.806640625,\"equip\":1,\"z\":-86.1635971069336,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-71.65625762939453,\"x\":-233.3338165283203,\"equip\":1,\"z\":-79.15843200683594,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0.5},{\"y\":-71.27642822265625,\"x\":-261.203369140625,\"equip\":1,\"z\":-79.39801788330078,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-95.59561920166016,\"x\":-277.8853454589844,\"equip\":1,\"z\":-63.76515579223633,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-95.07794952392578,\"x\":-243.5623779296875,\"equip\":1,\"z\":-132.2040557861328,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-95.00469970703125,\"x\":-208.36532592773438,\"equip\":1,\"z\":-126.12137603759766,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-95.67113494873047,\"x\":-142.74061584472657,\"equip\":1,\"z\":-46.936798095703128,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-95.35862731933594,\"x\":-67.46387481689453,\"equip\":1,\"z\":-25.947139739990236,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-94.69734191894531,\"x\":-47.03763198852539,\"equip\":1,\"z\":-22.422344207763673,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-95.39714813232422,\"x\":-38.11060333251953,\"equip\":1,\"z\":-12.599225044250489,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-91.35380554199219,\"x\":-19.604429244995118,\"equip\":1,\"z\":1.6843225955963135,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0.5},{\"y\":-90.59036254882813,\"x\":-14.366582870483399,\"equip\":1,\"z\":-5.600636005401611,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-95.04908752441406,\"x\":-40.232418060302737,\"equip\":1,\"z\":-12.234673500061036,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-90.47113037109375,\"x\":-70.0914535522461,\"equip\":1,\"z\":-53.118534088134769,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-79.5238037109375,\"x\":-67.66805267333985,\"equip\":1,\"z\":-76.06720733642578,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-75.9429931640625,\"x\":-56.60151290893555,\"equip\":1,\"z\":-79.32298278808594,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-75.00654602050781,\"x\":-31.57271385192871,\"equip\":1,\"z\":-57.785362243652347,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-76.40645599365235,\"x\":-24.85295295715332,\"equip\":1,\"z\":-39.82494354248047,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-75.04737854003906,\"x\":-8.137798309326172,\"equip\":1,\"z\":-34.66328430175781,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-74.97091674804688,\"x\":15.251713752746582,\"equip\":1,\"z\":-36.01083755493164,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-76.55072021484375,\"x\":7.008288383483887,\"equip\":1,\"z\":-63.67748260498047,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-82.39252471923828,\"x\":1.862072229385376,\"equip\":1,\"z\":-76.97442626953125,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-80.16503143310547,\"x\":8.938286781311036,\"equip\":1,\"z\":-81.49937438964844,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-82.54695892333985,\"x\":2.97719669342041,\"equip\":1,\"z\":-87.07685089111328,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0.5},{\"y\":-74.69515228271485,\"x\":7.637115955352783,\"equip\":1,\"z\":-101.2001953125,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-71.45970916748047,\"x\":21.531206130981447,\"equip\":1,\"z\":-111.62348175048828,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-75.07813262939453,\"x\":53.5029411315918,\"equip\":1,\"z\":-137.69631958007813,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-75.37242126464844,\"x\":72.62187957763672,\"equip\":1,\"z\":-133.76119995117188,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-69.44612121582031,\"x\":80.92835235595703,\"equip\":1,\"z\":-107.80218505859375,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-55.86265182495117,\"x\":84.01776885986328,\"equip\":1,\"z\":-69.37672424316406,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-44.00522232055664,\"x\":60.188663482666019,\"equip\":1,\"z\":-53.838043212890628,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-35.30022430419922,\"x\":36.2784309387207,\"equip\":1,\"z\":-61.88577651977539,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-35.00065612792969,\"x\":-38.657100677490237,\"equip\":1,\"z\":-94.74298095703125,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0},{\"y\":-35.11465072631836,\"x\":-81.71607208251953,\"equip\":1,\"z\":-115.22794342041016,\"equipenable\":false,\"dotrate\":0,\"jump\":false,\"wait\":0}]\n                    ")
								end
								
								
								v62 = 149646175
								local v64, v65 = v61(fn16)
								if not v64 or type(v65) ~= "table" then
									__lph_capture_array_1000017[2]:Notify({ text = "Invalid Path JSON", highlights = { selectedpath }, time = 3 })
									return
								end
								for _, pathpoint in ipairs(__lph_capture_array_1000017[4].pathpoints) do
									if pathpoint.part then
										pathpoint.part:Destroy()
									end
									if __lph_capture_array_1000017[4].pointguis[pathpoint] and __lph_capture_array_1000017[4].pointguis[pathpoint].Parent then
										__lph_capture_array_1000017[4].pointguis[pathpoint]:Destroy()
									end
								end
								for _, pathdot in ipairs(__lph_capture_array_1000017[4].pathdots) do
									if pathdot and pathdot.Parent then
										pathdot:Destroy()
									end
								end
								for _, pathsegment in pairs(__lph_capture_array_1000017[4].pathsegments) do
									if pathsegment and pathsegment.dots then
										for _, dot in pairs(pathsegment.dots) do
											if dot and dot.Parent then
												dot:Destroy()
											end
										end
									end
								end
								table.clear(__lph_capture_array_1000017[4].pathpoints)
								table.clear(__lph_capture_array_1000017[4].pathparts)
								table.clear(__lph_capture_array_1000017[4].pointbypart)
								table.clear(__lph_capture_array_1000017[4].pointguis)
								
								
								table.clear(__lph_capture_array_1000017[4].pathdots)
								table.clear(__lph_capture_array_1000017[4].groundpoints)
								table.clear(__lph_capture_array_1000017[4].pathsegments)
								__lph_capture_array_1000017[5].selectedpoint = nil
								__lph_capture_array_1000017[5].draggingpoint = nil
								__lph_capture_array_1000017[5].draggingpart = nil
								for _, v66 in ipairs(v65) do
									if v66.x and v66.y and v66.z then
										createpoint(Vector3.new(v66.x, v66.y, v66.z), true)
										local v67 = __lph_capture_array_1000017[4].pathpoints[#__lph_capture_array_1000017[4].pathpoints]
										if v67 then
											v67.jump = v66.jump == true
											v67.wait = tonumber(v66.wait) or 0
											v67.dotrate = math.clamp(tonumber(v66.dotrate) or 1, 0, 25)
											v67.equip = tonumber(v66.equip)
											v67.equipenable = v66.equipenable == true and type(v67.equip) == "number"
										end
									end
								end
								for i = 1, #__lph_capture_array_1000017[4].pathpoints do
									if __lph_capture_array_1000017[4].pathpoints[i].label then
										__lph_capture_array_1000017[4].pathpoints[i].label.Text = "Index: " .. i
									end
								end
								refreshsegments()
								__lph_capture_array_1000017[2]:Notify({ text = "Loaded Path", highlights = { selectedpath }, time = 3 })
								if selectedpath == "goldfarmbyZach&rinn" then
									__lph_capture_array_1000017[2]:Notify({
										text = "Gold Farm by rinn, edited by zach",
										time = 10,
										highlights = { "~1000/hour @ 17 speed", "Slot 1: God Pick" },
									})
								end
							end
						end
						tbl11.callback = fn15(table.pack(tbl6, library, httpService, tbl7, tbl5))
						button(v59, tbl11)
						v59:button({
							name = "Delete",
							confirm = true,
							callback = function()
								
								
								
								local selectedpath = library.flags.selectedpath
								if not selectedpath or selectedpath == "" then
									library:Notify({ text = "No Path Selected", time = 3 })
									return
								end
								if selectedpath == "goldfarmbyZach&rinn" then
									library:Notify({ text = "Cannot delete default paths", time = 5 })
									return
								end
								local placeId = game.PlaceId
								
								local str = "Boo/games/" .. placeId .. "/paths"
								local str2 = str .. "/" .. selectedpath
								if not string.lower(selectedpath):match("%.txt$") and not string.lower(selectedpath):match("%.json$") then
									if isfile(str .. "/" .. selectedpath .. ".txt") then
										str2 = str .. "/" .. selectedpath .. ".txt"
										local function fn16(arg2, arg3)
											
											local n31 = arg3 + os.time() + math.random(1, 999) + os.clock()
											local n32 = arg2 + 314878642
											return n31, function(arg4, arg5)
												
												local v62 = n31
												local n33 = arg5 + 407566747
												local n34
												if n33 % 4294967296 ~= n33 % 4294967296 then
													n34 = 0
												else
													n34 = n33 % 4294967296 - n33 % 4294967296 % 1
												end
												if n34 == 132131767 then
													local n35
													if arg5 % 4294967296 ~= arg5 % 4294967296 then
														n35 = 0
													else
														n35 = arg5 % 4294967296 - arg5 % 4294967296 % 1
													end
													bit32.bxor(n35, 1394881735)
												end
												return v62 == arg4 and (n31 % 527 + n31 % 476) % 476 + 378
											end
										end
										local v62, v63 = fn16(381029379, 0)
										local n31 = v62 % 944 * 22 + 50
										local n32 = v62 % 944 * 22 + 50
										local tbl12 = { [v63(v62, 344378883)] = true }
										
										do

end
									else
										str2 = str .. "/" .. selectedpath .. ".json"
									end
								end
								if isfile(str2) then
									delfile(str2)
								end
								v60:setoptions(refreshpathlist())
								v60:set(nil)
								library:Notify({ text = "Deleted Path", highlights = { selectedpath }, time = 3 })
							end,
						})
						v59:button({
							name = "Refresh",
							callback = function()
								
								v60:setoptions(refreshpathlist())
								library:Notify({ text = "Refreshed Paths", time = 3 })
							end,
						})
						v59:textbox({
							name = "Import",
							flag = "importpathtext",
							default = "",
							callback = function(arg2)
								
								
								
								if not arg2 or arg2 == "" then
									return
								end
								local v61 = pcall
								local n31 = 127586645
								local function fn16()
									
									local flag2 = bit32.bxor(n31 % 4294967296 - n31 % 4294967296 % 1, 0) ~= 463852486
									return httpService:JSONDecode(arg2)
								end
								
								
								n31 = 463852486
								local v62, v63 = v61(fn16)
								local v64 = v63
								if not v62 or type(v64) ~= "table" then
									library:Notify({ text = "Invalid Path JSON", time = 3 })
									return
								end
								local v65 = ipairs
								local pathpoints = tbl7.pathpoints
								
								for _, pathpoint in v65(pathpoints) do
									if pathpoint.part then
										pathpoint.part:Destroy()
									end
									if tbl7.pointguis[pathpoint] and tbl7.pointguis[pathpoint].Parent then
										tbl7.pointguis[pathpoint]:Destroy()
									end
								end
								for _, pathdot in ipairs(tbl7.pathdots) do
									if pathdot and pathdot.Parent then
										pathdot:Destroy()
									end
								end
								for _, pathsegment in pairs(tbl7.pathsegments) do
									if pathsegment and pathsegment.dots then
										for _, dot in pairs(pathsegment.dots) do
											if dot and dot.Parent then
												dot:Destroy()
											end
										end
									end
								end
								table.clear(tbl7.pathpoints)
								table.clear(tbl7.pathparts)
								
								table.clear(tbl7.pointbypart)
								table.clear(tbl7.pointguis)
								table.clear(tbl7.pathdots)
								table.clear(tbl7.groundpoints)
								table.clear(tbl7.pathsegments)
								tbl5.selectedpoint = nil
								tbl5.draggingpoint = nil
								tbl5.draggingpart = nil
								for _, v67 in ipairs(v64) do
									if v67.x and v67.y and v67.z then
										createpoint(Vector3.new(v67.x, v67.y, v67.z), true)
										local v68 = tbl7.pathpoints[#tbl7.pathpoints]
										if v68 then
											v68.jump = v67.jump == true
											local wait_ = tonumber(v67.wait)
											v68.wait = wait_ or 0
											v68.dotrate = math.clamp(tonumber(v67.dotrate) or 1, 0, 25)
											v68.equip = tonumber(v67.equip)
											v68.equipenable = v67.equipenable == true and type(v68.equip) == "number"
										end
									end
									task.wait()
								end
								for i, pathpoint in ipairs(tbl7.pathpoints) do
									if pathpoint.label then
										pathpoint.label.Text = "Index: " .. i
									end
								end
								refreshsegments()
								library:Notify({ text = "Imported Path", highlights = { tostring(#v64) .. " Points" }, time = 3 })
							end,
						})
						v59:button({
							name = "Set To Clipboard",
							callback = function()
								
								if tbl6.goldfarmbyZachloaded then
									library:Notify({ text = "Cannot set default paths to clipboard", time = 5 })
									return
								end
								local tbl12 = {}
								for _, pathpoint in ipairs(tbl7.pathpoints) do
									if pathpoint.part then
										local position = pathpoint.part.Position
										local insert = table.insert
										local tbl13 = { x = position.X, y = position.Y, z = position.Z, jump = pathpoint.jump == true }
										local wait_ = tonumber(pathpoint.wait)
										tbl13.wait = wait_ or 0
										tbl13.dotrate = tonumber(pathpoint.dotrate) or 1
										tbl13.equipenable = pathpoint.equipenable == true
										tbl13.equip = tonumber(pathpoint.equip)
										insert(tbl12, tbl13)
									end
								end
								setclipboard(httpService:JSONEncode(tbl12))
								library:Notify({ text = "Set Path To Clipboard", highlights = { tostring(#tbl12) .. " Points" }, time = 3 })
							end,
						})
					end
					local v54
					v54 = bit32.bxor(v53, n27 % 4294967296 - n27 % 4294967296 % 1)
					local v55
					v55 = v37:tab({ name = "Config" })
					cfgname = v55:textbox({
						name = "Config Name",
						flag = "cfgname",
						callback = function()
							
						end,
					})
					cfglist = v55:dropdown({
						name = "Config List",
						flag = "selectedcfg",
						options = library.ConfigManager:RefreshConfigList(),
						max = 1,
						callback = function()
							
						end,
					})
					getcfglist = function()
						
						local flag2 = type(cfglist) == "table"
						if flag2 and type(cfglist.setoptions) == "function" and type(cfglist.set) == "function" then
							return cfglist
						end
						local selectedcfg = library.items.selectedcfg
						if selectedcfg and type(selectedcfg) == "table" and type(selectedcfg.setoptions) == "function" and type(selectedcfg.set) == "function" then
							cfglist = selectedcfg
							return selectedcfg
						end
						return nil
					end
					updatecfglist = function(arg2)
						
						local v56 = getcfglist()
						if not v56 then
							warn("Config List dropdown is nil or invalid")
							return false
						end
						v56:setoptions(library.ConfigManager:RefreshConfigList())
						if arg2 ~= nil then
							v56:set(arg2)
						end
						return true
					end
					local function fn12()
						
						local selectedcfg = library.flags.selectedcfg
						if type(selectedcfg) == "table" then
							selectedcfg = selectedcfg[1]
						end
						if not selectedcfg or selectedcfg == "" then
							return nil
						end
						return selectedcfg
					end
					getselectedcfg = fn12
					task.defer(function()
						
						updatecfglist()
					end)
					v55:button({
						name = "Create",
						callback = function()
							
							local cfgname_ = library.flags.cfgname
							local v56, v57 = library.ConfigManager:CreateConfig(cfgname_)
							if v56 then
								updatecfglist(cfgname_)
								library:Notify({ text = "Created config", time = 3, highlights = { tostring(cfgname_) } })
							else
								library:Notify({ text = "Create failed", time = 3, highlights = { tostring(v57) } })
							end
						end,
					})
					v55:button({
						name = "Save",
						confirm = true,
						callback = function()
							
							local v56 = getselectedcfg()
							if not v56 then
								library:Notify({ text = "Save failed", time = 3, highlights = { "no config selected" } })
								return
							end
							local v57, v58 = library.ConfigManager:SaveConfig(v56)
							if v57 then
								updatecfglist(v56)
								library:Notify({ text = "Saved config", time = 3, highlights = { tostring(v56) } })
							else
								library:Notify({ text = "Save failed", time = 3, highlights = { tostring(v58) } })
							end
						end,
					})
					v55:button({
						name = "Load",
						confirm = true,
						callback = function()
							
							local v56 = getselectedcfg()
							if not v56 then
								library:Notify({ text = "Load failed", time = 3, highlights = { "no config selected" } })
								return
							end
							local v57, v58 = library.ConfigManager:LoadConfig(v56)
							if v57 then
								updatecfglist(v56)
								library:Notify({ text = "Loaded config", time = 3, highlights = { tostring(v56) } })
							else
								library:Notify({ text = "Load failed", time = 3, highlights = { tostring(v58) } })
							end
						end,
					})
					v55:button({
						name = "Delete",
						confirm = true,
						callback = function()
							
							local v56 = getselectedcfg()
							if not v56 then
								library:Notify({ text = "Delete failed", time = 3, highlights = { "no config selected" } })
								return
							end
							local v57, v58 = library.ConfigManager:DeleteConfig(v56)
							if v57 then
								updatecfglist(nil)
								library:Notify({ text = "Deleted config", time = 3, highlights = { tostring(v56) } })
							else
								library:Notify({ text = "Delete failed", time = 3, highlights = { tostring(v58) } })
							end
						end,
					})
					v55:button({ name = "Refresh", callback = updatecfglist })
					v55:button({
						name = "Set Autoload",
						callback = function()
							
							local v56 = getselectedcfg()
							if not v56 then
								local flag2 = not library
								local n
								if flag2 then
									n = -(-nil)
								else
									n = library
									flag2 = n.Notify
								end
								flag2(n, { text = "Autoload failed", time = 3, highlights = { "no config selected" } })
								return
							end
							local v57, v58 = library.ConfigManager:SetAutoload(v56)
							if v57 then
								library:Notify({ text = "Autoload set", time = 3, highlights = { tostring(v56) } })
							else
								library:Notify({ text = "Autoload failed", time = 3, highlights = { tostring(v58) } })
							end
						end,
					})
					v55:textbox({
						name = "Import",
						flag = "importcfgtext",
						default = "",
						callback = function(arg2)
							
							if not arg2 or arg2 == "" then
								return
							end
							local function fn13()
								
								return httpService:JSONDecode(arg2)
							end
							local ok, result = pcall(fn13)
							if not ok or type(result) ~= "table" then
								library:Notify({ text = "Invalid Config JSON", time = 3 })
								return
							end
							local ok2, result2 = pcall(function()
								
								library.ConfigManager:Load(result)
							end)
							if not ok2 then
								library:Notify({ text = "Import failed", time = 3, highlights = { tostring(result2) } })
								return
							end
							library:Notify({ text = "Imported Config", time = 3 })
						end,
					})
					v55:button({
						name = "Set To Clipboard",
						tooltip = "Set current settings to clipboard",
						callback = function()
							
							local v56 = library.ConfigManager:Save()
							setclipboard(httpService:JSONEncode(v56))
							library:Notify({ text = "Set Config To Clipboard", time = 3 })
						end,
					})
					v55:label({ name = "Accent Color" }):colorpicker({
						color = library.accent,
						flag = "accent",
						callback = function(arg2)
							
							library:updateColorGroup({ value = arg2, store = "accent", accentMode = true })
						end,
					})
					v55:label({ name = "Background Color" }):colorpicker({
						color = library.backgroundcolor,
						flag = "backgroundcolor",
						callback = function(arg2)
							
							library:updateColorGroup({ value = arg2, store = "backgroundcolor", propsAttribute = "BackgroundProps" })
						end,
					})
					v55:label({ name = "Content Color" }):colorpicker({
						color = library.contentcolor,
						flag = "contentcolor",
						callback = function(arg2)
							
							library:updateColorGroup({ value = arg2, store = "contentcolor", propsAttribute = "ContentProps" })
						end,
					})
					v55:label({ name = "Button Color" }):colorpicker({
						color = library.buttoncolor,
						flag = "buttoncolor",
						callback = function(arg2)
							
							library:updateColorGroup({
								value = arg2,
								store = "buttoncolor",
								propsAttribute = "Buttons",
								disabledAttribute = "ButtonDisabled",
							})
						end,
					})
					local v56 = v55:label({ name = "Stroke Color" })
					v56:colorpicker({
						color = library.stroke,
						flag = "stroke",
						callback = function(arg2)
							
							library:updateColorGroup({
								value = arg2,
								store = "stroke",
								propsAttribute = "StrokeProps",
								disabledAttribute = "StrokeDisabled",
							})
						end,
					})
					v56:colorpicker({
						color = library.stroke2,
						flag = "stroke2",
						callback = function(arg2)
							
							library:updateColorGroup({
								value = arg2,
								store = "stroke2",
								propsAttribute = "StrokeProps2",
								disabledAttribute = "Stroke2Disabled",
							})
						end,
					})
					local function fn13(arg2)
						
						library:updateColorGroup({
							value = arg2,
							store = "textcolor",
							propsAttribute = "TextProps",
							disabledAttribute = "TextDisabled",
						})
					end
					v55:label({ name = "Text Color" }):colorpicker({ color = library.textcolor, flag = "textcolor", callback = fn13 })
					local function fn14(arg2)
						
						library:updateColorGroup({ value = arg2, store = "misccolor", propsAttribute = "MiscProps" })
					end
					v55:label({ name = "Misc's Color" }):colorpicker({ color = library.misccolor, flag = "misccolor", callback = fn14 })
					local n = n27 + n28
					v55:label({ name = "Show Gui" }):keybind({
						default = Enum.KeyCode.RightControl,
						state = true,
						mode = "Toggle",
						flag = "showgui",
						callback = function(arg2)
							
							library:toggle(arg2)
						end,
					})
					local function fn15(visible)
						
						watermark.Visible = visible
					end
					v55:toggle({
						name = "Show Watermark",
						flag = "showwatermark",
						state = false,
						callback = fn15,
					})
					v55:toggle({
						name = "Show Keybind List",
						state = v25.TouchEnabled,
						flag = "showkeybinds",
						callback = function(arg2)
							
							library.keybindListVisible = arg2 == true
							local v57 = KeybindContainer
							local keybindListVisible = library.keybindListVisible
							v57.Visible = keybindListVisible and not library.mobileKeybindMode
							if library.mobileKeybindMode then
								for k in next, library.mobileKeybindButtons, nil do
									if k.ApplyMobileKeybindMode then
										k:ApplyMobileKeybindMode()
									end
								end
							end
						end,
					})
					if v25.TouchEnabled then
						v55:toggle({
							name = "Show Mobile Toggle",
							state = v25.TouchEnabled,
							flag = "showmobilebutton",
							callback = function(visible)
								
								MobileButton.Visible = visible
							end,
						})
					end
					v55:button({
						name = "Unload",
						confirm = true,
						callback = function()
							
							library:Unload()
						end,
					})
					local str = ""
					library:connect(game:GetService("RunService").Heartbeat, function()
						
						
						
						if not library.flags.showwatermark then
							return
						end
						local dataPing = game:GetService("Stats"):FindFirstChild("Network") and game:GetService("Stats").Network:FindFirstChild("ServerStatsItem") and game:GetService("Stats").Network.ServerStatsItem:FindFirstChild("Data Ping")
						if not dataPing then
							return
						end
						local v57 = os.date("%H:%M:%S")
						local str2 = string.format("Boo | %d ms | %s", math.floor(dataPing:GetValue()), v57)
						if str2 ~= str then
							str = str2
							library:setwatermark(str2)
						end
					end)
					local autoload = library.ConfigManager:GetAutoload()
					if autoload then
						local v57, v58 = library.ConfigManager:LoadConfig(autoload)
						if v57 then
							cfglist:setoptions(library.ConfigManager:RefreshConfigList())
							local v59 = bit32.bxor(v54, 0)
							cfglist:set(autoload)
							library:Notify({ text = "Autoloaded config", highlights = { tostring(autoload) }, time = 3 })
							bit32.bxor(v59, 3643403938)
						else
							library:Notify({ text = "Autoload failed", highlights = { tostring(v58) }, time = 3 })
						end
						library.loaded = true
					else
						library.loaded = true
					end
					library:connect(v16.RenderStepped, function()local r,R= v24 ;local R= library ;r.FogStart=R.flags.nofog and 1/0 or 100;R,r= v24 , library ;R.FogEnd=r.flags.nofog and 1/0 or 1000;R,r= localPlayer , library ;R.CameraMaxZoomDistance=r.flags.maxzoom;R=not  flag and  tbl2 .settings.enabled;if R then local p,p= library ,math.clamp(tonumber( library .flags.espfps)or 60,1,240);r=tick()- n14 >=1/p;if r then  n14 =tick();p= fn4 ;p();end;end;r,R= humanoid ;if r then local p= library ;R=not p.flags.freecam;else R=r;end;if R then r= library ;local p=r.flags.enablewalkspeed;if p then set( humanoid ,"WalkSpeed", library .flags.walkspeed);end;set( humanoid ,"JumpPower", library .flags.jumppower);else local p,V= humanoid ;if p then local e= library ;V=e.flags.freecam;else V=p;end;if V then set( humanoid ,"WalkSpeed",0);set( humanoid ,"JumpPower",0);end;end;R=not  character or not  character .Parent;if R then return;end;R=not  humanoid or not  humanoid .Parent or  humanoid .Health<=0;if R then return;end;r=not  humanoidRootPart or not  humanoidRootPart .Parent;if r then return;end;r=nil;R= library ;local p,V=not R.flags.killaura;if p then R= library ;V=not R.flags.resourceaura;else V=p;end;if V then R= tbl5 ;p=R.killaurahighlight;if p then local e= tbl5 ;e.killaurahighlight:Destroy();e= tbl5 ;e.killaurahighlight=nil;end;local e= tbl5 ;e.killauratarget=nil;e= tbl6 ;e.isHitting=false;e= tbl6 ;e.ismineauraing=false;return;end;R= localPlayer ;if not R:GetAttribute("hasSpawned")then return;end;R=nil;V= character .Tools:GetChildren();local Y,e=#V==1;if Y then p=V[1];R=if p:IsA("Model")then p else R;else local e=#V>1;if e then local e=pairs;for P,b in e(V)do P=b:IsA("Model");local e;if P then local i;i,e= tbl7 ,table.find( tbl7 .weapons,b.Name)or b.Name:find("Axe")or b.Name:find("Pick");else e=P;end;if e then R=b;break;end;end;else end;end;if not R then return;end;V= library ;Y,p=V.flags.killaura;if Y then V=nil;V,p= tbl7 ,table.find( tbl7 .weapons,R.Name)or R.Name:find("Axe")or R.Name:find("Pick");else p=Y;end;if p then r=getTarget();Y=not r;if Y then V= tbl5 ;local e=V.killaurahighlight;if e then local P= tbl5 ;P.killaurahighlight:Destroy();P= tbl5 ;P.killaurahighlight=nil;end;e= tbl5 ;e.killauratarget=nil;else aura(r);local e= tbl6 ;e.isHitting=true;end;else local e= tbl5 ;local P=e.killaurahighlight;if P then e= tbl5 ;e.killaurahighlight:Destroy();local b= tbl5 ;b.killaurahighlight=nil;end;P= tbl5 ;P.killauratarget=nil;e= tbl6 ;e.isHitting=false;end;Y= tbl6 ;p,V=not Y.isHitting;if p then Y= library ;V=Y.flags.resourceaura;else V=p;end;p=nil;if V then Y=nil;Y,p= tbl7 ,table.find( tbl7 .weapons,R.Name)or R.Name:find("Axe")or R.Name:find("Pick");else p=V;end;if p then if r then return;end;Y= tbl7 ;R=#Y.validmineaura>0;if R then V=getresource();if V then local r= library ;local p=r.flags.resourceauraface;if p then  character :PivotTo(CFrame.lookAt( humanoidRootPart .Position,Vector3.new(V:GetPivot().Position.X, humanoidRootPart .Position.Y,V:GetPivot().Position.Z)));end;resourceaura(V);r= tbl6 ;r.ismineauraing=true;else local r= tbl6 ;r.ismineauraing=false;end;else local r= tbl6 ;r.ismineauraing=false;end;local r,r= tbl9 ,tick()- tbl9 .lastmineauracache>=0.1;if r then local r= tbl9 ;r.lastmineauracache=tick();table.clear( tbl7 .validmineaura);table.clear( tbl7 .checkedmineaura);r= library ;if not r.flags.resourceaura then return;end;r=not  character or not  humanoidRootPart ;if r then return;end;r=OverlapParams.new();r.FilterType=Enum.RaycastFilterType.Exclude;local p,Y,Y={};local Y,Y,Y,Y= v19 , v19 , v19 , v20 ; appendCapturedArguments ( nil, p,0, character , v19 .Players, v19 .Terrain, v19 .Items, v20 :GetTagged("Contents"));r.FilterDescendantsInstances=p;p= v19 ;local j,j,j,j= library , library , library ,p:GetPartBoundsInBox( character :GetPivot(),Vector3.new( library .flags.resourceaurasize*2.5, library .flags.resourceaurasize*2.5, library .flags.resourceaurasize*2.5),r);p=#j;for Y=1,p,1 do r=j[Y]:FindFirstAncestorWhichIsA("Model");Y=nil;if r then local j= tbl7 ;Y=not j.checkedmineaura[r];else Y=r;end;local j=Y and r.Parent and r:IsA("Model");if j then Y= library ;local j,p=Y.flags.resourceauratargets,false;local X=j=="Resources"or type(j)=="table"and table.find(j,"Resources");if X then local Y,Y,V= v19 ,r.Parent== v19 .Resources;if Y then V=Y;else local Y;Y,V= v19 ,r.Parent== v19 .Mounds;end;p=if V or r.Name=="Gold Node"or r.Name=="Iron Node"or r.Name=="Coal Node"or r.Name=="Meteor Core"or r.Name=="Crystal Meteor Core"or r.Name=="Crystal Meteor Rock"or r.Name=="Magnetite Meteor Rock"or r.Name=="Small Rock"or r.Name=="Meteor Rock"then true else p;else end;X=not p and(j=="Critters"or type(j)=="table"and table.find(j,"Critters"));if X then local Y;Y,p= v19 ,if r.Parent== v19 .Critters then true else p;else end;X=not p and(j=="Deployables"or type(j)=="table"and table.find(j,"Deployables"));if X then local Y;Y,p= v19 ,if r.Parent== v19 .Deployables then true else p;else end;X=not p and(j=="Rubble"or type(j)=="table"and table.find(j,"Rubble"));if X then j=nil;j,p= v19 ,if r.Parent== v19 .Rubble then true else p;else end;if p then X= tbl7 ;X.checkedmineaura[r]=true;local j,p= tbl7 ;p,j.validmineaura[# tbl7 .validmineaura+1]= tbl7 ,r;end;end;end;end;end;end)
					do
						local v57 = library
						local connect = v57.connect
						local heartbeat = v16.Heartbeat
						bit32.bxor(v54, 3313901026)
						local v58 = (function(...) return function(__lph_capture_array_2000342, __lph_unused_1)
	return function(arg)
		
		
		if not __lph_capture_array_2000342[1][5][__lph_capture_array_2000342[1][4]] or not __lph_capture_array_2000342[1][5][__lph_capture_array_2000342[1][4]].Parent then
			return
		end
		if not __lph_capture_array_2000342[2][5][__lph_capture_array_2000342[2][4]] or not __lph_capture_array_2000342[2][5][__lph_capture_array_2000342[2][4]].Parent or __lph_capture_array_2000342[2][5][__lph_capture_array_2000342[2][4]].Health <= 0 then
			return
		end
		if not __lph_capture_array_2000342[3][5][__lph_capture_array_2000342[3][4]] or not __lph_capture_array_2000342[3][5][__lph_capture_array_2000342[3][4]].Parent then
			return
		end
		local sendlowbloodfruit = __lph_capture_array_2000342[4].sendlowbloodfruit
		
		if sendlowbloodfruit then
			__lph_capture_array_2000342[4].sendlowbloodfruit = false
			local inventory = __lph_capture_array_2000342[5].inventory
			
			local bloodfruit = inventory.Bloodfruit
			local inventory2 = bloodfruit and __lph_capture_array_2000342[6].Data.inventory and __lph_capture_array_2000342[6].Data.inventory[bloodfruit]
			__lph_capture_array_2000342[7]:Notify({
				text = "Warning! You have " .. tostring(tonumber(inventory2 and inventory2.quantity) or 0) .. " Bloodfruits",
				time = 5,
			})
			
		end
		if __lph_capture_array_2000342[4].updateautodropdropdown then
			if __lph_capture_array_2000342[8].autodropdropdown then
				__lph_capture_array_2000342[8].autodropdropdown:setoptions(__lph_capture_array_2000342[5].inventorylist)
			end
			__lph_capture_array_2000342[4].updateautodropdropdown = false
		end
		local model = __lph_capture_array_2000342[1][5][__lph_capture_array_2000342[1][4]]:FindFirstChild("Tools"):FindFirstChildOfClass("Model")
		if model then
			local lower = string.lower
			
			local name = model.Name
			
			lower(name)
			
			
		end
		set(__lph_capture_array_2000342[2][5][__lph_capture_array_2000342[2][4]], "MaxSlopeAngle", __lph_capture_array_2000342[7].flags.maxslopeangle)
		set(__lph_capture_array_2000342[2][5][__lph_capture_array_2000342[2][4]], "HipHeight", __lph_capture_array_2000342[7].flags.hipheight)
		if __lph_capture_array_2000342[7].flags.freecam then
			local currentCamera = __lph_capture_array_2000342[9].CurrentCamera
			if not currentCamera then
				return
			end
			if __lph_capture_array_2000342[9].CurrentCamera.CameraType ~= Enum.CameraType.Scriptable then
				local v2 = __lph_capture_array_2000342[9]
				
				v2.CurrentCamera.CameraType = Enum.CameraType.Scriptable
			end
			__lph_capture_array_2000342[8].freecamCFrame = __lph_capture_array_2000342[8].freecamCFrame or currentCamera.CFrame
			local mouseDelta = __lph_capture_array_2000342[10]:GetMouseDelta()
			
			if mouseDelta.X ~= 0 or mouseDelta.Y ~= 0 then
				local freecamvars = __lph_capture_array_2000342[8].freecamvars
				freecamvars.freecamYaw = freecamvars.freecamYaw - mouseDelta.X * __lph_capture_array_2000342[7].flags.freecamsensitivity * 0.001
				local freecamvars2 = __lph_capture_array_2000342[8].freecamvars
				local freecamPitch = freecamvars2.freecamPitch
				
				freecamvars2.freecamPitch = freecamPitch - mouseDelta.Y * __lph_capture_array_2000342[7].flags.freecamsensitivity * 0.001
				__lph_capture_array_2000342[8].freecamvars.freecamPitch = math.clamp(__lph_capture_array_2000342[8].freecamvars.freecamPitch, -1.5533430342749532, 1.5533430342749532)
			end
			local cframe = CFrame.fromOrientation
			local freecamPitch = __lph_capture_array_2000342[8].freecamvars.freecamPitch
			local freecamYaw = __lph_capture_array_2000342[8].freecamvars.freecamYaw
			
			
			local v3 = cframe(freecamPitch, freecamYaw, 0)
			local n4 = 0
			if __lph_capture_array_2000342[5].freecamKeys.W then
				n4 = -1
			end
			if __lph_capture_array_2000342[5].freecamKeys.S then
				n4 += 1
			end
			local n5 = 0
			if __lph_capture_array_2000342[5].freecamKeys.A then
				n5 = -1
			end
			if __lph_capture_array_2000342[5].freecamKeys.D then
				n5 += 1
			end
			local n6 = 0
			if __lph_capture_array_2000342[5].freecamKeys.E then
				n6 = 1
			end
			if __lph_capture_array_2000342[5].freecamKeys.Q then
				n6 -= 1
			end
			if __lph_capture_array_2000342[8].freecamdir and __lph_capture_array_2000342[8].freecamdir.Magnitude > 0.01 then
				local v4 = __lph_capture_array_2000342[8]
				
				
				n5 += v4.freecamdir.X
				n4 += __lph_capture_array_2000342[8].freecamdir.Z
				
				
			end
			local flag = n5 ~= 0
			if not flag then
				flag = n6 ~= 0
				
			end
			if not flag then
				
				flag = n4 ~= 0
			end
			if flag then
				local freecamspeed = __lph_capture_array_2000342[7].flags.freecamspeed or 60
				if __lph_capture_array_2000342[10].TouchEnabled and mouseHoldingJoystick and __lph_capture_array_2000342[8].freecamMoveCenter then
					
					freecamspeed *= math.clamp((math.min((__lph_capture_array_2000342[10]:GetMouseLocation() - __lph_capture_array_2000342[8].freecamMoveCenter).Magnitude, 60) - 15) / 45, 0, 1)
				end
				if __lph_capture_array_2000342[10]:IsKeyDown(Enum.KeyCode.LeftShift) or __lph_capture_array_2000342[10]:IsKeyDown(Enum.KeyCode.RightShift) then
					freecamspeed *= 0.25
				end
				local v4 = __lph_capture_array_2000342[8]
				
				
				v4.freecamCFrame = v4.freecamCFrame + v3:VectorToWorldSpace(Vector3.new(n5, n6, n4).Unit) * freecamspeed * arg
			end
			currentCamera.CFrame = CFrame.new(__lph_capture_array_2000342[8].freecamCFrame.Position) * v3
			
			
		end
		if not __lph_capture_array_2000342[11]:GetAttribute("hasSpawned") then
			return
		end
		local autopickup = __lph_capture_array_2000342[7].flags.autopickup or __lph_capture_array_2000342[7].flags.autodelete
		if not autopickup then
			autopickup = __lph_capture_array_2000342[7].flags.autochestitems
			
		end
		if autopickup then
			table.clear(__lph_capture_array_2000342[5].validitems)
			table.clear(__lph_capture_array_2000342[5].chestitems)
			table.clear(__lph_capture_array_2000342[5].checkeditems)
			local overlapParams = OverlapParams.new()
			overlapParams.FilterType = Enum.RaycastFilterType.Exclude
			overlapParams.MaxParts = 1000
			local filterDescendantsInstances = {}
			local v2 = __lph_capture_array_2000342[1][5][__lph_capture_array_2000342[1][4]]
			
			local players = __lph_capture_array_2000342[9].Players
			local terrain = __lph_capture_array_2000342[9].Terrain
			local resources = __lph_capture_array_2000342[9].Resources
			
			local critters = __lph_capture_array_2000342[9].Critters
			local rubble = __lph_capture_array_2000342[9].Rubble
			filterDescendantsInstances[1] = v2
			filterDescendantsInstances[2] = players
			filterDescendantsInstances[3] = terrain
			filterDescendantsInstances[4] = resources
			filterDescendantsInstances[5] = critters
			filterDescendantsInstances[6] = rubble
			overlapParams.FilterDescendantsInstances = filterDescendantsInstances
			local position = __lph_capture_array_2000342[1][5][__lph_capture_array_2000342[1][4]]:GetPivot().Position
			local partBoundsInBox = __lph_capture_array_2000342[9]:GetPartBoundsInBox(__lph_capture_array_2000342[1][5][__lph_capture_array_2000342[1][4]]:GetPivot(), Vector3.new(50, 50, 50), overlapParams)
			
			local exitTo = nil
			for i = 1, #partBoundsInBox do
				if overlapParams.MaxParts < i then
					exitTo = 1
					break
				else
					local v4 = partBoundsInBox[i]
					local model2 = v4 and v4:FindFirstAncestorWhichIsA("Model")
					local contents = v4 and v4:FindFirstAncestor("Contents")
					if not (v4 and v4.Parent == __lph_capture_array_2000342[9].Items) then
						if model2 and model2.Parent == __lph_capture_array_2000342[9].Items then
							v4 = model2
						else
							local autopickupchests = __lph_capture_array_2000342[7].flags.autopickupchests and contents
							
							if autopickupchests then
								if v4.Parent ~= contents then
									local flag = model2 and model2.Parent == contents
									v4 = nil
									if flag then
										v4 = model2
									end
								end
							else
								v4 = nil
							end
						end
					end
					if v4 and not __lph_capture_array_2000342[5].checkeditems[v4] and v4.Parent then
						if not (v4:IsA("Model") and v4:GetPivot().Position) then
							local position2 = v4.Position
						end
						__lph_capture_array_2000342[5].validitems[#__lph_capture_array_2000342[5].validitems + 1] = v4
						__lph_capture_array_2000342[5].checkeditems[v4] = true
					end
				end
			end
			if exitTo ~= 1 then
			end
			
			
		end
		local v2 = __lph_capture_array_2000342[7]
		local v3 = 50786977
		if v2.flags.autodelete then
			local tbl = {}
			local autodeletetargets = __lph_capture_array_2000342[7].flags.autodeletetargets
			if type(autodeletetargets) == "string" then
				tbl[autodeletetargets] = true
			elseif type(autodeletetargets) == "table" then
				for _, autodeletetarget in pairs(autodeletetargets) do
					tbl[autodeletetarget] = true
				end
			end
			for k, validitem in pairs(__lph_capture_array_2000342[5].validitems) do
				if not (__lph_capture_array_2000342[7].flags.autodeleterange <= (__lph_capture_array_2000342[3][5][__lph_capture_array_2000342[3][4]].Position - validitem:GetPivot().Position).Magnitude) then
					if tbl.All or tbl[validitem.Name] then
						validitem:Destroy()
						__lph_capture_array_2000342[5].validitems[k] = nil
						__lph_capture_array_2000342[5].checkeditems[validitem] = nil
					end
				end
			end
		end
		local chosenchest = __lph_capture_array_2000342[7].flags.autochestitems and __lph_capture_array_2000342[8].chosenchest
		if chosenchest then
			local v4 = __lph_capture_array_2000342[8]
			
			chosenchest = v4.chosenchest.model
			v3 = 50786977
		end
		if chosenchest and not __lph_capture_array_2000342[4].autopotioning and not __lph_capture_array_2000342[4].autoChestItemsRunning then
			__lph_capture_array_2000342[4].autoChestItemsRunning = true
			task.spawn(function()
				
				
				local n4 = 95231375
				local chosenchest2 = __lph_capture_array_2000342[8].chosenchest
				
				if chosenchest2 then
					
					chosenchest2 = __lph_capture_array_2000342[8].chosenchest.model
				else
					
				end
				if chosenchest2 then
					local chosenchest3 = __lph_capture_array_2000342[8].chosenchest
					
					chosenchest2 = chosenchest3.model:FindFirstChild("Hitbox")
					
				end
				if not chosenchest2 then
					__lph_capture_array_2000342[4].autoChestItemsRunning = false
					return
				end
				local tbl = {}
				local autochesttargets = __lph_capture_array_2000342[7].flags.autochesttargets
				if type(autochesttargets) == "string" then
					tbl[autochesttargets] = true
				else
					
					
					if type(autochesttargets) == "table" then
						for k, autochesttarget in pairs(autochesttargets) do
							if type(autochesttarget) == "string" then
								tbl[autochesttarget] = true
							elseif type(k) == "string" and autochesttarget == true then
								tbl[k] = true
							end
						end
					end
					
					n4 = 95231375
				end
				for _, validitem in pairs(__lph_capture_array_2000342[5].validitems) do
					if not (not validitem or not validitem.Parent) then
						if not (not tbl.All and tbl[validitem.Name] ~= true) then
							local attribute = validitem:GetAttribute("EntityID")
							if attribute then
								if not (__lph_capture_array_2000342[5].lastChestItemInteract[attribute] and tick() - __lph_capture_array_2000342[5].lastChestItemInteract[attribute] < 0.01) then
									local n6 = n4 % 4294967296 - n4 % 4294967296 % 1 + 2310338914 - 0
									local n7 = n6 % 4294967296 - n6 % 4294967296 % 1
									local n8
									if (__lph_capture_array_2000342[3][5][__lph_capture_array_2000342[3][4]].Position - validitem:GetPivot().Position).Magnitude <= 25 then
										__lph_capture_array_2000342[5].lastChestItemInteract[attribute] = tick()
										local parent, flag
										if validitem:IsA("Model") then
											if validitem.PrimaryPart and validitem.PrimaryPart.Anchored then
												if __lph_capture_array_2000342[5].chestteleports[validitem] and tick() - __lph_capture_array_2000342[5].chestteleports[validitem] > game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000 then
													local n9 = n7 % 4294967296 - n7 % 4294967296 % 1 + 1984628382
													n4 = n9 % 4294967296 - n9 % 4294967296 % 1
												else
													firepacket("ForceInteract", attribute)
													local n9 = n7 % 4294967296 - n7 % 4294967296 % 1 + 2147483648
													__lph_capture_array_2000342[5].chestteleports[validitem] = tick()
													task.wait(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000)
													__lph_capture_array_2000342[5].chestteleports[validitem] = nil
													local n10 = n9 % 4294967296 - n9 % 4294967296 % 1 + 2147483648
													n7 = n10 % 4294967296 - n10 % 4294967296 % 1
													parent = validitem and validitem.Parent and chosenchest2 and chosenchest2.Parent
													if parent then
														if validitem:IsA("Model") then
															flag = validitem.PrimaryPart and not validitem.PrimaryPart.Anchored
															if flag then
																validitem:PivotTo(chosenchest2.CFrame)
															end
														elseif validitem:IsA("BasePart") then
															if not validitem.Anchored then
																validitem:PivotTo(chosenchest2.CFrame)
															end
														end
													end
													n8 = n7 % 4294967296 - n7 % 4294967296 % 1 + 1984628382
													n4 = n8 % 4294967296 - n8 % 4294967296 % 1
												end
												continue
											else
												parent = validitem and validitem.Parent and chosenchest2 and chosenchest2.Parent
												if parent then
													if validitem:IsA("Model") then
														flag = validitem.PrimaryPart and not validitem.PrimaryPart.Anchored
														if flag then
															validitem:PivotTo(chosenchest2.CFrame)
														end
													elseif validitem:IsA("BasePart") then
														if not validitem.Anchored then
															validitem:PivotTo(chosenchest2.CFrame)
														end
													end
												end
											end
										else
											if validitem:IsA("BasePart") then
												if validitem.Anchored then
													local flag2 = __lph_capture_array_2000342[5].chestteleports[validitem]
													if flag2 then
														flag2 = tick() - __lph_capture_array_2000342[5].chestteleports[validitem] > game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
														local n9 = n7 % 4294967296 - n7 % 4294967296 % 1 + 2337662800
														local n10 = n9 % 4294967296 - n9 % 4294967296 % 1 + 1957304496
														n7 = n10 % 4294967296 - n10 % 4294967296 % 1
													end
													if flag2 then
														local n9 = n7 % 4294967296 - n7 % 4294967296 % 1 + 1984628382
														n4 = n9 % 4294967296 - n9 % 4294967296 % 1
													else
														firepacket("ForceInteract", attribute)
														__lph_capture_array_2000342[5].chestteleports[validitem] = tick()
														task.wait(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000)
														__lph_capture_array_2000342[5].chestteleports[validitem] = nil
														parent = validitem and validitem.Parent and chosenchest2 and chosenchest2.Parent
														if parent then
															if validitem:IsA("Model") then
																flag = validitem.PrimaryPart and not validitem.PrimaryPart.Anchored
																if flag then
																	validitem:PivotTo(chosenchest2.CFrame)
																end
															elseif validitem:IsA("BasePart") then
																if not validitem.Anchored then
																	validitem:PivotTo(chosenchest2.CFrame)
																end
															end
														end
														n8 = n7 % 4294967296 - n7 % 4294967296 % 1 + 1984628382
														n4 = n8 % 4294967296 - n8 % 4294967296 % 1
														continue
													end
												else
													parent = validitem and validitem.Parent and chosenchest2 and chosenchest2.Parent
													if parent then
														if validitem:IsA("Model") then
															flag = validitem.PrimaryPart and not validitem.PrimaryPart.Anchored
															if flag then
																validitem:PivotTo(chosenchest2.CFrame)
															end
														elseif validitem:IsA("BasePart") then
															if not validitem.Anchored then
																validitem:PivotTo(chosenchest2.CFrame)
															end
														end
													end
													n8 = n7 % 4294967296 - n7 % 4294967296 % 1 + 1984628382
													n4 = n8 % 4294967296 - n8 % 4294967296 % 1
													continue
												end
											else
												parent = validitem and validitem.Parent and chosenchest2 and chosenchest2.Parent
												if parent then
													if validitem:IsA("Model") then
														flag = validitem.PrimaryPart and not validitem.PrimaryPart.Anchored
														if flag then
															validitem:PivotTo(chosenchest2.CFrame)
														end
													elseif validitem:IsA("BasePart") then
														if not validitem.Anchored then
															validitem:PivotTo(chosenchest2.CFrame)
														end
													end
												end
												n8 = n7 % 4294967296 - n7 % 4294967296 % 1 + 1984628382
												n4 = n8 % 4294967296 - n8 % 4294967296 % 1
												continue
											end
											continue
										end
									end
									n8 = n7 % 4294967296 - n7 % 4294967296 % 1 + 1984628382
									n4 = n8 % 4294967296 - n8 % 4294967296 % 1
								end
							end
						end
					end
				end
				__lph_capture_array_2000342[4].autoChestItemsRunning = false
			end)
		end
		local autopickup2 = __lph_capture_array_2000342[7].flags.autopickup
		
		
		if autopickup2 then
			local tbl = {}
			local autopickuptargets = __lph_capture_array_2000342[7].flags.autopickuptargets
			if type(autopickuptargets) == "string" then
				tbl[autopickuptargets] = true
			elseif type(autopickuptargets) == "table" then
				for _, autopickuptarget in pairs(autopickuptargets) do
					tbl[autopickuptarget] = true
				end
			end
			for _, validitem in pairs(__lph_capture_array_2000342[5].validitems) do
				if not (__lph_capture_array_2000342[7].flags.autopickuprange <= (__lph_capture_array_2000342[3][5][__lph_capture_array_2000342[3][4]].Position - validitem:GetPivot().Position).Magnitude) then
					if __lph_capture_array_2000342[12].canBearLoad(validitem) then
						local all = tbl.All
						local v4 = bit32.bxor(v3 % 4294967296 - v3 % 4294967296 % 1, 224759703)
						if all or tbl[validitem.Name] then
							if __lph_capture_array_2000342[7].flags.autopickupdelay < tick() - __lph_capture_array_2000342[13].lastpickup then
								firepacket("Pickup", validitem:GetAttribute("EntityID"))
								__lph_capture_array_2000342[13].lastpickup = tick()
							end
						end
						v3 = bit32.bxor(v4, 224759703)
					end
				end
			end
			if __lph_capture_array_2000342[7].flags.autopickupchests then
				for _, chestitem in pairs(__lph_capture_array_2000342[5].chestitems) do
					if not (__lph_capture_array_2000342[7].flags.autopickuprange <= (__lph_capture_array_2000342[3][5][__lph_capture_array_2000342[3][4]].Position - chestitem:GetPivot().Position).Magnitude) then
						if __lph_capture_array_2000342[12].canBearLoad(chestitem) then
							if tbl.All or tbl[chestitem.Name] then
								local v4 = tick
								local v5 = bit32.bxor(v3 % 4294967296 - v3 % 4294967296 % 1, 1089149574)
								if __lph_capture_array_2000342[7].flags.autopickupdelay < v4() - __lph_capture_array_2000342[13].lastpickup then
									firepacket("Pickup", chestitem:GetAttribute("EntityID"))
									__lph_capture_array_2000342[13].lastpickup = tick()
								end
								v3 = bit32.bxor(v5 % 4294967296 - v5 % 4294967296 % 1, 1089149574)
							end
						end
					end
				end
			end
		end
		if tick() - __lph_capture_array_2000342[13].lastchestinteractcleanup >= 30 then
			__lph_capture_array_2000342[13].lastchestinteractcleanup = tick()
			local n4 = tick() - 10
			bit32.bxor(v3 % 4294967296 - v3 % 4294967296 % 1, 0)
			for k, v4 in pairs(__lph_capture_array_2000342[5].lastChestItemInteract) do
				if v4 < n4 then
					__lph_capture_array_2000342[5].lastChestItemInteract[k] = nil
				end
			end
		end
	end
end
end)(nil, nil, {
							[18] = 28,
							[17] = 114,
							10,
							[3] = 255,
							[4] = 101,
							[21] = 237,
							[12] = 224,
							[8] = 63,
							[19] = 25,
							[16] = 221,
							[9] = 222,
							[5] = 107,
							[14] = 67,
							[6] = 62,
							[10] = 27,
							[13] = 10,
							[15] = 2,
							138,
							[20] = 99,
							[7] = 38,
							[11] = 135,
						}, 386)(table.pack(__boohub_scalar_capture_cell(function()return character end,function(__value)character=__value end), __boohub_scalar_capture_cell(function()return humanoid end,function(__value)humanoid=__value end), __boohub_scalar_capture_cell(function()return humanoidRootPart end,function(__value)humanoidRootPart=__value end), tbl6, tbl7, GameUtil, library, tbl5, v19, v25, localPlayer, functions, tbl9))
						connect(v57, heartbeat, v58)
					end
					library:connect(v25.InputBegan, function(j,P)if P then return;end;P= library ;local b,i=P.flags.pointbuild;if b then P= library ;i=not P.flags.pointmove;else i=b;end;b=nil;if i then P= library ;b=not P.flags.pointdelete;else b=i;end;local O,D,D=b and(j.UserInputType==Enum.UserInputType.MouseButton1 or j.UserInputType==Enum.UserInputType.Touch);if O then P= mouse2 ;b,i=P.Hit,j.UserInputType==Enum.UserInputType.Touch;if i then local D= v19 ;local L,A=D.CurrentCamera:ViewportPointToRay(j.Position.X,j.Position.Y), v19 ;D=A:Raycast(L.Origin,L.Direction*1000);b=D and CFrame.new(D.Position);else end;if not b then return;end;createpoint(b.Position+Vector3.new(0,3,0));end;P= library ;i,b=P.flags.choosechest and(j.UserInputType==Enum.UserInputType.MouseButton1 or j.UserInputType==Enum.UserInputType.Touch);if i then O= library ;b=not O.flags.pointbuild;else b=i;end;if b then P= mouse2 ;i,O=P.Target,j.UserInputType==Enum.UserInputType.Touch;if O then local D= v19 ;local L,A=D.CurrentCamera:ViewportPointToRay(j.Position.X,j.Position.Y), v19 ;D=A:Raycast(L.Origin,L.Direction*1000);i=D and D.Instance;else end;if not i then return;end;local D=i:FindFirstAncestorWhichIsA("Model");if not D then return;end;if D.Name~="Reinforced Chest"and D.Name~="Chest"then return;end;local L= tbl5 ;local A=L.chosenchest;if A then L= tbl5 ;local c=L.chosenchest.highlight;if c then local s= tbl5 ;s.chosenchest.highlight:Destroy();end;c= tbl5 ;local s=c.chosenchest.model==D;if s then c= tbl5 ;c.chosenchest=nil;local c= library ;c.items.choosechest:set(false);return;end;end;A= tbl5 ;A.chesthighlight=Instance.new("Highlight");A= tbl5 ;A.chesthighlight.Adornee=D;L= tbl5 ;L.chesthighlight.Parent=D;L= tbl5 ;L.chesthighlight.DepthMode=Enum.HighlightDepthMode.Occluded;A= tbl5 ;A.chesthighlight.FillColor=Color3.fromRGB(255,255,255);local L,A,c= tbl5 ,{model=D}, tbl5 ;A.highlight=c.chesthighlight;L.chosenchest=A;D= library ;D.items.choosechest:set(false);return;end;P= library ;local D,L=P.flags.freecam;if D then i=j.KeyCode==Enum.KeyCode.W;if i then b= tbl7 ;b.freecamKeys.W=true;else P=j.KeyCode==Enum.KeyCode.A;if P then O= tbl7 ;O.freecamKeys.A=true;else local L=j.KeyCode==Enum.KeyCode.S;if L then local L= tbl7 ;L.freecamKeys.S=true;else local L=j.KeyCode==Enum.KeyCode.D;if L then local L= tbl7 ;L.freecamKeys.D=true;else local L=j.KeyCode==Enum.KeyCode.Q;if L then local L= tbl7 ;L.freecamKeys.Q=true;else local L=j.KeyCode==Enum.KeyCode.E;if L then local L= tbl7 ;L.freecamKeys.E=true;else local L=j.KeyCode==Enum.KeyCode.LeftShift or j.KeyCode==Enum.KeyCode.RightShift;if L then local L= tbl7 ;L.freecamKeys.Shift=true;end;end;end;end;end;end;end;local L=j.UserInputType==Enum.UserInputType.MouseButton2;if L then local L= v25 ;L.MouseBehavior=Enum.MouseBehavior.LockCenter;end;end;O= mouse2 ;b,P=O.Target,j.UserInputType==Enum.UserInputType.Touch;if P then O= v19 ;D,i=O.CurrentCamera:ViewportPointToRay(j.Position.X,j.Position.Y), v19 ;local p=i:Raycast(D.Origin,D.Direction*1000);b=p and p.Instance;else end;if b then b:FindFirstAncestorWhichIsA("Model");end;D=nil;if b then i= tbl7 ;D=i.pointbypart[b];else D=b;end;if not D then return;end;P= tbl7 ;b,i,O=P.pointguis[D],j.UserInputType==Enum.UserInputType.Touch;if i then P= library ;O=not P.flags.pointmove;else O=i;end;P=nil;if O then i= library ;P=not i.flags.pointdelete;else P=O;end;if P then if b then b.Enabled=not b.Enabled;end;end;i=j.UserInputType==Enum.UserInputType.MouseButton2;if i then if b then b.Enabled=not b.Enabled;end;else O=j.UserInputType==Enum.UserInputType.MouseButton1 or j.UserInputType==Enum.UserInputType.Touch;if O then P= library ;local j=P.flags.pointdelete;if j then local j,j= tbl7 ,table.find( tbl7 .pathpoints,D);if not j then return;end;local p= tbl7 ;local X,e=#p.pathpoints, tbl7 ;e.pathparts[D.part]=nil;e= tbl7 ;e.pointbypart[D.part]=nil;p= tbl7 ;p.pointguis[D]=nil;if b and b.Parent then b:Destroy();end;if D.part and D.part.Parent then D.part:Destroy();end;table.remove( tbl7 .pathpoints,j);p= tbl7 ;e=#p.pathpoints;for P=j,e,1 do p= tbl7 ;local b=p.pathpoints[P].label;if b then local b= tbl7 ;b.pathpoints[P].label.Text="Index: "..P;end;end;e= tbl5 ;p=e.selectedpoint==D;if p then e= tbl5 ;e.selectedpoint=nil;end;p= tbl5 ;e=p.draggingpoint==D;if e then p= tbl5 ;p.draggingpoint=nil;local P= tbl5 ;P.draggingpart=nil;end;if X<2 then refreshsegments();return;end;e=j-1;e=if e<1 then X else e;local P,b=if j>X then 1 else j, tbl7 ;X=b.pathsegments[e];if X and X.dots then for i,i in ipairs(X.dots)do if i and i.Parent then i:Destroy();end;end;end;p= tbl7 ;b=p.pathsegments[P];if b and b.dots then for i,i in ipairs(b.dots)do if i and i.Parent then i:Destroy();end;end;end;X= tbl7 ;X.pathsegments[e]=nil;p= tbl7 ;p.pathsegments[P]=nil;X= tbl7 ;e=#X.pathpoints<2;if e then X= tbl7 ;for P,P in pairs(X.pathsegments)do if P and P.dots then for X,X in ipairs(P.dots)do if X and X.Parent then X:Destroy();end;end;end;end;table.clear( tbl7 .pathsegments);table.clear( tbl7 .groundpoints);table.clear( tbl7 .pathdots);refreshsegments();return;end;e,p={}, tbl7 ;for X,P in pairs(p.pathsegments)do if X<j then e[X]=P;elseif X>j then e[X-1]=P;end;end;p= tbl7 ;p.pathsegments=e;refreshsegments(j-1);else local j= library ;local r=j.flags.pointmove;if r then j= tbl5 ;j.draggingpoint=D;local j= tbl5 ;j.draggingpart=D.part;if D.part then D.part.Color=Color3.fromRGB(0,255,255);end;end;end;end;end;end)
					library:connect(v25.InputChanged, function(j,e)if e then return;end;if j.UserInputType~=Enum.UserInputType.MouseMovement and j.UserInputType~=Enum.UserInputType.Touch then return;end;e={};if previewpoint then e[previewpoint]=previewpoint.CanQuery;previewpoint.CanQuery=false;end;local P= tbl5 ;local b=P.draggingpart;if b then local i,O= tbl5 ;O,e[i.draggingpart]= tbl5 , tbl5 .draggingpart.CanQuery;i= tbl5 ;i.draggingpart.CanQuery=false;end;P= mouse2 ;local i,O,D=P.Hit,j.UserInputType==Enum.UserInputType.Touch;if O then P= v19 ;local D,L=P.CurrentCamera:ViewportPointToRay(j.Position.X,j.Position.Y), v19 ;b=L:Raycast(D.Origin,D.Direction*1000);i=b and CFrame.new(b.Position);else end;for D,L in pairs(e)do if D and D.Parent then D.CanQuery=L;end;end;e= library ;b=e.flags.pointbuild;if b then if i then e=not previewpoint or not previewpoint.Parent;if e then local D,L,A= library ,{Name="PreviewPoint",Anchored=true,CanCollide=false,CanQuery=false,CanTouch=false,Shape=Enum.PartType.Ball,Material=Enum.Material.Neon,Size=Vector3.new(1,1,1),Transparency=0.75}, library ;L.Color=A.flags.pointcolor.Color;P= v19 ;L.Parent=P;previewpoint=D:Create("Part",L);end;previewpoint.Position=i.Position+Vector3.new(0,3,0);O=nil;O,previewpoint.Color= library , library .flags.pointcolor.Color;end;else if previewpoint and previewpoint.Parent then previewpoint:Destroy();end;previewpoint=nil;end;b= library ;e,P=b.flags.pointmove;if e then b= tbl5 ;P=b.draggingpoint;else P=e;end;if P then O=nil;if i then b= tbl5 ;O=b.draggingpoint.part;else O=i;end;e=nil;if O then local D= tbl5 ;e=D.draggingpoint.part.Parent;else e=O;end;if e then local D= tbl5 ;D.draggingpoint.part.Position=i.Position+Vector3.new(0,3,0);end;return;end;O= tbl7 ;if#O.pathpoints<=0 then return;end;O= mouse2 ;e,P=O.Target,j.UserInputType==Enum.UserInputType.Touch;if P then O= v19 ;local p,i=O.CurrentCamera:ViewportPointToRay(j.Position.X,j.Position.Y), v19 ;b=i:Raycast(p.Origin,p.Direction*1000);e=b and b.Instance;else end;P= tbl5 ;if e==P.lastpart then return;end;b= tbl5 ;O,j=b.lastpart;if O then b= tbl5 ;j=b.lastpart.Parent;else j=O;end;b=nil;if j then P,O= tbl5 ;O,b= tbl5 ,P.lastpart~= tbl5 .draggingpart;else b=j;end;if b then j,O= tbl5 ;O,j.lastpart.Color= library , library .flags.pointcolor.Color;local p,X= tbl5 ;X,p.lastpart.Transparency= library , library .flags.pointcolor.Alpha;end;j= tbl5 ;j.lastpart=nil;b=nil;if e then O= tbl7 ;b=O.pathparts[e];else b=e;end;if b then P= tbl5 ;P.lastpart=e;j= library ;local r,p=j.flags.pointdelete and Color3.fromRGB(255,0,0);if r then p=r;else O= library ;p=O.flags.pointmove and Color3.fromRGB(0,255,255);end;r=nil;if p then r=p;else local j= library ;r=j.flags.pointcolor.Color;end;e.Color=r;p= library ;e.Transparency=p.flags.pointcolor.Alpha;end;end)
					library:connect(v25.InputEnded, function(j,e)if e then return;end;local P,b=j.UserInputType==Enum.UserInputType.Touch;if P then e= tbl6 ;e.pointhold=false;local r= tbl5 ;r.heldpoint=nil;end;P= library ;local r,b=P.flags.freecam;if r then P=j.KeyCode==Enum.KeyCode.W;if P then e= tbl7 ;e.freecamKeys.W=false;else local b=j.KeyCode==Enum.KeyCode.A;if b then local b= tbl7 ;b.freecamKeys.A=false;else local b=j.KeyCode==Enum.KeyCode.S;if b then local b= tbl7 ;b.freecamKeys.S=false;else local b=j.KeyCode==Enum.KeyCode.D;if b then local b= tbl7 ;b.freecamKeys.D=false;else local b=j.KeyCode==Enum.KeyCode.Q;if b then local b= tbl7 ;b.freecamKeys.Q=false;else local b=j.KeyCode==Enum.KeyCode.E;if b then local b= tbl7 ;b.freecamKeys.E=false;else local b=j.KeyCode==Enum.KeyCode.LeftShift or j.KeyCode==Enum.KeyCode.RightShift;if b then local b= tbl7 ;b.freecamKeys.Shift=false;end;end;end;end;end;end;end;local b=j.UserInputType==Enum.UserInputType.MouseButton2;if b then local b= v25 ;b.MouseBehavior=Enum.MouseBehavior.Default;end;end;r,e=j.UserInputType==Enum.UserInputType.MouseButton1 or j.UserInputType==Enum.UserInputType.Touch;if r then P= tbl5 ;e=P.draggingpoint;else e=r;end;if e then P= tbl5 ;j,r=P.draggingpoint, tbl5 ;r.draggingpoint=nil;local r= tbl5 ;r.draggingpart=nil;r=j.part and j.part.Parent;if r then local r;r,j.part.Color= library , library .flags.pointcolor.Color;r,j.part.Transparency= library , library .flags.pointcolor.Alpha;end;local r,r= tbl7 ,table.find( tbl7 .pathpoints,j);if r then refreshsegments(r-1,r);end;end;end)
					library:connect(localPlayer.CharacterAdded, function(j)setupcharacter(j);j= tbl5 ;local p,X=j.spectating;if p then j= tbl5 ;X=j.spectatinglabel;else X=p;end;if X then p= tbl5 ;p.spectatinglabel.TextColor3=Color3.fromRGB(255,255,255);end;p= tbl5 ;p.spectating=nil;p= tbl5 ;p.spectatinglabel=nil;end)
					local function fn16(j)local O=j:IsA("ImageButton");if O then local O= tbl5 ;local D,L=O.spectating;if D then O=nil;O,L= tbl5 ,j.Name== tbl5 .spectating.Name;else L=D;end;O=L and(j:FindFirstChild("NameLabel"));if O then L= tbl5 ;L.spectatinglabel=j.NameLabel;j.NameLabel.TextColor3=Color3.fromRGB(255,0,0);end;O= v25 ;local p,A,A,c=O.TouchEnabled;if p then O= library ;A=O:connect(j.Activated,function()local p= v19 ;local O=p.Players:FindFirstChild(j.Name);if not O or not O:FindFirstChild("Humanoid")then return;end;p= v18 ;local c=p:GetPlayerFromCharacter(O);if not c then return;end;p= tbl5 ;local s,M=p.spectating;if s then p= tbl5 ;M=p.spectatinglabel;else M=s;end;p=nil;if M then s= tbl5 ;p=s.spectating~=c;else p=M;end;if p then M= tbl5 ;M.spectatinglabel.TextColor3=Color3.fromRGB(255,255,255);end;local M,k= tbl5 ;s= currentCamera ;M.spectating=s.CameraSubject~=O.Humanoid and c or nil;p,M= tbl5 , currentCamera ;p.spectatinglabel=M.CameraSubject~=O.Humanoid and j.NameLabel or nil;local p,s,k= currentCamera , currentCamera ;p.CameraSubject=s.CameraSubject~=O.Humanoid and O.Humanoid or  humanoid ;s= localPlayer ;M=c~=s;if M then s=nil;s,j.NameLabel.TextColor3= currentCamera , currentCamera .CameraSubject~=O.Humanoid and Color3.fromRGB(255,255,255)or Color3.fromRGB(255,0,0);end;end);L= tbl7 ;L.spectateconnections[j.Name]=A;else D= library ;A=D:connect(j.MouseButton2Click,function()local p= v19 ;local X=p.Players:FindFirstChild(j.Name);if not X or not X:FindFirstChild("Humanoid")then return;end;p= v18 ;local Y=p:GetPlayerFromCharacter(X);if not Y then return;end;p= tbl5 ;local V,O=p.spectating;if V then p= tbl5 ;O=p.spectatinglabel;else O=V;end;V=nil;if O then p= tbl5 ;V=p.spectating~=Y;else V=O;end;if V then p= tbl5 ;p.spectatinglabel.TextColor3=Color3.fromRGB(255,255,255);end;local p,D= tbl5 ;V= currentCamera ;p.spectating=V.CameraSubject~=X.Humanoid and Y or nil;O,V= tbl5 , currentCamera ;O.spectatinglabel=V.CameraSubject~=X.Humanoid and j.NameLabel or nil;local r,p,V= currentCamera , currentCamera ;r.CameraSubject=p.CameraSubject~=X.Humanoid and X.Humanoid or  humanoid ;p= localPlayer ;O=Y~=p;if O then r=nil;r,j.NameLabel.TextColor3= currentCamera , currentCamera .CameraSubject~=X.Humanoid and Color3.fromRGB(255,255,255)or Color3.fromRGB(255,0,0);end;end);local r= tbl7 ;r.spectateconnections[j.Name]=A;end;end;end
					library:connect(localPlayer.PlayerGui.SecondaryGui.PlayerList.List.ChildAdded, fn16)
					library:connect(localPlayer.PlayerGui.SecondaryGui.PlayerList.List.ChildRemoved, function(j)local X= tbl7 ;local Y=X.spectateconnections[j.Name];if Y then X= library ;X:disconnect(Y);local p= tbl7 ;p.spectateconnections[j.Name]=nil;end;end)
					library:connect(v18.PlayerAdded, function(j) moderatorLookup.check(j, "A Moderator has left your server: ") end)
					library:connect(v18.PlayerRemoving, function(j)local e= tbl5 ;local P=e.spectating==j;if P then e= tbl5 ;e.spectating=nil;local b= tbl5 ;b.spectatinglabel=nil;local r,b= currentCamera ;r.CameraSubject= humanoid ;end;e= tbl7 ;local r,p=e.spectateconnections[j.Name];if r then e,P= library , tbl7 ;e:disconnect(P.spectateconnections[j.Name]);local p= tbl7 ;p.spectateconnections[j.Name]=nil;end;e= tbl7 ;P=e.modIds[j.UserId];moderatorLookup.check(j, "A Moderator has left your server: ")end)
					library.Unloading.Event:Connect(function()local r= tbl2 ;if r then  tbl2 :Unload(); tbl2 =nil;end;table.clear( tbl7 .resourcetable);table.clear( tbl7 .spectateconnections);table.clear( tbl7 .lastChestItemInteract);table.clear( tbl7 .chestteleports);r= mainGui ;local p=r.Panels.Toolbar.Container.Boosts:FindFirstChild("Clan EXP");if p then r= mainGui ;r.Panels.Toolbar.Container.Boosts:FindFirstChild("Clan EXP").Visible=true;else task.spawn(function()while true do  task.wait();local M= mainGui ;if M.Panels.Toolbar.Container.Boosts:FindFirstChild("Clan EXP")then break;end;end;local M= mainGui ;M.Panels.Toolbar.Container.Boosts:FindFirstChild("Clan EXP").Visible=true;end);end;p= tbl5 ;local M,k=p.oldLPId;if M then r= tbl5 ;k=r.oldLPName;else k=M;end;M=nil;if k then r= tbl5 ;M=r.oldLPDisplay;else M=k;end;if M then r,k= localPlayer , tbl5 ;r.UserId=k.oldLPId;local R,z= localPlayer , tbl5 ;R.Name=z.oldLPName;R,z= localPlayer , tbl5 ;R.DisplayName=z.oldLPDisplay;end;updateStats();local R,z,z= mainGui ;z,R.Panels.Stats.Bars.Bag.ValueLabel.Text= functions ,string.format("%0.1f", functions .playerCacheLoad);z,p=pairs, localPlayer ;R= table.pack (p.PlayerGui.SecondaryGui.PlayerList.List:GetChildren());for P,E in z( unpackCapturedArguments ( nil, R))do p=E:IsA("ImageButton");if p then k= tbl7 ;P=k.oldnames[E]and E:FindFirstChild("NameLabel");if P then M=nil;M,E:FindFirstChild("NameLabel").Text= tbl7 , tbl7 .oldnames[E];end;end;end;M,p=ipairs, mainGui ;k= table.pack (p.Panels.Toolbar.List:GetChildren());for Y,P in M( unpackCapturedArguments ( nil, k))do r=P:IsA("ImageButton")and P:FindFirstChild("Quantity");if r then Y=tonumber(P.Name);z=nil;if Y then R= GameUtil ;z=R.Data.toolbar[Y];else z=Y;end;if z then P.Quantity.Text=tostring(z.quantity or 0);else P.Quantity.Text="";end;end;end;r= tbl5 ;k=r.killaurahighlight;if k then R= tbl5 ;R.killaurahighlight:Destroy();end;z= tbl5 ;M=z.chosenchest;if M then p= tbl5 ;R=p.chosenchest.highlight;if R then z= tbl5 ;z.chosenchest.highlight:Destroy();end;k= tbl5 ;k.chosenchest=nil;end;local j,Y= currentCamera ;R=j and  humanoid ;if R then M= currentCamera ;M.CameraSubject= humanoid ;end;p= localPlayer ;for Y,Y in pairs(p.PlayerGui.SecondaryGui.PlayerList.List:GetChildren())do if Y:IsA("ImageButton")then Y.NameLabel.TextColor3=Color3.fromRGB(255,255,255);end;end;j= v24 ;j.FogStart=100;z= v24 ;z.FogEnd=1000;set( humanoid ,"WalkSpeed",16);set( humanoid ,"JumpPower",50);set( humanoid ,"MaxSlopeAngle",46);set( humanoid ,"HipHeight",2);j= localPlayer ;j.CameraMaxZoomDistance=125;j= localPlayer ;j.DevCameraOcclusionMode=Enum.DevCameraOcclusionMode.Zoom;z= v25 ;z.MouseBehavior=Enum.MouseBehavior.Default;j= v24 ;j.GlobalShadows=true;k= v19 ;k.Terrain.WaterTransparency=0.6;j= v19 ;j.Terrain.WaterReflectance=0.6;z= v19 ;z.Terrain.WaterWaveSize=0.3;p= v19 ;p.Terrain.WaterWaveSpeed=10;R= tbl6 ;R.pathrunning=false;R= tbl5 ;k=R.selectedresourcehighlight;if k then R= tbl5 ;R.selectedresourcehighlight:Destroy();end;r,z=ipairs, tbl7 ;k=z.pathpoints;for Y,e in r(k)do if e.part and e.part.Parent then e.part:Destroy();end;j= tbl7 ;Y,M=j.pointguis[e];if Y then z= tbl7 ;M=z.pointguis[e].Parent;else M=Y;end;if M then p= tbl7 ;p.pointguis[e]:Destroy();end;end;k= tbl7 ;for r,r in pairs(k.pathsegments)do if r.dots then for Y,Y in pairs(r.dots)do if Y and Y.Parent then Y:Destroy();end;end;end;end;table.clear( tbl7 .pathpoints);table.clear( tbl7 .pathparts);table.clear( tbl7 .pointbypart);table.clear( tbl7 .pointguis);table.clear( tbl7 .pathdots);table.clear( tbl7 .groundpoints);table.clear( tbl7 .pathsegments);j= tbl5 ;j.selectedpoint=nil;p= tbl5 ;p.draggingpoint=nil;k= tbl5 ;k.draggingpart=nil;M= v19 ;for r,r in ipairs(M:GetDescendants())do if r:IsA("BasePart")then r.CastShadow=true;end;end;z= character ;for r,r in pairs(z:GetDescendants())do if r:IsA("BasePart")and r.CanCollide then r.CanCollide=true;end;end;j= tbl7 ;for r,r in pairs(j.resourcehighlights)do for j,p in pairs(r)do if p then p:Destroy();end;r[j]=nil;end;end;end)
					return
				end
				
end
end
		end
end)()
