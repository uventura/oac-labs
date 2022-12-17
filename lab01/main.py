from time import sleep

'''
           (N)
        NW  ^  NE
    (W) <       > (E)
        SW  v  SE
           (S)
    N => North
    W => West
    E => East
    S => South

    N+S => Vertical -> Only S is relevant -> (0, 0) + (0, -1)
    W+E => Horizontal -> (0, -1) + (0, 1)
    NW+SE => Primary Diagonal -> (-1, -1) + (1,1)
    NE+SW => Second Diagonal -> (-1, 1) + (1, -1)
'''
# Don't need to analyze north
directions = {
    'vertical': [0, 0, -1, 0],
    'horizontal': [0, -1, 0, 1],
    'primary_diagonal': [-1, -1, 1, 1],
    'second_diagonal': [-1, 1, 1, -1]
}

def print_board(board):
    print(' ',1,2,3,4,5,6,7)
    current_line = 1
    for line in board:
        print(str(current_line), end = ' ')
        for col in line:
            print(col, end=" ")
        print()
        current_line += 1
    print()

def in_range(board, row, col):
    return 0 <= row < len(board) and 0 <= col < len(board[0])
    
def put_element(board, symbol, col, col_buffer):
    if 0 <= col < len(board[0]) and col_buffer[col] < 0:
        return -1

    for row in range(5, -1, -1):
        if board[row][col] == '+':
            board[row][col] = symbol
            return row
        

def increment_direction(board, row, col, incr_row, incr_col, symbol):
    if incr_row == incr_col == 0:
        return [0,0]

    if not in_range(board, row, col):
        return [0,0]

    if board[row][col] == symbol:
        return [incr_row, incr_col]
    else:
        return [0, 0]

def dir_increment(
    board,
    symbol,
    row,
    col,
    dir_row1,
    dir_col1,
    dir_row2,
    dir_col2
):
    count = 0
    continue_moving = True

    temp_row1, temp_col1 = dir_row1, dir_col1
    temp_row2, temp_col2 = dir_row2, dir_col2

    while continue_moving:
        if not (dir_row1 == dir_col1 == 0):
            dir_row1, dir_col1 = increment_direction(
                board,
                row + dir_row1,
                col + dir_col1,
                dir_row1 + temp_row1,
                dir_col1 + temp_col1,
                symbol
            )
        if not (dir_row1 == dir_col1 == 0):
            count += 1


        if not(dir_row2 == dir_col2 == 0):
            dir_row2, dir_col2 = increment_direction(
                board,
                row + dir_row2,
                col + dir_col2,
                dir_row2 + temp_row2,
                dir_col2 + temp_col2,
                symbol
            )
        if not(dir_row2 == dir_col2 == 0):
            count += 1
    
        if (dir_row1 == dir_row2 == dir_col1 == dir_col2 == 0):
            continue_moving = False
        
    return count

def around(board, symbol, row, col):
    global directions

    max = -1
    for direction in directions:
        pos = directions[direction]
        current = dir_increment(board, symbol, row, col,
            pos[0],
            pos[1],
            pos[2],
            pos[3]
        )
        if max < current:
            max = current

    return max

def artificial_movement(board, symbol, col_buffer):
    chosen_col = 0
    max = -1
    for col in range(len(board[0])):
        current = around(board, symbol, col_buffer[col], col)
        if current > max:
            max = current
            chosen_col = col

    return chosen_col

def won(board, symbol, row, col):
    points = around(board, symbol, row, col)
    if points >= 3:
        return True
    return False

board = [['+' for i in range(7)] for i in range(6)]

col_buffer = [len(board) - 1 for line in range(len(board[0]))]

print_board(board)

player = 'x'
while True:
    if player == 'x':
        col = int(input('Col: ')) - 1
        row = put_element(board, player, col, col_buffer)
        col_buffer[col] -= 1

        if row != -1:
            if won(board, player, row, col):
                print_board(board)
                print('You Won!')
                break
    
    print_board(board)

    col = artificial_movement(board, 'o', col_buffer)
    row = put_element(board, 'o', col, col_buffer)

    print_board(board)

    if won(board, 'o', row, col):
        print('Machine won!')
        break
