local TICKRATE = 1/320

require "Colliders"
require "Player"
require "Bullets"
require "Chicken"
require "Boss"

--Background image
background = love.graphics.newImage("assets/background.png")
background:setFilter("nearest", "nearest")


love.load = function()

	--60 fps cap
	tick_period = 1 /60
	accumulator = 0.0
	all_collected = false


	--Set/ get window size
	love.window.setMode(1500, 700)
	window_width, window_height = love.graphics.getDimensions( )

	
	--Loading other files
	Colliders.load()
	Chicken.load()
	Boss.load()
	Bullets.load()

	--Boos room barrier
	Colliders.add(770, 20, 30, 110)

end



love.update = function(dt)
	accumulator = accumulator + dt

	if accumulator >= tick_period then

		--Loading other files
		Player.update()
		Chicken.update()
		Boss.update()
		Bullets.update()


		--Checks if all chickens are gone
		if #Chicken.objects <= 0 then
			all_collected = true
		end


		--Temporary shortcuts
		if love.keyboard.isDown("l") then
			all_collected = true
		end
		if love.keyboard.isDown("p") then
			Player.x = 700
			Player.y = 65
		end


		--Disappearing collider
		if all_collected == true then
			table.remove(Colliders.objects,27)
		end


		accumulator = accumulator - tick_period
	end
	direction = ""
end



love.draw = function()

	--Game is only drawn if the player or bass has hp left
	if Player.hp >= 1 and Boss.hp >= 1 then

		--Drawing the background
	    for i = 0, love.graphics.getWidth() / background:getWidth() do
	        for j = 0, love.graphics.getHeight() / background:getHeight() do
	            love.graphics.draw(background, i * background:getWidth(), j * background:getHeight())
	        end
	    end

	    --Loading other files
	    Colliders.draw()
		Player.draw()
		Bullets.draw()
		Chicken.draw()
		Boss.draw()
	end

	--Win/ lose message
	if Boss.hp <= 0 then
		love.graphics.print("You win!", 700, 350, 0, 2, 2)
	elseif Player.hp <= 0 then
		love.graphics.print("You died", 700, 350, 0, 2, 2)
	end

	--Temporary on screen info
	love.graphics.print(tostring(Player.hp), 30, 30)
	love.graphics.print(tostring(Boss.hp), 30, 50)
end
