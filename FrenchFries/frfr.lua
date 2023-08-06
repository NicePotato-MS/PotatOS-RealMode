--[[

FrenchFries Programming Language Compiler

Made by NicePotato

]]--

-- Save this script as 'my_script.lua'
-- Usage: lua my_script.lua [file_path]

-- Function to check if a file exists
local function file_exists(file_path)
    local file = io.open(file_path, "r")
    if file then
        file:close()
        return true
    end
    return false
end

local function get_file(file_path) -- returns exists, file
    if not file_path:match("^%a:") and not file_path:match("^/") then
        -- Check if the file exists
        -- Relative path, get the current working directory
        local current_dir = io.popen("cd"):read("*l")
        -- Concatenate the current working directory and the relative file path
        file_path = current_dir .. "/" .. file_path
    end
    if file_exists(file_path) then
        return true, io.open(file_path,"r")
    else
        return false, nil
    end
end

-- Check if an argument (file path) was provided
if #arg == 0 then
    print("No file path provided.")
else
    print(get_file(arg[1]))
end
