View.Set ("graphics:600;600,offscreenonly")
var tiles : flexible array 0 .. 0 of int
var counter : int := 0
var FileName : string := "map.txt"
var FileNo : int
var displacementX, displacementY : int := 0
var totalX, totalY : int := 0
var ground : boolean := true
var xv : real := 0
var yv : real := 0
var g : real := 1
var x1 : int := 1
var jumpcount :int :=0
var x2 : int := x1 + 10
var y1 : int := 1
var y2 : int := y1 + 10
% Picture Id's %
var player : int := Pic.FileNew ("player1.bmp")
var block4 : int := Pic.FileNew ("block(4).bmp")
%---Customizable Variables (Carful what you do)---%
var playerHBoffsetX : int := 10
var playerHBoffsetY : int := 26
var block_size : int := 40
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
    Draw.Box (x1 - 1, y1 - 1, x2 + 1, y2 + 1, grey)
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
var px, py : int := 1 % we start off at grid 1,1

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
var timeRunning : int := Time.Elapsed
var jumptimer :int := Time.Elapsed
    reDraw
    Input.KeyDown (key)
    if key ('w') and y2 < maxy and jumptimer >1000 then
	yv += 8
	jumpcount +=1
    end if
    if key ('a') and x1 > 0 then
	xv -= 1
    elsif key ('d') and x2 < maxx then
	xv += 1
    elsif key (KEY_ESC) then
	exit
    end if

    if y1 > 0 then
	yv -= g
    elsif y1 < 0 then
	yv := 0
	y1 := 0
    end if

    if xv > 0 then
	xv -= 0.5
    elsif xv < 0 then
	xv += 0.5
    end if

    if x1 < 0 then
	x1 := 0
	xv := 0
    elsif x2 > maxx then
	x1 := maxx - 10
	xv := 0
    end if

    if y2 > maxy then
	y1 := maxy - 10
	yv := 0
    end if

    if y1 = 0 then
	ground := true
	jumpcount := 0
    else
	ground := false
    end if

    x1 += round (xv)
    y1 += round (yv)
    x2 := x1 + 10
    y2 := y1 + 10
    %array is a function and px-1,py are the parameters
    if key ('*') then
	Draw.FillBox (x1, y1, x2+40, y2+56, black)
	locate (1, 1)
	if ground = true then
	    put "On Ground"
	else
	    put "Off Ground"
	end if
	put "This program has run: ", timeRunning, " milliseconds"
	put "Time Between Last Jump:  ", timeRunning, " milliseconds" 
    end if


    snapGrid
    Pic.Draw (player, x1, y1, picMerge)
    View.Update
    delay (10)
end loop
