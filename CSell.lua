local x, y = guiGetScreenSize()
local sx, sy = x / 1920, y / 1080
local px, py = 800 * sx, 800 * sy
local centerX, centerY = (x / 2) - (px / 2), (y / 2) - (py / 2)

local govsell_marker = createMarker ( 1794.88391, 1684.97852, 15.27944, "cylinder", 1.5, 0, 0, 255, 170 )
local debug_text = "СМОТРИТЕ СЮДА: пока ниче нет"

function ShowSellUI()
    dxDrawRectangle(centerX * sx, centerY * sy, px, py, tocolor(36, 36, 36, 255))
    dxDrawRectangle((centerX + px - 30) * sx, centerY * sy, 30 * sx, 30 * sy, tocolor(255, 0, 0, 255))
    dxDrawText("Продажа тачки", px, 340 * sy)

    dxDrawRectangle(px, 360 * sy, 120 * sx, 30 * sy, tocolor(0, 0, 0, 255))
    dxDrawText("<----- ПРОДАТЬ", px + 125, 365 * sy)

    dxDrawText(debug_text, px + 125, 450 * sy)

    showCursor(true)
end

function handlePlayerSellMarker(hitElement)
	local elementType = getElementType(hitElement)
    if elementType ~= "player" then return end
    addEventHandler("onClientRender", root, ShowSellUI)
end
addEventHandler("onClientMarkerHit", govsell_marker, handlePlayerSellMarker)

function destroySellUI(button, state)
    if button ~= "left" or state ~= "down" then return end
    if not isEventHandlerAdded("onClientRender", root, ShowSellUI) then return end
    if isMouseInPosition( (centerX + px - 30) * sx, centerY * sy, 30 * sx, 30 * sy ) then
        removeEventHandler("onClientRender", root, ShowSellUI)
        showCursor(false)
    end
end
addEventHandler("onClientClick", root, destroySellUI)

function TrySellVehicle(button, state)
    if button ~= "left" or state ~= "down" then return end
    if isMouseInPosition(px, 360 * sy, 120 * sx, 30 * sy ) then
        triggerServerEvent("PlayerSellCar", localPlayer )
    end
end
addEventHandler("onClientClick", root, TrySellVehicle)

function SellVehicle(state)
    if state == false then
        debug_text = "СМОТРИТЕ СЮДА: у тебя нет тачек для продажи"
    else
        debug_text = "СМОТРИТЕ СЮДА: Ура, тачка продана"
    end
end
addEvent("SellVehicle", true)
addEventHandler("SellVehicle", root, SellVehicle)