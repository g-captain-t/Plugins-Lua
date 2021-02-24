-- # OBJECTS

local function newpixel()
	return {
		p=nil;
		r=1;
		c="FFFFFF";
		d=0;
	}
end

local function newproject()
	local self = {
		name = "MyProject";
		canvas = {};
	}
	for y = 1, 16 do 
		self.canvas[y] = {}
		for x = 1, 16 do 
			self.canvas[y][x] = newpixel()
		end
	end
	return self
end

local function newstate()
	return {
		selectedcolor = "FFFFFF";
		selecteddepth = 1;
		selectedpart = "square";
		currentmode = "build";
		currentproject = newproject();
	}
end