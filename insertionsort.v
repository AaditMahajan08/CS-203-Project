module InsertionSort #(parameter N = 16, parameter SIZE = 5) (
    input [N*SIZE-1:0] array_in,
    output reg [N*SIZE-1:0] array_out
);
    integer i, j;
    reg [N-1:0] array [0:SIZE-1];  // Array to hold individual elements
    reg [N-1:0] key;               // Key element for insertion
    wire greater, equal, less;     // Comparator outputs
    reg [N-1:0] a_reg, b_reg;      // Registers to hold elements being compared
    reg done;                      // Flag to exit while loop

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

        // Insertion Sort algorithm
        for (i = 1; i < SIZE; i = i + 1) begin
            key = array[i];          // Take the key element
            j = i - 1;
            done = 0;

            // Shift elements of array[0..i-1], that are greater than key,
            // to one position ahead of their current position
            while (j >= 0 && !done) begin
                a_reg = array[j];    // Load the current element
                b_reg = key;         // Compare with the key element
                #1;                  // Allow comparator to evaluate

                if (greater) begin
                    array[j + 1] = array[j]; // Shift element to the right
                    j = j - 1;
                end else begin
                    done = 1;        // Exit the loop
                end
                #1; // Ensure comparator evaluation is completed
            end
            array[j + 1] = key;      // Place the key element in the correct position
        end

        // Flatten the sorted array back to the output format
        for (i = 0; i < SIZE; i = i + 1) begin
            array_out[N*i +: N] = array[i];
        end
    end
endmodule

