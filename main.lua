WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

local centerX = WINDOW_WIDTH / 2
local centerY = WINDOW_HEIGHT / 2

-- -- used to draw circles
-- local circleCoords = {}
-- local radius

local lines = {}

local speed = 10

local angle = 0

local camPos = {
    x = 0,
    y = 0,
    z = -5,
}

local camRot = {
    0,
    0,
}

love.mouse.setRelativeMode(true)
local dx, dy = 0, 0 -- to handle rotation

local isQ = false
local isE = false
local isA = false
local isD = false
local isW = false
local isS = false

-- vertices of a cube in relation to its center
local vertices = {{-1,-1,-1},{1,-1,-1},{1,1,-1},{-1,1,-1},{-1,-1,1},{1,-1,1},{1,1,1},{-1,1,1}}

-- edges are just indexes of vertices which are connected together
local edges = {{1,2},{2,3},{3,4},{4,1},{5,6},{6,7},{7,8},{8,5},{1,5},{2,6},{3,7},{4,8}}

function love.load()
    love.window.setTitle("3D Engine")

    -- set window size
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false
    })
end

function love.keypressed(key)
    -- quit at any time with ESC key
    if key == "escape" then
        love.event.quit()
    end

    if key == "w" then
        isW = true
    end
    if key == "s" then
        isS = true
    end
    if key == "a" then
        isA = true
    end
    if key == "d" then
        isD = true
    end
    if key == "q" then
        isQ = true
    end
    if key == "e" then
        isE = true
    end
end

function love.keyreleased(key)
    if key == "w" then
        isW = false
    end
    if key == "s" then
        isS = false
    end
    if key == "a" then
        isA = false
    end
    if key == "d" then
        isD = false
    end
    if key == "q" then
        isQ = false
    end
    if key == "e" then
        isE = false
    end
end

function love.update(dt)

    mouseRotationUpdate()

    -- -- circles at verticles
    -- circleCoords = {}
    -- for i, v in ipairs(vertices) do
    --     local x = vertices[i][1] - camPos.x
    --     local y = vertices[i][2] - camPos.y
    --     local z = vertices[i][3] - camPos.z

    --     x, z = rotate2d(x, z, camRot[2])
    --     y, z = rotate2d(y, z, camRot[1])

    --     local f = WINDOW_HEIGHT / 2 / z

    --     x = x * f
    --     y = y * f
    --     radius = f / 15
        
    --     table.insert(circleCoords, {centerX + math.ceil(x), centerY + math.ceil(y)})
    -- end

    lines = {}

    for _, edge in ipairs(edges) do -- loops 12 times because there are 12 edges in a cube

        local p1 = vertices[edge[1]]
        local p2 = vertices[edge[2]]

        local points = {}

        for _, vertice in ipairs({p1, p2}) do -- loops 2 times, because line is described by 2 points

            local x = vertice[1] - camPos.x
            local y = vertice[2] - camPos.y
            local z = vertice[3] - camPos.z

            x, z = rotate2d(x, z, camRot[2])
            y, z = rotate2d(y, z, camRot[1])

            local f = WINDOW_HEIGHT / 2 / z

            x = x * f
            y = y * f

            table.insert(points, centerX + math.ceil(x))
            table.insert(points, centerY + math.ceil(y))

        end
        table.insert(lines, points)
    end


    if isQ then
        camPos.y = camPos.y - speed * dt
    end

    if isE then
        camPos.y = camPos.y + speed * dt
    end

    if isA then
        camPos.x = camPos.x - speed * dt
    end

    if isD then
        camPos.x = camPos.x + speed * dt
    end

    if isW then
        camPos.z = camPos.z + speed * dt
    end

    if isS then
        camPos.z = camPos.z - speed * dt
    end
end



function love.draw()

    -- -- draw circles at verticles
    -- for _,v in ipairs(circleCoords) do
    --     love.graphics.circle("fill", v[1],v[2], radius)
    -- end

    -- draw edges of the cube
    for _,v in ipairs(lines) do
        love.graphics.line(v)
    end

    -- print FPS number
    love.graphics.printf(love.timer.getFPS( ), 0, 0, WINDOW_WIDTH, "left")
end

-- rotation algorithm
function rotate2d(x, y, angle)
    local s = math.sin(angle)
    local c = math.cos(angle)
    return x * c - y * s, y * c + x * s
end

function mouseRotationUpdate()

    -- DX and DY are representing the change in
    -- position of mouse coords during one game tick
    function love.mousemoved(X,Y,DX,DY)
        dx, dy = DX, DY
    end

    -- values are divided to control the sensitivity of
    -- mouse input, we are basically moving from pixels
    -- to radians, note that to complete a full turn 
    -- you need to rotate by 2Pi ~ 6.28 radians and mouse
    -- is easily moving by tens and hundreds of pixels so
    -- that's why we are dividing these values
    dx = dx / 50
    dy = dy / 50
    
    camRot[1] = camRot[1] + dy
    camRot[2] = camRot[2] + dx
end