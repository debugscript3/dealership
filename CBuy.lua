--NEXTRP, вы лучшие <3
--И если что, я умею красиво называть функции и ивенты, совмещать две функции в одну, и всё в таком духе)

local x, y = guiGetScreenSize()
local sx, sy = x / 1920, y / 1080
local px, py = 800 * sx, 800 * sy
local centerX, centerY = (x / 2) - (px / 2), (y / 2) - (py / 2)

local debug_text = "СМОТРИТЕ СЮДА: пока ниче нет"
local dealership_marker = createMarker ( 1790.45105, 1685.53564, 15.27944, "cylinder", 1.5, 255, 255, 255, 170 )

function ShowUI()
    dxDrawRectangle(centerX * sx, centerY * sy, px, py, tocolor(36, 36, 36, 255))
    dxDrawRectangle((centerX + px - 30) * sx, centerY * sy, 30 * sx, 30 * sy, tocolor(255, 0, 0, 255))
    dxDrawText("Крутая тачка с ID 411", px, 300 * sy)

    dxDrawRectangle(px, 320 * sy, 120 * sx, 30 * sy, tocolor(0, 0, 0, 255))
    dxDrawText("<----- КУПИТЬ", px + (125 * sx), 325 * sy)

    dxDrawText(debug_text, px + (125 * sx), 450 * sy)

    showCursor(true)
end

function handleBuyMarker(hitElement)
	local elementType = getElementType(hitElement)
    if elementType ~= "player" then return end
    addEventHandler("onClientRender", root, ShowUI)
end
addEventHandler("onClientMarkerHit", dealership_marker, handleBuyMarker)

function destroyUI(button, state)
    if button ~= "left" or state ~= "down" then return end
    if not isEventHandlerAdded("onClientRender", root, ShowUI) then return end
    if isMouseInPosition( (centerX + px - 30) * sx, centerY * sy, 30 * sx, 30 * sy ) then
        if isValidEditBox(1) then
            dxDestroyEditBox(1)
        end

        if not isEventHandlerAdded("onClientClick", root, TryBuyVehicle) then
            addEventHandler("onClientClick", root, TryBuyVehicle)
        end
        debug_text = "СМОТРИТЕ СЮДА: пока ниче нет"
        removeEventHandler("onClientRender", root, ShowUI)
        removeEventHandler("onClientClick", root, CheckNumberPlate)
        showCursor(false)
    end
end
addEventHandler("onClientClick", root, destroyUI)

function TryBuyVehicle(button, state)
    if button ~= "left" or state ~= "down" then return end
    if isMouseInPosition(px, 320 * sy, 120 * sx, 30 * sy ) then
        triggerServerEvent("PlayerHasVehicle", localPlayer)
    end
end
addEventHandler("onClientClick", root, TryBuyVehicle)

function CheckNumberPlate(button, state)
    if button ~= "left" or state ~= "down" then return end
    if isMouseInPosition(px, 320 * sy, 120 * sx, 30 * sy ) then
        local text = dxGetText(1)
        if not validateLicensePlate(text) then
            debug_text = "СМОТРИТЕ СЮДА: Гос.знак введен не по формату х000хх000.\nЕсли че можно ещё х000хх00"
        else
            debug_text = "СМОТРИТЕ СЮДА: Гос.знак введен верно, поздравляю с тачкой)\nЕсли тачка не появилась в бд то номер занят"
            triggerServerEvent("onPlayerBoughtCar", localPlayer, text)
            removeEventHandler("onClientClick", root, CheckNumberPlate)
            addEventHandler("onClientClick", root, TryBuyVehicle)
        end
    end
end

function BuyVehicle(state)
    if state == false then
        debug_text = "СМОТРИТЕ СЮДА: у тебя есть тачка, вторую нельзя"
    else
        debug_text = "СМОТРИТЕ СЮДА: у тебя нет тачки, идём дальше, выбери гос знак\nэдит бокс принимает только английские буквы капсом,\nкоторые есть в номерах РФ. К вводу доступно: На англ. раскладке КАПСОМ\nА, В, Е, К, М, Н, О, Р, С, Т, У, Х\nЦифры все от 1 до 0\n\nКак введешь госзнак - нажимай на ту же черную кнопку выше"
        local editbox = dxCreateEditBox("grz", "", "Введите ГРЗ", 600, 600, 300, 35)
        removeEventHandler("onClientClick", root, TryBuyVehicle)
        addEventHandler("onClientClick", root, CheckNumberPlate)
    end
end
addEvent("BuyVehicle", true)
addEventHandler("BuyVehicle", root, BuyVehicle)