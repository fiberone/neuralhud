function getCenterPoint(...)
    local minx, miny, maxx, maxy = 0,0,0,0
    local x = {}
    local y = {}
    local points = {...}
    for i, point in pairs(points) do
        table.insert(x, point[1])
        table.insert(y, point[2])
    end
    maxx = math.max(table.unpack(x))
    minx = math.min(table.unpack(x))
    maxy = math.max(table.unpack(y))
    miny = math.min(table.unpack(y))
    xy = {x=(maxx+minx)/2, y=(maxy-miny)/2}
    return xy
end

-- https://stackoverflow.com/questions/12161277/how-to-rotate-a-vertex-around-a-certain-point
function rotatePoints(ang, poly)
    local points = {}
    local newPoints = {}
    if poly == nil then
        printError("no poly object, is it possible you meant to use polyobj:rotate instead?")
        return
    end
    local center = poly.center
    for i=1, poly.getPointCount(), 1 do
        table.insert(points, table.pack(poly.getPoint(i)))
    end
    --local shifted = {} 
    --for i, point in pairs(points) do
    --    table.insert(shifted, {point.x-center.x, point.y-center.y})
    --end
    local r
    for i, point in pairs(points) do
        --r = math.sqrt((point.x-center.x)^2+(point.y-center.y)^2)
        local ptx = center.x + ( math.cos(ang) * (point[1]-center.x) + math.sin(ang) * (point[2] -center.y))
        local pty = center.y + ( -math.sin(ang) * (point[1]-center.x) + math.cos(ang) * (point[2] -center.y))
        poly.setPoint(i, ptx, pty)
    end
    return newPoints
end

function medialPolygon(cx, cy, r, sides, color)
    --local color = assureColor(color)
    local cx, cy, r = cx or 0, cy or 0, r or 1
    local points = {}
    for i = 1, 360, 360/sides do
      local angle = i * math.pi / 180
      local ptx, pty = cx + r * math.cos( angle ), cy + r * math.sin( angle )
      ptx, pty = tonumber(string.format("%.0f", ptx)),tonumber(string.format("%.0f", pty))
      table.insert(points, {ptx, pty} )
    end
    table.insert(points, #points+1, color)
    return points, function (x) x.center = {x=cx, y=cy} x.rotate = function(poly, ang) rotatePoints(math.rad(ang), poly) end end
end