.data
	CURRENT_GAME:
	.byte
#	0 1 2 3 4 5 6
	0,0,0,0,0,0,0, # 0
	0,0,0,0,0,0,0, # 1
	0,0,0,3,0,0,0, # 2
	0,0,0,4,0,0,0, # 3
	0,0,0,3,0,0,0, # 4
	0,0,0,0,0,0,0, # 5
	
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

	#li a0, 3
	#li a1, 3
	#li a2, 0
	#li a3, -1
	#li a4, 3
	#jal DIRECTION_PIECES
	li a0, 3
	li a1, 3
	li a2, 3
	jal WON
	
	li a7, 10
	ecall

WON: # a0 => Row, a1 => Col, a2 => Number
# Pos(i, j) = Addr + i * num_cols + j

	addi sp, sp, -20
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw a0, 16(sp)

	li s0, 0		# Counter
	la s1, DIRECTIONS_WON
	li s2, 0		# Sums
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
	ecall

	li t0, 3
	beq a0, t0, PLAYER_WON
	
	addi s0, s0, 1
	addi s1, s1, 4
	li t0, 4
	beq s0, t0, PLAYER_NOT_WON
	j LOOP_WON
PLAYER_WON:
	li a0, 1
	j END_LOOP_WON
PLAYER_NOT_WON:
	li a0, 0
END_LOOP_WON:
	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	addi sp, sp, 20
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
	bgt t2, t5, END_DIR_PIECES_LOOP
	# Col Analyzer
	li t5, 0
	blt t3, t5, END_DIR_PIECES_LOOP
	li t5, 7
	bgt t3, t5, END_DIR_PIECES_LOOP

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
	
