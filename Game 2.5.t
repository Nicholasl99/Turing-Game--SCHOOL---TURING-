View.Set ("graphics:600;600,offscreenonly")
var tiles : flexible array 0 .. 0 of real

var FileName : string := "map.txt"
var FileNo : int
var displacementX, displacementY : int := 0
var totalX, totalY : int := 0
var on_ground : boolean := true
% Picture Id's %
var player : int := Pic.FileNew ("player1.bmp")
var block4 : int := Pic.FileNew ("block(4).bmp")
%---Customizable Variables (Carful what you do)---%
var playerHBoffsetX : int := 10
var playerHBoffsetY : int := 26
var block_size : int := 40
%-------------------------------------------------%
var velX : real := 0
var g : real := 1
var velY : real := 0
%-------------------------------------------------%

fcn Array (x, y : int) : int
    %make sure that going offscreen won't crash the game
    if x >= 0 and x < totalX and y >= 0 and y < totalY then
	result totalX * y + x %totalY * x + y also works
    else
	for k : 0 .. upper (tiles)
	    if tiles (k) = 1 then
		result k
	    end if
	end for
    end if
end Array
%open the file
open : FileNo, FileName, get
get : FileNo, totalX %how many X's
get : FileNo, totalY %how many Y's
new tiles, totalX * totalY - 1 %total number of elements
%the -1 is there because we started the aray at 0
for decreasing y : totalY - 1 .. 0 % for every y remember we started the array at 0!
    for x : 0 .. totalX - 1 %for every x
	get : FileNo, tiles (Array (x, y)) %get the tile type at (x,y) and store it in it's 1d counter-part
    end for
end for

close (FileNo)

procedure reDraw
    for x : 0 .. totalX - 1
	for y : 0 .. totalY - 1
	    %array is a function and px-1,py are the parameters
	    if tiles (Array (x, y)) = 1 then
		Draw.FillBox (x * block_size + displacementX, y * block_size + displacementY,
		    x * block_size + block_size + displacementX, y * block_size + block_size + displacementY, red)
		Pic.Draw (block4, x * block_size + displacementX, y * block_size + displacementY, picMerge)
		% the +block_size is there because each tile is block_size by block_size
	    else
		Draw.FillBox (x * block_size + displacementX, y * block_size + displacementY, x * block_size + block_size + displacementX, y * block_size + block_size + displacementY, black)
	    end if
	end for
    end for
end reDraw

var key : array char of boolean
var px, py : real := 1 % we start off at grid 1,1
var x2 : int := round (px) + 10

var y2 : int := round (py) + 10

proc snapGrid
    %if the grid is too far left
    if (displacementX + totalX * block_size) < maxx then
	displacementX := maxx - totalX * block_size %we use block_size because that is the size of each tile
	%if the grid is too far right
    elsif (displacementX + 0 * block_size) > 0 then
	displacementX := 0 - 0 * block_size %or just zero
    end if
    %if the map is too far down, move it up
    if (displacementY + totalY * block_size) < maxy then
	displacementY := maxy - totalY * block_size
	% if the map is too far up move it down
    elsif (displacementY + 0 * block_size) > 0 then
	displacementY := 0 - 0 * block_size %or just zero
    end if
end snapGrid

loop
    reDraw
    Input.KeyDown (key)
    %array is a function and px-1,py are the parameters
    if key ('a') then
	if velX * -1 = 3 then
	    velX += 0
	else
	    velX -= 1
	end if
    end if
    if key ('d') then
	if velX = 3 then
	    velX += 0
	else
	    velX += 1
	end if
    end if
    if key ('s') then
	put "beta stuff"
    end if
    if key ('w') then
	velY += 8
    end if
    if key ('*') then
	Draw.Box (round (px) * block_size + displacementX, round (py) * block_size + displacementY, round (px) * block_size + block_size + displacementX + playerHBoffsetX, round (py) * block_size + 
	    block_size + displacementY +
	    playerHBoffsetY, yellow)
	if on_ground = true then
	    put "On Ground"
	else
	    put "Off Ground"
	end if
	put "velocity X: ", velX
	put "velocity Y: ", velY
    end if

    %---%
    if on_ground = false then
	velY -= g
    elsif on_ground = true then
	velY := 0
    end if

    if velX > 0 then
	velX -= 0.5
    elsif velX < 0 then
	velX += 0.5
    end if

    px += round (velX)
    py += round (velY)
    %---%
    %procedure position%
    if py * block_size + displacementY >= maxy div 2 then
	displacementY -= block_size
    end if
    if py * block_size + displacementY <= maxy div 2 then
	displacementY += block_size
    end if
    if px * block_size + displacementX <= maxx div 2 then
	displacementX += block_size
    end if
    if px * block_size + displacementX >= maxx div 2 then
	displacementX -= block_size
    end if
    %end position%
    %-_---%
    if tiles (Array (round (px), round (py) - 1)) = 0 then
	on_ground := false
    else
	on_ground := true
    end if
    snapGrid
    locate (1, 1)
    %position%
    Pic.Draw (player, round (px) * block_size + displacementX, round (py) * block_size + displacementY, picMerge)
    View.Update
    delay (10)
    cls
end loop

