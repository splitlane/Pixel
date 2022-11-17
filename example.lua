--Hacky way to enable unicode on terminal: It will mess up things (input?)
os.execute('chcp 65001')


local Pixel = require('Pixel')

local t = {
    [1] = {
        [1] = 1,
        [2] = 0,
        [3] = 1
    },
    [2] = {
        [1] = 0,
        [2] = 1,
        [3] = 0
    },
    [3] = {
        [1] = 1,
        [2] = 0,
        [3] = 1
    }
}
local out = Pixel(t)
print(out)