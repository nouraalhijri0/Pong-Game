`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/09/2022 11:32:21 PM
// Design Name:
// Module Name: vga_out
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module vga_out(
    input clk,
    input [3:0] r, g, b,
    output [3:0] pix_r, pix_g, pix_b,
    output hsync,
    output vsync,
    output [10:0] curr_x,
    output [10:0] curr_y
);
    reg [10:0] hcount = 11'd0;
    reg [10:0] vcount = 11'd0;
    always@ (posedge clk)
    begin
        if ( hcount < 11'd1679 )
            hcount <= hcount + 11'b1;
        else
        begin
            hcount <= 11'b0;
            if ( vcount < 11'd827 )
                vcount <= vcount + 11'b1;
            else
                vcount <= 11'b0;
end end
    assign  hsync = ((hcount>=11'd0) && (hcount<= 11'd135)) ? 1'b0 : 1'b1;
    assign  vsync = ((vcount>=11'd0) &&(vcount<=11'd2)) ? 1'b1 : 1'b0;
    assign pix_r = ((hcount>=11'd336) && (hcount<= 11'd1615) && (vcount>=11'd27) &&
(vcount<=11'd826) ) ? r : 4'd0;
    assign pix_g = ((hcount>=11'd336) && (hcount<= 11'd1615) && (vcount>=11'd27) &&
(vcount<=11'd826) ) ? g : 4'd0;
    assign pix_b = ((hcount>=11'd336) && (hcount<= 11'd1615) && (vcount>=11'd27) &&
(vcount<=11'd826) ) ? b : 4'd0;
    assign curr_x = (hcount >=11'd336 ) && ( hcount <=11'd1615 ) ? hcount -11'd336 :
11'd0;
    assign curr_y = (vcount >=11'd27 ) &&  ( vcount <=11'd826 ) ? vcount -10'd27 : 11'd0;
endmodule