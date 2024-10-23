require "Bullets"

Chicken = {

	chicken_img = love.graphics.newImage("assets/chicken_idle.png"),
	x = 1400,
	y = 625,
	w = 12,
	h = 11,
	sx = 5,
	sy = 5,
	objects = {

	}

}

--Pixel filter
Chicken.chicken_img:setFilter("nearest", "nearest")


---------------------------
Chicken.add = function(x, y)
	table.insert(
		Chicken.objects,
		{
			x = x,
			y = y,
		}
	)
end


------------------------
Chicken.load = function()

	--Chicken locations
	Chicken.add(325, 625)
	Chicken.add(300, 520)
	Chicken.add(850, 365)
	Chicken.add(375, 225)
	Chicken.add(30, 245)


	
	Chicken.add(1400, 625)
	Chicken.add(935, 625)

end


--------------------------
Chicken.update = function()
	
	--Chicken bullet collisions
	for i, chicken in pairs(Chicken.objects) do

			for u, bullet in pairs(bullets) do
				if bullet.x > chicken.x and
				bullet.x < chicken.x + Chicken.w * Chicken.sx and
				bullet.y > chicken.y and
				bullet.y < chicken.y + Chicken.h * Chicken.sy 
				then
					table.remove(
					bullets,
					u
					)
					table.remove(
					Chicken.objects,
					i
					)

				end
			end
	end
end


------------------------
Chicken.draw = function()
	
	for i, chicken in pairs(Chicken.objects) do
		-- Chicken hitbox
		-- love.graphics.rectangle(
		-- 	"fill",
		-- 	chicken.x,
		-- 	chicken.y,
		-- 	Chicken.w * Chicken.sx,
		-- 	Chicken.h * Chicken.sy
		-- )


		--Chicken sprite
		love.graphics.draw(
			Chicken.chicken_img,
			chicken.x,
			chicken.y,
			0,
			Chicken.sx,
			Chicken.sy
		)
		end

end