local lexer = require("frfrlexer")
local tableserial = require("tableserial")

local function fileExists(filename)
    local file = io.open(filename, "r")
    if file then
        file:close()
        return true
    end
    return false
end

local filename = "out.txt"

-- Delete the file if it exists
if fileExists(filename) then
    os.remove(filename)
    print("Deleted existing file: " .. filename)
end

-- Create and open the file for appending
local file = io.open(filename, "a")
if file then
    print("Created and opened file: " .. filename)
else
    print("Failed to open file: " .. filename)
    os.exit(-1)
end

local function appendToFile(text)
    file:write(text .. "\n")
    file:flush()
end

-- local tokens, types = lexer.parse([[if+then
-- --Hello
-- --wow
-- 'string';'more string'
-- "also a string"
-- 'how sad, this string is incomplete!
-- 'even worse, this is at eof!]])
-- print(tableserial(tokens))
-- print(tableserial(types))

local FFscript = io.open("example.frfr","r")
if not FFscript then os.exit(-1) end
local tokens, types, pos = lexer.parse(FFscript:read("a"))
appendToFile(tableserial(tokens))
appendToFile(tableserial(types))
appendToFile(tableserial(pos))

file:close()