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

.text	
MAIN:
	li s0, 5 # Menu Indicator Line Position
	li s1, 5 # Menu Indicator Col Position
	li s2, 6 # Player Col

	la a0, MAP_1
	jal PRINT_MAP
	
MENU_LOOP:
	li t0, 0xFF200000
	lw t1, 0(t0)
	andi t1, t1, 0x00000001
		
	# Change Indicator Position on Menu
	beqz t1, MENU_LOOP
	jal CHANGE_MENU_POS
	j MENU_LOOP
BACK_MENU_LOOP:

EXIT:
	li a7, 10
	ecall

############################################################################
############################################################################

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
	beq a3, t0, BLOCK_4	# if a2 == 4, then BLOCK_3
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