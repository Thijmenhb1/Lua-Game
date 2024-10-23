require "Colliders"


Player = {
	sprites = {
		idle = love.graphics.newImage("assets/pirate_idle.png"),
		walk = love.graphics.newImage("assets/pirate_walk.png"),
		heart = love.graphics.newImage("assets/heart.png")
	},
	hp = 6,
	x = 40,
	y = 620,
	w = 26,
	h = 32,
	sx = 2,
	sy = 2,
	dir = 1,
	shooting = false,
	timer = 0,
	timer_max = 12,
	physics = {
		velocity = {
			x = 0,
			y = 0,
			drag = 15
		},
		gravity = 1,
		speed = 5,
		jump_force = 15,
		grounded = false
	},
	animations = {
		walking = false,
		idle = {
			current_quad = 1,
			timer = 0,
			timer_max = 10,
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
				},
				{
					x = 96,
					y = 0
				},
				{
					x = 128,
					y = 0
				},
				{
					x = 160,
					y = 0
				},
			},
		},
		walk = {
			current_quad = 1,
			timer = 0,
			timer_max = 2,
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
				},
				{
					x = 96,
					y = 0
				},
				{
					x = 128,
					y = 0
				},
				{
					x = 160,
					y = 0
				},
				{
					x = 192,
					y = 0
				},
				{
					x = 224,
					y = 0
				},
				{
					x = 256,
					y = 0
				},
				{
					x = 288,
					y = 0
				},
				{
					x = 320,
					y = 0
				},
				{
					x = 352,
					y = 0
				}
			}
		},
	},
}

--Pixel filter
Player.sprites.idle:setFilter("nearest", "nearest")
Player.sprites.walk:setFilter("nearest", "nearest")
Player.sprites.heart:setFilter("nearest", "nearest")


--Animation idle
Player.idle_quad = love.graphics.newQuad(
	Player.animations.idle.frames[Player.animations.idle.current_quad].x,
	Player.animations.idle.frames[Player.animations.idle.current_quad].y,
	Player.w,
	Player.h,
	Player.sprites.idle
)

--Animation walk
Player.walk_quad = love.graphics.newQuad(
	Player.animations.walk.frames[Player.animations.walk.current_quad].x,
	Player.animations.walk.frames[Player.animations.walk.current_quad].y,
	Player.w,
	Player.h,
	Player.sprites.walk
)





-------------------------
Player.update = function()
	--Reset player velocity
	Player.physics.velocity.x = 0


	--Faster run animation when not grounded
	if Player.physics.velocity.grounded == true then
		Player.animations.walk.timer_max = 2
	else
		Player.animations.walk.timer_max = 1
	end


	--Player gravity
	colliderTop = Colliders.isColliding("top", Player)
	colliderBottom = Colliders.isColliding("bottom", Player)

	if Player.physics.velocity.y >= 0 and colliderBottom ~= nil then
		Player.physics.velocity.y = 0
		Player.physics.velocity.grounded = true
		Player.y = colliderBottom.y - Player.h * Player.sy
	else
		if colliderTop ~= nil and Player.physics.velocity.y < 0 then
			Player.y = colliderTop.y + colliderTop.h
			Player.physics.velocity.y = 0
		else
			Player.physics.velocity.y = Player.physics.velocity.y + Player.physics.gravity 
		end

		Player.physics.velocity.grounded = false

		if Player.physics.velocity.y > Player.physics.velocity.drag then
			Player.physics.velocity.y = Player.physics.velocity.drag
		end
	end


	--Player movement left&right
	if love.keyboard.isDown("a") then
		Player.dir = -1
		colliderLeft = Colliders.isColliding("left", Player)

		if colliderLeft ~= nil then
			Player.x = colliderLeft.x + colliderLeft.w
		else
			Player.physics.velocity.x = -Player.physics.speed
		end
	end

	if love.keyboard.isDown("d") then
		Player.dir = 1
		colliderRight = Colliders.isColliding("right", Player)

		if colliderRight ~= nil then
			Player.x = colliderRight.x - Player.w * Player.sx
		else
			Player.physics.velocity.x = Player.physics.speed
		end
	end

	--Player jump
	if love.keyboard.isDown("space") and Player.y > 0
		and Player.physics.velocity.grounded == true then
			Player.physics.velocity.y = -Player.physics.jump_force
	end

	--Player velocity math or something
	Player.x = math.ceil(Player.x + Player.physics.velocity.x)
	Player.y = math.ceil(Player.y + Player.physics.velocity.y)



	--Animations

	--Animations walk state

	if love.keyboard.isDown("w") or love.keyboard.isDown("a") or love.keyboard.isDown("d") then
		Player.animations.walking = true
	else
		Player.animations.walking = false
	end


	--Animation timers

	--Timer idle
	if Player.animations.idle.timer > Player.animations.idle.timer_max then 

		Player.animations.idle.timer = 0

	if Player.animations.idle.current_quad >= #Player.animations.idle.frames then 
		Player.animations.idle.current_quad = 1
	else 
		Player.animations.idle.current_quad  = Player.animations.idle.current_quad + 1
	end 

		Player.idle_quad = love.graphics.newQuad(
			Player.animations.idle.frames[Player.animations.idle.current_quad].x,
			Player.animations.idle.frames[Player.animations.idle.current_quad].y,
			32,
			32,
			Player.sprites.idle
		)
	else 
		Player.animations.idle.timer = Player.animations.idle.timer + 1
	end

	--Timer walk
	if Player.animations.walk.timer > Player.animations.walk.timer_max then 

		Player.animations.walk.timer = 0

	if Player.animations.walk.current_quad >= #Player.animations.walk.frames then 
		Player.animations.walk.current_quad = 1
	else 
		Player.animations.walk.current_quad  = Player.animations.walk.current_quad + 1
	end 

		Player.walk_quad = love.graphics.newQuad(
			Player.animations.walk.frames[Player.animations.walk.current_quad].x,
			Player.animations.walk.frames[Player.animations.walk.current_quad].y,
			32,
			32,
			Player.sprites.walk
		)
	else 
		Player.animations.walk.timer = Player.animations.walk.timer + 1
	end

end


-----------------------
Player.draw = function()
		-- Collision box
		-- love.graphics.rectangle(
		-- 	"fill",
		-- 	Player.x,
		-- 	Player.y,
		-- 	Player.w * Player.sx,
		-- 	Player.h * Player.sy
		-- )

		--Player sprites
		if Player.animations.walking == false then
			--Player sprite idle
			love.graphics.draw(
				Player.sprites.idle,
				Player.idle_quad,
				love.math.newTransform(
					Player.x + (Player.w * (Player.sx / 2)) + (Player.w * (Player.sy / 2)) * - Player.dir,
					Player.y,
					0,
					Player.sx * Player.dir,
					Player.sy
				)
			)
		else
			love.graphics.draw(
				--Player sprite walk
				Player.sprites.walk,
				Player.walk_quad,
				love.math.newTransform(
					Player.x + (Player.w * (Player.sx / 2)) + (Player.w * (Player.sy / 2)) * - Player.dir,
					Player.y,
					0,
					Player.sx * Player.dir,
					Player.sy
				)
			)
		end

		print(Player.sprites.heart)

		for i = 1, Player.hp, 1
		do 
			love.graphics.draw(
				Player.sprites.heart,
				622 + (32 * i),
				2,
				0,
				2,
				2
			)
		end

		-- --Collider direction display
		-- if Colliders.isColliding("top", Player) ~= nil then
		-- 	love.graphics.setColor(0, 255, 0)
		-- 	love.graphics.rectangle("fill", Player.x, Player.y, Player.w * Player.sx, 5)
		-- 	love.graphics.setColor(255, 255, 255)
		-- end
		
		-- if Colliders.isColliding("bottom", Player) ~= nil then
		-- 	love.graphics.setColor(0, 255, 0)
		-- 	love.graphics.rectangle("fill", Player.x, Player.y + Player.h * Player.sy - 5, Player.w * Player.sx, 5)
		-- 	love.graphics.setColor(255, 255, 255)
		-- end
		
		-- if Colliders.isColliding("left", Player) ~= nil then
		-- 	love.graphics.setColor(0, 255, 0)
		-- 	love.graphics.rectangle("fill", Player.x, Player.y, 5, Player.h * Player.sy)
		-- 	love.graphics.setColor(255, 255, 255)
		-- end
		
		-- if Colliders.isColliding("right", Player) ~= nil then
		-- 	love.graphics.setColor(0, 255, 0)
		-- 	love.graphics.rectangle("fill", Player.x + Player.w * Player.sx - 5, Player.y, 5, Player.h * Player.sy)
		-- 	love.graphics.setColor(255, 255, 255)
		-- end
end