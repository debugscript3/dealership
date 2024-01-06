local x, y = guiGetScreenSize()
local sx, sy = x / 1920, y / 1080
local px, py = 800 * sx, 800 * sy
local centerX, centerY = (x / 2) - (px / 2), (y / 2) - (py / 2)

local debug_text = "СМОТРИТЕ СЮДА: пока ниче нет"
local change_numberplate = createMarker ( 1799.21753, 1684.43445, 15.27944, "cylinder", 1.5, 255, 0, 0, 170 )

function ShowChangeUI()
    dxDrawRectangle(centerX * sx, centerY * sy, px, py, tocolor(36, 36, 36, 255))
    dxDrawRectangle((centerX + px - 30) * sx, centerY * sy, 30 * sx, 30 * sy, tocolor(255, 0, 0, 255))
    dxDrawText("Сменить номер для крутой тачки", px, 280 * sy)

    dxDrawRectangle(px, 300 * sy, 100 * sx, 30 * sy, tocolor(0, 0, 0, 255))
    dxDrawText("<----- СМЕНИТЬ", px + 125, 305 * sy)

    dxDrawText(debug_text, px + 125, 450 * sy)
    showCursor(true)
end

function handlePlayerChangeMarker(hitElement)
	local elementType = getElementType(hitElement)
    if elementType ~= "player" then return end
    addEventHandler("onClientRender", root, ShowChangeUI)
end
addEventHandler("onClientMarkerHit", change_numberplate, handlePlayerChangeMarker)

function destroyChangeUI(button, state)
    if button ~= "left" or state ~= "down" then return end
    if not isEventHandlerAdded("onClientRender", root, ShowChangeUI) then return end
    if isMouseInPosition( (centerX + px - 30) * sx, centerY * sy, 30 * sx, 30 * sy ) then
        if isValidEditBox(1) then
            dxDestroyEditBox(1)
        end
        if not isEventHandlerAdded("onClientClick", root, TryChangeNumberplate) then
            addEventHandler("onClientClick", root, TryChangeNumberplate)
        end
        if isEventHandlerAdded("onClientClick", root, CheckNumber) then
            removeEventHandler("onClientClick", root, CheckNumber)
        end
        debug_text = "СМОТРИТЕ СЮДА: пока ниче нет"
        removeEventHandler("onClientRender", root, ShowChangeUI)
        showCursor(false)
    end
end
addEventHandler("onClientClick", root, destroyChangeUI)

function TryChangeNumberplate(button, state)
    if button ~= "left" or state ~= "down" then return end
    if isMouseInPosition(px, 300 * sy, 100 * sx, 30 * sy ) then
        triggerServerEvent("PlayerHasVehicleForChangeNumberplate", localPlayer)
    end
end
addEventHandler("onClientClick", root, TryChangeNumberplate)

function CheckNumber(button, state)
    if button ~= "left" or state ~= "down" then return end
    if isMouseInPosition(px, 300 * sy, 100 * sx, 30 * sy ) then
        local text = dxGetText(1)
        if not validateLicensePlate(text) then
            debug_text = "СМОТРИТЕ СЮДА: Гос.знак введен не по формату х000хх000.\nЕсли че можно ещё х000хх00"
        else
            debug_text = "СМОТРИТЕ СЮДА: Гос.знак введен верно, поздравляю с сменой номера)\nЕсли номер не поменялся в бд, то он занят("
            triggerServerEvent("onPlayerChangeCarNumberplates", localPlayer, text)
            removeEventHandler("onClientClick", root, CheckNumber)
            addEventHandler("onClientClick", root, TryChangeNumberplate)
        end
    end
end

function ChangeNumber(state)
    if state == false then
        debug_text = "СМОТРИТЕ СЮДА: У тебя нет тачки, как менять номера?((("
    else
        debug_text = "выбери гос знак\nэдит бокс принимает только английские буквы капсом,\nкоторые есть в номерах РФ. К вводу доступно: На англ. раскладке КАПСОМ\nА, В, Е, К, М, Н, О, Р, С, Т, У, Х\nЦифры все от 1 до 0\n\nКак введешь госзнак - нажимай на ту же черную кнопку выше"
        local editbox = dxCreateEditBox("grz", "", "Введите ГРЗ", 600, 600, 300, 35)
        removeEventHandler("onClientClick", root, TryChangeNumberplate)
        addEventHandler("onClientClick", root, CheckNumber)
    end
end
addEvent("ChangeNumber", true)
addEventHandler("ChangeNumber", root, ChangeNumber)