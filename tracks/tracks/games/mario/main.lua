--[[
    Super Mario Bros. Demo
    Author: Colton Ogden
    Original Credit: Nintendo

    Demonstrates rendering a screen of tiles.
]]

Class = require 'class'
push = require 'push'

require 'Animation'
require 'Map'
require 'Player'

-- close resolution to NES but 16:9
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- actual window resolution
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- seed RNG
math.randomseed(os.time())

-- makes upscaling look pixel-y instead of blurry
love.graphics.setDefaultFilter('nearest', 'nearest')

-- an object to contain our map data
map = Map()
player = Player(map)

-- performs initialization of all objects and data needed by program
function love.load()

    -- sets up a different, better-looking retro font as our default
    love.graphics.setFont(love.graphics.newFont('fonts/font.ttf', 8))
    -- endingFont = love.graphics.newFont('fonts/font.ttf', 24)

    -- sets up virtual screen resolution for an authentic retro feel
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true
    })

    love.window.setTitle('Super Mario 50')

    love.keyboard.keysPressed = {}
    love.keyboard.keysReleased = {}

    gameState = 'play'

    level = 0
    game_over = 3
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

-- called whenever a key is pressed
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
        --restarts level
    elseif key == 'enter' or key == 'return' then
        love.audio.stop()
        map:init()
        player:init(map)
        gameState = 'play'
    end

    love.keyboard.keysPressed[key] = true
end

-- called whenever a key is released
function love.keyreleased(key)
    love.keyboard.keysReleased[key] = true
end

-- called every frame, with dt passed in as delta in time since last frame
function love.update(dt)
    map:update(dt)
    player:update(dt)
    

    -- reset all keys pressed and released this frame
    love.keyboard.keysPressed = {}
    love.keyboard.keysReleased = {}

    if player.map:tileAt(player.x, player.y).id == FLAG_BOTTOM or
        player.map:tileAt(player.x + player.width, player.y).id == FLAG_TOP then
        gameState = 'finish'
        -- level = level + 1
        

    elseif player.y > map.mapHeightPixels then
        gameState = 'dead'
        
    end

    -- if game_over == 0 then
    --     gameState = 'lose'
    -- end

end

-- called each frame, used to render to the screen
function love.draw()
    -- begin virtual resolution drawing
    push:apply('start')

    -- clear screen using Mario background blue
    love.graphics.clear(108/255, 140/255, 255/255, 255/255)

    -- renders our map object onto the screen
    love.graphics.translate(math.floor(-map.camX + 0.5), math.floor(-map.camY + 0.5))
    map:render()
    
 
    
    if gameState == 'finish' then
        -- love.graphics.setFont(endingFont)
        love.graphics.printf("CONGRATULATIONS!", 0 ,40, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press Enter to Advance", 0, 60, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'dead' then
        -- love.graphics.setFont(endingFont)
        love.graphics.printf("You Died!", 0 ,40, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press Enter to Respawn", 0, 60, VIRTUAL_WIDTH, 'center')
        -- game_over = game_over - 1
    elseif gameState == 'lose' then
        -- love.graphics.setFont(endingFont)
        love.graphics.printf("Game Over!", 0 ,40, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Try Again Next Time!", 0 ,60, VIRTUAL_WIDTH, 'center')
    end
    
    -- end virtual resolution
    push:apply('end')
end