module comparatorbit1 (
    input a_bit, b_bit, g_in, e_in, l_in,  // Inputs
    output g_out, e_out, l_out            // Outputs
);
    wire not_a, not_b, and1, and2, and3, or1, and4, and5, and6, and7, or2;

    // Invert inputs
    not (not_a, a_bit);
    not (not_b, b_bit);

    // Greater-than logic
    and (and1, a_bit, not_b);              // a_i b'_i
    and (and2, a_bit, b_bit);              // a_i b_i
    and (and3, not_a, not_b);              // a'_i b'_i
    or  (or1, and2, and3);                 // (a_i b_i + a'_i b'_i)
    and (and4, g_in, or1);                 // g_i (a_i b_i + a'_i b'_i)
    or  (g_out, and1, and4);               // g_{i+1} = a_i b'_i + g_i (a_i b_i + a'_i b'_i)

    // Equal-to logic
    and (and5, e_in, or1);                 // e_i (a_i b_i + a'_i b'_i)
    assign e_out = and5;                   // e_{i+1}

    // Less-than logic
    and (and6, not_a, b_bit);              // a'_i b_i
    and (and7, l_in, or1);                 // l_i (a_i b_i + a'_i b'_i)
    or  (l_out, and6, and7);               // l_{i+1} = a'_i b_i + l_i (a_i b_i + a'_i b'_i)
endmodule

module comparatorbitN #(parameter N = 4) (
    input [N-1:0] A, B,       // n-bit inputs
    output G, E, L            // Outputs: G (A > B), E (A == B), L (A < B)
);

    wire [N:0] g_bus, e_bus, l_bus; // Propagation buses

    // Initial conditions
    assign g_bus[0] = 0;   // g_0 = 0
    assign e_bus[0] = 1;   // e_0 = 1
    assign l_bus[0] = 0;   // l_0 = 0

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : COMPARE_STAGE
            comparatorbit1 stage (  // Change here from comparator_1bit to comparatorbit1
                .a_bit(A[i]),
                .b_bit(B[i]),
                .g_in(g_bus[i]),
                .e_in(e_bus[i]),
                .l_in(l_bus[i]),
                .g_out(g_bus[i+1]),
                .e_out(e_bus[i+1]),
                .l_out(l_bus[i+1])
            );
        end
    endgenerate

    // Final outputs
    assign G = g_bus[N];
    assign E = e_bus[N];
    assign L = l_bus[N];

endmodule