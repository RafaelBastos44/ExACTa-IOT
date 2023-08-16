import serial
from datetime import datetime

serial_port = '/dev/ttyACM0'  # Altere para a porta serial correta
baud_rate = 9600

ser = serial.Serial(serial_port, baud_rate)
file_path = 'saida_serial.txt'

with open(file_path, 'a') as file:
    while True:
        if ser.in_waiting > 0:
            data = ser.readline().decode('utf-8').strip()  # Lê a linha da porta serial
            if data[0] == "R" and data[-1]=="B":
                data = data[1:-1]
            else:
                continue
            timestamp = datetime.now().isoformat()
            data_list = [timestamp]
            data_list.extend(data.split())
            formatted_data = ",".join(data_list)
            # formatted_data = f'[{timestamp}] {data}'
            print(formatted_data)  # Opcional: exibe os dados no terminal
            file.write(formatted_data + '\n')  # Escreve no arquivo