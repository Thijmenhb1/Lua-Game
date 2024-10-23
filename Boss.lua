require "Player"

Boss = {
	sprites = {
		dragon_img = love.graphics.newImage("assets/dragon.png"),
		fire_img = love.graphics.newImage("assets/fire.png")
	},
	hp = 5,
	x = 1350,
	y = 299,
	w = 32,
	h = 32,
	sx = 3,
	sy = 3,
	speed = 3, --default 3
	dir = "up",
	timer = 0,
	timer_max = 60,
	animation = {
		current_quad = 1,
		timer = 0,
		timer_max = 5,
		frames ={
			{
				x = 0,
				y = 0
			},
			{
				x = 32,
				y = 0
			},
			{
				x = 64,
				y = 0
			}
		}
	}
}

--Pixel filter
Boss.sprites.dragon_img:setFilter("nearest", "nearest")
Boss.sprites.fire_img:setFilter("nearest", "nearest")


--Boss animation quad
Boss.quad = love.graphics.newQuad(
	Boss.animation.frames[Boss.animation.current_quad].x,
	Boss.animation.frames[Boss.animation.current_quad].y,
	Boss.w,
	Boss.h,
	Boss.sprites.dragon_img
)



---------------------
Boss.load = function()

	fires = {

	}

end


-----------------------
Boss.update = function()
	
	--Boss movement
	if Boss.dir == "up" then
		Boss.y = Boss.y - Boss.speed
		if Boss.y < 40 then
			Boss.dir = "down"
		end
	end

	if Boss.dir == "down" then
		Boss.y = Boss.y + Boss.speed
		if Boss.y > 320 then
			Boss.dir = "up"
		end
	end



	--Boss fire map collisions
	for i, fire in pairs(fires) do
		for u, collider in pairs(Colliders.objects) do
			if fire.x < collider.x + collider.w and
			fire.x + fire.w > collider.x and
			fire.y < collider.y + collider.h and
			fire.y + fire.h > collider.y 
			then
				table.remove(
					fires,
					i
				)
			end
		end
		fire.x = fire.x - 5
	end


	--Fire player collisions
	for i, fire in pairs(fires) do
		if fire.x < Player.x + Player.w * Player.sx and
		fire.x + fire.w > Player.x and
		fire.y < Player.y + Player.h * Player.sy and
		fire.y + fire.h > Player.y 
		then
			table.remove(
				fires,
				i
			)
			Player.hp = Player.hp - 1
		end




	end





	if Boss.timer > 0 then
		Boss.timer = Boss.timer - 1
	else
		Boss.timer = Boss.timer_max

		--Randomizes the ammount of time in between fireballs 
		Boss.timer_max = math.random(60,150)


   		table.insert(
   			fires,
   			{
   				x = Boss.x - 30,
   				y = Boss.y + 15,
   				w = 30,
   				h = 20,
   				speed = 15,
   			}
   		)
	end

	if Boss.timer > 0 then
		Boss.timer = Boss.timer - 1
	end











	--Boss animation
	if Boss.animation.timer > Boss.animation.timer_max then 

		Boss.animation.timer = 0

	if Boss.animation.current_quad >= #Boss.animation.frames then 
		Boss.animation.current_quad = 1
	else 
		Boss.animation.current_quad  = Boss.animation.current_quad + 1
	end 

		Boss.quad = love.graphics.newQuad(
			Boss.animation.frames[Boss.animation.current_quad].x,
			Boss.animation.frames[Boss.animation.current_quad].y,
			32,
			32,
			Boss.sprites.dragon_img
		)
	else 
		Boss.animation.timer = Boss.animation.timer + 1
	end

end


---------------------
Boss.draw = function()
	
	--Boss fire
	for i, fire in pairs(fires) do

		--Fire hitbox
		-- love.graphics.rectangle(
		-- 		"fill",
		-- 		fire.x,
		-- 		fire.y,
		-- 		fire.w,
		-- 		fire.h
		-- )

		love.graphics.draw(
			Boss.sprites.fire_img,
			fire.x,
			fire.y,
			0,
			3,
			3
		)

	end


	--Boss hitbox
	-- love.graphics.rectangle(
	-- 		"fill",
	-- 		Boss.x,
	-- 		Boss.y,
	-- 		Boss.w * Boss.sx,
	-- 		Boss.h * Boss.sy
	-- )




	--Boss sprite
	love.graphics.draw(
		Boss.sprites.dragon_img,
		Boss.quad,
		love.math.newTransform(
			Boss.x,
			Boss.y,
			0,
			Boss.sx,
			Boss.sy
		)
	)







	-- love.graphics.draw(
	-- 	Boss.dragon_img,
	-- 	Boss.x,
	-- 	Boss.y,
	-- 	0,
	-- 	Boss.sx,
	-- 	Boss.sy
	-- )

end