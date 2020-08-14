Player = Class{}

local WALKING_SPEED = 140
local JUMP_VELOCITY = 400

first = math.random(0,10)
second = math.random(0, 10)
moves = 0


function Player:init(map)
    
    self.x = 0
    self.y = 0
    self.width = 32
    self.height = 32

    -- offset from top left to center to support sprite flipping
    self.xOffset = 8
    self.yOffset = 10

    -- reference to map for checking tiles
    self.map = map
    self.texture = love.graphics.newImage('player/player.png')

    -- animation frames
    self.frames = {}

    -- current animation frame
    self.currentFrame = nil

    -- used to determine behavior and animations
    self.state = 'idle'

    -- determines sprite flipping
    self.direction = 'left'

    -- x and y velocity
    self.dx = 0
    self.dy = 0

    -- position on top of map tiles
    self.y = map.tileHeight * ((map.mapHeight - 2) / 2) - self.height
    self.x = map.tileWidth * 10

    self.sounds = {
        ['add'] = love.audio.newSource('sounds/add.wav', 'static'),
        ['sub'] = love.audio.newSource('sounds/sub.wav', 'static'),
        ['mult'] = love.audio.newSource('sounds/mult.wav', 'static'),
        ['div'] = love.audio.newSource('sounds/div.wav', 'static'),
        ['question'] = love.audio.newSource('sounds/question.wav', 'static'),
        ['jump'] = love.audio.newSource('sounds/jump.wav', 'static')
    }

    -- initialize all player animations
    self.animations = {
        ['idle'] = Animation {
            texture = self.texture,
            frames = {
                love.graphics.newQuad(0, 0, 32, 32, self.texture:getDimensions())
            }
        },
        ['walking'] = Animation {
            texture = self.texture,
            frames = {
                love.graphics.newQuad(256, 0, 32, 32, self.texture:getDimensions()),
                love.graphics.newQuad(288, 0, 32, 32, self.texture:getDimensions()),
                love.graphics.newQuad(320, 0, 32, 32, self.texture:getDimensions()),
                love.graphics.newQuad(352, 0, 32, 32, self.texture:getDimensions())
            },
            interval = 0.15
        },
        ['jumping'] = Animation {
            texture = self.texture,
            frames = {
                love.graphics.newQuad(32, 0, 32, 32, self.texture:getDimensions()),
                love.graphics.newQuad(64, 0, 32, 32, self.texture:getDimensions()),
                love.graphics.newQuad(96, 0, 32, 32, self.texture:getDimensions()),
                love.graphics.newQuad(128, 0, 32, 32, self.texture:getDimensions()),
                love.graphics.newQuad(160, 0, 32, 32, self.texture:getDimensions()),
                love.graphics.newQuad(192, 0, 32, 32, self.texture:getDimensions()),
                love.graphics.newQuad(224, 0, 32, 32, self.texture:getDimensions())
            }
        }
    }

    -- initialize animation and current frame we should render
    self.animation = self.animations['idle']
    self.currentFrame = self.animation:getCurrentFrame()

-- behavior map we can call based on player state
self.behaviors = {
    ['idle'] = function(dt)
        
        -- add spacebar functionality to trigger jump state
        if love.keyboard.wasPressed('space') then
            self.dy = -JUMP_VELOCITY
            self.state = 'jumping'
            self.animation = self.animations['jumping']
            -- self.sounds['jump']:play()
        elseif love.keyboard.isDown('left') then
            -- print('i.left')
            self.direction = 'left'
            self.dx = -WALKING_SPEED
            self.state = 'walking'
            self.animations['walking']:restart()
            self.animation = self.animations['walking']
        elseif love.keyboard.isDown('right') then
            -- print('i.right')
            self.direction = 'right'
            self.dx = WALKING_SPEED
            self.state = 'walking'
            self.animations['walking']:restart()
            self.animation = self.animations['walking']
        else
            self.dx = 0
        end
    end,
    ['walking'] = function(dt)
        
        -- keep track of input to switch movement while walking, or reset
        -- to idle if we're not moving
        if love.keyboard.wasPressed('space') then
            self.dy = -JUMP_VELOCITY
            self.state = 'jumping'
            self.animation = self.animations['jumping']
            -- self.sounds['jump']:play()
        elseif love.keyboard.isDown('left') then
            -- print('w.left')
            -- print(math.floor(self.x))
            self.direction = 'left'
            self.dx = -WALKING_SPEED
        elseif love.keyboard.isDown('right') then
            -- print('w.right')
            -- print(math.floor(self.x))
            self.direction = 'right'
            self.dx = WALKING_SPEED
        else
            self.dx = 0
            self.state = 'idle'
            self.animation = self.animations['idle']
        end


        -- check if there's a tile directly beneath us
        if not self.map:collides(self.map:tileAt(self.x, self.y + self.height)) and
            not self.map:collides(self.map:tileAt(self.x + self.width - 1, self.y + self.height)) then
            
            -- if so, reset velocity and position and change state
            self.state = 'jumping'
            self.animation = self.animations['jumping']
        end
    end,
    ['jumping'] = function(dt)
        -- break if we go below the surface
        if self.y > 300 then
            return
        end

        if love.keyboard.isDown('left') then
            self.direction = 'left'
            self.dx = -WALKING_SPEED
        elseif love.keyboard.isDown('right') then
            self.direction = 'right'
            self.dx = WALKING_SPEED
        end

        -- apply map's gravity before y velocity
        self.dy = self.dy + self.map.gravity

        -- check if there's a tile directly beneath us
        if self.map:collides(self.map:tileAt(self.x, self.y + self.height)) or
            self.map:collides(self.map:tileAt(self.x + self.width - 1, self.y + self.height)) then
            
            -- if so, reset velocity and position and change state
            self.dy = 0
            self.state = 'idle'
            self.animation = self.animations['idle']
            self.y = (self.map:tileAt(self.x, self.y + self.height).y - 1) * self.map.tileHeight - self.height
        end

    end
}
    
end

function Player:update(dt)

    self.behaviors[self.state](dt)
    self.animation:update(dt)
    self.currentFrame = self.animation:getCurrentFrame()
    self.x = self.x + self.dx * dt
    -- print(math.floor(self.x + self.xOffset))
    self.y = self.y + self.dy * dt
    --question timer
    
    if map.question_time > 0 then
        map.question_time = map.question_time - dt
        -- print(math.floor(map.question_time))
    end
    self:math()
    map:outoftime()

    if first <= 0 then
        first = 0
    end
    

end
function Player:math()
    math.randomseed(os.time())

    if self.dy < 0 then
        if self.map:tileAt(self.x, self.y).id ~= TILE_EMPTY or
            self.map:tileAt(self.x + self.width - 1, self.y).id ~= TILE_EMPTY then
            -- reset y velocity
            self.dy = 0

            if self.map:tileAt(self.x, self.y).id == ADD_BLOCK then
                first = math.floor(first + second)
                self.sounds['add']:play()
                second = math.random(0, 20)
                moves = moves + 1
                map:hit()
               
               
        
            elseif self.map:tileAt(self.x, self.y).id == MULTIPLY_BLOCK then
                first = math.floor(first * second)
                self.sounds['mult']:play()
                second = math.random(0, 20)
                moves = moves + 1
                map:hit()
                

            elseif self.map:tileAt(self.x, self.y).id == SUBTRACT_BLOCK then
                first = math.floor(first - second)
                self.sounds['sub']:play()
                second = math.random(0, 20)
                moves = moves + 1
                map:hit()
                
                

            elseif self.map:tileAt(self.x, self.y).id == DIVIDE_BLOCK then

                first = first / second
                self.sounds['div']:play()
                second = math.random(0, 20)
                moves = moves + 1
                map:hit()
                
               

            elseif self.map:tileAt(self.x, self.y).id == QUESTION_BLOCK then
                self.sounds['question']:play()
                if math.random(4) == 1 then
                    first = first / second
                elseif math.random(4) == 2 then
                    first = first * second
                elseif math.random(4) == 3 then
                    first = first + second
                else
                    first = first - second
                end

                second = math.random(0, 20)
                moves = moves + 1

            end
        end
    end
end



function Player:render()
    local scaleX


    -- set negative x scale factor if facing left, which will flip the sprite
    -- when applied
    if self.direction == 'right' then
        scaleX = 1
    else
        scaleX = -1
    end
    
    -- draw sprite with scale factor and offsets
    love.graphics.draw(self.texture, self.currentFrame, math.floor(self.x + self.xOffset),
        math.floor(self.y + self.yOffset), 0, scaleX, 1, self.xOffset, self.yOffset)

end