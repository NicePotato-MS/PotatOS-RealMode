--[[

FrenchFries Programming Language Lexer

Made by NicePotato

]]--

local lexer = {}

lexer._VERSION = 1

lexer.tokens = {}
local tokens = lexer.tokens

tokens.constant = {
    "true",
    "false",
    "ffcnst_*"
}
tokens.keyword = {
    "if",
    "then",
    "else",
    "end",
    "while",
    "for",
    "do",
    "function"
}
tokens.operator = {
    "and",
    "or",
    "not"
}
tokens.math = {
    "+",
    "-",
    "*",
    "/",
    "^",
    "="
}
tokens.data_type = {
    "byte",
    "word",
    "dword",
    "qword",
    "string"
}
tokens.conditional = {
    "==",
    "!=",
    ">",
    "<",
    ">=",
    "<="
}
tokens.compiler_keyword = {
    "#define",
    "#ifdef",
    "#then",
    "#else",
    "#end",
    "#suppress"
}

tokens.whitespace = {
    "\r",
    "\t",
    "\v",
    "\f",
    " "
}

tokens.string = {
    '"',
    "'"
}

tokens.open_bracket = {
    '(',
    '[',
    '{'
}

tokens.close_bracket = {
    ')',
    ']',
    '}'
}

tokens.comment = "--"

tokens.seperator = ","

local stopTemp = {
    tokens.whitespace,
    tokens.open_bracket,
    tokens.close_bracket,
    tokens.string,
    tokens.math,
    tokens.conditional
}
local stopWords = {}
for _,t in pairs(stopTemp) do
    for _,v in pairs(t) do
        table.insert(stopWords, v)
    end
end
table.insert(stopWords, tokens.seperator)
table.insert(stopWords, tokens.comment)
table.insert(stopWords, '\n')
table.insert(stopWords, ';')
table.insert(stopWords, "'")
table.insert(stopWords, '"')
stopTemp = nil

local specialTokens = {}
specialTokens["="] = "=="
specialTokens["-"] = "--"
specialTokens[">"] = ">="
specialTokens["<"] = "<="
specialTokens["!"] = "!=" -- not needed atm, possibly for future

local getTypeTemp = {}
getTypeTemp["compiler_keyword"] = tokens.compiler_keyword
getTypeTemp["keyword"] = tokens.keyword
getTypeTemp["operator"] = tokens.operator
getTypeTemp["math"] = tokens.math
getTypeTemp["conditional"] = tokens.conditional
getTypeTemp["constant"] = tokens.constant
getTypeTemp["data_type"] = tokens.data_type
getTypeTemp["open_bracket"] = tokens.open_bracket
getTypeTemp["close_bracket"] = tokens.close_bracket
getTypeTemp["whitespace"] = tokens.whitespace
local getType = {}
for k,v in pairs(getTypeTemp) do
    for _,t in pairs(v) do
        getType[t] = k
    end
end
getTypeTemp = nil

getType[","] = "seperator"
getType[";"] = "break"
getType["\n"] = "newline"

local function isType(str, type)
    local ret = false
    for _,v in pairs(type) do
        if str == v then ret = true break end
    end
    return ret
end

function lexer.parse(str)
    if type(str) ~= "string" then return nil end
    local retTokens = {}
    local retTypes = {}
    local retPos = {}
    local ptr = 1
    local length = str:len()
    
    while ptr<=length do
        -- Search for tokens
        local searchLoop = true
        local token = ""
        local ptrBefore = ptr
        while searchLoop do
            -- Check if we have reached a stoptoken
            for _,v in pairs(stopWords) do
                if str:sub(ptr,ptr+v:len()-1) == v then -- check if this token matches this stop
                    if specialTokens[v] then -- Check if this is a special case
                        if str:sub(ptr,ptr+1) == "--" then
                            searchLoop = false
                            break
                        elseif str:sub(ptr,ptr+specialTokens[v]:len()-1) ~= specialTokens[v] then
                            -- ^ check if the special case is in effect
                            if token == "" then
                                token = v
                                ptr=ptr+v:len()
                            end
                            searchLoop = false
                            break
                        end
                    else
                        if token == "" then
                            token = v
                            ptr=ptr+v:len()
                        end
                        searchLoop = false
                        break
                    end
                end
            end
            if searchLoop then
                token=token..str:sub(ptr,ptr)
                ptr=ptr+1
            end
            if ptr > length then break end -- check if we have more characters
        end
        if token ~= "" then -- Did we actually get a token?
            table.insert(retPos, ptrBefore)
            local tokenType = getType[token:lower()] -- This makes tokens non-case-sensitive
            if tokenType then -- Easy, let's insert the token and type
                table.insert(retTokens, token)
                table.insert(retTypes, tokenType)
            else
                if tonumber(token:sub(1,1)) then -- token is number (even if malformed)
                    table.insert(retTokens, token)
                    table.insert(retTypes, "number")
                else
                    table.insert(retTokens, token)
                    table.insert(retTypes, "other")
                end
            end
        end

        -- Look for strings
        for _,mark in pairs(tokens.string) do
            if str:sub(ptr,ptr) == mark then
                table.insert(retPos, ptr)
                local nextNewline = str:find("\n", ptr+1)
                local nextSemi = str:find(";", ptr+1)
                local nextMark = str:find(mark, ptr+1)
                local nextBreak = nextSemi or nextNewline or nil
                if nextMark then -- Do we have another mark?
                    if nextBreak then -- Yes, do we have a break after this?
                        if nextBreak > nextMark then -- Is the break after the mark?
                            table.insert(retTokens, str:sub(ptr, nextMark))
                            table.insert(retTypes, "string")
                            ptr = nextMark+1
                        else -- No? Then let's get to the break at least. Something is wrong.
                            table.insert(retTokens, str:sub(ptr, nextBreak-1))
                            table.insert(retTypes, "string")
                            ptr = nextBreak
                        end
                    else -- No? then this is the last part of the file
                        table.insert(retTokens, str:sub(ptr))
                        table.insert(retTypes, "string")
                        ptr = length+1
                        break -- Thats it, break out of the loop, very small optimization
                    end
                else -- No?
                    if nextBreak then -- Since not, can we get to end of section?
                        table.insert(retTokens, str:sub(ptr, nextBreak-1))
                        table.insert(retTypes, "string")
                        ptr = nextBreak
                    else -- No? Then let's get to end of file
                        table.insert(retTokens, str:sub(ptr))
                        table.insert(retTypes, "string")
                        ptr = length+1
                        break -- Thats it, break out of the loop, very small optimization
                    end
                end
            end
        end
        -- Look for comment
        if str:sub(ptr,ptr+tokens.comment:len()-1) == tokens.comment then
            table.insert(retPos, ptr)
            local commentText -- Text of the comment
            local nextNewline = str:find("\n", ptr)
            if nextNewline then -- Check if there is another line
                commentText = str:sub(ptr, nextNewline-1)
                ptr = nextNewline
            else -- If not get string to end of file
                commentText = str:sub(ptr)
                ptr = length+1
            end
            table.insert(retTokens, commentText)
            table.insert(retTypes, "comment")
        end
    end

    return retTokens, retTypes, retPos
end

return lexer