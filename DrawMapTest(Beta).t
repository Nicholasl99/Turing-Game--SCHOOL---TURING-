View.Set ("graphics:150;150,offscreenonly")
var tiles : flexible array 0 .. 0 of int

var FileName : string := "map.txt"
var FileNo : int

var displacementX, displacementY : int := 0
var totalX, totalY : int := 0

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
		Draw.FillBox (x * 10 + displacementX, y * 10 + displacementY,
		    x * 10 + 10 + displacementX, y * 10 + 10 + displacementY, red)
		% the +10 is there because each tile is 10 by 10
	    else
		Draw.FillBox (x * 10 + displacementX, y * 10 + displacementY, x * 10 + 10 + displacementX, y * 10 + 10 + displacementY, black)
	    end if
	end for
    end for
end reDraw

var key : array char of boolean
var px, py : int := 1 % we start off at grid 1,1

proc snapGrid
    %if the grid is too far left
    if (displacementX + totalX * 10) < maxx then
	displacementX := maxx - totalX * 10 %we use 10 because that is the size of each tile
	%if the grid is too far right
    elsif (displacementX + 0 * 10) > 0 then
	displacementX := 0 - 0 * 10 %or just zero
    end if
    %if the map is too far down, move it up
    if (displacementY + totalY * 10) < maxy then
	displacementY := maxy - totalY * 10
	% if the map is too far up move it down
    elsif (displacementY + 0 * 10) > 0 then
	displacementY := 0 - 0 * 10 %or just zero
    end if
end snapGrid

loop
    reDraw
    Input.KeyDown (key)
    %array is a function and px-1,py are the parameters
    if key ('a') and tiles (Array (px - 1, py)) = 0 then
	px -= 1
	%notice how this if is within the if that checks weather or not the player has collided?
	%this is convenient since the map should move only if the player moved.
	if px * 10 + displacementX <= maxx div 2 then
	    displacementX += 10
	end if
    end if
    if key ('d') and tiles (Array (px + 1, py)) = 0 then
	px += 1
	if px * 10 + displacementX >= maxx div 2 then
	    displacementX -= 10
	end if
    end if
    if key ('s') and tiles (Array (px, py - 1)) = 0 then
	py -= 1
	if py * 10 + displacementY <= maxy div 2 then
	    displacementY += 10
	end if
    end if
    if key ('w') and tiles (Array (px, py + 1)) = 0 then
	py += 1
	if py * 10 + displacementY >= maxy div 2 then
	    displacementY -= 10
	end if
    end if
    snapGrid
    Draw.FillBox (px * 10 + displacementX, py * 10 + displacementY, px * 10 + 10 + displacementX, py * 10 + 10 + displacementY, yellow)
    View.Update
    delay (50)
end loop
