def print_board(board):
    for line in board:
        for col in line:
            print(col, end="")
        print()

def dir_increment(board, symbol, row, col, dir_row, dir_col):
    if not(0 <= row + dir_row < len(board)
    and    0 <= col + dir_col < len(board[0])):
            return 0
    count = 0
    while board[row + dir_row][col + dir_col] == symbol:
        row += dir_row
        col += dir_col
        count += 1
        if not(0 <= row + dir_row < len(board)
        and    0 <= col + dir_col < len(board[0])):
            break
    return count

def around(board, symbol, row, col):
    south = dir_increment(board, symbol, row, col, 1, 0)
     = dir_increment(board, symbol, row, col, 0, 1)
    right = dir_increment(board, symbol, row, col, 0, -1)
    diag_1 = dir_increment(board, symbol, row, col, )

    if down > left and down > right:
        return 'down'
    elif left > down and left > right:
        return 'left'
    else:
        return 'right'

def artificial_movement(board):
    max_points = 0
            
board = [['+' for i in range(7)] for i in range(6)]

board[3][3] = 'o'

board[3][4] = 'o'
board[3][5] = 'o'

board[3][2] = 'o'
board[3][1] = 'o'
# board[3][0] = 'o'

print_board(board)
print(around(board, 'o', 3,3))
