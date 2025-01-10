module TOP #(parameter DATA_WIDTH = 8, WIDTH = 4, HEIGHT = 4, BUFFER_SIZE = 4) (
	input clk                   ,
	input rst_n                 ,
	input data_valid            ,
	input start_compute         ,
	input [DATA_WIDTH-1:0] data_in_A,
	input [DATA_WIDTH-1:0] data_in_B,
	output wire done,
	output wire read_data,
  input [3:0] in_valid_A,
  input [3:0] in_valid_B);

	wire [3:0] mux_select;

// mux select matrix A
	wire [DATA_WIDTH - 1:0] data_to_mux_1;
	wire [DATA_WIDTH - 1:0] data_to_mux_2;
	wire [DATA_WIDTH - 1:0] data_to_mux_3;
	wire [DATA_WIDTH - 1:0] data_to_mux_4;

// mux select matrix B 
	wire [DATA_WIDTH - 1:0] data_to_mux_5;
	wire [DATA_WIDTH - 1:0] data_to_mux_6;
	wire [DATA_WIDTH - 1:0] data_to_mux_7;
	wire [DATA_WIDTH - 1:0] data_to_mux_8;

// from matrix A
	wire [DATA_WIDTH - 1:0] bf_to_pe_1;
	wire [DATA_WIDTH - 1:0] bf_to_pe_2;
	wire [DATA_WIDTH - 1:0] bf_to_pe_3;
	wire [DATA_WIDTH - 1:0] bf_to_pe_4;

// from matrix B 
	wire [DATA_WIDTH - 1:0] bf_to_pe_5;
	wire [DATA_WIDTH - 1:0] bf_to_pe_6;
	wire [DATA_WIDTH - 1:0] bf_to_pe_7;
	wire [DATA_WIDTH - 1:0] bf_to_pe_8;

	// right connect of each PE
	wire [DATA_WIDTH - 1:0] R_pe00;
	wire [DATA_WIDTH - 1:0] R_pe10;
	wire [DATA_WIDTH - 1:0] R_pe20;
	wire [DATA_WIDTH - 1:0] R_pe30;
	wire [DATA_WIDTH - 1:0] R_pe01;
	wire [DATA_WIDTH - 1:0] R_pe11;
	wire [DATA_WIDTH - 1:0] R_pe21;
	wire [DATA_WIDTH - 1:0] R_pe31;
	wire [DATA_WIDTH - 1:0] R_pe02;
	wire [DATA_WIDTH - 1:0] R_pe12;
	wire [DATA_WIDTH - 1:0] R_pe22;
	wire [DATA_WIDTH - 1:0] R_pe32;

	// right bottom of each PE
	wire [DATA_WIDTH - 1:0] B_pe00;
	wire [DATA_WIDTH - 1:0] B_pe10;
	wire [DATA_WIDTH - 1:0] B_pe20;
	wire [DATA_WIDTH - 1:0] B_pe01;
	wire [DATA_WIDTH - 1:0] B_pe11;
	wire [DATA_WIDTH - 1:0] B_pe21;
	wire [DATA_WIDTH - 1:0] B_pe02;
	wire [DATA_WIDTH - 1:0] B_pe12;
	wire [DATA_WIDTH - 1:0] B_pe22;
	wire [DATA_WIDTH - 1:0] B_pe03;
	wire [DATA_WIDTH - 1:0] B_pe13;
	wire [DATA_WIDTH - 1:0] B_pe23;

	wire in_valid_1;
	wire in_valid_2;
	wire in_valid_3;
	wire in_valid_4;
	wire in_valid_5;
	wire in_valid_6;
	wire in_valid_7;
	wire in_valid_8;

	
// buffer of matrix A
BUFFER #(.DATA_WIDTH(8), .BUFFER_SIZE (4)) buffer_row_A1 (
	.clk      ( clk           ) ,
	.rst_n    ( rst_n         ) ,
	.in_valid ( in_valid_1    ) ,
	.data_in  ( data_in_A     ) ,
	.data_out ( data_to_mux_1 )
);
BUFFER #(.DATA_WIDTH(8), .BUFFER_SIZE (4)) buffer_row_A2 (
	.clk      ( clk           ) ,
	.rst_n    ( rst_n         ) ,
	.in_valid ( in_valid_2    ) ,
	.data_in  ( data_in_A       ) ,
	.data_out ( data_to_mux_2 )
);
BUFFER #(.DATA_WIDTH(8), .BUFFER_SIZE (4)) buffer_row_A3 (
	.clk      ( clk           ) ,
	.rst_n    ( rst_n         ) ,
	.in_valid ( in_valid_3    ) ,
	.data_in  ( data_in_A     ) ,
	.data_out ( data_to_mux_3 )
);
BUFFER #(.DATA_WIDTH(8), .BUFFER_SIZE (4)) buffer_row_A4 (
	.clk      ( clk           ) ,
	.rst_n    ( rst_n         ) ,
	.in_valid ( in_valid_4    ) ,
	.data_in  ( data_in_A       ) ,
	.data_out ( data_to_mux_4 )
);
// buffer of matrix B
BUFFER #(.DATA_WIDTH(8), .BUFFER_SIZE (4)) buffer_row_B1 (
	.clk      ( clk           ) ,
	.rst_n    ( rst_n         ) ,
	.in_valid ( in_valid_5    ) ,
	.data_in  ( data_in_B     ) ,
	.data_out ( data_to_mux_5 )
);
BUFFER #(.DATA_WIDTH(8), .BUFFER_SIZE (4)) buffer_row_B2 (
	.clk      ( clk           ) ,
	.rst_n    ( rst_n         ) ,
	.in_valid ( in_valid_6    ) ,
	.data_in  ( data_in_B     ) ,
	.data_out ( data_to_mux_6 )
);
BUFFER #(.DATA_WIDTH(8), .BUFFER_SIZE (4)) buffer_row_B3 (
	.clk      ( clk           ) ,
	.rst_n    ( rst_n         ) ,
	.in_valid ( in_valid_7    ) ,
	.data_in  ( data_in_B     ) ,
	.data_out ( data_to_mux_7 )
);
BUFFER #(.DATA_WIDTH(8), .BUFFER_SIZE (4)) buffer_row_B4 (
	.clk      ( clk           ) ,
	.rst_n    ( rst_n         ) ,
	.in_valid ( in_valid_8    ) ,
	.data_in  ( data_in_B     ) ,
	.data_out ( data_to_mux_8 )
);


	// Array of PE, first row
PE #(.DATA_WIDTH(8)) pe00 (
	.clk        ( clk        ) ,
	.rst_n      ( rst_n      ) ,
	.top_in     ( bf_to_pe_5 ) ,
	.left_in    ( bf_to_pe_1 ) ,
	.right_out  ( R_pe00     ) ,
	.bottom_out ( B_pe00     ) 
);
PE #(.DATA_WIDTH(8)) pe01 (
	.clk        ( clk        ) ,
	.rst_n      ( rst_n      ) ,
	.top_in     ( bf_to_pe_6 ) ,
	.left_in    ( R_pe00     ) ,
	.right_out  ( R_pe01     ) ,
	.bottom_out ( B_pe01     ) 
);
PE #(.DATA_WIDTH(8)) pe02 (
	.clk        ( clk        ) ,
	.rst_n      ( rst_n      ) ,
	.top_in     ( bf_to_pe_7 ) ,
	.left_in    ( R_pe01     ) ,
	.right_out  ( R_pe02     ) ,
	.bottom_out ( B_pe02     ) 
);
PE #(.DATA_WIDTH(8)) pe03 (
	.clk        ( clk        ) ,
	.rst_n      ( rst_n      ) ,
	.top_in     ( bf_to_pe_8 ) ,
	.left_in    ( R_pe02     ) ,
	.right_out  (            ) ,
	.bottom_out ( B_pe03     ) 
);
	// Array of PE, second row
PE #(.DATA_WIDTH(8)) pe10 (
	.clk        ( clk        ) ,
	.rst_n      ( rst_n      ) ,
	.top_in     ( B_pe00     ) ,
	.left_in    ( bf_to_pe_2 ) ,
	.right_out  ( R_pe10     ) ,
	.bottom_out ( B_pe10     ) 
);
PE #(.DATA_WIDTH(8)) pe11 (
	.clk        ( clk        ) ,
	.rst_n      ( rst_n      ) ,
	.top_in     ( B_pe01     ) ,
	.left_in    ( R_pe10     ) ,
	.right_out  ( R_pe11     ) ,
	.bottom_out ( B_pe11     ) 
);
PE #(.DATA_WIDTH(8)) pe12 (
	.clk        ( clk        ) ,
	.rst_n      ( rst_n      ) ,
	.top_in     ( B_pe02     ) ,
	.left_in    ( R_pe11     ) ,
	.right_out  ( R_pe12     ) ,
	.bottom_out ( B_pe12     ) 
);
PE #(.DATA_WIDTH(8)) pe13 (
	.clk        ( clk        ) ,
	.rst_n      ( rst_n      ) ,
	.top_in     ( B_pe03     ) ,
	.left_in    ( R_pe12     ) ,
	.right_out  (            ) ,
	.bottom_out ( B_pe13     ) 
);
	// Array of PE, third row
PE #(.DATA_WIDTH(8)) pe20 (
	.clk        ( clk        ) ,
	.rst_n      ( rst_n      ) ,
	.top_in     ( B_pe10     ) ,
	.left_in    ( bf_to_pe_3 ) ,
	.right_out  ( R_pe20     ) ,
	.bottom_out ( B_pe20     ) 
);
PE #(.DATA_WIDTH(8)) pe21 (
	.clk        ( clk        ) ,
	.rst_n      ( rst_n      ) ,
	.top_in     ( B_pe11     ) ,
	.left_in    ( R_pe20     ) ,
	.right_out  ( R_pe21     ) ,
	.bottom_out ( B_pe21     ) 
);
PE #(.DATA_WIDTH(8)) pe22 (
	.clk        ( clk        ) ,
	.rst_n      ( rst_n      ) ,
	.top_in     ( B_pe12     ) ,
	.left_in    ( R_pe21     ) ,
	.right_out  ( R_pe22     ) ,
	.bottom_out ( B_pe22     ) 
);
PE #(.DATA_WIDTH(8)) pe23 (
	.clk        ( clk        ) ,
	.rst_n      ( rst_n      ) ,
	.top_in     ( B_pe13     ) ,
	.left_in    ( R_pe22     ) ,
	.right_out  (            ) ,
	.bottom_out ( B_pe23     ) 
);
	// Array of PE, four row
PE #(.DATA_WIDTH(8)) p30 (
	.clk        ( clk        ) ,
	.rst_n      ( rst_n      ) ,
	.top_in     ( B_pe20     ) ,
	.left_in    ( bf_to_pe_4 ) ,
	.right_out  ( R_pe30     ) ,
	.bottom_out (            ) 
);
PE #(.DATA_WIDTH(8)) pe31 (
	.clk        ( clk        ) ,
	.rst_n      ( rst_n      ) ,
	.top_in     ( B_pe21     ) ,
	.left_in    ( R_pe30     ) ,
	.right_out  ( R_pe31     ) ,
	.bottom_out (            ) 
);
PE #(.DATA_WIDTH(8)) pe32 (
	.clk        ( clk        ) ,
	.rst_n      ( rst_n      ) ,
	.top_in     ( B_pe22     ) ,
	.left_in    ( R_pe31     ) ,
	.right_out  ( R_pe32     ) ,
	.bottom_out (            ) 
);
PE #(.DATA_WIDTH(8)) pe33 (
	.clk        ( clk        ) ,
	.rst_n      ( rst_n      ) ,
	.top_in     ( B_pe23     ) ,
	.left_in    ( R_pe31     ) ,
	.right_out  (            ) ,
	.bottom_out (            ) 
);

controller #(.ROW_NUM(4), .WIDTH(4), .HEIGHT(4)) control (
	.clk        (clk       ),
	.rst_n      (rst_n     ),
	.data_valid (data_valid),
	.mux_select (mux_select),
	.in_valid_A (in_valid_A), 
	.in_valid_B (in_valid_B), 
	.read_data  (read_data ),
	.done       (done      )
);
endmodule

	
	
	



















































