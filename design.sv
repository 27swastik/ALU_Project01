module alu #(
    parameter int WIDTH = 4
)(
    input  logic [WIDTH-1:0] A, B,
    input  logic [3:0]       opcode,
    output logic [WIDTH-1:0] Result,
    output logic             CarryOut,
    output logic             Zero,
    output logic             Overflow,
    output logic             Negative
);
  // Opcodes
  localparam logic [3:0]
    OP_ADD  = 4'h0,
    OP_SUB  = 4'h1,
    OP_AND  = 4'h2,
    OP_OR   = 4'h3,
    OP_XOR  = 4'h4,
    OP_NOT  = 4'h5,
    OP_NAND = 4'h6,
    OP_SLL  = 4'h7,
    OP_SRL  = 4'h8,
    OP_SRA  = 4'h9,
    OP_ROL  = 4'hA,
    OP_ROR  = 4'hB;

  localparam int MSB = WIDTH-1;

  // Declare shift amount here 
  integer shamt;

  always @(*) begin
    // Safe defaults
    Result   = '0;
    CarryOut = 1'b0;
    Zero     = 1'b0;
    Overflow = 1'b0;
    Negative = 1'b0;

    // Mask shift amount to 0..WIDTH-1
    shamt = B & (WIDTH-1);

    case (opcode)
      OP_ADD: begin
        {CarryOut, Result} = A + B;
        Overflow = (~(A[MSB]^B[MSB])) & (A[MSB]^Result[MSB]);
      end
      OP_SUB: begin
        {CarryOut, Result} = A - B;
        Overflow = (A[MSB]^B[MSB]) & (A[MSB]^Result[MSB]);
      end
      OP_AND:  Result = A & B;
      OP_OR:   Result = A | B;
      OP_XOR:  Result = A ^ B;
      OP_NOT:  Result = ~A;
      OP_NAND: Result = ~(A & B);

      // Shifts / Rotates (guard shamt==0 to avoid shifting by WIDTH)
      OP_SLL: Result = (shamt==0) ? A : (A << shamt);                          // logical left
      OP_SRL: Result = (shamt==0) ? A : (A >> shamt);                          // logical right
      OP_SRA: Result = (shamt==0) ? A : ($signed(A) >>> shamt);                // arithmetic right
      OP_ROL: Result = (shamt==0) ? A : ((A << shamt) | (A >> (WIDTH - shamt)));
      OP_ROR: Result = (shamt==0) ? A : ((A >> shamt) | (A << (WIDTH - shamt)));

      default: Result = '0;
    endcase

    Zero     = (Result == '0);
    Negative = Result[MSB];
  end
endmodule
