module tb_alu;
  localparam int WIDTH = 4;
  localparam int MSB   = WIDTH-1;

  // Opcodes match DUT
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

  // DUT signals
  logic [WIDTH-1:0] A, B;
  logic [3:0]       opcode;
  logic [WIDTH-1:0] Result;
  logic             CarryOut, Zero, Overflow, Negative;

  // Instantiate DUT
  alu #(.WIDTH(WIDTH)) dut (
    .A(A), .B(B), .opcode(opcode),
    .Result(Result), .CarryOut(CarryOut),
    .Zero(Zero), .Overflow(Overflow), .Negative(Negative)
  );

  // Reference model as a TASK (portable with Icarus)
  task automatic ref_alu(
    input  logic [WIDTH-1:0] a, b,
    input  logic [3:0]       op,
    output logic [WIDTH-1:0] exp_res,
    output logic             exp_c, exp_z, exp_v, exp_n
  );
    logic [WIDTH:0] tmp; // {carry, result}
    int   shamt;
    shamt = b & (WIDTH-1);

    unique case (op)
      OP_ADD: begin tmp = a + b; exp_v = (~(a[MSB]^b[MSB])) & (a[MSB]^tmp[MSB]); end
      OP_SUB: begin tmp = a - b; exp_v = (a[MSB]^b[MSB]) & (a[MSB]^tmp[MSB]);  end
      OP_AND:  begin tmp = {1'b0, (a & b)};  exp_v = 1'b0; end
      OP_OR:   begin tmp = {1'b0, (a | b)};  exp_v = 1'b0; end
      OP_XOR:  begin tmp = {1'b0, (a ^ b)};  exp_v = 1'b0; end
      OP_NOT:  begin tmp = {1'b0, (~a)};     exp_v = 1'b0; end
      OP_NAND: begin tmp = {1'b0, ~(a & b)}; exp_v = 1'b0; end
      OP_SLL:  begin tmp = {1'b0, (shamt==0 ? a : (a << shamt))};                    exp_v = 1'b0; end
      OP_SRL:  begin tmp = {1'b0, (shamt==0 ? a : (a >> shamt))};                    exp_v = 1'b0; end
      OP_SRA:  begin tmp = {1'b0, (shamt==0 ? a : ($signed(a) >>> shamt))};          exp_v = 1'b0; end
      OP_ROL:  begin tmp = {1'b0, (shamt==0 ? a : ((a << shamt) | (a >> (WIDTH-shamt))))}; exp_v = 1'b0; end
      OP_ROR:  begin tmp = {1'b0, (shamt==0 ? a : ((a >> shamt) | (a << (WIDTH-shamt))))}; exp_v = 1'b0; end
      default: begin tmp = '0; exp_v = 1'b0; end
    endcase

    exp_res = tmp[MSB:0];
    exp_c   = tmp[WIDTH];
    exp_z   = (tmp[MSB:0] == '0);
    exp_n   = tmp[MSB];
  endtask

  task automatic check_case(
    input logic [WIDTH-1:0] a, b,
    input logic [3:0]       op
  );
    logic [WIDTH-1:0] exp_res;
    logic exp_c, exp_z, exp_v, exp_n;

    A = a; B = b; opcode = op; #1;
    ref_alu(a, b, op, exp_res, exp_c, exp_z, exp_v, exp_n);

    if (Result !== exp_res || CarryOut !== exp_c || Zero !== exp_z || Overflow !== exp_v || Negative !== exp_n) begin
      $display("FAIL op=0x%0h A=%0d B=%0d -> got (R=%0d C=%0b Z=%0b V=%0b N=%0b) exp (R=%0d C=%0b Z=%0b V=%0b N=%0b)",
               op, a, b, Result, CarryOut, Zero, Overflow, Negative,
               exp_res, exp_c, exp_z, exp_v, exp_n);
      $fatal(1);
    end else begin
      $display("PASS op=0x%0h A=%0d B=%0d -> R=%0d C=%0b Z=%0b V=%0b N=%0b",
               op, a, b, Result, CarryOut, Zero, Overflow, Negative);
    end
  endtask

  initial begin
    // Directed tests for new ops
    check_case(4'b1001, 4'd1, OP_SLL); // 1001 << 1 = 0010
    check_case(4'b1001, 4'd1, OP_SRL); // 1001 >> 1 = 0100
    check_case(4'b1001, 4'd1, OP_SRA); // 1001 >>> 1 = 1100
    check_case(4'b1001, 4'd1, OP_ROL); // 1001 rol1 = 0011
    check_case(4'b1001, 4'd1, OP_ROR); // 1001 ror1 = 1100

    // Also re-check earlier ops quickly
    check_case(4'd9,  4'd5,  OP_XOR);
    check_case(4'd9,  '0,    OP_NOT);
    check_case(4'd9,  4'd6,  OP_NAND);
    check_case(4'd7,  4'd2,  OP_ADD);
    check_case(4'd2,  4'd9,  OP_SUB);

    // Randoms across all ops (0..11)
    for (int i = 0; i < 80; i++) begin
      logic [WIDTH-1:0] ra, rb;
      logic [3:0]       rop;
      ra  = $urandom_range(0,(1<<WIDTH)-1);
      rb  = $urandom_range(0,(1<<WIDTH)-1);
      rop = $urandom_range(0, 11);
      check_case(ra, rb, rop);
    end

    $display("All tests passed");
    $finish;
  end
endmodule
