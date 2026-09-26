module ALU (
    input logic [31:0] A,
    input logic [31:0] B,
    input logic [2:0] ALUControl,
    output logic [31:0] Result,
    output logic Zero,
    output logic Negative,
    output logic Overflow,
    output logic Carry
);

    logic [32:0] sum;

    always_comb begin

        Result = 32'b0;
        Zero = 1'b0;
        Negative = 1'b0;
        Overflow = 1'b0;
        Carry = 1'b0;
        sum = 33'b0;

        case (ALUControl)

            // ADD
            3'b000: begin
                sum = {1'b0, A} + {1'b0, B};
                Result = sum[31:0];
                Carry = sum[32];

                if ((A[31] == B[31]) && (Result[31] != A[31]))
                    Overflow = 1'b1;
            end

            // SUBTRACT
            3'b001: begin
                Result = A - B;
                Carry = (A < B);

                if ((A[31] != B[31]) && (Result[31] != A[31]))
                    Overflow = 1'b1;
            end

            // AND
            3'b010: begin
                Result = A & B;
            end

            // OR
            3'b011: begin
                Result = A | B;
            end

            // SET LESS THAN
            3'b101: begin
                if ($signed(A) < $signed(B))
                    Result = 32'd1;
                else
                    Result = 32'd0;
            end

            default: begin
                Result = 32'b0;
            end

        endcase

        if (Result == 32'b0)
            Zero = 1'b1;

        Negative = Result[31];

    end

endmodule
