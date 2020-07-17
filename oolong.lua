local sdl = require "SDL"
local imgui = require "oolong.imgui"
local render = require "oolong.render"

local oolong = {}
local g_drawfunc 
local g_window

local VKMAP = {
    Tab = sdl.scancode.Tab,
    LeftArrow = sdl.scancode.Left,
    RightArrow = sdl.scancode.Right,
    UpArrow = sdl.scancode.Up,
    DownArrow = sdl.scancode.Down, 
    PageUp = sdl.scancode.PageUp,
    PageDown = sdl.scancode.PageDown,
    Home = sdl.scancode.Home,
    End = sdl.scancode.End,
    Insert = sdl.scancode.Insert,
    Delete = sdl.scancode.Delete,
    Backspace = sdl.scancode.Backspace,
    Space = sdl.scancode.Space,
    Enter = sdl.scancode.Enter,
    Escape = sdl.scancode.Escape,
    A = sdl.scancode.A,
    C = sdl.scancode.C,
    V = sdl.scancode.V,
    X = sdl.scancode.X,
    Y = sdl.scancode.Y,
    Z = sdl.scancode.Z
}

local function mapkeyboard()

end

function oolong.config(opt)
    assert(opt.window)
    assert(opt.draw)
    local wndflag = opt.window.flags
    if not wndflag then
        wndflag = {}
    end
    g_drawfunc = opt.draw
    table.insert(wndflag,sdl.window.OpenGL)
    table.insert(wndflag,sdl.window.Resizable)
    opt.window.flags = wndflag
    local err
    g_window,err = sdl.createWindow(opt.window)
    oolong.window = g_window
    sdl.glSetAttribute(sdl.glAttr.DoubleBuffer,1)
    sdl.glSetAttribute(sdl.glAttr.DepthSize,24)
    sdl.glSetAttribute(sdl.glAttr.StencilSize,8)
    local glctx,err = sdl.glCreateContext(g_window)
    sdl.glMakeCurrent(g_window,glctx)
    imgui.Create()
    if opt.font then
        imgui.LoadFont(opt.font,opt.fontsize)
    end
    render.init()
    imgui.KeyMap(VKMAP)
end 

local function keymod(mod)
   local state = 0
   if mod[sdl.keymod.LeftControl] or mod[sdl.keymod.RightControl] then
        state = state | 0x01
   end
   if mod[sdl.keymod.LeftAlt] or mod[sdl.keymod.RightAlt] then 
        state = state | 0x02
   end
   if mod[sdl.keymod.LeftShift] or mod[sdl.keymod.RightShift] then 
        state = state | 0x04
   end
   if mod[sdl.keymod.LGUI] or mod[sdl.keymod.RGUI] then 
        state = state | 0x08
   end
   return state
end

local function on_keydown(e)
   imgui.KeyState(e.keysym.scancode,true,keymod(e.keysym.mod))
end

local function on_keyup(e)
   imgui.KeyState(e.keysym.scancode,false,keymod(e.keysym.mod))
end

local function mousebtype(button)
    if button == sdl.mouseButton.Left then
        return 0
    elseif button == sdl.mouseButton.Right then
        return 1
    elseif button == sdl.mouseButton.Middle then
        return 2
    else 
        return 0
    end
    
end

local function on_mousebuttondown(e)
    imgui.MouseState(mousebtype(e.button),1)
end

local function on_mousebuttonup(e)
    imgui.MouseState(mousebtype(e.button),0)
end

local function on_mousewheel(e)
    if e.x > 0 then
        imgui.SetMouseWheel(1,true)
    elseif e.x < 0 then
        imgui.SetMouseWheel(-1,true)
    end
    if e.y > 0 then
        imgui.SetMouseWheel(1,false)
    elseif e.y < 0 then
        imgui.SetMouseWheel(-1,false)
    end
end

local function on_text(e)
    imgui.AddInputCharsUtf8(e.text)
end

function oolong.poll()
    local handler = {}
    handler[sdl.event.KeyDown] = on_keydown
    handler[sdl.event.KeyUp] = on_keyup
    handler[sdl.event.MouseButtonDown] = on_mousebuttondown
    handler[sdl.event.MouseButtonUp] = on_mousebuttonup
    handler[sdl.event.MouseWheel] = on_mousewheel
    handler[sdl.event.TextInput] = on_text
    local last_drawtime = 0

    while true do
        local e,err = sdl.waitEvent(33)
        if e then
            if e.type == sdl.event.Quit then
                return
            else
                local f = handler[e.type]
                if f then 
                    f(e)
                end
            end
        end
        local time = sdl.getTicks()
        if time - last_drawtime >= 33 then
            last_drawtime = time

            imgui.SetDisplaySize(g_window:getSize())
            local _,x,y = sdl.getMouseState()
            imgui.SetMousePos(x,y)
            imgui.NewFrame()
            g_drawfunc()
            render.render()
            sdl.glSwapWindow(g_window)
        end
    end
end

return oolong