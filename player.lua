Player = Entity:extend()

function Player:new(player_mark)
    self.action_points = 10
    self.max_points = 10
    self.mark = player_mark
    self.bIsActive = false
    self.bAbilityPrimed = false
    self.PrimedAbility = nil

    -- For UI element we use for Action Points --
    self.x = 0
    self.y = 0
    self.width = 100
    self.height = 25
    self.label_x = 0
    self.label_y = 0
    self.label = string.format("Player %s AP: %d", self.mark, self.action_points)
end

function Player:deduct_points(points)
    self.action_points = self.action_points - points
end

function Player:add_points(points)
    if self.action_points == self.max_points then
        return
    end
    self.action_points = self.action_points + points
end

function Player:update(dt)
    self.label = string.format("Player %s AP: %d", self.mark, self.action_points)
    -- Process keyboard input
    if Board.bTurnOver == false
    and self.bIsActive
    and ProcessMouseEvent then
        -- Claim the mouse event
        ProcessMouseEvent = false

        -- Check what mouse is clicking on and return the object
        local other = EM:mouse_collision_check()
        
        -- If nothing, then return, because they've clicked on nothing
        if other == nil then 
            return 
        end

        -- On ability? Then prime!
        if other:is(AbilityParent) then
            if self.bAbilityPrimed then
                if self.PrimedAbility == other then
                    self.PrimedAbility:clear_status()
                    self.PrimedAbility = nil
                    self.bAbilityPrimed = false
                    return
                else
                    self.PrimedAbility:clear_status()
                    self.PrimedAbility = other
                    other:on_clicked()
                    return
                end
            end

            self.bAbilityPrimed = true
            self.PrimedAbility = other
            other:on_clicked()
        end

        -- On cell?
        if other:is(Cell) then
            -- Use the ability
            if self.bAbilityPrimed then
                -- Deduct action points and unprime ability
                self:deduct_points(self.PrimedAbility:get_cost())
                self.bAbilityPrimed = false
                -- Call the ability itself
                self.PrimedAbility:use(other, self.mark)
                -- Tell the ability to reset and clear it
                self.PrimedAbility.bIsPrimed = false
                self.PrimedAbility = nil
                -- Alert board that we've used our turn
                Board.bTurnOver = true
                return
                
            -- Else, just claim the cell
            elseif other.bIsClaimed == false then
                other:set_mark(self.mark)
                Board.bTurnOver = true
                if self.PrimedAbility ~= nil then
                    self.PrimedAbility.bIsPrimed = false
                    self.PrimedAbility = nil
                    self.PrimedAbility:clear_status()
                end
                return
            end
        end
    end
end

function Player:set_active_state(newState)
    self.bIsActive = newState
end

function Player:set_interface_pos(x, y)
    self.x = x
    self.y = y
    self.label_x = x + 5
    self.label_y = y + 5
end

function Player:draw()
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    love.graphics.print(self.label, self.label_x, self.label_y)
end