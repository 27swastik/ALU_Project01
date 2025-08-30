# Simple Parameterized ALU

This project contains a simple, parameterized Arithmetic Logic Unit (ALU) designed and verified in SystemVerilog. The ALU supports a variety of common arithmetic, logical, and shift/rotate operations. The design is accompanied by a self-checking testbench.

## Project Files

* `design.sv`: The SystemVerilog module for the parameterized ALU.

* `testbench.sv`: A self-checking testbench to verify the functionality of the `design.sv` module. It includes a reference model to compare the DUT's output against expected results.

## ALU Functionality

The `alu` module is parameterized by `WIDTH`, allowing for easy modification of the data path width. It takes two inputs (`A`, `B`), an `opcode` to select the operation, and outputs a `Result` along with various status flags: `CarryOut`, `Zero`, `Overflow`, and `Negative`.

### Supported Operations

The following opcodes are defined in both the design and the testbench:

| **Opcode** | **Operation** | **Description** |
| :--- | :--- | :--- |
| `0x0` | `OP_ADD` | Addition (`A + B`) |
| `0x1` | `OP_SUB` | Subtraction (`A - B`) |
| `0x2` | `OP_AND` | Bitwise AND (`A & B`) |
| `0x3` | `OP_OR` | Bitwise OR (`A \| B`) |
| `0x4` | `OP_XOR` | Bitwise XOR (`A ^ B`) |
| `0x5` | `OP_NOT` | Bitwise NOT (`~A`) |
| `0x6` | `OP_NAND` | Bitwise NAND (`~(A & B)`) |
| `0x7` | `OP_SLL` | Logical Left Shift (`A << B`) |
| `0x8` | `OP_SRL` | Logical Right Shift (`A >> B`) |
| `0x9` | `OP_SRA` | Arithmetic Right Shift (`$signed(A) >>> B`) |
| `0xA` | `OP_ROL` | Rotate Left |
| `0xB` | `OP_ROR` | Rotate Right |

The shift amount (`shamt`) for shift and rotate operations is masked to `B & (WIDTH-1)`.

## Testbench Overview

The `tb_alu` testbench instantiates the `alu` as the Device Under Test (DUT). It contains a reference model implemented as a SystemVerilog `task` to compute the expected results for each operation.

The testbench performs two types of checks:

1.  **Directed Tests:** A small set of specific test cases are run to verify the newly added shift and rotate operations, as well as a few core operations.
2.  **Randomized Tests:** A loop runs 80 times, applying random values for inputs `A`, `B`, and `opcode` to perform a more thorough verification of the ALU's functionality.

Any mismatch between the DUT's output and the reference model's expected output will result in a fatal error, stopping the simulation.

## How to Simulate

To run the simulation, you will need a SystemVerilog simulator such as Icarus Verilog or VCS.

### Using Icarus Verilog

1.  Navigate to the directory containing `design.sv` and `testbench.sv`.
2.  Compile the files:

    ```sh
    iverilog design.sv testbench.sv
    ```

3.  Run the simulation:

    ```sh
    vvp a.out
    ```

The simulation output will show a `PASS` message for each successful test case and a final `All tests passed` message if all checks are successful.

