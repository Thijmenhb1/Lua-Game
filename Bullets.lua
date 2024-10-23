require "Player"
require "Boss"
require "Colliders"


Bullets = {

	hit = false,

}


------------------------
Bullets.load = function()

	bullets = {

	}

end


--------------------------
Bullets.update = function() 

	--Projectile movement
	for i, bullet in pairs(bullets) do
		if bullet.x > window_width or bullet.x < -20 then
			table.remove(
				bullets,
				i
			)
		end


		bullet.x = bullet.x + bullet.speed * bullet.dir
	end

	--Determine if the player is shooting
	Player.shooting = false

	if love.keyboard.isDown( "lshift" ) then
		Player.shooting = true
	end

	--Projectile spawner/ timer
	if Player.shooting == true then

		if Player.timer > 0 then
			Player.timer = Player.timer - 1
		else
			Player.timer = Player.timer_max

			if Player.dir == 1 then
				--Bullet left spawn
		   		table.insert(
		   			bullets,
		   			{
		   				x = Player.x + Player.w * Player.sx,
		   				y = Player.y + Player.h * Player.sy * 0.50,
		   				w = 20,
		   				h = 5,
		   				speed = 15,
		   				dir = Player.dir
		   			}
		   		)
   			else
   				--Bullet right spawn
		   		table.insert(
		   			bullets,
		   			{
		   				x = Player.x - 20,
		   				y = Player.y + Player.h * Player.sy * 0.50,
		   				w = 20,
		   				h = 5,
		   				speed = 15,
		   				dir = Player.dir
		   			}
		   		)
				end



		end
	else
		if Player.timer > 0 then
			Player.timer = Player.timer - 1
		end
	end


	--Bullet map collisions
	for i, bullet in pairs(bullets) do
		for u, collider in pairs(Colliders.objects) do

			--Bullet right
			if bullet.dir == 1 then
				if bullet.x + bullet.w > collider.x and
				bullet.x + bullet.w < collider.x + collider.w and
				bullet.y + bullet.h / 2 > collider.y and
				bullet.y + bullet.h / 2 < collider.y + collider.h
				then
					table.remove(
						bullets,
						i
					)
				end
			end


			--Bullet left
			if bullet.dir == -1 then 
				if bullet.x < collider.x + collider.w and
				bullet.x > collider.x and
				bullet.y + bullet.h / 2 < collider.y + collider.h and
				bullet.y + bullet.h / 2 > collider.y
				then
					table.remove(
						bullets,
						i
					)
				end
			end
		end
	end


	--Bullet boss hitbox
	for i, bullet in pairs(bullets) do
		if bullet.x > Boss.x and bullet.y > Boss.y and bullet.y < Boss.y + Boss.h * Boss.sy then
			Boss.hp = Boss.hp - 1
			table.remove(
				bullets,
				i
			)
		end
	end

end


------------------------
Bullets.draw = function()

	for i, bullet in pairs(bullets) do
		--(maybe)Temporary projectile graphic
		love.graphics.rectangle(
				"fill",
				bullet.x,
				bullet.y,
				bullet.w,
				bullet.h
		)
	end

end