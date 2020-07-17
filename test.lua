local oolong = require "oolong"
local imgui = require "oolong.imgui"

oolong.config {
    window = {
        title = "imgui",
        width =  960,
        height = 480 
    },
    draw = function()
        --imgui.widget.Text('水寒')
        --imgui.widget.InputText('水寒',{})
        imgui.ShowDemo()
    end,
    font = "simsun.ttc",
    fontsize = 18.0
}


oolong.poll()