gpio={}
function gpio.write(a,b)
    print("gpio.write "..tostring(a).." "..tostring(b))
end
function gpio.irsend(a,b,c,d)
    print("gpio.irsend "..tostring(a).." "..tostring(b).." "..tostring(c).." "..tostring(d))
end
gpio.HIGH=1 
gpio.LOW=0 

wifi = {
    setmode = function() end,
    sta = {config=function() return "wifi" end}
}

tmr = {
    create = function()
        return{alarm=function()end}
    end
}


dofile("init.lua")


