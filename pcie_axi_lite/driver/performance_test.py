from pcie_mem_util import *
import time
import argparse
parser = argparse.ArgumentParser()
parser.add_argument("pcie_addr")
args = parser.parse_args()

print(args.pcie_addr)
pcie_addr_int=int(args.pcie_addr,16)

bram = pcie_mem(pcie_addr_int)

start_time = time.time()
for i in range(0x4000):
    bram.wwrite(i,i)
end_time = time.time()

write_MBps = 0x10000/(end_time-start_time)/1024/1024

start_time = time.time()
for i in range(0x4000):
    bram.wread(i)
end_time = time.time()

read_MBps = 0x10000/(end_time-start_time)/1024/1024

print("Write MBps is ",write_MBps)

print("Read MBps is ",read_MBps)