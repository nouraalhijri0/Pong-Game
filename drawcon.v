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
// Create Date: 04/12/2022 12:12:53 PM\
// Design Name:\
// Module Name: drawcon\
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
module drawcon\
#(\
parameter BALL_SIZE = 11'd20,\
parameter PAD_HEIGHT = 11'd100,\
parameter PAD_WIDTH = 11'd10,\
parameter PAD_OFFS = 11'd35,\
parameter H_RES = 11'd1280,\
parameter V_RES = 11'd800\
)\
(input [10:0] draw_x, draw_y, ball_x, ball_y, padl_y, padr_y,\
 output [3:0] r, g, b);\
       reg ball, padl, padr, pix_score;\
       always @* begin\
            ball = (draw_x >= ball_x) && (draw_x < ball_x + BALL_SIZE) && (draw_y >=\
ball_y) && (draw_y < ball_y + BALL_SIZE);\
            padl = (draw_x >= PAD_OFFS) && (draw_x < PAD_OFFS + PAD_WIDTH) && (draw_y >=\
padl_y) && (draw_y < padl_y + PAD_HEIGHT);\
            padr = (draw_x >= H_RES - PAD_OFFS - PAD_WIDTH - 11'd1) && (draw_x < H_RES -\
PAD_OFFS - 11'd1) && (draw_y >= padr_y) && (draw_y < padr_y + PAD_HEIGHT);\
\pard\pardeftab720\sa240\partightenfactor0
\cf2 end 
\f1 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0

\f0 \cf2 \cb3         reg [3:0] paint_r, paint_g, paint_b;\
        always @* begin\
            if(ball) \{ paint_r, paint_g, paint_b \} = 12'hF30;\
            else if (padl || padr) \{ paint_r, paint_g, paint_b \} = 12'hFC0;\
            else if (pix_score) \{ paint_r, paint_g, paint_b \} = 12'hFFF;\
            else \{ paint_r, paint_g, paint_b \} = 12'h137;\
\pard\pardeftab720\sa240\partightenfactor0
\cf2 end 
\f1 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0

\f0 \cf2 \cb3        assign r = paint_r;\
       assign g = paint_g;\
       assign b = paint_b;\
\pard\pardeftab720\sa240\partightenfactor0
\cf2 endmodule 
\f1 \cf4 \cb1 \
}