import numpy as np 
from pcie_mem_util import *


class dyn_clk:
    #REGS
    REG_CFG  = 0x200
    REG_DIV  = 0x208
    REG_SET  = 0x25C
    
    #SET_Value
    REG_SET_ON = 0x3
    
    def __init__ (self,device_offset,base_offset):
        self.device_offset = device_offset
        self.base_offset = base_offset
        self.set_clock(10.000)
        
        
    def set_clock(self,SetRate):
        new_values = self.get_config(SetRate)
        #print('CFG {0:.3f} {1:d} {2:.3f}'.format(new_values[0],new_values[1],new_values[2]))
        real_clk = 125*new_values[0]/new_values[1]/new_values[2]
        #convert to int
        m_int = int(new_values[0] * 1000)
        m_fraq = m_int%1000
        m_dec = int(m_int/1000)
        #print(m_dec,m_fraq)
        Div_int = int(new_values[2] * 1000)
        Div_fraq = Div_int%1000
        Div_dec = int(Div_int/1000)
        #print(Div_dec,Div_fraq)
        CFG_value = m_fraq<<16 | m_dec<<8 | new_values[1]
        DIV_value = Div_fraq<<8 | Div_dec
        #print(hex(CFG_value),hex(DIV_value))
        
        mem = pcie_mem(self.device_offset+self.base_offset)
        mem.wwrite(self.REG_CFG,CFG_value)
        mem.wwrite(self.REG_DIV,DIV_value)
        mem.wwrite(self.REG_SET,self.REG_SET_ON)
        
        return real_clk
        
    def get_config(self,SetRate):
        VcoMin = 600
        VcoMax = 1600
        Mmin = 2.0
        Mmax = 64
        Dmin = 1
        Dmax = 106
        Omin = 1.0
        Omax = 128
        Minerr = 1000
        PrimInClkFreq = 125


        m_final = 0.0
        d_final = 0
        Div_final = 0.0
        Diff = Minerr

        for m in np.arange(Mmin,Mmax,0.125):
            for d in range(Dmin,Dmax):
                Fvco = PrimInClkFreq  * m / d
                if ( Fvco >= VcoMin and Fvco <= VcoMax ):
                    for Div in np.arange(Omin,Omax,0.125):
                        Freq = Fvco/Div

                        if (Freq > SetRate):
                            Diff = Freq - SetRate
                        else:
                            Diff = SetRate - Freq
                        
                        if (Diff == 0 ):
                            m_final = m
                            d_final = d
                            Div_final = Div
                            return(m_final,d_final,Div_final)
                        elif (Diff < Minerr):
                            Minerr = Diff
                            m_final = m
                            d_final = d
                            Div_final = Div
        return(m_final,d_final,Div_final)
