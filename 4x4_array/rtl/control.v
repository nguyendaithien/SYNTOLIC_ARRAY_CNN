module controller #( parameter ROW_NUM = 4, WIDTH = 4, HEIGHT = 4) (
	input clk                   ,
	input rst_n                 ,
	input data_valid            ,
//	input start_compute         ,
	output reg [3:0] mux_select ,
	output reg [3:0] in_valid_A , // matrix A 
	output reg [3:0] in_valid_B , // matrix B 
	output reg read_data        ,
	output reg done
);

parameter IDLE        = 3'b000;
parameter LOAD_DATA	  = 3'b001;
parameter FIRST_PIXEL = 3'b010;
parameter COMPUTE     = 3'b011;
parameter DONE        = 3'b100;

wire start_compute;
reg [1:0] current_state ;
reg [1:0] next_state    ;
reg [4:0] counter       ;
reg [4:0] counter_pixel ;
reg [4:0] counter_input ;
reg [4:0] counter_buffer;


assign start_compute = (counter_input == HEIGHT * WIDTH) ? 1 : 0;
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		current_state <= IDLE;
	end else begin 
		current_state <= next_state;
	end
end

always @(*) begin
	case(current_state)
		IDLE:        if (data_valid) next_state = LOAD_DATA        ;
		LOAD_DATA:   if (start_compute) next_state = FIRST_PIXEL   ;
		FIRST_PIXEL: if (counter == ROW_NUM) next_state = COMPUTE  ;
		COMPUTE:     if (counter_pixel == 2*WIDTH ) next_state = DONE ;
		default: next_state = IDLE                                 ;
	endcase
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		counter <= 0;
		counter_pixel <= 0;
		counter_input <= 0;
		counter_buffer <= 0;
	end else begin
		case(next_state)
			IDLE: begin 
		    counter <= 0;
		    counter_pixel <= 0;
		    counter_input <= 0;
		    counter_buffer <= 0;
			end
			LOAD_DATA: begin
				read_data <= 1'b1;
		    counter_input <= counter_input + 1;
				counter_buffer <= counter_buffer + 1;
			end
			FIRST_PIXEL: begin
				read_data <= 1'b1;
				counter <= counter + 1;
				if(counter == 5'd0) begin
					mux_select <= 4'b1000;
				end else if(counter == 5'd1) begin
					mux_select <= 4'b1100;
				end else if(counter == 5'd2) begin
					mux_select <= 4'b1110;
				end else if(counter == 5'd3) begin
					mux_select <= 4'b1111;
				end else begin 
					mux_select <= 4'b0000;
				end
			end
			COMPUTE: begin
				counter_pixel <= counter_pixel + 5'd1;
			end
		  DONE: begin	
		    counter <= 0;
		    counter_pixel <= 0;
				done <= 1'd1;
			end
		endcase
	end
end
endmodule
