View.Set ("graphics:1280;1024,offscreenonly")

const map_size :int := 30

var tiles : array 0 .. (map_size-1), 0 .. (map_size-1) of int



var FileName : string := "map.txt"
var FileNo : int
var BlockID : int
var Block : int := Pic.FileNew ("block (1).bmp")

open : FileNo, FileName, get
for decreasing y : (map_size-1) .. 0
    for x : 0 .. (map_size-1)
	get : FileNo, tiles (x, y)
    end for
end for
close (FileNo)



procedure reDraw
    for x : 0 .. (map_size-1)
	for y : 0 .. (map_size-1)
	    if tiles (x, y) = 1 then
		Draw.FillBox (x * map_size, y * map_size, x * map_size + map_size, y * map_size + map_size, red)
		Pic.Draw (Block, x, y, picMerge)
	    else
		Draw.FillBox (x * map_size, y * map_size, x * map_size + map_size, y * map_size + map_size, black)
		Pic.Draw (Block, x, y, picMerge)
	    end if
	end for
    end for
end reDraw




var key : array char of boolean
var px, py : int := 1 %Player Starting Position%

loop
    reDraw
    Input.KeyDown (key)
    if key ('a') and tiles (px - 1, py) = 0 then
	px -= 1
    end if
    if key ('d') and tiles (px + 1, py) = 0 then
	px += 1
    end if
    if key ('s') and tiles (px, py - 1) = 0 then
	py -= 1
    end if
    if key ('w') and tiles (px, py + 1) = 0 then
	py += 1
    end if

    Draw.FillBox (px * map_size, py * map_size, px * map_size + map_size, py * map_size + map_size, yellow)
    View.Update
    delay (5)
end loop
