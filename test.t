var numFrames : int := 7
var walkRight : array 0 .. numFrames of int
var walkLeft : array 0 .. numFrames of int
var delayTime : int
var keys : array char of boolean
var x : int := 0
var y : int := 100
var canJump : boolean := true
var velocity : int := 100
var gravity : int := 1
var maxVelocity := 100

% process BGM
%     loop
%         Music.PlayFile ("ice_Climber.mp3")
%     end loop
% end BGM
%
% fork BGM

View.Set ("graphics:960;720, nobuttonbar, nocursor")

% Loads the right walking frames
for picNo : 0 .. numFrames
    walkRight (picNo) := Pic.FileNew ("Morse_Walk_" + intstr (picNo) + "_R.bmp")
end for

% Loads the left walking frames
for picNo : 0 .. numFrames
    walkLeft (picNo) := Pic.FileNew ("Morse_Walk_" + intstr (picNo) + "_L.bmp")
end for

% Loads the jumping frames
var jumpPicR := Pic.FileNew ("Morse_Jump_R.bmp")
var jumpPicL := Pic.FileNew ("Morse_Jump_L.bmp")

% Sets the background to be blue
Draw.FillBox (0, 0, maxx, maxy, blue)

% Define the sprites for movement
var spriteWalkR := Sprite.New (walkRight (1))
Sprite.SetPosition (spriteWalkR, 0, y, false)

var spriteWalkL := Sprite.New (walkLeft (1))

var spriteJumpR := Sprite.New (jumpPicR)

var spriteJumpL := Sprite.New (jumpPicL)

% Walking loop
Sprite.Show (spriteWalkR)
loop
    Input.KeyDown (keys)
    if keys (KEY_RIGHT_ARROW) then
	if x < 900 then
	    Sprite.Hide (spriteWalkL)
	    x += 8
	    Sprite.Show (spriteWalkR)
	    Sprite.Animate (spriteWalkR, walkRight ((x div 8) mod numFrames), x, y, false)
	    delay (40)
	end if
	Sprite.Animate (spriteWalkR, walkRight (1), x, y, false)
    elsif keys (KEY_LEFT_ARROW) then
	if x > 0 then
	    Sprite.Hide (spriteWalkR)
	    x -= 8
	    Sprite.Show (spriteWalkL)
	    Sprite.Animate (spriteWalkL, walkLeft ((x div 8) mod numFrames), x, y, false)
	    delay (40)
	end if
	Sprite.Animate (spriteWalkL, walkLeft (1), x, y, false)
    end if
    % Jump if on the ground and you just didn't jump
    if keys (KEY_UP_ARROW) and y = 100 and canJump then
    Sprite.Hide (spriteWalkR)
    Sprite.Hide (spriteWalkL)
    Sprite.Show (spriteJumpR)
	velocity := maxVelocity
	y += velocity
	Sprite.SetPosition (spriteJumpR, x, y, false)
	canJump := false
    elsif y = 100 then
	% Need to touch the ground to jump again
	canJump := true
    end if
    % Fall due to gravity
    if y >= 200 then
	velocity -= gravity
	y += velocity
	if y <= 200 then
	    y := 100
	    velocity := 0
	end if
    end if
end loop 
