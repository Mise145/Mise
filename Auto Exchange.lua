script_name("Auto Exchange")
script_version("4.00")

local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
    local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'РћР±РЅР°СЂСѓР¶РµРЅРѕ РѕР±РЅРѕРІР»РµРЅРёРµ. РџС‹С‚Р°СЋСЃСЊ РѕР±РЅРѕРІРёС‚СЊСЃСЏ c '..thisScript().version..' РЅР° '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Р—Р°РіСЂСѓР¶РµРЅРѕ %d РёР· %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Р—Р°РіСЂСѓР·РєР° РѕР±РЅРѕРІР»РµРЅРёСЏ Р·Р°РІРµСЂС€РµРЅР°.')sampAddChatMessage(b..'РћР±РЅРѕРІР»РµРЅРёРµ Р·Р°РІРµСЂС€РµРЅРѕ!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'РћР±РЅРѕРІР»РµРЅРёРµ РїСЂРѕС€Р»Рѕ РЅРµСѓРґР°С‡РЅРѕ. Р—Р°РїСѓСЃРєР°СЋ СѓСЃС‚Р°СЂРµРІС€СѓСЋ РІРµСЂСЃРёСЋ..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': РћР±РЅРѕРІР»РµРЅРёРµ РЅРµ С‚СЂРµР±СѓРµС‚СЃСЏ.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': РќРµ РјРѕРіСѓ РїСЂРѕРІРµСЂРёС‚СЊ РѕР±РЅРѕРІР»РµРЅРёРµ. РЎРјРёСЂРёС‚РµСЃСЊ РёР»Рё РїСЂРѕРІРµСЂСЊС‚Рµ СЃР°РјРѕСЃС‚РѕСЏС‚РµР»СЊРЅРѕ РЅР° '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, РІС‹С…РѕРґРёРј РёР· РѕР¶РёРґР°РЅРёСЏ РїСЂРѕРІРµСЂРєРё РѕР±РЅРѕРІР»РµРЅРёСЏ. РЎРјРёСЂРёС‚РµСЃСЊ РёР»Рё РїСЂРѕРІРµСЂСЊС‚Рµ СЃР°РјРѕСЃС‚РѕСЏС‚РµР»СЊРЅРѕ РЅР° '..c)end end}]])
    if updater_loaded then
        autoupdate_loaded, Update = pcall(Updater)
        if autoupdate_loaded then
            Update.json_url = "https://raw.githubusercontent.com/Mise145/Mise/main/update.json?" .. tostring(os.clock())
            Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
            Update.url = "https://github.com/Mise145/Mise"
        end
    end
end

local encoding = require "encoding"
encoding.default = 'CP1251'
u8 = encoding.UTF8

--[[
example.json should look like this:
{
  "latest": "25.06.2022",
  "updateurl": "https://raw.githubusercontent.com/qrlk/moonloader-script-updater/main/example.lua"
} ]]

require 'lib.moonloader'
local tag = "[AE]: "
local sampev = require("samp.events")
local state = true
local state2 = true
require "lib.sampfuncs"

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end

	_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    name = sampGetPlayerNickname(id)
    if name ~= "Miset_Basotskiy" then
        thisScript():unload()
    end

	if autoupdate_loaded and enable_autoupdate and Update then
		pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end

	sampRegisterChatCommand("Auto", cmd_auto)

	while true do
		wait(0)

		if state == false then
			wait(300)
			setVirtualKeyDown(18, true)
			wait(10)
			setVirtualKeyDown(18, false)
		end
		if isKeyJustPressed(VK_E) then
			state = true
			state2 = true
		end
	end
end

function cmd_auto(arg)
	state = not state
	state2 = not state
	sampAddChatMessage(tag.. (state and u8:decode'Скрипт выключен.' or u8:decode'Скрипт включён.'), 0xff0000)
end

function sampev.onShowDialog(id, style, title, button1, button2, tekst)
	if state == false then
		if tekst:find(u8:decode'Хочу обменять зловещую монету') then
			lua_thread.create(function()
			wait(0)
			listbox = sampGetListboxItemByText(u8:decode'Хочу обменять зловещую монету')
			sampSendDialogResponse(id, 1, listbox, nil)
			sampCloseCurrentDialogWithButton(0)
			end)
		end
	end
end

function sampGetListboxItemByText(text, plain)
    if not sampIsDialogActive() then return -1 end
        plain = not (plain == false)
    for i = 0, sampGetListboxItemsCount() - 1 do
        if sampGetListboxItemText(i):find(text, 1, plain) then
            return i
        end
    end
    return -1
end

function sampev.onServerMessage(color, text)
	if string.find(text, u8:decode"У тебя нет зловещих монет!", 1, true) then
		state = true
	end
end

