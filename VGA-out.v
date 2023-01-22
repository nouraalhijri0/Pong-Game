{\rtf1\ansi\ansicpg1252\cocoartf2636
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fmodern\fcharset0 CourierNewPSMT;\f1\froman\fcharset0 Times-Roman;}
{\colortbl;\red255\green255\blue255;\red12\green97\blue172;\red255\green255\blue255;\red0\green0\blue0;
}
{\*\expandedcolortbl;;\cssrgb\c0\c46275\c72941;\cssrgb\c100000\c100000\c100000;\cssrgb\c0\c0\c0;
}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\deftab720
\pard\pardeftab720\partightenfactor0

\f0\fs24 \cf2 \cb3 \expnd0\expndtw0\kerning0
`timescale 1ns / 1ps\
//////////////////////////////////////////////////////////////////////////////////\
// Company:\
// Engineer:\
//\
// Create Date: 04/09/2022 11:32:21 PM\
// Design Name:\
// Module Name: vga_out\
// Project Name:\
// Target Devices:\
// Tool Versions:\
// Description:\
//\
// Dependencies:\
//\
// Revision:\
// Revision 0.01 - File Created\
// Additional Comments:\
//\
//////////////////////////////////////////////////////////////////////////////////\
module vga_out(\
    input clk,\
    input [3:0] r, g, b,\
    output [3:0] pix_r, pix_g, pix_b,\
    output hsync,\
    output vsync,\
    output [10:0] curr_x,\
    output [10:0] curr_y\
\pard\pardeftab720\sa240\partightenfactor0
\cf2 ); 
\f1 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0

\f0 \cf2 \cb3     reg [10:0] hcount = 11'd0;\
    reg [10:0] vcount = 11'd0;\
    always@ (posedge clk)\
    begin\
        if ( hcount < 11'd1679 )\
            hcount <= hcount + 11'b1;\
        else\
        begin\
            hcount <= 11'b0;\
            if ( vcount < 11'd827 )\
                vcount <= vcount + 11'b1;\
            else\
                vcount <= 11'b0;\
\pard\pardeftab720\sa240\partightenfactor0
\cf2 end end 
\f1 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0

\f0 \cf2 \cb3     assign  hsync = ((hcount>=11'd0) && (hcount<= 11'd135)) ? 1'b0 : 1'b1;\
    assign  vsync = ((vcount>=11'd0) &&(vcount<=11'd2)) ? 1'b1 : 1'b0;\
    assign pix_r = ((hcount>=11'd336) && (hcount<= 11'd1615) && (vcount>=11'd27) &&\
(vcount<=11'd826) ) ? r : 4'd0;\
    assign pix_g = ((hcount>=11'd336) && (hcount<= 11'd1615) && (vcount>=11'd27) &&\
(vcount<=11'd826) ) ? g : 4'd0;\
    assign pix_b = ((hcount>=11'd336) && (hcount<= 11'd1615) && (vcount>=11'd27) &&\
(vcount<=11'd826) ) ? b : 4'd0;\
    assign curr_x = (hcount >=11'd336 ) && ( hcount <=11'd1615 ) ? hcount -11'd336 :\
11'd0;\
    assign curr_y = (vcount >=11'd27 ) &&  ( vcount <=11'd826 ) ? vcount -10'd27 : 11'd0;\
\pard\pardeftab720\sa240\partightenfactor0
\cf2 endmodule 
\f1 \cf4 \cb1 \
}