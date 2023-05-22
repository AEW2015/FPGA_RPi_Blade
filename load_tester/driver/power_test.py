import time
from xadc import *
from dyn_clk import *
from kasa import SmartStrip
import asyncio




def get_RPi_temp():
    with open('/sys/class/thermal/thermal_zone0/temp', 'r') as f:
        data = f.read()
    return float(data)/1000
    
async def get_KASA_wattage():
    strip = SmartStrip("192.168.0.14")
    await strip.update()
    return strip.get_plug_by_index(1).emeter_realtime.power


xadc = XADC(0x600000000,0x00000)
clk = dyn_clk(0x600000000,0x40000)


loop = asyncio.get_event_loop()

for i in range (10,145,1):
    print('\nRequested Clock {0:.3f}, Real Clock {1:.3f}'.format(i,clk.set_clock(i)))
    for j in range(5):
        time.sleep(10)
        FPGA_temp = xadc.read_temp()
        RPi_temp = get_RPi_temp()
        KASA_watts = loop.run_until_complete(get_KASA_wattage())
        print('FPGA Temp {0:.3f}, RPi Temp {1:.3f}, AC Wattage {2:.3f}'.format(FPGA_temp,RPi_temp,KASA_watts))
    