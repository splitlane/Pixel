# Pixel: A library to convert a 2-dimensional array into braille characters


- [Pixel: A library to convert a 2-dimensional array into braille characters](#pixel-a-library-to-convert-a-2-dimensional-array-into-braille-characters)
  - [How to use](#how-to-use)
  - [Optimization](#optimization)
  - [Benchmarks](#benchmarks)
  - [How it works](#how-it-works)


## How to use
Important Note: You need a terminal that supports unicode if you are planning on outputting to terminal, or you can just write to file.    

Do you know 2-dimensional arrays in lua?
The first index is x, second index is y.
For example,
```lua
local t = {}
t[1][2] = 1
```
This sets the dot x = 1, y = 2 {1, 2} as 1.  
To use this library, just require it and call it as so.
```lua
local Pixel = require('Pixel')

local t = {
    [1] = {
        [1] = 1,
        [2] = 0,
        [3] = 1
    }
}
local out = Pixel(t)
print(out)
```

## Optimization
The code has been carefully optimized, so there might be "dirty" / hard-coded parts.

## Benchmarks
TODO

## How it works

Steps
1. Convert to rows locally
2. Finds the min / max of x and y
3. Iterate over rows (y)
4. Iterate over column (x)
5. Look at each 2x4 "pixel"
6. Push to out
7. Repeat
8. Return
