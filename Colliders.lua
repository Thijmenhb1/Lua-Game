
Colliders = {
	objects = {

	}
}


-----------------------------------
Colliders.add = function(x, y, w, h)
	table.insert(
		Colliders.objects,
		{
			x = x,
			y = y,
			w = w,
			h = h
		}
	)
end


--------------------------
Colliders.load = function() 

	--Collider image
	collider_image = love.graphics.newImage("assets/collider.png")
	collider_image:setFilter("nearest", "nearest")
	collider_image:setWrap("repeat", "repeat")



	Colliders.add(0, 0, window_width, 35)
	Colliders.add(window_width - 20, 0, 20, window_height)
	Colliders.add(0, window_height - 20, window_width, 20)
	Colliders.add(0, 0, 20, window_height)

	--Colliders

	--Random shit for now
	Colliders.add(200, 575, 200, 20)
	Colliders.add(400, 500, 100, 180)
	Colliders.add(500, 590, 100, 90)
	Colliders.add(20, 400, 300, 50)
	Colliders.add(20, 300, 100, 100)
























































	Colliders.add(220, 210, 150, 90)
	Colliders.add(370, 280, 100, 20)

	Colliders.add(320, 130, 380, 80)
	Colliders.add(700, 130, 100, 180)
	Colliders.add(800, 280, 120, 30)

	Colliders.add(600, 420, 329, 80)
	Colliders.add(650, 390, 150, 30)
	Colliders.add(675, 500, 100, 90)

	Colliders.add(850, 590, 380, 20)
	Colliders.add(850, 590, 80, 90)
	Colliders.add(1000, 610, 230, 20)
	Colliders.add(1000, 660, 230, 20)



	--Boss room
	Colliders.add(920, 20, 30, 180)
	Colliders.add(920, 280, 30, 220)
	Colliders.add(950, 420, 530, 80)

	Colliders.add(950, 180, 100, 20)
	Colliders.add(1100, 300, 100, 20)


end


------------------------------------------------
Colliders.isColliding = function(direction, col1)
	for index, collider in pairs(Colliders.objects) do
		if Colliders.collides(direction, col1, collider) then
			return collider
		end
	end

	return nil
end


---------------------------------------------------
Colliders.collides = function(direction, col1, col2)
	if direction == "top" then
		return col1.x + col1.w * Player.sx > col2.x - col1.physics.velocity.x
			and col1.x + col1.physics.velocity.x < col2.x + col2.w
			and col1.y - col1.physics.jump_force < col2.y + col2.h
			and col1.y > col2.y
	elseif direction == "right" then
		return col1.x + col1.w * Player.sx > col2.x - col1.physics.speed
			and col1.x + col1.w * Player.sx < col2.x + col2.w + col1.physics.speed
			and col1.y + col1.h * Player.sy > col2.y
			and col1.y < col2.y + col2.h 
	elseif direction == "bottom" then
		return col1.x + col1.w * Player.sx > col2.x 
			and col1.x < col2.x + col2.w
			and col1.y + col1.h * Player.sy + col1.physics.jump_force > col2.y 
			and col1.y + col1.h * Player.sy < col2.y + col2.h 
	elseif direction == "left" then 
		return col1.x > col2.x - col1.physics.speed
			and col1.x < col2.x + col2.w + col1.physics.speed
			and col1.y + col1.h * Player.sy > col2.y 
			and col1.y < col2.y + col2.h
	else
		error("Direction " + tostring(direction) + " not available.")
	end
end


--------------------------
Colliders.draw = function()

	--Platform textures
	for i, collider in pairs(Colliders.objects) do
		quad = love.graphics.newQuad( collider.x,collider.y, collider.w,collider.h, 64,64 )
		love.graphics.draw(
			collider_image,
			quad,
			collider.x,
			collider.y,
			0,
			1,
			1
		)
	end

end