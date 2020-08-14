
Class = require 'class'
push = require 'push'

-- close resolution to NES but 16:9
VIRTUAL_WIDTH = 720
VIRTUAL_HEIGHT = 616

-- actual window resolution
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720


require 'Map'
require 'Player'
require 'Animation'

map = Map()
player = Player(map)
math.randomseed(os.time())


-- makes upscaling look pixel-y instead of blurry
love.graphics.setDefaultFilter('nearest', 'nearest')

function love.load()
    -- print('testing 123')
    love.graphics.setFont(love.graphics.newFont('Font/font.ttf', 34))
    -- endingFont = love.graphics.newFont('fonts/font.ttf', 24)

    -- sets up virtual screen resolution for an authentic retro feel
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true
    })
    love.keyboard.keysPressed = {}
    love.keyboard.keysReleased = {}

    love.window.setTitle('Math Moves')


    gameState = 'start'
    goal = math.random(0, 1000)
    total_moves = math.random(2, 10)

end

-- called whenever window is resized
function love.resize(w, h)
    push:resize(w, h)
end

-- global key pressed function
function love.keyboard.wasPressed(key)
    if (love.keyboard.keysPressed[key]) then
        return true
    else
        return false
    end
end

-- global key released function
function love.keyboard.wasReleased(key)
    if (love.keyboard.keysReleased[key]) then
        return true
    else
        return false
    end
end

function love.update(dt)
    player:update(dt)

    love.keyboard.keysPressed = {}
    love.keyboard.keysReleased = {}
    if total_moves - moves == 0 then
        gameState = 'end'
    end

end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        gameState = 'play'
    elseif key == 'tab' then
        gameState = 'start'
        goal = math.random(0, 1000)
        total_moves = math.random(2, 10)
        moves = 0
        first = math.random(0, 10)
        map:init()
    
    end

    love.keyboard.keysPressed[key] = true
end

-- called whenever a key is released
function love.keyreleased(key)
    love.keyboard.keysReleased[key] = true
end

function love.draw()

    push:apply('start')
    love.graphics.clear(108/255, 140/255, 255/255, 255/255)
    if gameState == 'start' then
        love.graphics.printf('Get to: '.. tostring(goal), 0, VIRTUAL_HEIGHT / 6 - 60, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('In: '.. tostring(total_moves) .. ' moves', 0, VIRTUAL_HEIGHT / 6 - 30, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to Start', 0, VIRTUAL_HEIGHT / 6, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        --numbers
        love.graphics.printf('Goal: '.. tostring(goal), 0, 0, VIRTUAL_WIDTH, 'left')
        love.graphics.printf('Moves left: '.. tostring(total_moves - moves), 0, 0, VIRTUAL_WIDTH, 'right')
        love.graphics.printf(tostring(math.floor(first)), -50 , VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')
        love.graphics.printf(tostring(math.floor(second)), 50 , VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')

    elseif gameState == 'end' then
        love.audio.stop()
        if first <= goal + 10 and first >= goal - 10 then
            love.graphics.printf('VICTORY!', 0, VIRTUAL_HEIGHT / 4 - 30, VIRTUAL_WIDTH,  'center')
        else 
            love.graphics.printf('you lose', 0, VIRTUAL_HEIGHT / 4 - 30, VIRTUAL_WIDTH, 'center')
        end
        love.graphics.printf('Press Tab to restart', 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH,  'center')
        
    end

    map:render()
    player:render()

    push:apply('end')

end