gpio={}
function gpio.write(a,b)
    print("gpio.write "..tostring(a).." "..tostring(b))
end
function gpio.irsend(a,b,c,d)
    print("gpio.irsend "..tostring(a).." "..tostring(b).." "..tostring(c).." "..tostring(d))
end
gpio.HIGH=1 
gpio.LOW=0 

maquina=dofile("mqttSub2.lua")

msg1="publish-583,IRAR_01,IRAR;2;mode=COOL;temp=24;ligado=ON"
maquina.conectado.message(nil,nil,msg1)
