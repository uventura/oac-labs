def print_board(board):
    for line in board:
        for col in line:
            print(col, end="")
        print()

def dir_increment(board, symbol, row, col, dir_row, dir_col):
    if not(0 <= row + dir_row < len(board)
    and    0 <= col + dir_col < len(board[0])):
            return -1
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
    '''
    # Don't need to analyze north
    directions = {
        'W':  [ 0, -1],
        'E':  [ 0,  1],
        'S':  [-1,  0],
        'NW': [ 1, -1],
        'NE': [ 1,  1],
        'SW': [-1, -1],
        'SE': [-1,  1],
    }

    max = -1
    for direction in directions:
        pos = directions[direction]
        current = dir_increment(board, symbol, row, col, pos[0], pos[1])
        if max < current:
            max = current
    return max

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
