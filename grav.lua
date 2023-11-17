print('Starting, this process may take a while depending on your hardware..')
local filename = "Player.game__actor__gparam__PlayerGravityParam" --Change this value to the name of the file your trying to change, make sure to put it in the yaml folder
local file = io.open("yaml/"..filename..".yaml", "r")
local text = file:read("*a")
file:close()
function split(pString, pPattern)
    local Table = {}
    local fpat = "(.-)" .. pPattern
    local last_end = 1
    local s, e, cap = pString:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(Table,cap)
        end
        last_end = e+1
        s, e, cap = pString:find(fpat, last_end)
    end
    if last_end <= #pString then
        cap = pString:sub(last_end)
        table.insert(Table, cap)
    end
    return Table
end
function secSplit(text, delim)
    local result = {}
    local magic = "().%+-*?[]^$"

    if delim == nil then
        delim = "%s"
    elseif string.find(delim, magic, 1, true) then
        delim = "%"..delim
    end

    local pattern = "[^"..delim.."]+"
    for w in string.gmatch(text, pattern) do
        table.insert(result, w)
    end
    return result
end
local splittedText = split(text, "JumpGravity: ")
print("Started! Just splitted the text.")
function isEven(number)
    return number % 2 == 0
end
function math.sign(v)
	return (v >= 0 and 1) or -1
end
function round(v, bracket)
	bracket = bracket or 1
	return math.floor(v/bracket + math.sign(v) * 0.5) * bracket
end
function getDecimals(num)
    local newNum = tonumber(num)
    if newNum == math.floor(newNum) then
        return 0
    end
    local sillyNum = secSplit(tostring(newNum), ".")[2]
    return string.len(sillyNum)
end
function getGravNumbers()
    local tabl = {}
    for i,v in pairs(splittedText) do
        if i ~= 1 then
            local splitter = '}'
            if isEven(i) then
                splitter = ','
            end
            local num = split(v, splitter)[1]
            table.insert(tabl, #tabl+1, num)
            print('added index '..i..' with number'..num)
        end
    end
    return tabl
end
function setGravNumbers(gravNumbers, multi)
    local newGravNumbers = {}
    for inter,v in pairs(gravNumbers) do
        table.insert(newGravNumbers, #newGravNumbers+1, v+(multi))
        if getDecimals(newGravNumbers[inter]) > 5 then
            newGravNumbers[inter] = round(tonumber(newGravNumbers[inter]), 5)
        end
        print('set index '..inter..' with number'..newGravNumbers[inter])
    end
    return newGravNumbers
end
print('functions has been made')
local sillyVal = setGravNumbers(getGravNumbers(), -0.05)
print('got the gravity numbers!')
function replaceYamlText()
    local sillyText = text
    for i,v in pairs(getGravNumbers()) do
        sillyText = string.gsub(sillyText, 'JumpGravity: '..tostring(v), 'JumpGravity: '..tostring(sillyVal[i]), 1)
        print('replaced number '..v..' in original file with number '..sillyVal[i])
    end
    return sillyText
end
print('Writing data...')
local exportFile = io.open("yaml/export/export.yaml", "w")
exportFile:write(replaceYamlText())
exportFile:close()
print('')
print('Finished! Check yaml/export/export.yaml for the exported file data!')
