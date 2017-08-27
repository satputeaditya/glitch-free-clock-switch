// glitch_free_clock_switch.v

module glitch_free_clock_switch (
									input   rst,
									input   clk_1,
									input   clk_2,
									input   select,   // 1 = clk_1  , 0 = clk_2
									output  clk_out
								);
  //----------------------------------------------------------------
  // Concurrent connectivity for ports etc.
  //----------------------------------------------------------------
  assign temp_1 	= (clock_2[1] &   select);
  assign temp_2 	= (clock_1[1] & (~select));  
  assign clk_out 	= ((clock_1[1]&clk_1) | (clock_2[1]|&clk_2));
    
  //----------------------------------------------------------------
  // Registers including update variables and write enable.
  //----------------------------------------------------------------  
  reg [1:0] clock_1;
  reg [1:0] clock_2;
  wire 		temp_1;
  wire 		temp_2;
  reg [7:0] duration_count_old;
  reg [7:0] duration_count_new;  
  reg [7:0] state;
  
  //----------------------------------------------------------------
  // synchronous logic for clk_1
  //----------------------------------------------------------------
  always @ (posedge clk_1 or negedge rst)
    begin : clk_1_reg
		if (!rst)
          clock_1   <= 'b0;
		else
			begin
			  clock_1[0]   <= temp_1;
			  clock_1[1]   <= clock_1[0];
			end
	end 
	
  //----------------------------------------------------------------
  // synchronous logic for clk_2
  //----------------------------------------------------------------
  always @ (posedge clk_2 or negedge rst)
    begin : clk_2_reg
		if (!rst)
          clock_2   <= 'b0;
		else
			begin
			  clock_2[0]   <= temp_2;		
			  clock_2[1]   <= clock_2[0];
			end
	end

endmodule  // EOF clock_transition