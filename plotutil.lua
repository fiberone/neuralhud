-- https://stackoverflow.com/questions/12161277/how-to-rotate-a-vertex-around-a-certain-point
function rotatePoints(ang, center, ...)
    local points = {...}
    local newPoints = {}
    --local shifted = {} 
    --for i, point in pairs(points) do
    --    table.insert(shifted, {point.x-center.x, point.y-center.y})
    --end
    local r
    for i, point in pairs(points) do
        --r = math.sqrt((point.x-center.x)^2+(point.y-center.y)^2)
        local ptx = center.x + ( math.cos(ang) * (point.x-center.x) + math.sin(ang) * (point.y -center.y))
        local pty = center.y + ( -math.sin(ang) * (point.x-center.x) + math.cos(ang) * (point.y -center.y))
        table.insert(newPoints, {x=ptx, y=pty})
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
    return points, color
end