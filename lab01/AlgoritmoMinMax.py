 ####################################################################
 #  Algoritmo de busca com Alpha-Beta Pruning.
 #
 #  Mais detalhes: https://en.wikipedia.org/wiki/Alpha–beta_pruning
 ####################################################################
 ####################################################################
 #     Exemplo do gameboard, sendo X = jogador e O = Machine
 #                1 2 3 4 5 6 7
 #              1 . . . . . . .
 #              2 . . . . . . .
 #              3 . . . . . . x
 #              4 . . . . . . x
 #              5 . . . . . . x
 #              6 o o o o . . x
 ####################################################################

def isPlayerAt(column, row, gameBoard, currentPlayer):
    place = gameBoard[column][row]
    if place != "." and place == currentPlayer:
        return True
    return False

def isVictory(currentPlayer, rows, columns):

    for r in range(rows - 1, 0, -1):
        for c in range(0, columns):
            
            if isPlayerAt(c, r, currentPlayer):
                ## Vertical
                isWin = True
                count = 0
                while (count<4) and (r-count) >= 0 and isWin:
                    isWin = isPlayerAt(c, r-count, currentPlayer)
                    count += 1
                if isWin and count==4:
                    return True

                ## Horizontal
                isWin = True
                count = 0
                while (count<4) and (c+count) < columns and isWin:
                    isWin = isPlayerAt(c+count, r, currentPlayer)
                    count += 1
                if isWin and count==4:
                    return True
                
                # Diagonal direita
                isWin = True
                count = 0
                while (count<4) and (r-count)>=0 and (c+count)<columns and isWin:
                    isWin = isPlayerAt(c+count, r-count, currentPlayer)
                    count += 1
                if isWin and count==4:
                    return True

                # Diagonal esquerda
                isWin = True
                count = 0
                while (count<4) and (r-count)>rows and (c-count)>=0 and isWin:
                    isWin = isPlayerAt(c-count, r-count, currentPlayer)
                    count += 1
                if isWin and count==4:
                    return True

    return False

def gameScore(rows, columns, gameBoard, currentPlayer, level):
    if isVictory(currentPlayer):
        if currentPlayer:
            return 10000
        else:
            return 20000
    else:
        return getGameScore(rows, columns, gameBoard, currentPlayer)


def getGameScore(rows, columns, gameBoard, isCurrentPlayer):
    score = 0
    for r in range(rows-1, 0, -1):
        for c in range(0, columns):

            # Vertical
            places = []
            count = 0
            while (count<4) and (r-count)>=0:
                places.append(gameBoard[c][r-count])
                count += 1
            score += evaluatePlaces(places, isCurrentPlayer)

            # Horizontal
            places = []
            count = 0
            while (count<5) and (c+count)<columns:
                places.append(gameBoard[c+count][r])
                count += 1
            score += evaluatePlaces(places, isCurrentPlayer)

            # Diagonal direita
            count = 0
            while (count<4) and (r-count)>=0 and (c+count)<columns:
                places.append(gameBoard[c+count][r-count])
                count += 1
            score += evaluatePlaces(places, isCurrentPlayer)

            # Diagonal esquerda
            count = 0
            while (count<4) and (r-count)<rows and (c-count)>=columns:
                places.append(gameBoard[c-count][r-count])
                count += 1
            score += evaluatePlaces(places, isCurrentPlayer)
        
    return score


def evaluatePlaces(places, isCurrentPlayer):
    if len(places)!=4 and len(places)!=5:
        return 0
    nullCount = 0
    playerCount = 0
    Machine = 0
    for i in places:
        if i == ".":
            nullCount += 1
        elif i == "x":
            playerCount += 1
        elif i == "o":
            Machine += 1
    
    # Casos Especiais
    if len(places) == 5 and Machine!=0:
        # | |P|P|P| |
        if(playerCount==3 and places[1]!="." and places[2]!="." and places[3]!="."):
            return 40

        # |P|P| |P| |
        if(playerCount==3 and places[0]!="." and places[1]!="." and places[3]!="."):
            return 30
        
        # | |P|P| |P|
        if(playerCount==3 and places[1]!="." and places[2]!="." and places[4]!="."):
            return 30
        
        # |P| |P|P| |
        if(playerCount==3 and places[0]!="." and places[2]!="." and places[3]!="."):
            return 30
        
        # | |P| |P|P|
        if( playerCount==3 and places[1]!="." and places[3]!="." and places[4]!="." ):
            return 30
        
        # | |P| |P| |
        if( playerCount==2 and places[1]!="." and places[3]!="." ):
            return 30
        

    if Machine!=0:
        return 0
    
    else:
        if playerCount==1 :
            return 1
        
        if playerCount==2 :
            return 4
        
        if playerCount==3 :
            return 8

        return playerCount



def MinMaxWithAlphaBetaPruning(availableMoves, currentPlayer, level, min, max):

    if(len(availableMoves) == 0 or level <= 0 or isVictory(currentPlayer)):
        score = gameScore(rows, columns, gameBoard, currentPlayer, level)
        #print("returning score: ", score);
        return score
        