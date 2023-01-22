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
//`timescale 1ns\
module game_top\
#(\
parameter WIN = 10'd4,\
parameter SPEEDUP = 4'd5,\
parameter BALL_SIZE = 11'd20,\
parameter BALL_SPEED = 11'd10,\
parameter PAD_HEIGHT = 11'd100,\
parameter PAD_WIDTH = 11'd10,\
parameter PAD_OFFS = 11'd35,\
parameter PAD_SPY = 11'd15,\
parameter H_RES = 11'd1280,\
\pard\pardeftab720\sa240\partightenfactor0
\cf2 parameter V_RES = 11'd800\cb1 \uc0\u8232 \cb3 )(\cb1 \uc0\u8232 \cb3 input clk,\cb1 \uc0\u8232 \cb3 input center, up, down,\cb1 \uc0\u8232 \cb3 output [3:0] pix_r, pix_g, pix_b, output hsync, 
\f1 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0

\f0 \cf2 \cb3 output vsync\
);\
     clk_wiz_0 instance_name\
\pard\pardeftab720\sa240\partightenfactor0
\cf2 ( 
\f1 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0

\f0 \cf2 \cb3 .clk_out1(pix_clk),\
.clk_out2(logic_clk),\
.clk_out3(slow_clk),\
.clk_in1(clk));\
wire pix_clk;\
wire logic_clk;\
wire slow_clk;\
wire [10:0] curr_x;\
wire [10:0] curr_y;\
reg [10:0] blk_pos_x;\
reg [10:0] blk_pos_y;\
wire [3:0] draw_r;\
wire [3:0] draw_g;\
wire [3:0] draw_b;\
//scores\
reg [3:0] score_l;\
reg [3:0] score_r;\
// output clk_out1\
  // output clk_out2\
 // output clk_out3\
//drawing signals\
reg ball, padl, padr, pix_score;\
//ball properties\
reg [10:0] ball_x;\
reg [10:0] ball_y;\
reg [3:0] shot_count;\
reg ball_dx, ball_dy;\
reg ball_dx_prev;\
reg coll_r, coll_l;\
//paddle properties\
reg [10:0] padl_y, padr_y;\
reg [10:0] ai_y, play_y;\
//link paddles to AI or player\
always @* begin\
    padl_y = play_y;\
    padr_y = ai_y;\
end\
reg slow_clock;\
reg [23:0] slow_counter;\
always@(posedge slow_clk) begin\
    slow_counter <= slow_counter + 1'b1;\
    if(slow_counter >= 24'd100000) begin\
        slow_clock <= ~slow_clock;\
        slow_counter <= 24'd0;\
    end\
\pard\pardeftab720\sa240\partightenfactor0
\cf2 end 
\f1 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0

\f0 \cf2 \cb3 //game state\
parameter NEW_GAME = 4'd0;\
parameter POSITION = 4'd1;\
parameter END_GAME = 4'd2;\
parameter PLAY = 4'd3;\
reg [3:0] state, next_state;\
always @* begin\
    case(state)\
        NEW_GAME: begin\
            next_state = POSITION;\
        end\
        POSITION: next_state = PLAY;\
        END_GAME: next_state = NEW_GAME;\
        PLAY: begin\
            if (coll_l || coll_r) begin\
                if((score_l == WIN ) || (score_r == WIN)) next_state = END_GAME;\
                else next_state = POSITION;\
            end else next_state = PLAY;\
        end\
        default: begin\
            next_state = NEW_GAME;\
        end\
\pard\pardeftab720\sa240\partightenfactor0
\cf2 endcase end 
\f1 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0

\f0 \cf2 \cb3 //update game state\
always @(posedge pix_clk) state <= next_state;\
// AI paddle control\
always @(posedge slow_clock) begin\
    if(state == POSITION) ai_y <= (V_RES - PAD_HEIGHT)/11'd2;\
    else if (state == PLAY) begin\
        if (ai_y + PAD_HEIGHT/11'd2 < ball_y) begin\
            if (ai_y + PAD_HEIGHT + PAD_SPY >= V_RES-11'd1) begin\
                ai_y <= V_RES - PAD_HEIGHT -11'd1;\
            end else ai_y <= ai_y + PAD_SPY;\
        end else if (ai_y + PAD_HEIGHT/11'd2 > ball_y + BALL_SIZE) begin\
            if (ai_y < PAD_SPY) begin\
                ai_y <= 11'd0;\
            end else ai_y <= ai_y - PAD_SPY;\
\pard\pardeftab720\sa240\partightenfactor0
\cf2 end end 
\f1 \cf4 \cb1 \

\f0 \cf2 \cb3 end 
\f1 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0

\f0 \cf2 \cb3 // player paddle control\
always @(posedge slow_clock) begin\
    if (state == POSITION) play_y <= (V_RES - PAD_HEIGHT)/11'd2;\
    if (state == PLAY) begin\
        if (down) begin\
            if (state == PLAY) begin\
                  if (play_y + PAD_HEIGHT + PAD_SPY >= V_RES-11'd1) begin\
                        play_y <= V_RES - PAD_HEIGHT - 11'd1;\
                  end else play_y <= play_y + PAD_SPY;\
            end\
        end\
        if (up) begin\
            if (state == PLAY) begin\
                if(play_y < PAD_SPY) begin\
                    play_y <= 11'd0;\
                end else play_y <= play_y - PAD_SPY;\
\pard\pardeftab720\sa240\partightenfactor0
\cf2 end end 
\f1 \cf4 \cb1 \

\f0 \cf2 \cb3 end end 
\f1 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0

\f0 \cf2 \cb3 //ball control\
always @(posedge slow_clock) begin\
    case(state)\
        NEW_GAME: begin\
            score_l <= 4'd0;\
            score_r <= 4'd0;\
        end\
        POSITION: begin\
            coll_l <= 1'd0;\
            coll_r <= 1'd0;\
            ball_y <= (V_RES - BALL_SIZE) /11'd2;\
            if (coll_r) begin\
                ball_dx = 1'd1;\
                ball_x <= H_RES - (PAD_OFFS + PAD_WIDTH + BALL_SIZE);\
            end\
\pard\pardeftab720\sa240\partightenfactor0
\cf2 else begin 
\f1 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0

\f0 \cf2 \cb3 ball_dx = 1'd0;\
                    ball_x <= PAD_OFFS + PAD_WIDTH;\
                end\
            end\
            PLAY: begin\
                if ((PAD_OFFS+PAD_WIDTH >= ball_x) && (padl_y <= ball_y+BALL_SIZE) &&\
(padl_y+PAD_HEIGHT >= ball_y)) ball_dx <= 1'd0;\
                else if ((H_RES - PAD_OFFS <= ball_x+BALL_SIZE) && (padr_y <=\
ball_y+BALL_SIZE) && (padr_y+PAD_HEIGHT >= ball_y)) ball_dx <= 1'd1;\
                if (ball_dx == 1'd0) begin\
                    if(ball_x + BALL_SIZE + BALL_SPEED >= H_RES - 11'd1) begin\
                        ball_x <= H_RES - BALL_SIZE;\
                        score_l <= score_l + 4'd1;\
                        coll_r <= 1'd1;\
\pard\pardeftab720\sa240\partightenfactor0
\cf2 end 
\f1 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0

\f0 \cf2 \cb3                     else ball_x <= ball_x + BALL_SPEED;\
                end\
                else begin\
                    if (ball_x < BALL_SPEED) begin\
                        ball_x <= 11'd0;\
                        score_r <= score_r + 4'd1;\
                        coll_l <= 1'd1;\
                end\
                    else ball_x <= ball_x - BALL_SPEED;\
\pard\pardeftab720\sa240\partightenfactor0
\cf2 end 
\f1 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0

\f0 \cf2 \cb3                 if (ball_dy == 1'd0 ) begin\
                    if(ball_y + BALL_SIZE + BALL_SPEED >= V_RES - 11'd1)\
                        ball_dy <= 1'd1;\
                    else ball_y <= ball_y + BALL_SPEED;\
                end else begin\
                    if(ball_y < BALL_SPEED)\
\pard\pardeftab720\sa240\partightenfactor0
\cf2 end end 
\f1 \cf4 \cb1 \

\f0 \cf2 \cb3 endcase 
\f1 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0

\f0 \cf2 \cb3     ball_dy <= 1'd0;\
else ball_y <= ball_y - BALL_SPEED;\
        //if (frame) ball_dx_prev <= ball_dx;\
    end\
    reg [23:0] logic_counter;\
    reg logic_clock;\
    always @(posedge logic_clk) begin\
        logic_counter <= logic_counter + 1'b1;\
        if(logic_counter>=24'd10000) begin\
            logic_clock <= ~logic_clock;\
            logic_counter <= 24'd0;\
        end\
\pard\pardeftab720\sa240\partightenfactor0
\cf2 end 
\f1 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0

\f0 \cf2 \cb3     wire [3:0] draw_r, draw_g, draw_b;\
    drawcon draw (curr_x, curr_y, ball_x, ball_y, padl_y, padr_y, draw_r, draw_g,\
draw_b);\
    vga_out display (pix_clk, draw_r, draw_g, draw_b , pix_r, pix_g, pix_b, hsync, vsync,\
curr_x, curr_y);\
\pard\pardeftab720\sa240\partightenfactor0
\cf2 endmodule 
\f1 \cf4 \cb1 \
}