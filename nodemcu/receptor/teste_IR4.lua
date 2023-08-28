--Controle do led ON
--msg = "EXY00000000111101111100000000111111EXE"

--controle da TV POWER (Olhar o que colocar antes do Y)
msg = "EEY11100000111000000110011110011000"


ON_SEND = 1
OFF_SEND = (ON_SEND+1)%2

DELAY_US = 562

DELAY_US_ADD = -119

pin_send = 2

for i = 1, #msg do
    local c = msg:sub(i, i+1)
    if c == "XY" then
        --print("inicio "..i)
        count = 0
        lista_delay = {}
        lista_level = {}

        count = count + 1
        lista_delay[count] = 9*1000
        lista_level[count] = ON_SEND

        count = count + 1
        lista_delay[count] = 4500
        lista_level[count] = OFF_SEND
        
        for j = i+2, #msg do
            c = msg:sub(j, j)
            if c == "0" then
                count = count + 1
                lista_delay[count] = DELAY_US
                lista_level[count] = ON_SEND

                count = count + 1
                lista_delay[count] = DELAY_US
                lista_level[count] = OFF_SEND
            elseif c == "1" then
                count = count + 1
                lista_delay[count] = DELAY_US
                lista_level[count] = ON_SEND

                count = count + 1
                lista_delay[count] = DELAY_US*3
                lista_level[count] = OFF_SEND
            else
                break
            end
            
            --print(c)
        end
        
        break
    end
    print(c)
end


print("OK "..#lista_level)
print("OK "..#lista_delay)

for i = 1,count do
    --print(lista_level[i].."   "..lista_delay[i])

end

gpio.mode(pin_send, gpio.OUTPUT)

gpio.write(pin_send, OFF_SEND)

tmr.delay(500*1000)

soma = 0
now2 = tmr.now()
for i = 1,count do
    now = tmr.now()
    tmr.delay(lista_delay[i] + DELAY_US_ADD)
    gpio.write(pin_send, lista_level[i])
    soma = soma + lista_delay[i]
    --print(tmr.now()-now)
end
print(tmr.now()-now2)
print(soma)
