<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ALU Project Documentation</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f3f4f6;
            color: #1f2937;
        }
    </style>
</head>
<body class="p-8">
    <div class="max-w-4xl mx-auto bg-white shadow-xl rounded-2xl p-8 lg:p-12 border border-gray-200">
        <h1 class="text-4xl font-extrabold text-gray-900 mb-6">Simple Parameterized ALU</h1>

        <p class="text-gray-700 mb-8 leading-relaxed">
            This project contains a simple, parameterized Arithmetic Logic Unit (ALU) designed and verified in SystemVerilog. The ALU supports a variety of common arithmetic, logical, and shift/rotate operations. The design is accompanied by a self-checking testbench.
        </p>

        <h2 class="text-3xl font-bold text-gray-800 mb-4 border-b-2 border-gray-200 pb-2">Project Files</h2>
        <ul class="list-disc list-inside space-y-2 text-gray-700 mb-8">
            <li>`design.sv`: The SystemVerilog module for the parameterized ALU.</li>
            <li>`testbench.sv`: A self-checking testbench to verify the functionality of the `design.sv` module. It includes a reference model to compare the DUT's output against expected results.</li>
        </ul>

        <h2 class="text-3xl font-bold text-gray-800 mb-4 border-b-2 border-gray-200 pb-2">ALU Functionality</h2>
        <p class="text-gray-700 mb-6 leading-relaxed">
            The `alu` module is parameterized by `WIDTH`, allowing for easy modification of the data path width. It takes two inputs (`A`, `B`), an `opcode` to select the operation, and outputs a `Result` along with various status flags: `CarryOut`, `Zero`, `Overflow`, and `Negative`.
        </p>

        <h3 class="text-2xl font-bold text-gray-800 mb-4">Supported Operations</h3>
        <p class="text-gray-700 mb-6 leading-relaxed">
            The following opcodes are defined in both the design and the testbench:
        </p>
        <div class="overflow-x-auto rounded-lg shadow-inner border border-gray-200 mb-8">
            <table class="w-full text-left table-auto">
                <thead class="bg-gray-100">
                    <tr>
                        <th class="px-4 py-3 text-gray-600 font-semibold uppercase tracking-wider text-sm">Opcode</th>
                        <th class="px-4 py-3 text-gray-600 font-semibold uppercase tracking-wider text-sm">Operation</th>
                        <th class="px-4 py-3 text-gray-600 font-semibold uppercase tracking-wider text-sm">Description</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-200">
                    <tr class="hover:bg-gray-50 transition-colors duration-200">
                        <td class="px-4 py-4 whitespace-nowrap text-gray-900 font-medium">`0x0`</td>
                        <td class="px-4 py-4 whitespace-nowrap text-gray-700">`OP_ADD`</td>
                        <td class="px-4 py-4 text-gray-700">Addition (`A + B`)</td>
                    </tr>
                    <tr class="hover:bg-gray-50 transition-colors duration-200">
                        <td class="px-4 py-4 whitespace-nowrap text-gray-900 font-medium">`0x1`</td>
                        <td class="px-4 py-4 whitespace-nowrap text-gray-700">`OP_SUB`</td>
                        <td class="px-4 py-4 text-gray-700">Subtraction (`A - B`)</td>
                    </tr>
                    <tr class="hover:bg-gray-50 transition-colors duration-200">
                        <td class="px-4 py-4 whitespace-nowrap text-gray-900 font-medium">`0x2`</td>
                        <td class="px-4 py-4 whitespace-nowrap text-gray-700">`OP_AND`</td>
                        <td class="px-4 py-4 text-gray-700">Bitwise AND (`A & B`)</td>
                    </tr>
                    <tr class="hover:bg-gray-50 transition-colors duration-200">
                        <td class="px-4 py-4 whitespace-nowrap text-gray-900 font-medium">`0x3`</td>
                        <td class="px-4 py-4 whitespace-nowrap text-gray-700">`OP_OR`</td>
                        <td class="px-4 py-4 text-gray-700">Bitwise OR (`A | B`)</td>
                    </tr>
                    <tr class="hover:bg-gray-50 transition-colors duration-200">
                        <td class="px-4 py-4 whitespace-nowrap text-gray-900 font-medium">`0x4`</td>
                        <td class="px-4 py-4 whitespace-nowrap text-gray-700">`OP_XOR`</td>
                        <td class="px-4 py-4 text-gray-700">Bitwise XOR (`A ^ B`)</td>
                    </tr>
                    <tr class="hover:bg-gray-50 transition-colors duration-200">
                        <td class="px-4 py-4 whitespace-nowrap text-gray-900 font-medium">`0x5`</td>
                        <td class="px-4 py-4 whitespace-nowrap text-gray-700">`OP_NOT`</td>
                        <td class="px-4 py-4 text-gray-700">Bitwise NOT (`~A`)</td>
                    </tr>
                    <tr class="hover:bg-gray-50 transition-colors duration-200">
                        <td class="px-4 py-4 whitespace-nowrap text-gray-900 font-medium">`0x6`</td>
                        <td class="px-4 py-4 whitespace-nowrap text-gray-700">`OP_NAND`</td>
                        <td class="px-4 py-4 text-gray-700">Bitwise NAND (`~(A & B)`)</td>
                    </tr>
                    <tr class="hover:bg-gray-50 transition-colors duration-200">
                        <td class="px-4 py-4 whitespace-nowrap text-gray-900 font-medium">`0x7`</td>
                        <td class="px-4 py-4 whitespace-nowrap text-gray-700">`OP_SLL`</td>
                        <td class="px-4 py-4 text-gray-700">Logical Left Shift (`A << B`)</td>
                    </tr>
                    <tr class="hover:bg-gray-50 transition-colors duration-200">
                        <td class="px-4 py-4 whitespace-nowrap text-gray-900 font-medium">`0x8`</td>
                        <td class="px-4 py-4 whitespace-nowrap text-gray-700">`OP_SRL`</td>
                        <td class="px-4 py-4 text-gray-700">Logical Right Shift (`A >> B`)</td>
                    </tr>
                    <tr class="hover:bg-gray-50 transition-colors duration-200">
                        <td class="px-4 py-4 whitespace-nowrap text-gray-900 font-medium">`0x9`</td>
                        <td class="px-4 py-4 whitespace-nowrap text-gray-700">`OP_SRA`</td>
                        <td class="px-4 py-4 text-gray-700">Arithmetic Right Shift (`$signed(A) >>> B`)</td>
                    </tr>
                    <tr class="hover:bg-gray-50 transition-colors duration-200">
                        <td class="px-4 py-4 whitespace-nowrap text-gray-900 font-medium">`0xA`</td>
                        <td class="px-4 py-4 whitespace-nowrap text-gray-700">`OP_ROL`</td>
                        <td class="px-4 py-4 text-gray-700">Rotate Left</td>
                    </tr>
                    <tr class="hover:bg-gray-50 transition-colors duration-200">
                        <td class="px-4 py-4 whitespace-nowrap text-gray-900 font-medium">`0xB`</td>
                        <td class="px-4 py-4 whitespace-nowrap text-gray-700">`OP_ROR`</td>
                        <td class="px-4 py-4 text-gray-700">Rotate Right</td>
                    </tr>
                </tbody>
            </table>
        </div>
        <p class="text-gray-700 mb-8 leading-relaxed">
            The shift amount (`shamt`) for shift and rotate operations is masked to `B & (WIDTH-1)`.
        </p>
        
        <h2 class="text-3xl font-bold text-gray-800 mb-4 border-b-2 border-gray-200 pb-2">Testbench Overview</h2>
        <p class="text-gray-700 mb-6 leading-relaxed">
            The `tb_alu` testbench instantiates the `alu` as the Device Under Test (DUT). It contains a reference model implemented as a SystemVerilog `task` to compute the expected results for each operation.
        </p>
        <p class="text-gray-700 mb-8 leading-relaxed">
            The testbench performs two types of checks:
        </p>
        <ol class="list-decimal list-inside space-y-2 text-gray-700 mb-8">
            <li><strong>Directed Tests:</strong> A small set of specific test cases are run to verify the newly added shift and rotate operations, as well as a few core operations.</li>
            <li><strong>Randomized Tests:</strong> A loop runs 80 times, applying random values for inputs `A`, `B`, and `opcode` to perform a more thorough verification of the ALU's functionality.</li>
        </ol>
        <p class="text-gray-700 mb-8 leading-relaxed">
            Any mismatch between the DUT's output and the reference model's expected output will result in a fatal error, stopping the simulation.
        </p>

        <h2 class="text-3xl font-bold text-gray-800 mb-4 border-b-2 border-gray-200 pb-2">How to Simulate</h2>
        <p class="text-gray-700 mb-6 leading-relaxed">
            To run the simulation, you will need a SystemVerilog simulator such as Icarus Verilog or VCS.
        </p>
        <h3 class="text-2xl font-bold text-gray-800 mb-4">Using Icarus Verilog</h3>
        <ol class="list-decimal list-inside space-y-2 text-gray-700 mb-8">
            <li>Navigate to the directory containing `design.sv` and `testbench.sv`.</li>
            <li>Compile the files:
                <pre class="bg-gray-100 p-4 rounded-lg text-sm overflow-x-auto my-2"><code>iverilog design.sv testbench.sv</code></pre>
            </li>
            <li>Run the simulation:
                <pre class="bg-gray-100 p-4 rounded-lg text-sm overflow-x-auto my-2"><code>vvp a.out</code></pre>
            </li>
        </ol>
        <p class="text-gray-700 mb-8 leading-relaxed">
            The simulation output will show a `PASS` message for each successful test case and a final `All tests passed` message if all checks are successful.
        </p>

        <h2 class="text-3xl font-bold text-gray-800 mb-4 border-b-2 border-gray-200 pb-2">License</h2>
        <p class="text-gray-700 leading-relaxed">
            This project is licensed under the MIT License.
        </p>
    </div>
</body>
</html>
