module BubbleSort_BottomUp #(parameter N = 16, parameter SIZE = 5) (
    input [N*SIZE-1:0] array_in,
    output reg [N*SIZE-1:0] array_out
);
    integer i, j;
    reg [N-1:0] array [0:SIZE-1];  // Array to hold individual elements
    reg [N-1:0] temp;               // Temporary variable for swapping
    wire greater, equal, less;      // Comparator outputs
    reg [N-1:0] a_reg, b_reg;      // Registers to hold elements being compared

    comparatorbitN #(N) comparator (
        .A(a_reg),           // A port connected to a_reg
        .B(b_reg),           // B port connected to b_reg
        .G(greater),         // Greater-than output
        .E(equal),           // Equal output
        .L(less)             // Less-than output
    );

    always @(array_in) begin
        // Convert the input array to a 2D register array for easier processing
        for (i = 0; i < SIZE; i = i + 1) begin
            array[i] = array_in[N*i +: N];
        end

        // Bubble Sort algorithm: Bottom-Up approach
        for (i = 0; i < SIZE-1; i = i + 1) begin
            for (j = SIZE-1; j > i; j = j - 1) begin
                a_reg = array[j];    // Load current element to compare
                b_reg = array[j-1];  // Load the previous element
                #1;                   // Allow comparator to evaluate

                // If 'less' signal is high, swap elements
                if (less) begin
                    // Swap the elements
                    temp = array[j];
                    array[j] = array[j-1];
                    array[j-1] = temp;
                end
                #1; // Ensure that the swap logic is applied after comparator evaluation
            end
        end

        // Flatten the sorted array back to the output format
        for (i = 0; i < SIZE; i = i + 1) begin
            array_out[N*i +: N] = array[i];
        end
    end
endmodule

