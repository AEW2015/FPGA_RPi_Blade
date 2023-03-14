# LiteX LitePCIe

Install LiteX and Linux on Litex following instructions on
* [LiteX](https://github.com/enjoy-digital/litex)
* [Linux-on-Litex](https://github.com/litex-hub/linux-on-litex-vexriscv)
* [VexRiscv](https://github.com/SpinalHDL/VexRiscv)
* Add info for RISC-V gcc

## LiteX Boards
* Run `python3 ./sqrl_acorn.py --varient=<target> --with-pcie --driver --build`
    * target
        * `cle-101`  ~ litefury
        * `cle-215`  ~ nitefury
        * `cle-215+` ~ acorn
* Driver will have to be copied to RPi
    * Need to define arch in MakeFile to `arm64`
    * TODO: kills RPI need to Debug

## Linux on LiteX
* Run `python3 ./make.py --board=acorn_pcie --build`
* This default to acorn cle-215+
* Same issue with driver
