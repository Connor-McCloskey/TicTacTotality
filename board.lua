TicTacBoard = Entity:extend()

function TicTacBoard:new()
    self.grid = {}
    self.column_count = 6
    self.row_count = 6
    self.cellTotal = self.column_count * self.row_count
    self.current_player = 1
    self.bTurnOver = false
    
    local cellX = 10
    local cellY = 10

    -- Init the board
    for i=1,self.row_count do
        self.grid[i] = {}
        for j = 1, self.column_count do
            -- Create cell and add to entity manager
            self.grid[i][j] = Cell(cellX, cellY, j, i)
            EM:add_entity(self.grid[i][j])

            -- Increment the position for the next cell
            cellX = cellX + 50
        end

        -- Set position values for next iteration
        cellX = 10
        cellY = cellY + 50
    end

    cellY = cellY + 20
    -- Init abilities fields
    local convert = Convert(cellX, cellY)
    EM:add_entity(convert)

    cellX = cellX + 10 + convert.width
    local cShift = Column_Shift(cellX, cellY)
    EM:add_entity(cShift)

    cellX = cellX + 10 + cShift.width
    local rShift = Row_Shift(cellX, cellY)
    EM:add_entity(rShift)

    cellX = cellX + 10 + rShift.width
    local rando = Random(cellX, cellY)
    EM:add_entity(rando)

    cellX = cellX + 10 + rando.width
    local clear = Clear(cellX, cellY)
    EM:add_entity(clear)

    -- Alert Players to where they can draw their UI elements
    cellX = 10
    cellY = cellY + 20 + convert.height
    P1:set_interface_pos(cellX, cellY)

    cellX = cellX + 150
    P2:set_interface_pos(cellX, cellY)
end

function TicTacBoard:update(dt)
    if self.bTurnOver then
        self:turn_over()
    end
end

-- Board can also, in this simple game, act as our game manager
-- So game state will exist here
function TicTacBoard:turn_over()
    -- Check win  OR tie conditions
    local claimedTally = 0

    -- Check rows
    -- We will also do a complete accounting of which cells
    -- have been claimed in this first pass
    for i = 1, self.column_count do
        if self.grid[i][1].mark ~= " " then
            local playerMark = self.grid[i][1].mark
            local markCount = 1
            claimedTally = claimedTally + 1
            for j = 2, self.row_count do
                if self.grid[i][j].mark == playerMark then
                    markCount = markCount + 1
                    claimedTally = claimedTally + 1
                elseif self.grid[i][j].mark ~= " " then
                    claimedTally = claimedTally + 1
                end
                if markCount == self.row_count then
                    Message = string.format("Player %s wins!", playerMark)
                    GameOver = true
                    return
                end
            end
        end
    end

    -- Check columns
    for i = 1, self.row_count do
        if self.grid[1][i].mark ~= " " then
            local playerMark = self.grid[1][i].mark
            local markCount = 1
            for j = 2, self.column_count do
                if self.grid[j][i].mark == playerMark then
                    markCount = markCount + 1
                end
                if markCount == self.column_count then
                    Message = string.format("Player %s wins!", playerMark)
                    GameOver = true
                    return
                end
            end
        end
    end

    -- Check upper left to bottom right diagonal
    local diagRow = 1
    local diagColumn = 1
    local diagCount = 0
    local diagMark = " "
    if self.grid[diagColumn][diagRow].mark ~= " " then
        diagMark = self.grid[diagColumn][diagRow].mark
        diagCount = diagCount + 1
        for i = 2, self.column_count do
            diagRow = diagRow + 1
            diagColumn = diagColumn + 1
            if self.grid[diagColumn][diagRow].mark ~= " " and self.grid[diagColumn][diagRow].mark == diagMark then
                diagCount = diagCount + 1
            end
            if diagCount == self.column_count then
                Message = string.format("Player %s wins!", diagMark)
                GameOver = true
                return
            end
        end
    end

    -- Check upper right to bottom left diagonal
    diagRow = 1
    diagColumn = self.column_count
    diagCount = 0
    diagMark = " "
    if self.grid[diagColumn][diagRow].mark ~= " " then
        diagMark = self.grid[diagColumn][diagRow].mark
        diagCount = diagCount + 1
        for i = self.column_count, 2, -1 do
            diagRow = diagRow + 1
            diagColumn = diagColumn - 1
            if self.grid[diagColumn][diagRow] ~= " " and self.grid[diagColumn][diagRow].mark == diagMark then
                diagCount = diagCount + 1
            end
            if diagCount == self.column_count then
                Message = string.format("Player %s wins!", diagMark)
                GameOver = true
                return
            end
        end
    end

    -- Finally, check claimed tally...
    if claimedTally == self.cellTotal then
        Message = "Tie!"
        GameOver = true
        return
    end

    -- Change active player
    self:change_active_player()
    self.bTurnOver = false
end

function TicTacBoard:change_active_player()
    if self.current_player == 1 then
        self.current_player = 2
        P1:set_active_state(false)
        P2:set_active_state(true)
        P2:add_points(1)
    else
        self.current_player = 1
        P1:set_active_state(true)
        P1:add_points(1)
        P2:set_active_state(false)
    end
end

function TicTacBoard:draw()
    if not GameOver then
        local p = nil
        if self.current_player == 1 then
            p = "X"
        else
            p = "O"
        end
        local msg = string.format("%s - your turn!", p)
        love.graphics.print(msg, 10, 500)
    end
    if GameOver then
        love.graphics.print(Message, 10, 500)
    end
end