### Simple Pong
- This project is a simulation of a simple pong game using the BASYS 3 Vivado FPGA board. It is a 2 player game where the onboard buttons are used as player inputs (upto 2 players), the onboard LEDs track the position of the ball and the onboard seven seg display is used to show the score.

- The resources folder contain snapshots of the code, logic diagram and block diagram of the whole system.

## Installation and Usage
- [Vivado Design Suite](https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html 'link to site') was used in the creation for the project.

1. Create a new folder in your computer and clone this repo there.
    ```bash
        mkdir [new_folder_name]
        cd [new_folder_name]
        git clone https://github.com/AnnonymousCoder/FPGA-Pong.git
    ```

2. Install Vivado Design Suite from the link above. [Click for Installation instructions](https://digilent.com/reference/programmable-logic/guides/installing-vivado-and-vitis 'installation instructions link')

2. Once installation is done, open Vivado and on the Quick Start Section click Open Project. Locate the folder you just created and select it for opening.

3. To upload the code to the FPGA Board you need to follow the compilation steps in order. First we run synthesize and implementation then we generate the bitstream.
    * We accomplish the above steps by first pressing the green play button and selecting run Synthesis and implementation in that order.
    * Lastly, once done we press the green downward facing arrow to generate bitstream.
    <br/>
![image of the described buttons](./Resources/vivado_app.png 'Vivado Project View')


## Logic and Design
- Below is the Logic on how the game functions in form of a bubble diagram.
    <br/>
![Logic Diagram](./Resources/logic%20bubble%20diagram.png 'Logic Diagram')
    <br/>
- Below is Block Diagram of the different Component blocks that went into the game.
    <br/>
![Block Diagram Design](./Resources/block%20diagram.png 'Block Diagram Design')