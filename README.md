# FPGA RPi Blade
An affordable HPC FPGA platform with COTS parts. 

## TODOs

### Before Launch
  * ~~List Parts~~
  * ~~link RPi XDMA~~
  * ~~XDMA Steaming Example~~
  * ~~XDMA Memory mapped option~~
  * ~~Simple Axi lite Option~~
  * ~~Python SW for it~~
  * ~~Litex Directory with repo with simple instructions~~
  * ~~Post Results~~
  * ~~Fill out README.md for each directory~~

### After Launch
  * ~~Power Load test~~
  * ~~Add all 2019.1 releases~~
  * Need Flash Firmware update (without need of JTAG)
  * Move to Vivado 2023.1 
  * Add supporting IP to examples (Temp, Flash, Version, LEDs, DDR)
  * Board Files
  * Fix LiteX Driver Issue
  * Dynamic Power Tester (overclocked BRAMs)
  * Add Platform support for examples
  * Try various Vitis Libraries Examples
  * Get Vitis AI working
  * Do Advent of Code on it?

## Parts
 * Raspberry Computer Module 4
 * LiteFury/NiteFury/Acorn M.2 FPGA
   * LiteFury Info: [Link](https://rhsresearch.com/products/litefury) Buy: [Amazon](https://www.amazon.com/RHS-Research-Litefury-Artix-7-Development/dp/B08BKSVJH5).
   * NiteFury Info: [Link](https://rhsresearch.com/collections/rhs-public/products/nitefury-xilinx-artix-fpga-kit-in-nvme-ssd-form-factor-2280-key-m)  Buy: [Amazon](https://www.amazon.com/RHS-Research-Litefury-Artix-7-Development/dp/B0B9FMBF6C).
   * SQRL Acorn CLE Info: [Link](https://web.archive.org/web/20190619181059/http://squirrelsresearch.com/acorn-cle-215-plus/)  Buy?: [eBay](https://www.ebay.com/sch/i.html?_from=R40&_trksid=p2334524.m570.l1313&_nkw=SQRL+Acorn+cle+215%2B+FPGA&_sacat=0&LH_TitleDesc=0&_odkw=SQRL+Acorn+cle+215+FPGA&_osacat=0).
 * Compute Blade
   * Product Page [Link](https://computeblade.com/)
   * Kickstarter [Link](https://www.kickstarter.com/projects/uptimelab/compute-blade?ref=ae6z7n)

## Examples
Currently Built for Vivado 2019.1 (my favorite version)

I will include other verions in the future, but it should be easy to port.

### XDMA
  * In Vivdao run `source src_proc.tcl'.
  * Go to XDMA directory for more info

### PCIe AXI Lite
  * In Vivdao run `source src_proc.tcl'.
  * Go to PCIe AXI Lite directory for more info

### LiteX LitePCIe
  * Go to LitePcie directory for more info


