# Introduction
---
This design implements a matrix multiplier matrix multiplication accelerator using systolic arrays. Systolic arrays take advantage of parallel processing which greatly reduces the number of operations required to perform matrix multiplication. The design is fully parameterised and the user is able to adjust the matrix size and the data width. 
## What are systolic arrays?
A systolic array is an array of processing elements. Each element is connected in a grid and performs some computation based on the data received from its neighbours. It stores the result within itself. In this case, the processing elements consist of multiply accumulate (MAC) modules.

![systolic_array](https://github.com/fionn-smyth-25/matrix-mult-accelerator/tree/main/images/systolic_array.png)
*An example of a 4 x 4 systolic array - note how inputs are received from the north and west and outputs are sent to the south and east*


# Design Description
---
## Modules
The module hierarchy is as follows:
```
accelerator.sv
├── controller.v
└── systolic_array.sv
    └── processing_element.v
```
- **Accelerator** - the top level module that connects the control logic and the systolic array. It also features logic to prepare the input matrix for the systolic array.
- **Systolic Array** - an N x N grid of processing elements.
- **Controller** - a finite state machine (FSM) featuring three states: IDLE, COMPUTE and DONE. 
- **Processing Elements** - the building blocks of the systolic array, each performing MAC operations. 

| Name     | Input/Output | Width     | Function                         |
| -------- | ------------ | --------- | -------------------------------- |
| clk      | Input        | 1         | Clock                            |
| rst      | Input        | 1         | Reset                            |
| ready    | Input        | 1         | Begins computation               |
| a        | Input        | Parameter | Flat version of input matrix a   |
| b        | Input        | Parameter | Flat version of input matrix b   |
| result   | Output       | Parameter | Flat version of resulting matrix |
| finished | Output       | 1         | Signals end of computation       |
