local class = require "lib.middleclass"

local GameObject = require "obj.GameObject"
local Collider = GameObject:subclass("Collider")

function Collider:initialize(name,x,y,w,h,world)
  GameObject.initialize(self,name,x,y,w,h,"Collider")
  self.world = world
  
  self.world:add(self,x,y,w,h)
  self:move(x,y) -- If placed inside another object, move away from it
end

local filter = function(item,other)
  if     other.name == "coin" then return "cross"
  elseif other.name == "wall" then return "slide"
  else return nil end
  -- You can change this for different kinds of objects
  -- It's hardcoded and kinda rubbish... but I'm tired :(
end

function Collider:move(gx,gy)
  local ax, ay, cols, len = self.world:move(self,gx,gy,filter)
  self.x = ax
  self.y = ay
  if self.renderable ~= nil then
    self.renderable:move(ax,ay)
  end
  return cols
end

function Collider:update(gx,gy)
  self.world:update(self,gx,gy)
  if self.renderable ~= nil then
    self.renderable:move(gx,gy)
  end
end

function Collider:destroy()
  self.world:remove(self)
end

function Collider:attachRenderable(renderable)
  self.renderable = renderable
end

return Collider