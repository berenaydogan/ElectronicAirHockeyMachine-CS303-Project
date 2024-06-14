module hockey(

input clk,
input rst,

input BTN_A,
input BTN_B,

input [1:0] DIR_A,
input [1:0] DIR_B,

input [2:0] Y_in_A,
input [2:0] Y_in_B,

/*output reg LEDA,
output reg LEDB,
output reg [4:0] LEDX,

output reg [6:0] SSD7,
output reg [6:0] SSD6,
output reg [6:0] SSD5,
output reg [6:0] SSD4, 
output reg [6:0] SSD3,
output reg [6:0] SSD2,
output reg [6:0] SSD1,
output reg [6:0] SSD0   */

output reg [2:0] X_COORD,
output reg [2:0] Y_COORD


);

reg turn;
reg [7:0] timer;
reg [1:0] dirY;
reg [2:0] scoreA;
reg [2:0] scoreB;

reg [3:0] cState;

parameter [3:0] IDLE = 4'b0000;
parameter [3:0] DISP = 4'b0001;
parameter [3:0] HIT_A = 4'b0010;
parameter [3:0] HIT_B = 4'b0011;
parameter [3:0] SEND_A = 4'b0100;
parameter [3:0] SEND_B = 4'b0101;
parameter [3:0] RESP_A = 4'b0110;
parameter [3:0] RESP_B = 4'b0111;
parameter [3:0] GOAL_A = 4'b1000;
parameter [3:0] GOAL_B = 4'b1001;
parameter [3:0] GAME_OVER = 4'b1010;

parameter [2:0] TWO_SECS = 3'd4;

always @(posedge clk or posedge rst)
begin
    if (rst) begin
        timer <= 0;
        dirY <= 0;
        scoreA <= 0;
        scoreB <= 0;
        X_COORD <= 0;
        Y_COORD <= 0;
        cState <= IDLE;
    end
    else 
    begin
        case (cState)
            IDLE:
            begin
                if (BTN_A == 0 && BTN_B == 1) 
                begin
                    turn <= 1;
                    cState <= DISP;
                end
                else if (BTN_A == 1 && BTN_B == 0) 
                begin
                    turn <= 0;
                    cState <= DISP;
                end
                else 
                begin
                    cState <= IDLE;
                end
            end
            DISP:
            begin
                if (timer < TWO_SECS) 
                begin
                    timer <= timer + 1;
                    cState <= DISP;
                end
                else 
                begin
                    timer <= 0;
                    if (turn == 1) 
                    begin
                        cState <= HIT_B;
                    end
                    else 
                    begin
                        cState <= HIT_A;
                    end
                end
            end
            HIT_A:
            begin
                if (BTN_A && (Y_in_A < 5))
                begin
                    X_COORD <= 0;
                    Y_COORD <= Y_in_A;
                    dirY <= DIR_A;
                    cState <= SEND_B;
                end
                else
                begin
                    cState <= HIT_A;
                end
            end
            HIT_B:
            begin
                if (BTN_B && (Y_in_B < 5))
                begin
                    X_COORD <= 4;
                    Y_COORD <= Y_in_B;
                    dirY <= DIR_B;
                    cState <= SEND_A;
                end
                else
                begin
                    cState <= HIT_B;
                end
            end
            SEND_A:
            begin
                if (timer < TWO_SECS) 
                begin
                    timer <= timer + 1;
                    cState <= SEND_A;
                end
                else
                begin
                    timer <= 0;
                    case (dirY)
                    2'b00:
                        if (X_COORD > 1)
                        begin
                            X_COORD <= X_COORD - 1;
                            cState <= SEND_A;
                        end
                        else
                        begin
                            X_COORD <= 0;
                            cState <= RESP_A;
                        end
                    2'b01:
                    begin
                        if (Y_COORD == 4)
                        begin
                            dirY <= 2'b10;
                            Y_COORD <= Y_COORD - 1;
                            if (X_COORD > 1)
                            begin
                                X_COORD <= X_COORD - 1;
                                cState <= SEND_A;
                            end
                            else
                            begin
                                X_COORD <= 0;
                                cState <= RESP_A;
                            end
                        end
                        else 
                        begin
                            Y_COORD <= Y_COORD + 1;
                            if (X_COORD > 1)
                            begin
                                X_COORD <= X_COORD - 1;
                                cState <= SEND_A;
                            end
                            else
                            begin
                                X_COORD <= 0;
                                cState <= RESP_A;
                            end
                        end
                    end
                    2'b10:
                    begin
                        if (Y_COORD == 0)
                        begin
                            dirY <= 2'b01;
                            Y_COORD <= Y_COORD + 1;
                            if (X_COORD > 1)
                            begin
                                X_COORD <= X_COORD - 1;
                                cState <= SEND_A;
                            end
                            else
                            begin
                                X_COORD <= 0;
                                cState <= RESP_A;
                            end
                        end
                        else 
                        begin
                            Y_COORD <= Y_COORD - 1;
                            if (X_COORD > 1)
                            begin
                                X_COORD <= X_COORD - 1;
                                cState <= SEND_A;
                            end
                            else
                            begin
                                X_COORD <= 0;
                                cState <= RESP_A;
                            end
                        end
                    end
                    default:
                    begin
                        cState <= SEND_A;
                    end
                    endcase
                end
            end
            SEND_B:
            begin
                if (timer < TWO_SECS) 
                begin
                    timer <= timer + 1;
                    cState <= SEND_B;
                end
                else
                begin
                    timer <= 0;
                    case (dirY)
                    2'b00:
                        if (X_COORD < 3)
                        begin
                            X_COORD <= X_COORD + 1;
                            cState <= SEND_B;
                        end
                        else
                        begin
                            X_COORD <= 4;
                            cState <= RESP_B;
                        end
                    2'b01:
                    begin
                        if (Y_COORD == 4)
                        begin
                            dirY <= 2'b10;
                            Y_COORD <= Y_COORD - 1;
                            if (X_COORD < 3)
                            begin
                                X_COORD <= X_COORD + 1;
                                cState <= SEND_B;
                            end
                            else
                            begin
                                X_COORD <= 4;
                                cState <= RESP_B;
                            end
                        end
                        else 
                        begin
                            Y_COORD <= Y_COORD + 1;
                            if (X_COORD < 3)
                            begin
                                X_COORD <= X_COORD + 1;
                                cState <= SEND_B;
                            end
                            else
                            begin
                                X_COORD <= 4;
                                cState <= RESP_B;
                            end
                        end
                    end
                    2'b10:
                    begin
                        if (Y_COORD == 0)
                        begin
                            dirY <= 2'b01;
                            Y_COORD <= Y_COORD + 1;
                            if (X_COORD < 3)
                            begin
                                X_COORD <= X_COORD + 1;
                                cState <= SEND_B;
                            end
                            else
                            begin
                                X_COORD <= 4;
                                cState <= RESP_B;
                            end
                        end
                        else 
                        begin
                            Y_COORD <= Y_COORD - 1;
                            if (X_COORD < 3)
                            begin
                                X_COORD <= X_COORD + 1;
                                cState <= SEND_B;
                            end
                            else
                            begin
                                X_COORD <= 4;
                                cState <= RESP_B;
                            end
                        end
                    end
                    default:
                    begin
                        cState <= SEND_B;
                    end
                    endcase
                end
            end
            RESP_A:
            begin
                if (timer < TWO_SECS) 
                begin
                    if (BTN_A && (Y_COORD == Y_in_A))
                    begin
                        X_COORD <= 1;
                        timer <= 0;
                        case (DIR_A)
                            2'b00:
                            begin
                                dirY <= DIR_A;
                                cState <= SEND_B;
                            end
                            2'b01:
                            begin
                                if (Y_COORD == 4)
                                begin
                                    dirY <= 2'b10;
                                    Y_COORD <= Y_COORD - 1;
                                    cState <= SEND_B;
                                end
                                else
                                begin
                                    dirY <= DIR_A;
                                    Y_COORD <= Y_COORD + 1;
                                    cState <= SEND_B;
                                end
                            end
                            2'b10:
                            begin
                                if (Y_COORD == 0)
                                begin
                                    dirY <= 2'b01;
                                    Y_COORD <= Y_COORD + 1;
                                    cState <= SEND_B;
                                end
                                else
                                begin
                                    dirY <= DIR_A;
                                    Y_COORD <= Y_COORD - 1;
                                    cState <= SEND_B;
                                end
                            end
                            default:
                            begin
                                cState <= RESP_A;
                            end
                        endcase
                    end
                    else 
                    begin
                        timer <= timer + 1;
                        cState <= RESP_A;
                    end
                end
                else
                begin
                    timer <= 0;
                    scoreB <= scoreB + 1;
                    cState <= GOAL_B;
                end
            end
            RESP_B:
            begin
                if (timer < TWO_SECS) 
                begin
                    if (BTN_B && (Y_COORD == Y_in_B))
                    begin
                        X_COORD <= 3;
                        timer <= 0;
                        case (DIR_B)
                            2'b00:
                            begin
                                dirY <= DIR_B;
                                cState <= SEND_A;
                            end
                            2'b01:
                            begin
                                if (Y_COORD == 4)
                                begin
                                    dirY <= 2'b10;
                                    Y_COORD <= Y_COORD - 1;
                                    cState <= SEND_A;
                                end
                                else
                                begin
                                    dirY <= DIR_B;
                                    Y_COORD <= Y_COORD + 1;
                                    cState <= SEND_A;
                                end
                            end
                            2'b10:
                            begin
                                if (Y_COORD == 0)
                                begin
                                    dirY <= 2'b01;
                                    Y_COORD <= Y_COORD + 1;
                                    cState <= SEND_A;
                                end
                                else
                                begin
                                    dirY <= DIR_B;
                                    Y_COORD <= Y_COORD - 1;
                                    cState <= SEND_A;
                                end
                            end
                            default:
                            begin
                                cState <= RESP_B;
                            end
                        endcase
                    end
                    else 
                    begin
                        timer <= timer + 1;
                        cState <= RESP_B;
                    end
                end
                else
                begin
                    timer <= 0;
                    scoreA <= scoreA + 1;
                    cState <= GOAL_A;
                end
            end
            GOAL_A:
            begin
                if (timer < TWO_SECS) 
                begin
                    timer <= timer + 1;
                    cState <= GOAL_A;
                end
                else
                begin
                    timer <= 0;
                    if (scoreA == 3)
                    begin
                        turn <= 0;
                        cState <= GAME_OVER;
                    end
                    else
                    begin
                        cState <= HIT_B;
                    end
                end
            end
            GOAL_B:
            begin
                if (timer < TWO_SECS) 
                begin
                    timer <= timer + 1;
                    cState <= GOAL_B;
                end
                else
                begin
                    timer <= 0;
                    if (scoreB == 3)
                    begin
                        turn <= 1;
                        cState <= GAME_OVER;
                    end
                    else
                    begin
                        cState <= HIT_A;
                    end
                end
            end
            GAME_OVER:
            begin
                cState <= GAME_OVER;
            end
            default:
            begin
                cState <= IDLE;
            end
        endcase
    end
end

endmodule
