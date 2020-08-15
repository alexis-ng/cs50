WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

Class = require 'class'
push = require 'push'

require 'Ball'
require 'Paddle'

function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Pong')

    smallFont = love.graphics.newFont('font.TTF', 8)
    scoreFont = love.graphics.newFont('font.TTF', 32)
    victoryFont = love.graphics.newFont('font.TTF', 24)
    sounds = {
        ['paddle_hit'] = love.audio.newSource('hit.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('wall.wav', 'static'),
        ['point_score'] = love.audio.newSource('point_score.wav', 'static')
    }

    love.graphics.setFont(smallFont)
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
   
    })
    --player scores
    player1Score = 0
    player2Score = 0


    --sets which player is serving
    servingPlayer = math.random(2) == 1 and 1 or 2

    --between one and two
    winningPlayer = 0
    
    --paddle starting location
    paddle1 = Paddle(5, 20, 5, 20)
    paddle2 = Paddle(VIRTUAL_WIDTH - 10 , VIRTUAL_HEIGHT - 30 , 5, 20)
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 5, 5)

    if servingPlayer == 1 then
        ball.dx = 100
    else
        ball.dx = -100
    end

    -- ball goes left or right
    -- ballDX = math.random(2) == 1 and -100 or 100
    -- ballDY = math.random(-50, 50)
   
    gameState = 'start'
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)

    if gameState == 'play' then
        
        

        --if ball collides with paddles
        if ball:collides(paddle1) then
            -- deflect ball right
            ball.dx = -ball.dx * 1.03
            ball.x = paddle1.x + 5

            sounds['paddle_hit']:play()
            
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else 
                ball.dy = math.random(10, 150)
            end
        end

        if ball:collides(paddle2) then
            --deflect ball left
            ball.dx = -ball.dx * 1.03
            ball.x = paddle2.x - 4

            sounds['paddle_hit']:play()

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else 
                ball.dy = math.random(10, 150)
            end
        end

        --if ball hits top or bottom
        if ball.y <= 0 then
            --deflect ball down
            ball.dy = -ball.dy
            ball.y = 0

            sounds['wall_hit']:play()
        end

        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.dy = -ball.dy
            ball.y = VIRTUAL_HEIGHT - 4
            
            sounds['wall_hit']:play()

        end

        --player 2 scores
        if ball.x <= 0 then
            player2Score = player2Score + 1
            servingPlayer = 1
            ball:reset()
            ball.dx = 100
            sounds['point_score']:play()


            if player2Score >= 10 then
               gameState = 'victory'
               winningPlayer = 2
            else
                gameState = 'serve'
            end    
            
        end

        --player 1 scores
        if ball.x >= VIRTUAL_WIDTH - 4 then
            player1Score = player1Score + 1
            servingPlayer = 2
            ball:reset()
            ball.dx = -100
            sounds['point_score']:play()

            if player1Score >= 10 then
                gameState = 'victory'
                winningPlayer = 1
             else
                 gameState = 'serve'
             end
        end
    end

    --player 1 movement
    if love.keyboard.isDown('w') then

        paddle1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then

        paddle1.dy = PADDLE_SPEED
    else
        paddle1.dy = 0
    end

    computer()
    

    if gameState =='play' then
        ball:update(dt)
    end

    paddle1:update(dt)
    paddle2:update(dt)
end


function love.keypressed(key)

    if key == 'escape' then
        love.event.quit()

    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'victory' then
            gameState = 'start'
            player1Score = 0
            player2Score = 0
        end
    end
end

function love.draw()
    push:apply('start')

    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

   
    displayScore()
    
    love.graphics.setFont(smallFont)
    if gameState == 'start' then

        love.graphics.printf('Welcome to Pong!', 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to Play!', 0, 32, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then

        love.graphics.printf("Player" .. tostring(servingPlayer) .. "'s turn!", 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press Enter to Serve!", 0, 32, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'victory' then

        --draw a vict message
        love.graphics.setFont(victoryFont)
        love.graphics.printf("Player" .. tostring(winningPlayer) .. " wins!", 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf("Press Enter to Serve!", 0, 42, VIRTUAL_WIDTH, 'center')
    end


    -- render ball
    ball:render()
 
    -- render paddles
    paddle1:render()
    paddle2:render()

    displayFPS()
    -- end rendering
    push:apply('end')

end

function displayFPS()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.setFont(smallFont)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 40, 20)
    love.graphics.setColor(1, 1, 1, 1)
end

function displayScore()
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
end

--runs player two
function computer(dt)

    if gameState == 'play' then
        if ball.y > VIRTUAL_HEIGHT / 2 - 2 then

            paddle2.dy = math.floor(PADDLE_SPEED / 2)
        else
            paddle2.dy = math.floor(-PADDLE_SPEED / 2)

        end

        if ball.y > paddle2.y then
            paddle2.dy = math.floor(PADDLE_SPEED / 2)
        else
            paddle2.dy = math.floor(-PADDLE_SPEED / 2)
        end 
    end

    -- Paddle(VIRTUAL_WIDTH / 2 , VIRTUAL_HEIGHT / 2 , 5, 20)  

end