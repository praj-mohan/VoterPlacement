@ defining the CPU (Raspberry Pi 4)

.cpu cortex-a72
.fpu neon-fp-armv8


@ data section (input and output)
.data
inp1: .asciz "Enter number of booths: " @ Input String
inp2: .asciz "%d" @ inputted number
inp3: .asciz "How many voters?" @ 2nd Input String
inp4: .asciz "%d" @inputted number
output4: .asciz "There isn’t enough voting booths for voters" @error message

@ text section (the code)
.text
.align 2
.global main
.type main, %function


main:

push {fp, lr} @ save fp, lr on the stack
add fp, sp, #4 @ points fp to where lr is on the stack

@printf("How many voters?"); in C
ldr r0, =inp3 @ memory is loaded into r0
bl printf

@ scanf("%d", &term); in C
ldr r0, =inp4 @r0 receives the memory from inp2
sub sp, sp, #4 @sp = sp - 4 goes up one mem location
mov r1, sp @ user input will be stored at sp loc
bl scanf
ldr r4, [sp] @ saves input into r4

@printf("Enter number of booths: "); in C
ldr r0, =inp1 @ memory is loaded into r0
bl printf

@ scanf("%d", &term); in C
ldr r0, =inp2 @r0 receives the memory from inp2
sub sp, sp, #4 @sp = sp - 4 @ goes up one mem location
mov r1, sp @ user input will be stored at sp loc
bl scanf
ldr r5, [sp] @ saves input into r5

cmp r4, r5 @ checks if the number of voters exceeeds the number of machines
bgt tooBIG @ goes to the error message if true

mov r3, #4 @ r3 = 4
mul r5, r5, r3 @ r5 = r5 * 4
sub sp, sp, r5 @ goes up several mem locations depending on r5
mov r3, #4 @ r3 = 4
udiv r5, r5, r3  @ restores r5 to the user value for booths (r5 = r5 / 4)
mov r10, #0 @ initializes the counter (r10 = i)
	 
arrayLOOP: @ for loop for creating the array

cmp r10, r5 @ checks if r10 < r5
bge loopEXIT @ exits the loop if the condition isn't true
mov r0, #4 @ r0 = 4
mov r1, #1 @ r1 = 1
mul r0, r10, r0 @ r0  = r10 * 4
add r0, sp, r0  @ sp + (4 * r10)
str r1, [r0] @ stores the value 1 into the array location
add r10, r10, #1 @ r10 is incremented by 1
b arrayLOOP @ goes back to the beginning of the loop

loopEXIT:
mov r0, sp @ moves array into r0
mov r1, r4 @ r1 = r4
mov r2, r5 @ r2 = r5
bl placement @ goes to the placement function

mov r0, sp @ moves array into r0
mov r1, r5 @ r1 = r5
bl arrayprinting



sub sp, fp, #4 @ restore the value of sp and fp
pop {fp, pc}


tooBIG:
ldr r0, =output4 @ prints out the error messsage
bl printf
sub sp, fp, #4 @ restore the value of sp and fp
pop {fp, pc} 

