Cell = Entity:extend()

function Cell:new(x, y, c, r)
    self.mark = " "
    self.width = 70
    self.height = 70
    self.x = x
    self.y = y
    self.mark_x = self.x + 25
    self.mark_y = self.y + 20
    self.bIsClaimed = false
    self.column = c
    self.row = r
end

function Cell:set_mark(player_mark)
    self.mark = player_mark
    if player_mark == " " then
        self.bIsClaimed = false
        return
    end
    
    self.bIsClaimed = true
end

function Cell:clear_mark()
    self.mark = " "
    self.bIsClaimed = false
end

function Cell:draw()
    local font = love.graphics.newFont(25)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    love.graphics.print(self.mark, font, self.mark_x, self.mark_y)
end