import GUI
View.Set ("graphics:1024;768,offscreenonly,nobuttonbar")
var tiles : flexible array 0 .. 0 of int

var FileName : string := "map.txt"
var FileNo : int
var displacementX, displacementY : int := 0
var totalX, totalY : int := 0
var on_ground : boolean := true
var g : real := 1
% Picture Id's %
var player : int := Pic.FileNew ("Player.bmp")
var title : int := Pic.FileNew ("Title.bmp")
var block4 : int := Pic.FileNew ("Tree.bmp")
var block2 : int := Pic.FileNew ("Grass.bmp")
var block3 : int := Pic.FileNew ("Water.bmp")
%---Customizable Variables (Carful what you do)---%
var playerHBoffsetX : int := 0
var playerHBoffsetY : int := 0
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
%--------------------------------------------------%
%--------------------------------------------------%


procedure DrawMap
    for x : 0 .. totalX - 1
	for y : 0 .. totalY - 1
	    %array is a function and px-1,py are the parameters
	    if tiles (Array (x, y)) = 1 then
		Draw.FillBox (x * block_size + displacementX, y * block_size + displacementY,
		    x * block_size + block_size + displacementX, y * block_size + block_size + displacementY, red)
		Pic.Draw (block4, x * block_size + displacementX, y * block_size + displacementY, picMerge)
		% the +block_size is there because each tile is block_size by block_size
	    elsif tiles (Array (x, y)) = 2 then
		Draw.FillBox (x * block_size + displacementX, y * block_size + displacementY,
		    x * block_size + block_size + displacementX, y * block_size + block_size + displacementY, red)
		Pic.Draw (block3, x * block_size + displacementX, y * block_size + displacementY, picMerge)
		% the +block_size is there because each tile is block_size by block_size
	    else
		Draw.FillBox (x * block_size + displacementX, y * block_size + displacementY, x * block_size + block_size + displacementX, y * block_size + block_size + displacementY, black)
		Pic.Draw (block2, x * block_size + displacementX, y * block_size + displacementY, picMerge)
	    end if
	end for
    end for
end DrawMap

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












procedure startgame
    loop
	DrawMap
	Input.KeyDown (key)
	%array is a function and px-1,py are the parameters
	if key ('a') and tiles (Array (px - 1, py)) = 0 then
	    px -= 1
	    %notice how this if is within the if that checks weather or not the player has collided?
	    %this is convenient since the map should move only if the player moved.
	    if px * block_size + displacementX <= maxx div 2 then
		displacementX += block_size
	    end if
	end if
	if key ('d') and tiles (Array (px + 1, py)) = 0 then
	    px += 1
	    if px * block_size + displacementX >= maxx div 2 then
		displacementX -= block_size
	    end if
	end if
	if key ('s') and tiles (Array (px, py - 1)) = 0 then
	    py -= 1
	    if py * block_size + displacementY <= maxy div 2 then
		displacementY += block_size
	    end if
	end if
	if key ('w') and tiles (Array (px, py + 1)) = 0 then
	    py += 1
	    if py * block_size + displacementY >= maxy div 2 then
		displacementY -= block_size
	    end if
	end if
	if key ('*') then
	    Draw.Box (px * block_size + displacementX, py * block_size + displacementY, px * block_size + block_size + displacementX + playerHBoffsetX, py * block_size + block_size + displacementY +
		playerHBoffsetY, yellow)
	    if on_ground = true then
	    else
	    end if
	end if
	if tiles (Array (px, py - 1)) = 0 then
	    on_ground := false
	else
	    on_ground := true
	end if
	snapGrid
	Pic.Draw (player, px * block_size + displacementX, py * block_size + displacementY, picMerge)
	View.Update
	delay (50)
    end loop
end startgame

procedure mainmenu
    Pic.Draw (title, maxx div 2 - 125, maxy div 2 + 200, picMerge)
    var BtnSG : int := GUI.CreateButton (maxx div 2, maxy div 2 + 100, 0, "Start Game", startgame)
    loop
	exit when GUI.ProcessEvent
    end loop
end mainmenu
%actuall run phase%
mainmenu
startgame
