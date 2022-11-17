--Build data table of pixels

--WARNING: Not optimized + dirty

--https://github.com/qntm/braille-encode/blob/main/index.js
local dotdata = ([[
⠀ ⢀ ⠠ ⢠ ⠐ ⢐ ⠰ ⢰ ⠈ ⢈ ⠨ ⢨ ⠘ ⢘ ⠸ ⢸
⡀ ⣀ ⡠ ⣠ ⡐ ⣐ ⡰ ⣰ ⡈ ⣈ ⡨ ⣨ ⡘ ⣘ ⡸ ⣸
⠄ ⢄ ⠤ ⢤ ⠔ ⢔ ⠴ ⢴ ⠌ ⢌ ⠬ ⢬ ⠜ ⢜ ⠼ ⢼
⡄ ⣄ ⡤ ⣤ ⡔ ⣔ ⡴ ⣴ ⡌ ⣌ ⡬ ⣬ ⡜ ⣜ ⡼ ⣼
⠂ ⢂ ⠢ ⢢ ⠒ ⢒ ⠲ ⢲ ⠊ ⢊ ⠪ ⢪ ⠚ ⢚ ⠺ ⢺
⡂ ⣂ ⡢ ⣢ ⡒ ⣒ ⡲ ⣲ ⡊ ⣊ ⡪ ⣪ ⡚ ⣚ ⡺ ⣺
⠆ ⢆ ⠦ ⢦ ⠖ ⢖ ⠶ ⢶ ⠎ ⢎ ⠮ ⢮ ⠞ ⢞ ⠾ ⢾
⡆ ⣆ ⡦ ⣦ ⡖ ⣖ ⡶ ⣶ ⡎ ⣎ ⡮ ⣮ ⡞ ⣞ ⡾ ⣾
⠁ ⢁ ⠡ ⢡ ⠑ ⢑ ⠱ ⢱ ⠉ ⢉ ⠩ ⢩ ⠙ ⢙ ⠹ ⢹
⡁ ⣁ ⡡ ⣡ ⡑ ⣑ ⡱ ⣱ ⡉ ⣉ ⡩ ⣩ ⡙ ⣙ ⡹ ⣹
⠅ ⢅ ⠥ ⢥ ⠕ ⢕ ⠵ ⢵ ⠍ ⢍ ⠭ ⢭ ⠝ ⢝ ⠽ ⢽
⡅ ⣅ ⡥ ⣥ ⡕ ⣕ ⡵ ⣵ ⡍ ⣍ ⡭ ⣭ ⡝ ⣝ ⡽ ⣽
⠃ ⢃ ⠣ ⢣ ⠓ ⢓ ⠳ ⢳ ⠋ ⢋ ⠫ ⢫ ⠛ ⢛ ⠻ ⢻
⡃ ⣃ ⡣ ⣣ ⡓ ⣓ ⡳ ⣳ ⡋ ⣋ ⡫ ⣫ ⡛ ⣛ ⡻ ⣻
⠇ ⢇ ⠧ ⢧ ⠗ ⢗ ⠷ ⢷ ⠏ ⢏ ⠯ ⢯ ⠟ ⢟ ⠿ ⢿
⡇ ⣇ ⡧ ⣧ ⡗ ⣗ ⡷ ⣷ ⡏ ⣏ ⡯ ⣯ ⡟ ⣟ ⡿ ⣿]]):gsub('\n', ' ')



local function GenerateDotData() --im lazy, so this will generate a dictionary with all of the patterns formatted.
    local Split=function(a,b)local c={}for d,b in a:gmatch("([^"..b.."]*)("..b.."?)")do table.insert(c,d)if b==''then return c end end end
    local function ToBinary(a)
        local t = {}
        while a > 0 do
            local r = math.fmod(a, 2)
            t[#t + 1] = string.sub(r, 1, 1)
            a=(a - r) / 2
        end
        local s = string.reverse(table.concat(t))
        return string.rep('0', 8 - #s) .. s
        --return s
    end
    local function format(s)
        --return string.rep('0', 8 - #s) .. s
        return s
    end
    local t = Split(dotdata, ' ')
    local newt = {}
    --print(#t) --> 256
    local inputa = false
    local str = ''
    local sep = ' '
    for i = 1, #t do
        newt[i - 1] = format(t[i])
    end
    return newt
end
local dots = GenerateDotData()
--Order: LU, RU, LD, RD







--Main function
function Pixel(t)
    local rows = {}
    --Just loop over once
    --Build min / max data while building rows
    local minx, maxx, miny, maxy = nil, nil, nil, nil
    for x, v in pairs(t) do
        minx = minx and (x < minx and x or minx) or x
        maxx = maxx and (x > maxx and x or maxx) or x
        for y, v2 in pairs(v) do
            miny = miny and (y < miny and y or miny) or y
            maxy = maxy and (y > maxy and y or maxy) or y
            rows[y] = rows[y] or {}
            rows[y][x] = v2
        end
    end

    --Check if blank
    if not (minx and maxx and miny and maxy) then
        return ''
    end

    local out = {}
    --Now the real work
    for y = miny, maxy, 4 do
        for x = minx, maxx, 2 do
            --local c1, c2 = rows[y], rows[y + 1]
            local c1, c2 = t[x], t[x + 1]
            --Now, dirty part
            --This is really efficient and optimized
            local pixel = 
            (c1 and (
                (c1[y] or 0) * 128 + 
                (c1[y + 1] or 0) * 64 + 
                (c1[y + 2] or 0) * 32 + 
                (c1[y + 3] or 0) * 16
            ) or 0) + 
            (c2 and (
                (c2[y] or 0) * 8 + 
                (c2[y + 1] or 0) * 4 + 
                (c2[y + 2] or 0) * 2 + 
                (c2[y + 3] or 0)
            ) or 0)
            --print(pixel)
            out[#out + 1] = dots[pixel]
        end
        out[#out + 1] = '\n'
    end
    return table.concat(out)
end

return Pixel