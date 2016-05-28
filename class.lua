-- base functions
function setMaxCharCount(str, maxCharCount)
    maxCharCount = maxCharCount or 20
    local len = string.len(str)
    if len < maxCharCount then
        str = str .. string.rep(' ', maxCharCount-len)
    else
        str = string.sub(str, 1, maxCharCount)
    end
    return str..'\t'
end

function print_loop(cls, prefix)
    prefix = prefix or ''
    local maxCharCount = 30
    for k,v in pairs(cls) do
        local key = prefix .. k
        key = setMaxCharCount(key)
        print(key, v)
    end
end

local function print_class(cls)
    local meta = getmetatable(cls)
    if meta then
        local super = meta.__index
        if super and type(super) == 'table' then
            print_class(super)
        end
    end
    local super = cls.__index
    if super and type(super) == 'table' then
        print_class(super)
    end
    local clsname = cls.__classname or ''
    prefix = clsname .. '.'
    print_loop(cls, prefix)
    print(string.rep('---', 30))
end

-- Object Definition
local Object = {}

function Object:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Object:inherite(super)
    local obj = self:new()
    setmetatable(obj, {__index = super})
    return obj
end

-- Class Factory
return function(classname, super)
    super = super or {}
    local obj = Object:inherite(super)
    obj.__classname = classname
    obj.super = super
    obj.print = function(tab) print_class(tab) end
    obj.set   = function(tab, key, val)
        -- 该方法不会改动到父类，而是从父类 copy 一份过来
        -- 如果需要改动到父类，请根据需要使用重载
        local str = setMaxCharCount(classname .. '[set]' .. key)
        if tab[key] then
            tab[key] = val
            print(str, '=>', val)
        end
    end
    obj.get   = function(tab, key)
        local val = tab[key]
        if val then
            local str = setMaxCharCount(classname .. '[get]' .. key)
            print(str, '==', val)
        end
        return val
    end
    obj.init = function(tab, ...)
        local args = {...}
        if #args > 0 then
            tab.__args__ = args
        end
    end
    obj.new = function(tab, ...)
        local o = {}
        setmetatable(o, {__index = tab})
        o:init(...)
        return o
    end
    obj.args = function(tab)
        return tab.__args__
    end
    return obj
end