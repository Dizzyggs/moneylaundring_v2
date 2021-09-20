ESX = nil

local location = vector3(-402.40, 1127.390, 325.850)

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  }
  
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end 
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)



function Draw3DText(x, y, z, text, scale)

    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
 
    SetTextScale(0.0, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextColour(255, 255, 255, 215)
 
    AddTextComponentString(text)
    DrawText(_x, _y)
 
    local factor = (string.len(text)) / 230
    -- DrawRect(_x, _y + 0.0250, 0.095 + factor, 0.06, 41, 11, 41, 100)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
  local coords = GetEntityCoords(GetPlayerPed(-1))
  local distance = #(coords - Config.Location)
  if distance < 2 then
    Draw3DText(Config.Location.x, Config.Location.y, Config.Location.z, Config.DrawText, 1.0)
    if distance < 0.5 then
    if ( IsControlJustPressed( 1, Config.MenuKey ) ) then
 
    ESX.TriggerServerCallback('checkstate', function(inprogress) 
    if inprogress >= 1 then
    TriggerEvent('inprogressmenu')
    else TriggerEvent('dialog')
    
end
end)
end
end
end
end
end)




  RegisterNetEvent('dialog')
  AddEventHandler('dialog', function()
  local dialog = exports['zf_dialog']:DialogInput({
          header = "Money Wash", 
          rows = {
              {
                  id = 1, 
                  txt = "Amount"
              },
  
          }
      })
       
              if dialog[1].input == nil then
                  exports['mythic_notify']:DoHudText('inform', 'You need to put in a value in order to wash..')
                  else input = dialog[1].input
                  TriggerServerEvent('moneywashevent', (input))
  
      
  end
  end)




RegisterNetEvent('inprogressmenu', function(data)
    TriggerEvent('nh-context:sendMenu', {
        {
            id = 1,
            header = "Collect Cash",
            txt = "",
            params = {
                event = "collectDatCash"
            }
        },


    })
end)



 --Checking if timer is out, if not, sending a notification with how long its left... 
RegisterNetEvent('collectDatCash')
AddEventHandler('collectDatCash', function()
ESX.TriggerServerCallback('checkstate_timer', function(timer)
if timer <= 0 then
TriggerServerEvent('collectcashyo')
else

exports['mythic_notify']:DoHudText('error', 'Your money is being washed.. Its around ' ..(timer/1000).. " seconds left")
end
end)
end)



RegisterNetEvent('collecting_anim')
AddEventHandler('collecting_anim', function()
    TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
    TriggerEvent("mythic_progbar:client:progress", {
        name = "unique_action_name",
        duration = Config.Collectingtime * 1000,
        label = Config.CollectingLabel,
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = false,
        }})
    Citizen.Wait(Config.ProgressbarTime * 1000)
    ClearPedTasks(PlayerPedId())
		
end)




RegisterNetEvent('animationxd')
AddEventHandler('animationxd', function()
    TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
    TriggerEvent("mythic_progbar:client:progress", {
        name = "unique_action_name",
        duration = Config.ProgressbarTime * 1000,
        label = Config.PutCashInLabel,
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = false,
        }})
    Citizen.Wait(Config.ProgressbarTime * 1000)
    ClearPedTasks(PlayerPedId())
		
end)

