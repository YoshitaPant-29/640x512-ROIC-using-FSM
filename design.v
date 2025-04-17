// Code your design here
module row_col_traversal (
    input clk,
    input rst,
    output reg [8:0] col_enable,   // 9 bits for 640 columns
    output reg [8:0] row_enable    // 9 bits for 512 rows
);

    // FSM states
    typedef enum logic [2:0] {
        IDLE,
        ROW_SELECT,
        COLUMN_HOLD,
        INTER_DELAY,
        NEXT_ROW,
        DONE
    } state_t;

    state_t state, next_state;

    // Counters
    reg [8:0] row_count;
    reg [9:0] col_count; // 640 columns
    reg [15:0] hold_counter;
    reg [15:0] delay_counter;

    // State transition
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            row_count <= 0;
            col_count <= 0;
            hold_counter <= 0;
            delay_counter <= 0;
            row_enable <= 0;
            col_enable <= 0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    row_enable <= 0;
                    col_enable <= 0;
                    row_count <= 0;
                    col_count <= 0;
                end

                ROW_SELECT: begin
                    row_enable <= (1 << row_count); // one-hot row
                    col_enable <= (1 << col_count); // start with column 0
                    hold_counter <= 0;
                end

                COLUMN_HOLD: begin
                    if (hold_counter < 70)
                        hold_counter <= hold_counter + 1;
                    else begin
                        delay_counter <= 0;
                    end
                end

                INTER_DELAY: begin
                    if (delay_counter < 10)
                        delay_counter <= delay_counter + 1;
                    else begin
                        if (col_count < 639) begin
                            col_count <= col_count + 1;
                            col_enable <= (1 << (col_count + 1));
                            hold_counter <= 0;
                        end
                    end
                end

                NEXT_ROW: begin
                    if (row_count < 511) begin
                        row_count <= row_count + 1;
                        col_count <= 0;
                        row_enable <= (1 << (row_count + 1));
                        col_enable <= (1 << 0);
                        hold_counter <= 0;
                    end else begin
                        row_enable <= 0;
                        col_enable <= 0;
                    end
                end

                DONE: begin
                    row_enable <= 0;
                    col_enable <= 0;
                end
            endcase
        end
    end

    // FSM next-state logic
    always @(*) begin
        case (state)
            IDLE:          next_state = ROW_SELECT;
            ROW_SELECT:    next_state = COLUMN_HOLD;
            COLUMN_HOLD:   next_state = (hold_counter >= 70) ? INTER_DELAY : COLUMN_HOLD;
            INTER_DELAY:   next_state = (delay_counter >= 10) ? ((col_count < 639) ? COLUMN_HOLD : NEXT_ROW) : INTER_DELAY;
            NEXT_ROW:      next_state = (row_count < 511) ? COLUMN_HOLD : DONE;
            DONE:          next_state = DONE;
            default:       next_state = IDLE;
        endcase
    end

endmodule
