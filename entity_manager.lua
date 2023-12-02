EntityManager = Object:extend()

function EntityManager:new()
    self.allEntities = {}
end

function EntityManager:update(dt)
    if next(self.allEntities) ~= nil then
        for key, value in pairs(self.allEntities) do
            value:update(dt)
        end
    end
end

function EntityManager:draw()
    if next(self.allEntities) ~= nil then
        for key, value in pairs(self.allEntities) do
            value:draw()
        end
    end
end

function EntityManager:add_entity(e)
    table.insert(self.allEntities, e)
end

function EntityManager:mouse_collision_check()
    local x = love.mouse.getX()
    local y = love.mouse.getY()
    
    for key, value in pairs(self.allEntities) do
        if value:is(Cell) or value:is(AbilityParent) then
            local vRight = value.x + value.width
            local vLeft = value.x
            local vTop = value.y
            local vBottom = value.y + value.height

            if x < vRight
            and x > vLeft
            and y > vTop
            and y < vBottom then
                return value
            end
        end
    end


    return nil
end