local class = require('class')

local testObj = class('test', function() end)
testObj.base  = 0
testObj.showHiddenHeart = 0
function testObj:setBase(base)
    self:set('showHiddenHeart', base)
    self:set('base', base)
    self.base = base
end

local testObj2 = class('test2', testObj)
function testObj2:setBase(base)
    self.super:setBase(base)
    -- self:set('base', base)
end
function testObj2:init_overwrite(...)
    -- self.super:init(...)
    local params = {...}
    for k,v in pairs(params) do
        print(k,'=>', v)
    end
end

-- testObj2:setBase(2)
-- testObj2:get('base')
-- testObj2:get('showHiddenHeart')
-- testObj2:set('base', 8)
-- testObj2:set('showHiddenHeart', 9)
-- print(string.rep('======', 10))
-- testObj2.print()

local obj = testObj2:new()
obj:set('__classname', 'OBJECT')
obj:set('base', 999)
obj:setBase(888)
obj:print()
