countTHENV = 0

--valEnv = 0
countTHENV = 0
countMic = 0

function f_timerMic()
    valEnv = adc.read(0)

    if valEnv > THENV then
        countTHENV = countTHENV + 1
    end

    if countMic % 50 == 0 then
        print(countTHENV.."   "..valEnv)
        countTHENV = 0
        if countTHENV> 25 then
            gpio.write(led, gpio.HIGH)
        else
            gpio.write(led, gpio.LOW)
        end
    end

    countMic = countMic +1

end

timerMic = tmr.create()

timerMic:register(10, tmr.ALARM_AUTO, f_timerMic)

print('timerMic criado.')
