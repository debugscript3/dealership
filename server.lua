local db = dbConnect( "mysql", "dbname=brp_srv_1;host=127.0.0.1;charset=utf8", "blazerp", "vdiYTCpHNury9411" )

dbExec(db, [[CREATE TABLE IF NOT EXISTS ??
    ( ?? INT AUTO_INCREMENT PRIMARY KEY, ?? VARCHAR(32), ?? INT(6), ?? VARCHAR(9) );]],
    "vehicles", "id", "serial", "car_id", "numberplate"
)

function table.empty( a )
    if type( a ) ~= "table" then
        return false
    end
    
    return next(a) == nil
end

function PlayerHasVehicle()
    local player = client or source
    local function hasDatabaseRecord(dbData, serial)
        local data = {}
        for _,v in pairs(dbData) do
            if v.serial == serial then
                data.id = v.id
            end
        end
        return data
    end

    local function checkHasCar(query)
        if not query then return end
        local dbData = dbPoll(query, 0)
		if type(dbData) ~= "table" then
            dbFree(query)
            return
         end

        local dbInfo = hasDatabaseRecord(dbData, getPlayerSerial(player))
        iprint(dbInfo)
        if not player then return end
        if not table.empty(dbInfo) then 
            triggerClientEvent(player, "BuyVehicle", player, false)
        else
            triggerClientEvent(player, "BuyVehicle", player, true)
        end
    end
    dbQuery(checkHasCar, db, "SELECT id, serial FROM vehicles")
end
addEvent("PlayerHasVehicle", true)
addEventHandler("PlayerHasVehicle", getRootElement(), PlayerHasVehicle)

function AddVehicleRecord(numberplate)
    local player = client or source
    local serial = getPlayerSerial(player)

    local function checkNumberplate(query)
        if not query then return end
        local dbData = dbPoll(query, 0)
        if type(dbData) ~= "table" then
            dbFree(query)
            return
        end
        if not table.empty(dbData) then
            iprint('Номер уже занят')
        else
            dbExec(db, "INSERT INTO vehicles VALUES (?,?,?,?)", nil, serial, 411, numberplate)
        end
    end
    dbQuery(checkNumberplate, db, "SELECT numberplate FROM vehicles WHERE numberplate = ?", numberplate)
end
addEvent("onPlayerBoughtCar", true)
addEventHandler("onPlayerBoughtCar", getRootElement(), AddVehicleRecord)

function PlayerSellCar()
    local player = client or source
    local function hasDatabaseRecord(dbData, serial)
        local data = {}
        for _,v in pairs(dbData) do
            if v.serial == serial then
                data.id = v.id
            end
        end
        return data
    end
    local function checkHasCar(query)
        if not query then return end
        local dbData = dbPoll(query, 0)
		if type(dbData) ~= "table" then
            dbFree(query)
            return
         end

        local dbInfo = hasDatabaseRecord(dbData, getPlayerSerial(player))
        iprint(dbInfo)
        if not player then return end
        if not table.empty(dbInfo) then 
            triggerClientEvent(player, "SellVehicle", player, true)
        else
            triggerClientEvent(player, "SellVehicle", player, false)
        end
    end
    dbQuery(checkHasCar, db, "SELECT id, serial FROM vehicles")
    dbExec(db, "DELETE FROM vehicles WHERE serial = ?", getPlayerSerial(player))
end
addEvent("PlayerSellCar", true)
addEventHandler("PlayerSellCar", getRootElement(), PlayerSellCar)

function PlayerHasVehicleForChangeNumberplate()
    local player = client or source
    local function hasDatabaseRecord(dbData, serial)
        local data = {}
        for _,v in pairs(dbData) do
            if v.serial == serial then
                data.id = v.id
            end
        end
        return data
    end

    local function checkHasCar(query)
        if not query then return end
        local dbData = dbPoll(query, 0)
		if type(dbData) ~= "table" then
            dbFree(query)
            return
         end

        local dbInfo = hasDatabaseRecord(dbData, getPlayerSerial(player))
        iprint(dbInfo)
        if not player then return end
        if not table.empty(dbInfo) then 
            triggerClientEvent(player, "ChangeNumber", player, true)
        else
            triggerClientEvent(player, "ChangeNumber", player, false)
        end
    end
    dbQuery(checkHasCar, db, "SELECT id, serial FROM vehicles")
end
addEvent("PlayerHasVehicleForChangeNumberplate", true)
addEventHandler("PlayerHasVehicleForChangeNumberplate", getRootElement(), PlayerHasVehicleForChangeNumberplate)

function ChangeNumberPlates(numberplate)
    local player = client or source
    local serial = getPlayerSerial(player)

    local function checkNumberplate(query)
        if not query then return end
        local dbData = dbPoll(query, 0)
        if type(dbData) ~= "table" then
            dbFree(query)
            return
        end
        if not table.empty(dbData) then
            iprint('Номер уже занят')
        else
            dbExec(db, "UPDATE vehicles SET numberplate = ? WHERE serial = ?", numberplate, serial)
        end
    end
    dbQuery(checkNumberplate, db, "SELECT numberplate FROM vehicles WHERE numberplate = ?", numberplate)
end
addEvent("onPlayerChangeCarNumberplates", true)
addEventHandler("onPlayerChangeCarNumberplates", getRootElement(), ChangeNumberPlates)

addEventHandler ( "onPlayerSpawn", root, function()
    local player = client or source
    local serial = getPlayerSerial(player)
    iprint(serial)
    
    local function hasDatabaseRecord(dbData, serial)
        local data = {}
        for _,v in pairs(dbData) do
            if v.serial == serial then
                data.car_id = v.car_id
            end
        end
        return data
    end

    local function checkHasCar(query)
        if not query then return end
        local dbData = dbPoll(query, 0)
		if type(dbData) ~= "table" then
            dbFree(query)
            return
         end

        local dbInfo = hasDatabaseRecord(dbData, getPlayerSerial(player))
        iprint(dbInfo)

        if not table.empty(dbInfo) then 
            local x, y, z = getElementPosition(player)
            createVehicle(dbInfo.car_id, x, y, z + 3)
        else
            outputChatBox ( "У тебя нет тачек для спавна" , player, 255, 255, 255 )
        end
    end
    dbQuery(checkHasCar, db, "SELECT * FROM vehicles")
end)

