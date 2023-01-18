.data
	.include "sprites/block_background.s"		# 1
	.include "sprites/empty_hole.s"			# 2
	.include "sprites/player_one.s"			# 3
	.include "sprites/player_two.s"			# 4
	.include "sprites/indicator.s"			# 5
	
	.include "sprites/A.s"			# 6
	.include "sprites/C.s"			# 7
	.include "sprites/D.s"			# 8
	.include "sprites/E.s"			# 9
	.include "sprites/F.s"			# 10
	.include "sprites/I.s"			# 11
	.include "sprites/L.s"			# 12
	.include "sprites/M.s"			# 13
	.include "sprites/O.s"			# 14
	
	.include "sprites/indicator_two.s"			# 15

MAP_1:
	.byte 
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,1,1,15,10,6,7,11,12,1,1,1,1,1,1,1,1,1,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,1,1,1,1,1,13,9,8,11,14,1,1,1,1,1,1,1,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,1,1,1,8,11,10,7,11,12,1,1,1,1,1,1,1,1,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,

MAP_2:
	.byte 
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,1,1,1,5,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,1,1,1,2,2,2,2,2,2,2,1,1,1,1,1,1,1,
	1,1,1,1,1,1,2,2,2,2,2,2,2,1,1,1,1,1,1,1,
	1,1,1,1,1,1,2,2,2,2,2,2,2,1,1,1,1,1,1,1,
	1,1,1,1,1,1,2,2,2,2,2,2,2,1,1,1,1,1,1,1,
	1,1,1,1,1,1,2,2,2,2,2,2,2,1,1,1,1,1,1,1,
	1,1,1,1,1,1,2,2,2,2,2,2,2,1,1,1,1,1,1,1,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	
CURRENT_HEIGHTS: .byte 0,0,0,0,0,0,0,0

CURRENT_GAME:
	.byte
	0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,

DIRECTIONS_WON:
#	* * *		(-1, -1)  (-1, 0)  (-1, 1)
#	* o *	>>>> 	( 0, -1)  ( 0, 0)  ( 0, 1)
#	* * *		( 1, -1)  ( 1, 0)  ( 1, 1)
	# Horizontal
	.byte  0,-1,
	.byte  0, 1,
	# Vertical
	.byte -1, 0,
	.byte  1, 0,
	# Diagonal One
	.byte -1,-1,
	.byte  1, 1,
	# Diagonal Two
	.byte -1, 1,
	.byte  1,-1,

.text

#==================+
#	MAIN	   |	
#==================+

MAIN:
	li s0, 5 # Menu Indicator Line Position
	li s1, 5 # Menu Indicator Col Position
	li s2, 1 # Dificult Level
	li s3, 6 # Player Col
	li s4, 3 # Current Player (The number is its sprite)
	li s5, 0 # Won status
	li s6, 0 # Player moved
	
	la a0, MAP_1
	jal PRINT_MAP

#=======================+
#	MENU_LOOP	|
#=======================+

MENU_LOOP:
	li t0, 0xFF200000
	lw t1, 0(t0)
	andi t1, t1, 0x00000001
		
	# Change Indicator Position on Menu
	beqz t1, MENU_LOOP
	jal CHANGE_MENU_POS
		
	j MENU_LOOP
BACK_MENU_LOOP:

#=======================+
#	GAME LOOP	|
#=======================+

RENDER_MAP:
	la a0, MAP_2
	jal PRINT_MAP

GAME_LOOP:
	li s6, 0
		
	li t0, 0xFF200000
	lw t1, 0(t0)
	andi t1, t1, 0x00000001
		
	# Change Indicator Position on Menu
	beqz t1, GAME_LOOP

	jal PLAYER_MOVEMENT
	li t0, -1
	beq a0, t0, GAME_LOOP
	
	li t0, 3
	ble t0, s5, GAME_OVER

NEW_AI_MOVEMENT:
	jal AI_MOVEMENT
	
	li t0, -1
	beq a0, t0, NEW_AI_MOVEMENT
	
	# ebreak

	li t0, 3
	beq s5, t0, GAME_OVER
	
	jal VERIFY_DRAW
		
	j GAME_LOOP
END_GAME_LOOP:

GAME_OVER:
	# Reset Current Heights
	la t0, CURRENT_HEIGHTS
	sw zero, 0(t0)
	sb zero, 4(t0)
	sb zero, 5(t0)
	sb zero, 6(t0)
	
	# Reset Current Game
	la t0, CURRENT_GAME
	li t1, 0
	li t2, 42
GAMER_OVER_LOOP:
	beq t1, t2, END_GAMER_OVER_LOOP
	sb zero, 0(t0)
	addi t0, t0, 1
	addi t1, t1, 1
	j GAMER_OVER_LOOP
END_GAMER_OVER_LOOP:
	j MAIN

#==================+
#	EXIT	   |
#==================+

EXIT:
	li a7, 10
	ecall

############################################################################
############################################################################

#=======================+
#	VERIFY_DRAW	|
#=======================+
VERIFY_DRAW:
	li t0, 6
	la t1, CURRENT_HEIGHTS
	li t2, 0
	li t3, 7

LOOP_VERIFY_DRAW:
	beq t2, t3, END_LOOP_VERIFY_DRAW
	lb t4, 0(t1)
	bne t4, t0, END_VERIFY_DRAW
	addi t2, t2, 1
	j LOOP_VERIFY_DRAW
END_LOOP_VERIFY_DRAW:
	j GAME_OVER

END_VERIFY_DRAW:
	ret

#========================+
#	AI_MOVEMENT	 |
#========================+

AI_MOVEMENT:
	li t0, 1
	beq s2, t0, AI_MOVEMENT_LEVEL_1
	
	li t0, 2
	beq s2, t0, AI_MOVEMENT_LEVEL_2
	
	li t0, 3
	beq s2, t0, AI_MOVEMENT_LEVEL_1
	
AI_MOVEMENT_END:
	ret
AI_MOVEMENT_LEVEL_1:
	beqz s6, AI_MOVEMENT_END
	
	addi sp, sp, -4
	sw ra, 0(sp)

	# Generate random position
	li a7, 42
	li a1, 7
	li a0, 7
	ecall
	
	# Fix position
	addi a0, a0, 6
	
	jal MAKE_MOVEMENT
	
	lw ra, 0(sp)
	addi sp, sp, 4

	ret

AI_MOVEMENT_LEVEL_2:
	addi sp, sp, -4
	sw ra, 0(sp)
	
	li a0, 4
	jal AI_LOOK_AROUND

	addi a0, a0, 6
	jal MAKE_MOVEMENT
	
	lw ra, 0(sp)
	addi sp, sp, 4
	ret

#============================+
#	PLAYER_MOVEMENT	     |
#============================+

PLAYER_MOVEMENT:
	li t0, 0xFF200004
	lb t0, 0(t0)
	
	li t1, 'a'
	beq t0, t1, PRESS_MENU_A
	
	li t1, 'd'
	beq t0, t1, PRESS_MENU_D
	
	li t1, '\n' # Enter
	beq t0, t1, PLAYER_MAKE_MOVE
	
	li a0, -1
	ret

PRESS_MENU_A:
	addi a1, s3, -1
	li t0, 5
	bgt a1, t0, PLAYER_SELECTION
	li a1, 12
	j PLAYER_SELECTION
PRESS_MENU_D:
	addi a1, s3, 1
	li t0, 13
	blt a1, t0, PLAYER_SELECTION
	li a1, 6
PLAYER_SELECTION:
	addi sp, sp, -8
	sw ra, 0(sp)
	sw a1, 4(sp)

	li a0, 3
	li a2, 5
	li a3, 0
	li a4, 0
	
	jal BLOCK_SELECTION

	mv a1, s3
	li a2, 1
	jal BLOCK_SELECTION
	
	lw ra, 0(sp)
	lw s3, 4(sp)
	addi sp, sp, 8
	
	li a0, -1		# Player Moved to left
	ret

PLAYER_MAKE_MOVE:
	li s6, 1	# Player Moved

	addi sp, sp, -4
	sw ra, 0(sp)
	
	mv a0, s3
	jal MAKE_MOVEMENT
	
	lw ra, 0(sp)
	addi sp, sp, 4
	ret

MAKE_MOVEMENT: # a0 => Col
	addi sp, sp, -12
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)

	mv a1, a0

	addi t0, a0, -6		# s3 = Col => t0 = a0 - 6 = Current Relative Col
	la t1, CURRENT_HEIGHTS	# t1 = Height Address
	add t0, t0, t1		# addr(CURRENT_HEIGHT) + Current Relative Col
	
	lb a0, 0(t0)		# Getting the relative height of the pin
	addi a0, a0, 9		# Getting screen height
	
	lb t1, 0(t0)		# Load height
	
	addi t1, t1, -1		# t1 -= 1 => Increasing the height (Which is inverse)
	
	li t2, -7
	beq t1, t2, CANNOT_MOVE

	sb t1, 0(t0)		# Storing new height
	
	# Rendering new pin
	mv a2, s4		# Current Player
	li a3, 0
	li a4, 0
	jal BLOCK_SELECTION
	
	# Verify if Won
	addi a0, a0, -4		# Line in CURRENT_GAME matrix
	addi a1, a1, -6		# Col in CURRENT_GAME matrix
	
	li t0, 7		# t0 = 7
	mul t0, t0, a0		# t0 += a0(current_line)
	add t0, t0, a1		# t0 += a1(current_col)
	la t1, CURRENT_GAME	# t1 = CURRENT_GAME
	add t0, t0, t1		# t0 = CURRENT_GAME + current_line * 7 + current_col
	sb s4, 0(t0)		# Store player position
	
	mv a2, s4		# Player
	jal WON			# Verification if Won
	
	# ebreak
	mv s5, a0		# if Won, then a0 = 1
	
	lw ra, 0(sp)
	addi sp, sp, 12

	li t0, 3
	beq s4, t0, CHANGE_TO_PLAYER_TWO
	li s4, 3
	j END_MAKE_MOVEMENT
CHANGE_TO_PLAYER_TWO:
	li s4, 4
END_MAKE_MOVEMENT:
	ret
CANNOT_MOVE:
	lw ra, 0(sp)
	addi sp, sp, 12
	li a0, -1
	ret

#=================================================+
#	AI LOOK AROUND TO FIND BEST POSITION	  |
#=================================================+

AI_LOOK_AROUND: # a0 = Player Selection
# Return the Best col in a0
	addi sp, sp, -28
	sw s0, 0(sp)
	sw s1, 4(sp)
	sw s2, 8(sp)
	sw s3, 12(sp)
	sw s4, 16(sp)
	sw s5, 20(sp)
	sw ra, 24(sp)

	la s0, CURRENT_HEIGHTS
	li s1, 0	# Counter
	li s2, 7	# Maximum
	mv s3, a0	# Player Selection
	li s4, 0	# Selected col
	li s5, 0	# Points in Selected col

LOOP_AI_LOOK_AROUND:
	beq s1, s2, END_AI_LOOK_AROUND

	add a0, s1, s0
	lb a0, 0(a0)
	addi a0, a0, 5
	
	mv a1, s1
	mv a2, s3
	jal WON
	
	bgt s5, a0, SKIP_COL_AI
	mv s4, s1
	mv s5, a0
SKIP_COL_AI:
	
	addi s1, s1, 1
	j LOOP_AI_LOOK_AROUND

END_AI_LOOK_AROUND:
	mv a0, s4

	lw s0, 0(sp)
	lw s1, 4(sp)
	lw s2, 8(sp)
	lw s3, 12(sp)
	lw s4, 16(sp)
	lw s5, 20(sp)
	lw ra, 24(sp)
	addi sp, sp, 28

	ret

#=================+
#	WON	  |
#=================+
	
WON: # a0 => Row, a1 => Col, a2 => Number
# Pos(i, j) = Addr + i * num_cols + j

	addi sp, sp, -24
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw a0, 16(sp)
	sw s3, 20(sp)

	li s0, 0		# Counter
	la s1, DIRECTIONS_WON
	li s2, 0		# Sums
	li s3, 0		# Max Points
	mv a4, a2

LOOP_WON:
	lb a0, 16(sp)
	lb a2, 0(s1)
	lb a3, 1(s1)
	jal DIRECTION_PIECES
	
	mv s2, a0
	
	lb a0, 16(sp)
	
	lb a2, 2(s1)
	lb a3, 3(s1)
	jal DIRECTION_PIECES

	add a0, a0, s2

	bgt s3, a0, LESS_POINTS_WON	# Verify if got max points
	mv s3, a0
LESS_POINTS_WON:

	li t0, 3
	beq a0, t0, END_LOOP_WON
	
	addi s0, s0, 1
	addi s1, s1, 4
	li t0, 3

	beq s0, t0, END_LOOP_WON
	j LOOP_WON
END_LOOP_WON:
	# ebreak
	mv a0, s3

	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	lw s3, 20(sp)
	addi sp, sp, 24
	ret

DIRECTION_PIECES: # a0 => rel. line, a1 => rel. col, a2 => mov. line, a3 => mov. col, a4 => player
# Return the points accumlated
	
	la t0, CURRENT_GAME
	li t1, 0	# Points
	add t2, a0, a2	# Current Line
	add t3, a1, a3	# Current Col
DIR_PIECES_LOOP:
	# Line Analyzer
	li t5, 0
	blt t2, t5, END_DIR_PIECES_LOOP
	li t5, 6
	ble t5, t2, END_DIR_PIECES_LOOP
	# Col Analyzer
	li t5, 0
	blt t3, t5, END_DIR_PIECES_LOOP
	li t5, 7
	ble t5, t3, END_DIR_PIECES_LOOP

	li t4, 7
	mul t4, t4, t2 	# Current_line * 7
	add t4, t4, t3	# Current_line * 7 + Current_Col
	add t4, t4, t0	# CURRENT_GAME + Current_line * 7 + Current_Col
	
	lb t4, 0(t4)
	bne t4, a4, END_DIR_PIECES_LOOP
	addi t1, t1, 1
	add t2, t2, a2
	add t3, t3, a3
	j DIR_PIECES_LOOP
	
END_DIR_PIECES_LOOP:
	mv a0, t1
	ret

#=======================+
#	PRINT MAP	|
#=======================+

PRINT_MAP: # a0 = Map Selected

	addi sp, sp, -16		# sp -= 16
	sw ra, 0(sp)			# Store return address
	sw s0, 4(sp)			# Store s0
	sw s1, 8(sp)			# Store s1
	sw s2, 12(sp)			# Store s2
	
	li s0, 0			# Current Line
	li s1, 0			# Current Col
	mv s2, a0			# Current Map

LOOP_PRINT_MAP:
	mv a0, s1			# a0 = a4 = Current Block Line
	mv a1, s0			# a1 = a3 = Current Block Col
	lb a2, 0(s2)			# a2 = R[a5] = Current Block Type
	li a3, 0			# a3 = 0 = Offset_x
	li a4, 0			# a4 = 0 = Offset_y
	jal BLOCK_SELECTION		# Jump to BLOCK_SELECTION
	
	addi s2, s2, 1			# a5 += 1 => New Block Selected
	addi s0, s0, 1			# a3 += 1 => New Col
	li t0, 20			# t0 = 20
	bne t0, s0, LOOP_PRINT_MAP	# if t0 == a3, then NEW_LINE_MAP
NEW_LINE_MAP:
	addi s1, s1, 1			# a4 += 1 => New Line
	li s0, 0			# a3 = 0 => Reset Col
	li t0, 15			# t0 = 15
	bne t0, s1, LOOP_PRINT_MAP	# if t0 == a4, then PRINT_MAP

END_PRINT_MAP:
	lw ra, 0(sp)			# Load return address
	lw s0, 4(sp)			# Load s0
	lw s1, 8(sp)			# Load s1
	lw s2, 12(sp)			# Load s2
	addi sp, sp, 16			# sp += 16
	ret

#==========================+
#	MENU POSITION      |
#==========================+
CHANGE_MENU_POS:
	li t0, 0xFF200004
	lb t0, 0(t0)
	
	li t1, 'w'
	beq t0, t1, PRESS_MENU_W
	
	li t1, 's'
	beq t0, t1, PRESS_MENU_S
	
	li t1, '\n' # Enter
	beq t0, t1, SELECTED_LEVEL
	
	ret
PRESS_MENU_W:
	addi a0, s0, -3
	j END_MENU_POS_SELECTION
PRESS_MENU_S:
	addi a0, s0, 3
END_MENU_POS_SELECTION:
	li t0, 2
	beq a0, t0, END_MENU
	li t0, 14
	beq a0, t0, BEGIN_MENU
	j RENDER_MENU_INDICATOR
END_MENU:
	li a0, 11
	j RENDER_MENU_INDICATOR
BEGIN_MENU:
	li a0, 5
RENDER_MENU_INDICATOR:
	addi sp, sp, -8
	sw ra, 0(sp)
	sw a0, 4(sp)
	
	mv a1, s1
	li a2, 15
	li a3, 0
	li a4, 0
	jal BLOCK_SELECTION
	
	mv a0, s0
	li a2, 1
	jal BLOCK_SELECTION
	
	lw s0, 4(sp)
	lw ra, 0(sp)
	addi sp, sp, 8
	ret

SELECTED_LEVEL:
	li t0, 5
	beq t0, s0, LEVEL_1
	li t0, 8
	beq t0, s0, LEVEL_2
	li t0, 11
	beq t0, s0, LEVEL_3
LEVEL_1:
	li s2, 1
	j DEFINE_LEVEL
LEVEL_2:
	li s2, 2
	j DEFINE_LEVEL
LEVEL_3:
	li s2, 3

DEFINE_LEVEL:
	la ra, RENDER_MAP
	ret
	
#=============================+
#	BLOCKS SELECTION      |
#=============================+
# This procedure allows you to select blocks that you define in some map

# a0 => Block Line, a1 => Block Col, a2 => Type of Block, a3 => Offset_x, a4 => Offset_y
BLOCK_SELECTION:
	li t0, 1		
	beq a2, t0, BLOCK_1	# if a2 == 1, then BLOCK_1
	li t0, 2		
	beq a2, t0, BLOCK_2	# if a2 == 2, then BLOCK_2
	li t0, 3
	beq a2, t0, BLOCK_3	# if a2 == 3, then BLOCK_3
	li t0, 4
	beq a2, t0, BLOCK_4	# if a2 == 4, then BLOCK_3
	li t0, 5
	beq a2, t0, BLOCK_5	# if a2 == 5, then BLOCK_3
	li t0, 6
	beq a2, t0, BLOCK_6	# if a2 == 6, then BLOCK_6
	li t0, 7
	beq a2, t0, BLOCK_7	# if a2 == 7, then BLOCK_7
	li t0, 8
	beq a2, t0, BLOCK_8	# if a2 == 8, then BLOCK_8
	li t0, 9
	beq a2, t0, BLOCK_9	# if a2 == 9, then BLOCK_9
	li t0, 10
	beq a2, t0, BLOCK_10	# if a2 == 10, then BLOCK_10
	li t0, 11
	beq a2, t0, BLOCK_11	# if a2 == 11, then BLOCK_11
	li t0, 12
	beq a2, t0, BLOCK_12	# if a2 == 12, then BLOCK_12
	li t0, 13
	beq a2, t0, BLOCK_13	# if a2 == 13, then BLOCK_13
	li t0, 14
	beq a2, t0, BLOCK_14	# if a2 == 14, then BLOCK_14
	li t0, 15
	beq a2, t0, BLOCK_15	# if a2 == 14, then BLOCK_14
	ret
BLOCK_1:
	la a2, block_background
	j PRINT_BLOCK_SELECTED
BLOCK_2:
	la a2, empty_hole
	j PRINT_BLOCK_SELECTED
BLOCK_3:
	la a2, player_one
	j PRINT_BLOCK_SELECTED
BLOCK_4:
	la a2, player_two
	j PRINT_BLOCK_SELECTED
BLOCK_5:
	la a2, indicator
	j PRINT_BLOCK_SELECTED
BLOCK_6:
	la a2, A
	j PRINT_BLOCK_SELECTED
BLOCK_7:
	la a2, C
	j PRINT_BLOCK_SELECTED
BLOCK_8:
	la a2, D
	j PRINT_BLOCK_SELECTED
BLOCK_9:
	la a2, E
	j PRINT_BLOCK_SELECTED
BLOCK_10:
	la a2, F
	j PRINT_BLOCK_SELECTED
BLOCK_11:
	la a2, I
	j PRINT_BLOCK_SELECTED
BLOCK_12:
	la a2, L
	j PRINT_BLOCK_SELECTED
BLOCK_13:
	la a2, M
	j PRINT_BLOCK_SELECTED
BLOCK_14:
	la a2, O
	j PRINT_BLOCK_SELECTED
BLOCK_15:
	la a2, indicator_two
	j PRINT_BLOCK_SELECTED
PRINT_BLOCK_SELECTED:
	addi a2, a2, 8
	j PRINT_BLOCK
END_BLOCK_SELECTION:
	ret

#=============================+
#         PRINT BLOCK	      |
#=============================+

PRINT_BLOCK: # (a0 => Block Line, a1 => Block Col, a2 => Color, a3 => offset_x, a4 => offset_y)
	# (Width = 16, Height = 16) => The screen has 320X240, so you will have a grid with 20x15
	mv t0, a2			# t0 = Color Address
	li t1, 0			# t1 = Line Counter
	
NEW_BLOCK_LINE:
	# Pixel_Cell_Address = Represents the start address(or pixel) where the block will be printed
	# Pixel_Cell_Address = 0XFF000000 + 320 * line_counter + block_col * width + 320 * block_line * height
	# Pixel_Cell_Address = 0XFF000000 + 320 * line_counter + block_col * 16 + 320 * block_line * 16
	# Pixel_Cell_Address = 0XFF000000 + 64 * 5 * (line_counter + block_line * 16) + 16 * block_Col
	
	# Pixel_Cell_Address = 0XFF000000 + 64 * 5 * (line_counter + block_line * 16) + 16 * block_Col + offset_x + offset_y

	slli t2, a0, 4			# t2 = a0 << 4 = a0 * 16 = pixel_line * 16
	add t2, t2, t1			# t2 = t2 + t1 =  pixel_line * 16 + line_counter
	li t3, 5			# t3 = 5
	mul t2, t2, t3			# t2 = t2 * t3 = t2 * 5 = (pixel_line * 16 + line_counter) * 5
	slli t2, t2, 6			# t2 = t2 << 6 = t2 * 64 = (pixel_line * 16 + line_counter) * 5 * 64
	slli t3, a1, 4			# t3 = a1 << 4 = block_col * 16
	add t2, t2, t3			# t2 = t2 + t3 = (pixel_line * 16 + line_counter) * 5 * 64 + block_col * 16
	li t3, 0xFF000000		# t3 = 0xFF000000
	add t2, t2, t3 			# t2 = (pixel_line * 16 + line_counter) * 5 * 64 + block_col * 16 + 0XFF000000
	add t2, t2, a3			# t2 += a3 = Offset_x => Allows you to create an horizontal shift
	mv t3, a4			# t3 = a4 = Offset_y  => Allows you to create a vertical shift
	slli t3, t3, 6			# t3 << 6 = t3 * 64
	li t4, 5			# t4 = 5
	mul t3, t3, t4			# t3 *= 5 = Offset_y * 320
	add t2, t2, t3			# t2 += t3 = Offset_y
	
	li t3, 0			# temporary column counter
	li t4, 4			# maximum from column counter
STORE_BLOCK_COLOR:			# Store the colors from a single line
	lw t5, 0(t0)			# t5 = R[t0] = Load a word from the color 'block address'
	sw t5, 0(t2)			# t2 = R[t5] = Store the loaded color in Pixel_Cell_Address[0], ..., Pixel_Cell_Address[3]
	addi t0, t0, 4			# t0 += 4 = Next colors from 'block address'
	addi t2, t2, 4			# t2 += 4 = Next Address to store the colors
	addi t3, t3, 1			# t3 += 1 = Increase counter
	bne t3, t4, STORE_BLOCK_COLOR	# if t3 != t4, then new storage  
	
	addi t1, t1, 1			# t1 += 1 = Next line
	li t2, 16			# t2 = 16 = Maximum of lines
	
	bne t2, t1, NEW_BLOCK_LINE	# if t1 != t2, then NEW_BLOCK_LINE
	j END_BLOCK_SELECTION
