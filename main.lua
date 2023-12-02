-- On engine start
function love.load()
    -- Setting up engine for OOP and libraries
    Object = require "class"
    require "entity"
    require "entity_manager"
    require "board"
    require "abilities"
    require "player"
    require "cell"

    ProcessMouseEvent = false
    GameOver = false

    EM = EntityManager()
    P1 = Player("X")
    P1:set_active_state(true)
    P2 = Player("O")
    P2:set_active_state(false)
    Board = TicTacBoard()

    -- Add our instanced entities to the manager
    EM:add_entity(P1)
    EM:add_entity(P2)
    EM:add_entity(Board)

    print("\n-- Loading complete --\n")
end

-- Engine tick
function love.update(dt)
    if GameOver == false then
        EM:update(dt)
    end
end

-- Engine render
function love.draw()
    EM:draw()
end

function love.mousepressed(x, y, button, isTouched)
    if button == 1 then
        ProcessMouseEvent = true
    else
        ProcessMouseEvent = false
    end
end

function love.mousereleased(x, y, button)
    ProcessMouseEvent = false
end