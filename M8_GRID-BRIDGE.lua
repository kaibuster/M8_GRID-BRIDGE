-- Monome Grid / TouchOSC 
-- controller for Dirtywave 
-- M8

local grid = util.file_exists(_path.code.."toga") and include "toga/lib/togagrid" or grid
local arc = util.file_exists(_path.code.."toga") and include "toga/lib/togaarc" or arc

local function find_midi(name)
  for i, dev in pairs(midi.devices) do
    if dev.name == name then return i end
  end
end

my_midi = midi.connect(find_midi("M8"))
g = grid.connect()

local DIM = 8
local BRIGHT = 15
local is_playing = false

-- gunter pixel art (40x48)
local pw, ph = 40, 48
local px = {
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
  {1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1},
  {1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1},
  {1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1},
  {1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1},
  {1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
  {1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1},
  {1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1},
  {1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,1,1,1,0,0,1,0,1,1,1,1,1,1},
  {1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,1,1,1,0,1,1,1,0,0,1,1,1,0,1,1,1,1,1},
  {1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,1,1,1,1,0,1,1,0,0,1,1,1,1,0,1,1,1,1},
  {1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,1,1,1,1,1,0,1,1,0,0,1,1,1,1,0,1,1,1,1},
  {1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,1,1,1,1,1,0,1,1,0,0,1,1,1,1,1,1,1,1,1},
  {1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,1,1,1,1,1,1,1,0,0,0,0,1,1,0,1,1,1,1,1},
  {1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,1,1,1,0,1,0,1,1,1,0,0,0,1,1,1,1,1,1},
  {1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,1,1,0,1,1,1,1,1,1,1,0,1,1,1,1,1},
  {1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,1},
  {1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1},
  {1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1},
  {1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1},
  {1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1},
  {1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1},
  {1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1},
  {1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1},
  {1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1},
  {1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1},
  {1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1},
  {1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,1},
  {1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,1},
  {1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,1},
  {1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,1},
  {1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,1},
  {1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1},
  {1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1},
  {1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
  {1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1},
  {1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
  {1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1},
  {1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1},
  {1,1,1,1,1,1,1,1,1,1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1},
  {1,1,1,1,1,1,1,1,1,1,1,0,1,1,0,1,0,1,0,1,1,1,1,0,1,1,0,1,0,1,0,1,1,1,1,1,1,1,1,1},
  {1,1,1,1,1,1,1,1,1,1,1,1,0,1,0,0,1,0,0,1,1,1,1,1,0,1,1,0,1,0,0,1,1,1,1,1,1,1,1,1},
  {0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1},
}

local function draw_sprite(ox, oy)
  for y=1,ph do
    for x=1,pw do
      if px[y][x] == 1 then
        screen.pixel(ox + x, oy + y)
      end
    end
  end
  screen.fill()
end

local function draw_grid()
  g:led(1, 1, is_playing and BRIGHT or DIM)
  g:led(14, 2, DIM) -- up
  g:led(14, 3, DIM) -- down
  g:led(13, 3, DIM) -- left
  g:led(15, 3, DIM) -- right
  g:led(14, 5, DIM) -- shift
  g:led(15, 5, DIM) -- play
  g:led(15, 1, DIM) -- option
  g:led(16, 1, DIM) -- edit
  g:led(13, 7, DIM) -- left+shift
  g:led(14, 7, DIM) -- left+play
  for i=1,8 do g:led(i, 2, DIM) end
  for i=1,8 do g:led(i, 4, DIM) end
  g:refresh()
end

local function send_momentary(note, ch)
  my_midi:note_on(note, 1, ch)
end

local function send_momentary_off(note, ch)
  my_midi:note_off(note, 0, ch)
end

local function send_toggle(note, ch)
  clock.run(function()
    my_midi:note_on(note, 1, ch)
    clock.sleep(0.05)
    my_midi:note_off(note, 0, ch)
    clock.sleep(0.05)
  end)
end

local function send_combo(note_a, note_b, ch)
  clock.run(function()
    my_midi:note_on(note_a, 1, ch)
    clock.sleep(0.05)
    my_midi:note_on(note_b, 1, ch)
    clock.sleep(0.05)
    my_midi:note_off(note_b, 0, ch)
    clock.sleep(0.05)
    my_midi:note_off(note_a, 0, ch)
    clock.sleep(0.05)
  end)
end

function init()
  clock.run(function()
    clock.sleep(1)
    draw_grid()
  end)
  redraw()
end

g.key = function(x, y, z)
  local pressed = z > 0

  if x == 1 and y == 1 then
    if pressed then
      if is_playing then send_toggle(1, 10)
      else send_toggle(0, 10) end
      draw_grid()
    end

  elseif y == 2 and x <= 8 then
    local note = 11 + x
    if pressed then send_momentary(note, 10) g:led(x, 2, BRIGHT) g:refresh()
    else send_momentary_off(note, 10) g:led(x, 2, DIM) g:refresh() end

  elseif y == 4 and x <= 8 then
    local note = 19 + x
    if pressed then send_momentary(note, 10) g:led(x, 4, BRIGHT) g:refresh()
    else send_momentary_off(note, 10) g:led(x, 4, DIM) g:refresh() end

  elseif x == 15 and y == 1 then
    if pressed then send_momentary(3, 10) g:led(15, 1, BRIGHT) g:refresh()
    else send_momentary_off(3, 10) g:led(15, 1, DIM) g:refresh() end

  elseif x == 16 and y == 1 then
    if pressed then send_momentary(2, 10) g:led(16, 1, BRIGHT) g:refresh()
    else send_momentary_off(2, 10) g:led(16, 1, DIM) g:refresh() end

  elseif x == 14 and y == 2 then
    if pressed then send_momentary(6, 10) g:led(14, 2, BRIGHT) g:refresh()
    else send_momentary_off(6, 10) g:led(14, 2, DIM) g:refresh() end

  elseif x == 14 and y == 3 then
    if pressed then send_momentary(7, 10) g:led(14, 3, BRIGHT) g:refresh()
    else send_momentary_off(7, 10) g:led(14, 3, DIM) g:refresh() end

  elseif x == 13 and y == 3 then
    if pressed then send_momentary(4, 10) g:led(13, 3, BRIGHT) g:refresh()
    else send_momentary_off(4, 10) g:led(13, 3, DIM) g:refresh() end

  elseif x == 15 and y == 3 then
    if pressed then send_momentary(5, 10) g:led(15, 3, BRIGHT) g:refresh()
    else send_momentary_off(5, 10) g:led(15, 3, DIM) g:refresh() end

  elseif x == 14 and y == 5 then
    if pressed then send_momentary(1, 10) g:led(14, 5, BRIGHT) g:refresh()
    else send_momentary_off(1, 10) g:led(14, 5, DIM) g:refresh() end

  elseif x == 15 and y == 5 then
    if pressed then send_momentary(0, 10) g:led(15, 5, BRIGHT) g:refresh()
    else send_momentary_off(0, 10) g:led(15, 5, DIM) g:refresh() end

  elseif x == 13 and y == 7 then
    if pressed then
      send_combo(4, 1, 10) -- left+shift
      g:led(13, 7, BRIGHT) g:refresh()
    else
      g:led(13, 7, DIM) g:refresh()
    end

  elseif x == 14 and y == 7 then
    if pressed then
      send_combo(4, 0, 10) -- left+play
      g:led(14, 7, BRIGHT) g:refresh()
    else
      g:led(14, 7, DIM) g:refresh()
    end
  end
end

my_midi.event = function(data)
  local d = midi.to_msg(data)
  if not d then return end
  if d.type == "start" then is_playing = true draw_grid()
  elseif d.type == "stop" then is_playing = false draw_grid() end
end

function redraw()
  screen.clear()
  screen.aa(0)
  screen.level(15)
  draw_sprite(0, 8)
  screen.move(46, 20)
  screen.font_face(1)
  screen.font_size(8)
  screen.text("M8 Grid-Bridge 2.0")
  screen.move(46, 32)
  screen.update()
end