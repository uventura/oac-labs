from os import system
from time import sleep

def analisa_linha(linha, player):
    max_points = 0
    current_points = 0
    for element in linha:
        if element == player:
            current_points += 1
        else:
            if max_points < current_points:
                max_points = current_points
            current_points = 0
    return max_points

def print_board(board):
    print('1234567')
    for line in board:
        for col in line:
            print(col, end = '')
        print()

board = [['.' for i in range(7)] for i in range(6)]

# board[5][3] = 'x'
# board[5][4] = 'x'
# board[5][5] = '.'

# print('\n'+str(board[5]))
# print(analisa_linha(board[5]))

print_board(board)
print()

sleep(1)
player = 'x'
while True:
    coluna = int(input("Escolha a coluna:")) - 1
    correct_line = -1

    for line in range(6):
        if board[line][coluna] == '.':
            board[line][coluna] = player
            if correct_line == -1:
                correct_line = line
            else:
                board[line - 1][coluna] = '.'
        
    if player == 'x':
        player = 'o'
    else:
        player = 'x'
    system("clear")
    print()
    print_board(board)
    ans = input('Alguem ganhou?(s/n) ')
    if ans == 's':
        break
    
