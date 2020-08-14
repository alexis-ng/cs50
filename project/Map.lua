require 'Util'
Map = Class{}



ADD_BLOCK = 1
DIVIDE_BLOCK = 3
MULTIPLY_BLOCK = 5
SUBTRACT_BLOCK = 7
QUESTION_BLOCK = 6
TILE_BRICK = 2

TILE_EMPTY = 4


function Map:init()
    self.spritesheet = love.graphics.newImage('graphics/spritesheet.png')
    self.sprites = generateQuads(self.spritesheet, 24, 22)
    -- self.music = love.audio.newSource('sounds/music.wav', 'static')

    self.tileWidth = 24
    self.tileHeight = 22
    self.mapWidth = 30
    self.mapHeight = 28
    self.tiles = {}
    self.music = love.audio.newSource('sounds/music.wav', 'static')
    -- applies positive Y influence on anything affected
    self.gravity = 30

    -- associate player with map
    self.player = Player(self)

    -- cache width and height of map in pixels
    self.mapWidthPixels = self.mapWidth * self.tileWidth
    self.mapHeightPixels = self.mapHeight * self.tileHeight

    self.question_time = 0


    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            
            -- support for multiple sheets per tile; storing tiles as tables 
            self:setTile(x, y, TILE_EMPTY)
        end
    end

    -- print(self.mapHeight)

    -- for x = 0 , 30 do
    --     self:setTile(x, 1, SUBTRACT_BLOCK)
    -- end   
    
    -- for y = 0 , 28 do
    --     self:setTile(1, y, SUBTRACT_BLOCK)
    -- end   
        
    
    --loads flooring
    for b = self.mapHeight / 2, self.mapHeight do  --y
        for a = 1, self.mapWidth  do                   --x
            -- print(self.mapHeight)
            -- love.graphics.printf("test", b, a, VIRTUAL_WIDTH, 'center')
            self:setTile(a, b, TILE_BRICK)
        end
    end

        --loads operation blocks
    self:setTile(6, self.mapHeight / 2 - 4, ADD_BLOCK)
    self:setTile(12, self.mapHeight / 2 - 4, DIVIDE_BLOCK)
    self:setTile(18, self.mapHeight / 2 - 4, MULTIPLY_BLOCK)
    self:setTile(24, self.mapHeight / 2 - 4, SUBTRACT_BLOCK)

    self.music:setLooping(true)
    self.music:play()
end

-- return whether a given tile is collidable
function Map:collides(tile)
    -- define our collidable tiles
    local collidables = {
        TILE_BRICK, ADD_BLOCK, SUBTRACT_BLOCK,
        DIVIDE_BLOCK, MULTIPLY_BLOCK
    }

    -- iterate and return true if our tile type matches
    for _, v in ipairs(collidables) do
        if tile.id == v then
            return true
        end
    end

    return false
end

--returns tile at certain coord
function Map:tileAt(x, y)
    return {
        x = math.floor(x / self.tileWidth) + 1,
        y = math.floor(y / self.tileHeight) + 1,
        id = self:getTile(math.floor(x / self.tileWidth) + 1, math.floor(y / self.tileHeight) + 1)
    }
end

-- returns an integer value for the tile at a given x-y coordinate
function Map:getTile(x, y)
    return self.tiles[(y - 1) * self.mapWidth + x]
end

-- sets a tile at a given x-y coordinate to an integer value
function Map:setTile(x, y, id)
    self.tiles[(y - 1) * self.mapWidth + x] = id
end

function Map:hit()
    if math.random(2) == 1 then
        self:setTile(math.floor(player.x / self.tileWidth) + 1,
            math.floor(player.y / self.tileHeight) + 1, QUESTION_BLOCK)
    else
        self:setTile(math.floor(player.x / self.tileWidth) + 1,
            math.floor(player.y / self.tileHeight) + 1, TILE_EMPTY)
    end

    self.question_time = 3
end

function Map:outoftime()

    if self.question_time <= 0 then
        self:setTile(6, self.mapHeight / 2 - 4, ADD_BLOCK)
        self:setTile(12, self.mapHeight / 2 - 4, DIVIDE_BLOCK)
        self:setTile(18, self.mapHeight / 2 - 4, MULTIPLY_BLOCK)
        self:setTile(24, self.mapHeight / 2 - 4, SUBTRACT_BLOCK)
    end
end

function Map:render()
    
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            local tile = self:getTile(x, y)
            if tile ~= TILE_EMPTY then
                -- love.graphics.draw(self.spritesheet, self.sprites[tile],
                --     x , y )
                love.graphics.draw(self.spritesheet, self.sprites[tile],
                    (x - 1) * self.tileWidth, (y - 1) * self.tileHeight)
            end
        end
    end

    -- self.player:render()

    

end