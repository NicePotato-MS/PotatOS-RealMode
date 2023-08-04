-- Lua and C like syntax

-- Constants
-- 'true' is 1
-- 'false' is 0
-- 'FFCNST_PRG_SIZE' is the size of the program in bytes, dependent on compile settings

-- Hex values are converted to regular numbers at compile time


-- Variables
-- Variables can have letters of any case, numbers and hyphens. They cannot start with numbers.
-- Variables cannot start with "FFCNST_" as this is reserved only for special constants 
-- Variable 'tEst1' is accurate but not 'a+b-c' nor '123abc'
-- They are case-sensitive, meaning variable 'test' and variable 'Test' are different

-- Initializing a variable with just '=' will be put wherever the compiler decides is fit
byte byteVar1 = 10 -- Number taking up a byte
word wordVar1 = 312 -- Number taking up a word (2 bytes, 16-bits)
dword dwordVar1 = 3746926745 -- Number taking up a DWord (4 bytes, 32-bits)
qword qwordVar1 = 842729494831 -- Number taking up a QWord (8 bytes, 64-bits)
-- You can initialize a variable at an address with '>'
byte byteVar2 > 0xB000 = 1
-- You can use variables here, however its location will not change if the variable changes
byte byteVar3 > byteVar1 = 0
-- Address of byteVar3 is 10 or 0xA
byteVar1 = 11
-- Address of byteVar3 is still 10, not 11 or 0xB

-- Not setting a variable name with '>' implies that you want to just modify or get at that address
byte > 0xC000 = 98
-- You can use variables here
byte > byteVar1 = 98

-- You can get a pointer to a value by putting '*' in front
qword pointerVal = *byteVar2

-- You can declare something as an array by tagging [] onto it. Works for byte, word, dword, and qword
byte[] byteArray1 = {10,20,30,40,50}
word[] wordArray1 = {1372,257,890,102}
dword[] dwordArray = {4628916312,9462754714}
qword[] qwordArray = {1471395,1241052,123694}
-- These will by default be size of set values (4 values in a byte array means 4 bytes allocated)
-- You can set the specific size of the array by putting a number in []
byte[32] byteArray2 = {50,40,30,20,10} -- 32 bytes
word[32] wordArray2 = {982,742,164,473} -- 32 words, 64 bytes
-- You can put characters into arrays
byte[] charArray = "Hello, chars!" -- Note, there is no null byte at the end

-- Strings are slightly different than byte arrays as they add a null byte automatically.
-- Otherwise, they are identical
string stringVar1 = "Hello, world!" -- is actually "Hello, world!\0"
-- Here shows the difference between them
byte[] notAString = "String" -- is actually "String"
string isAString = "String" -- is actually "String\0"
-- You can also tag on a [] but do be aware you need to leave room for the null byte
string[6] helloString = "hello" -- 6 bytes in total 'h','e','l','l','o','\0'
-- string[5] helloString = "hello" -- would cause a compilation error


-- Conditionals
-- Code will run inside of a conditional statement as long as the value isn't 0 if no operand is present
if true then
    -- This if statement will always execute the code here
end
if false then
    -- This if statement will never execute the code here
end
-- Parentheses are optional, and if you use them no spaces are needed between keywords
if(true)then
    -- This is valid
end
if (true) then
    -- So is this
end

-- You can use variables in an if statement (obviously)
if byteVar2 then -- byteVar2 is 1, so it's true
    -- This code will run
end
if byteVar2 then -- byteVar3 is 0, so it is false
    -- This code will NOT run
end
if byteVar1 then -- byteVar1 is 11, so it's true as it's not 0
    -- This code will run
end

-- Comparisons are as follows
-- val1 == val2 - run if equal
-- val1 != val2 - run if not equal
-- val1 > val2 - run if val1 is greater than val2
-- val1 < val2 - run if val1 is less than val2
-- val1 >= val2 - run if val1 is greater than or equal to val2
-- val1 <= val2 - run if val1 is less than or equal to val2

-- Bool operations are as follows
-- not val - returns opposite bool result of val1
-- val1 or val2 - returns true if either val1 or val2 is true
-- val1 and val2 - returns true if both val1 and val2 is true

-- not takes highest priority and computes first, then or+and
-- not true or false - (not true) or false - false or false - false
-- not false or true - (not false) or true - true or true - true

if true == true then
    -- This code will run
end
if byteVal1 == byteVal2 then -- byteVal1 is 11 and byteVal2 is 0. They are not equal
    -- This code will not run as they must be equal
end
if byteVal1 != byteVal2 then -- byteVal1 is 11 and byteVal2 is 0. They are not equal
    -- This code will run as they are not equal
end
if byteVal1 > byteVal2 then -- byteVal1 is 11 and byteVal2 is 0. val1 is greater than val2
    -- This code will run as val1 is greater than val2
end
if byteVal1 < byteVal2 then -- byteVal1 is 11 and byteVal2 is 0. val1 is not greater than val2
    -- This code will not run as val1 must be less than val2
end
if true or false then -- true is true, so false will not be checked
    -- This code will run
end
if false or true then -- false is false, so true will be checked. It is true so the code will be ran.
    -- This code will run
end
if false or false or true -- These are checked sequentially
    -- This code will run
end
if true and false -- true is true, checking next. false is false, don't run code.
    -- This code will not run
end
if true and true -- true is true, checking next. true is true, run code.
    -- This code will run
end
if true and true and true -- Same as before, these are checked sequentially
    -- This code will run
end


function exampleFunction()

end