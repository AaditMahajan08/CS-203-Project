module Testbench;
    parameter N = 16; // Bit-width of each number
    parameter SIZE = 5; // Number of elements in the array

    reg [N*SIZE-1:0] input_array;          // Flattened input array
    wire [N*SIZE-1:0] sorted_array;        // Sorted output array

    // Instantiate Bubble Sort module
    BubbleSort_BottomUp #(N, SIZE) bubble_sort_inst (
        .array_in(input_array),
        .array_out(sorted_array)
    );

    // Task to display an array
    task display_array;
        input [N*SIZE-1:0] array; // Flattened array to display
        input [64*8-1:0] msg;     // Message to display
        integer i;                // Loop variable
        begin
            $display("%s", msg);  // Print the message
            for (i = 0; i < SIZE; i = i + 1) begin
                // Print each 16-bit element with fixed-width formatting
                $write("%5d", array[N*i +: N]); 
                if (i < SIZE - 1) begin
                    $write("  "); // Add spacing between numbers
                end
            end
            $display("");  // Newline
        end
    endtask

    initial begin
        // Test Case 1 - Random order
        input_array = {16'd4321, 16'd1234, 16'd8765, 16'd2345, 16'd1010};
        #50;
        display_array(input_array, "Input Array (Random):");
        display_array(sorted_array, "Sorted Array:");

        // Test Case 2 - Reverse order
        input_array = {16'd9987, 16'd5678, 16'd2345, 16'd1234, 16'd1010};
        #50;
        display_array(input_array, "Input Array (Reverse):");
        display_array(sorted_array, "Sorted Array:");

        // Test Case 3 - Already sorted
        input_array = {16'd1010, 16'd1234, 16'd2345, 16'd4321, 16'd8765};
        #50;
        display_array(input_array, "Input Array (Sorted):");
        display_array(sorted_array, "Sorted Array:");

        // Test Case 4 - All zeros
        input_array = {16'd0, 16'd0, 16'd0, 16'd0, 16'd0};
        #50;
        display_array(input_array, "Input Array (All Zeros):");
        display_array(sorted_array, "Sorted Array:");

        // Test Case 5 - All identical numbers
        input_array = {16'd5555, 16'd5555, 16'd5555, 16'd5555, 16'd5555};
        #50;
        display_array(input_array, "Input Array (Identical):");
        display_array(sorted_array, "Sorted Array:");

        // Test Case 6 - Alternating high and low
        input_array = {16'd9999, 16'd1000, 16'd8888, 16'd2000, 16'd7777};
        #50;
        display_array(input_array, "Input Array (Alternating High-Low):");
        display_array(sorted_array, "Sorted Array:");

        // Test Case 7 - Minimum and maximum values
        input_array = {16'd0, 16'd65535, 16'd32768, 16'd1, 16'd65534};
        #50;
        display_array(input_array, "Input Array (Min & Max):");
        display_array(sorted_array, "Sorted Array:");

        // Test Case 8 - Small range of values
        input_array = {16'd10, 16'd12, 16'd11, 16'd13, 16'd14};
        #50;
        display_array(input_array, "Input Array (Small Range):");
        display_array(sorted_array, "Sorted Array:");

        // Test Case 9 - Repeating patterns
        input_array = {16'd2000, 16'd1000, 16'd2000, 16'd1000, 16'd2000};
        #50;
        display_array(input_array, "Input Array (Repeating Pattern):");
        display_array(sorted_array, "Sorted Array:");

        // Test Case 10 - Sparse range of values
        input_array = {16'd5, 16'd10000, 16'd3, 16'd5000, 16'd1};
        #50;
        display_array(input_array, "Input Array (Sparse Range):");
        display_array(sorted_array, "Sorted Array:");
    end
endmodule