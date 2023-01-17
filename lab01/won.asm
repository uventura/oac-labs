.data
	CURRENT_GAME:
	.byte
#	0 1 2 3 4 5 6
	0,0,0,0,0,0,0, # 0
	0,0,0,0,0,0,0, # 1
	0,0,0,0,0,0,0, # 2
	0,0,0,0,0,0,0, # 3
	0,0,0,0,0,0,0, # 4
	3,4,3,3,3,0,4, # 5
	
	HEIGHTS: .byte 4,4,4,4,4,5,4
	
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
MAIN:
	li a7, 1
	
	#li a0, 5
	#li a1, 4
	#li a2, 3
	#jal WON
	
	la a0, CURRENT_GAME
	li a1, 3
	jal AI_LOOK_AROUND
	
	li a7, 1
	ecall

	li a7, 10
	ecall

AI_LOOK_AROUND: # a0 = CURRENT BOARD, a1 = Player Selection
# Return the Best col in a0
	addi sp, sp, -28
	sw s0, 0(sp)
	sw s1, 4(sp)
	sw s2, 8(sp)
	sw s3, 12(sp)
	sw s4, 16(sp)
	sw s5, 20(sp)
	sw ra, 24(sp)

	la s0, HEIGHTS
	li s1, 0	# Counter
	li s2, 6	# Maximum
	mv s3, a1	# Player Selection
	li s4, 0	# Selected col
	li s5, 0	# Points in Selected col

LOOP_AI_LOOK_AROUND:
	beq s1, s2, END_AI_LOOK_AROUND

	add a0, s1, s0
	lb a0, 0(a0)	
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

WON: # a0 => Row, a1 => Col, a2 => Number
# Pos(i, j) = Addr + i * num_cols + j
# Return the Maximum
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
	mv a4, a2
	li s3, 0

LOOP_WON:
	lb a0, 16(sp)
	lb a2, 0(s1)
	lb a3, 1(s1)
	jal DIRECTION_PIECES
	
	#ecall

	mv s2, a0
	
	lb a0, 16(sp)
	
	lb a2, 2(s1)
	lb a3, 3(s1)
	jal DIRECTION_PIECES

	#ecall

	add a0, a0, s2
	
	bgt s3, a0, LESS_POINTS_WON	# Verify if got max points
	mv s3, a0
LESS_POINTS_WON:

	li t0, 3
	beq a0, t0, PLAYER_WON
	
	addi s0, s0, 1
	addi s1, s1, 4
	li t0, 4
	beq s0, t0, PLAYER_NOT_WON
	j LOOP_WON
PLAYER_WON:
	li a0, 4
	j END_PLAYER_WON
PLAYER_NOT_WON:
	li a0, 0
END_LOOP_WON:
	mv a0, s3
END_PLAYER_WON:
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
	
