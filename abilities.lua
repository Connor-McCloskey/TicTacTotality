AbilityParent = Entity:extend()

function AbilityParent:new()
    self.cost = 0
    self.x = 0
    self.y = 0
    self.width = 0
    self.height = 0
    self.type = "base"
    self.label = "base"
    self.bIsPrimed = false
    self.label_width = 0
end

function AbilityParent:update(dt)
end

function AbilityParent:draw()
    love.graphics.setColor(1,1,1)
    local red = 1
    local blue = 1
    local green = 1

    if self.bIsPrimed == true then
        blue = 0
        green = 0
    end

    love.graphics.setColor(red,blue,green)
    love.graphics.rectangle("line", self.x, self.y, self.label_width, self.height)

    love.graphics.setColor(1,1,1)
    love.graphics.print(self.label, self.label_x, self.label_y)

    local costString = string.format("AP Cost: %d", self.cost)
    local costX = self.x
    local costY = self.y + self.height
    love.graphics.print(costString, costX, costY)
end

function AbilityParent:use(cell, mark)
end

function AbilityParent:clear_status()
    self.bIsPrimed = false
end

function AbilityParent:on_clicked()
    if self.bIsPrimed then
        self.bIsPrimed = false
        return nil
    end

    self.bIsPrimed = true
    return self.type
end

function AbilityParent:get_cost()
    return self.cost
end

---- Defining a player ability ----
-- Convert --
Convert = AbilityParent:extend()

function Convert:new(x, y)
    self.cost = 2
    self.width = 50
    self.height = 25
    self.type = "convert"
    self.label = "Convert Square"
    self.label_width = GetStringPrintLength(self.label) + 5
    self.width = self.label_width
    self.x = x
    self.y = y
    self.label_x = x + 1
    self.label_y = y + 5
end

function Convert:use(cell, mark)
    self.bIsPrimed = false
    cell:set_mark(mark)
end

-- Shift column --
Column_Shift = AbilityParent:extend()

function Column_Shift:new(x,y)
    self.cost = 5
    self.width = 50
    self.height = 25
    self.type = "column"
    self.label = "Shift Column Down"
    self.label_width = GetStringPrintLength(self.label) + 5
    self.width = self.label_width
    self.x = x
    self.y = y
    self.label_x = x + 1
    self.label_y = y + 5
end

function Column_Shift:use(cell, mark)
    self.bIsPrimed = false
    local temp = Board.grid[Board.row_count][cell.column].mark
    for i = Board.row_count, 2, -1 do
        Board.grid[i][cell.column]:set_mark(Board.grid[i-1][cell.column].mark)
    end
    Board.grid[1][cell.column]:set_mark(temp)
end

-- Shift Row --
Row_Shift = AbilityParent:extend()

function Row_Shift:new(x,y)
    self.cost = 5
    self.width = 50
    self.height = 25
    self.type = "row"
    self.label = "Shift Row Right"
    self.label_width = GetStringPrintLength(self.label) + 5
    self.width = self.label_width
    self.x = x
    self.y = y
    self.label_x = x + 1
    self.label_y = y + 5
end

function Row_Shift:use(cell, mark)
    self.bIsPrimed = false
    local temp = Board.grid[cell.row][Board.column_count].mark
    for i = Board.column_count, 2, -1 do
        Board.grid[cell.row][i]:set_mark(Board.grid[cell.row][i-1].mark)
    end
    Board.grid[cell.row][1]:set_mark(temp)
end


-- Randomize 2x2 square --
Random = AbilityParent:extend()

function Random:new(x,y)
    self.cost = 6
    self.width = 50
    self.height = 25
    self.type = "random"
    self.label = "Randomize 3x3 Grid"
    self.label_width = GetStringPrintLength(self.label) + 5
    self.width = self.label_width
    self.x = x
    self.y = y
    self.label_x = x + 1
    self.label_y = y + 5
end

function Random:use(cell, mark)
    self.bIsPrimed = false
    -- Gather all surrounding valid cells
    local r = cell.row
    local c = cell.column

    -- Go through all iterations of the surrounding 4x4 area
    Board.grid[r][c]:set_mark(RandomMark())
    CheckValid(r, c+1, "rand")
    CheckValid(r, c-1, "rand")
    CheckValid(r+1, c, "rand")
    CheckValid(r-1, c, "rand")
    CheckValid(r+1, c+1, "rand")
    CheckValid(r+1, c-1, "rand")
    CheckValid(r-1, c+1, "rand")
    CheckValid(r-1, c-1, "rand")
end

-- Clear 2x2 square --
Clear = AbilityParent:extend()

function Clear:new(x,y)
    self.cost = 7
    self.width = 50
    self.height = 25
    self.type = "clear"
    self.label = "Clear 3x3 Grid"
    self.label_width = GetStringPrintLength(self.label) + 5
    self.width = self.label_width
    self.x = x
    self.y = y
    self.label_x = x + 1
    self.label_y = y + 5
end

function Clear:use(cell, mark)
    self.bIsPrimed = false
    -- Gather all surrounding valid cells
    local r = cell.row
    local c = cell.column

    -- Go through all iterations of the surrounding 4x4 area
    Board.grid[r][c]:clear_mark()
    CheckValid(r, c+1, "clear")
    CheckValid(r, c-1, "clear")
    CheckValid(r+1, c, "clear")
    CheckValid(r-1, c, "clear")
    CheckValid(r+1, c+1, "clear")
    CheckValid(r+1, c-1, "clear")
    CheckValid(r-1, c+1, "clear")
    CheckValid(r-1, c-1, "clear")
end

-- Helper Function for randomness
function RandomMark()
    if math.random(0,1) == 1 then
        return "X"
    end
    return "O"
end

function CheckValid(r, c, mode)
    -- Check valid
    if r > Board.row_count or r < 1 then
        return
    end
    if c > Board.column_count or c < 1 then
        return
    end

    -- Check mode
    if mode == "rand" then
        Board.grid[r][c]:set_mark(RandomMark())
        return
    end
    if mode == "clear" then
        Board.grid[r][c]:clear_mark()
        return
    end
end