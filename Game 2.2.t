View.Set ('offscreenonly')

var x : real := 50
var y : real := 50
var velX : real := 0 %velocity in pixels per second
var velY : real := 0
var acceleration : int := 400 %acceleration in pixels per second
var deceleration : int := 400 %deceleration in pixels per second, for when no keys are pressed.

var _delay : int := 0
var _timeSinceLast : int := 0
var t : int

var keys : array char of boolean

function timeSinceLast : int %this hasn't changed
    var t : int := Time.Elapsed
    var out : int := t - _timeSinceLast
    _timeSinceLast := t
    result out
end timeSinceLast

loop
    t := timeSinceLast
    Input.KeyDown (keys)
   
    if keys (KEY_UP_ARROW) then
	velY += acceleration * t / 1000.0 %here we add our acceleration corrected for time to our velocity
    elsif keys (KEY_DOWN_ARROW) then
	velY -= acceleration * t / 1000.0
    else %if no key is pressed, we slow down
	if velY > 0 then
	    velY -= deceleration * t / 1000.0 %reduce velocity if it's positive, again corrected for time
	elsif velY < 0 then
	    velY += deceleration * t / 1000.0 %increase velocity if it's negative
	end if
    end if
   
    if keys (KEY_LEFT_ARROW) then %same thing for the X axis
	velX -= acceleration * t / 1000.0
    elsif keys (KEY_RIGHT_ARROW) then
	velX += acceleration * t / 1000.0
    else
	if velX > 0 then
	    velX -= deceleration * t / 1000.0
	elsif velX < 0 then
	    velX += deceleration * t / 1000.0
	end if
    end if
   
    if keys ('w') then
	_delay += 10
    elsif keys ('s') and _delay > 0 then
	_delay -= 10
    end if
   
    if keys (' ') then %this returns the ball to the starting position when the spacebar is pressed.
	x := 50
	y := 50
	velX := 0
	velY := 0
    end if
   
    %When decelaration is corrected for time, we often end up bouncing between very small positive and negative velocities, so the ball never stops.
    %This corrects it. When the velocity is smaller than the smallest possible deceleration corrected for time, we set it to 0. Using some kinematic
    %equations, we could also set the X and Y values to exactly where the ball should be in this time, but that's not important for this demonstration.
    if velX < deceleration*t/1000 and velX > -deceleration*t/1000 then
	velX := 0
    end if
    if velY < deceleration*t/1000  and velY > -deceleration*t/1000 then
	velY := 0
    end if
   
    y += velY * t / 1000.0 %Finally, we add the velocity corrected for time to the X and Y values.
    x += velX * t / 1000.0
    delay (_delay)
    cls
    locate (1, 1)
    put Time.Elapsed/1000.0
    Draw.FillOval (round (x), round (y), 10, 10, red)
    View.Update
end loop
