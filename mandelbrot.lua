monitor = peripheral.find("monitor")

os.loadAPI("image.lua")
os.loadAPI("monutil.lua")
function clearMon()
  monitor.setBackgroundColor(colors.black)
  monitor.clear()
end

toMonitor = true

w,h = monitor.getSize()
w,h = (w*2)-1, (h*3)-1
if not toMonitor then
w,h = term.getSize()
end

originX, originY, zoom = w/2,h/2,1

function debugLog(message)
  local file = fs.open("debug.log","a")
  file.writeLine(message)
  file.close()
end

function scale(x,y)
  x0 = (3.5 * (x-1+(originX-w/2)) / w) - 2.5
  y0 = (2 * (y-1+(originY-h/2)) / h) - 1
  --debugLog(x..","..y.."="..x0..","..y0)
  return x0/zoom,y0/zoom
end

function getColor(iter)
  if iter == 1000 then
        return colors.black
  end

  return bit.blshift(1,(math.floor(iter/2))%15+1)  
end

debugLog("w: "..w.." h: "..h)
function drawMandelbrot()
local dots = {}
for j = 2,h do
  for i = 2,w do

        x0,y0 = scale(i,j,zoom)
        
        x = 0
        y = 0
        
        iter = 0
        maxIter = 1000
        
        while x*x + y*y < 2*2 and iter < maxIter do
        
          xTemp = x*x - y*y + x0
          y = 2*x*y + y0
          x = xTemp
          
          iter = iter + 1

        end
        
        bgColor = getColor(iter)
--      print(iter)

        if toMonitor then       
          --monitor.setBackgroundColor(bgColor)
          --monitor.setCursorPos(i,j)
          --monitor.write(" ")  
          dots = {x=i, y=j, color=bgColor}
        else
          --term.setBackgroundColor(bgColor)
          --term.setCursorPos(i,j)
          --term.write(" ")
          dots = {x=i, y=j, color=bgColor}
        end
  end
  os.queueEvent("blah") os.pullEvent("blah")
end
return dots
end

local im = image.createImage()

im.image = {}
local points = drawMandelbrot()
for i, plot in pairs(points) do
    im.addPoint(plot.x, plot.y, plot.color)
end
monutil.bldraw(im.parseImage)

while true do
  event, button, mx, my = os.pullEvent("mouse_click")

  if button == 1 then
        zoom = zoom + 1
  elseif button == 2 then
        zoom = zoom - 1
  end

  originX, originY = mx/zoom,my/zoom

  if zoom < 1 then zoom = 1 end

  --clearMon()
  points = drawMandelbrot()
  im.image = {}
  for i, plot in pairs(points) do
    im.addPoint(plot.x, plot.y, plot.color)
  end
  monutil.bldraw(im.parseImage)
end