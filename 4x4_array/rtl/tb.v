module tb;
	reg clk               ;
	reg rst_n                 ;
	reg data_valid            ;
	reg start_compute         ;
	wire [7:0] data_in_A;
	wire [7:0] data_in_B;
	wire done;
	wire read_data;
  reg [3:0] in_valid_A;
  reg [3:0] in_valid_B;

TOP #(.DATA_WIDTH (8), .WIDTH(4), .HEIGHT(4), .BUFFER_SIZE(4)) top (
	.clk           (clk          ),
	.rst_n         (rst_n        ),
	.data_valid    (data_valid   ),
	.start_compute (start_compute),
  .data_in_A     (data_in_A    ),
  .data_in_B     (data_in_B    ),
	.done          (done         ),
	.read_data     (read_data    )        
);

initial begin
	$dumpfile("syntolic.VCD");
	$dumpvars(0, tb);
end
always #5 clk = ~clk;
initial begin
	clk = 0;
  rst_n = 0;
	#10 rst_n = 1;
	#40 data_valid = 1;
	#10 data_valid = 0;
end
reg [7:0] matrix_A [15:0];
reg [7:0] matrix_B [15:0];
reg [7:0] matrix_C [15:0];
initial begin
	$readmemb("matrix_bin_A.txt",matrix_A);
end
initial begin
	$readmemb("matrix_bin_B.txt",matrix_B);
end
initial begin
	#1000 $finish;
end
integer i;
//initial begin
//#100
// for (i = 0; i < 16; i = i + 1) begin
//        $display("matrix_A[%0d] = %d", i, matrix_A[i]);
//    end
// for (i = 0; i < 16; i = i + 1) begin
//        $display("matrix_B[%0d] = %d", i, matrix_B[i]);
//    end
//end
// for (i = 0; i < 16; i = i + 1) begin
//        $display("matrix_A[%0d] = %d", i, matrix_A[i]);
//    end
reg [4:0] add_A_cnt;
reg read_reg;
always @(posedge clk or negedge rst_n)
  begin
    if (!rst_n)
    begin
      add_A_cnt  <= 0;
      read_reg  <= 0;
    end
    else
    begin
     read_reg <= read_data;
      if ((start_compute) || add_A_cnt == 16)
        add_A_cnt   <= 0;
      else if (read_data)
        add_A_cnt   <= add_A_cnt + 1;
      else
        add_A_cnt   <= add_A_cnt;
    end
  end
assign data_in_A = (read_reg == 1)? matrix_A[add_A_cnt - 1] : 0; 
assign data_in_B = (read_reg == 1)? matrix_B[add_A_cnt - 1] : 0; 

integer j;
integer file; // Khai báo biến `file` ở đầu khối initial
initial begin
    wait(done); // Chờ tín hiệu `done`

    // Lưu giá trị từ các PE vào ma trận `matrix_C`
    matrix_C[0] = top.pe00.result;
    matrix_C[1] = top.pe01.result;
    matrix_C[2] = top.pe02.result;
    matrix_C[3] = top.pe03.result;
    matrix_C[4] = top.pe10.result;
    matrix_C[5] = top.pe11.result;
    matrix_C[6] = top.pe12.result;
    matrix_C[7] = top.pe13.result;
    matrix_C[8] = top.pe20.result;
    matrix_C[9] = top.pe21.result;
    matrix_C[10] = top.pe22.result;
    matrix_C[11] = top.pe23.result;
    matrix_C[12] = top.pe30.result;
    matrix_C[13] = top.pe31.result;
    matrix_C[14] = top.pe32.result;
    matrix_C[15] = top.pe33.result;

    // Ghi giá trị ra tệp
    file = $fopen("output_matrix.txt", "w");
    for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1) begin
            $fwrite(file, "%0d ", matrix_C[i * 4 + j]); // Ghi từng giá trị
        end
        $fwrite(file, "\n"); // Xuống dòng
    end
    $fclose(file);
end
endmodule
