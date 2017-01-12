
 List = {
 length=0
 }

 List.__index=List
 function List:new() 
 print(type(self))
     local temp = {e={}} 
     setmetatable(temp, List) 
     return temp 
 end 

function List:add(val)
   self.length=self.length+1
   self.e[self.length]=val
end

function List:get(index)
  return self.e[index]
end

function List:size()
	return self.length
end

--[[
a=List:new(self)
a:add("val a1")
a:add("val a2")

b=List:new(self)
b:add("val b1")
b:add("val b2")

print(a:size())
print(b:size())

print(a:get(1))
print(b:get(1))
]]