@ defining the CPU (Raspberry Pi 4)

.cpu cortex-a72
.fpu neon-fp-armv8


@ data section (input and output)
.data



@ text section (the code)
.text
.align 2
.global placement
.type placement, %function



placement:
push {fp, lr}
add fp, sp, #4

mov r9, r0 @the array
mov r4, r1 @voters
sub r4, r4, #1 @ voters is subtracted by 1 since blt is used for the while loop (which allows 0 to be counted in as a voter)
mov r5, r2 @booths
mov r6, #0 @counter
mov r7, #0 @counter2
mov r8, #0 @placer

firstwhileLOOP: @ while (voters >= 0) { in C
cmp r4, #0 @ checks if voters < 0
blt leave @ leaves if it's true

mov r10, #0 @ i = 0
b firstFORLOOP @ goes to the first forloop


firstFORLOOP: @ for (int i = 0; i < booths; i++) { in C
cmp r10, r5 @ checks if r10 > r5
bgt whileifstatementpartone @leaves loop if the condition is true
mov r0, #4 @ r0 = 4
mul r0, r0, r10 @ r0 = (4 * i)
add r0, r0, r9  @ r0 = 4i + sp 
ldr r1, [r0] @ loads value of array location into r1
cmp r1, #1 @ if (test[i] == 1) { in C
beq firstloopif @ goes to firstloopif if statement is true
cmp r6, r7 @ else if ((counter > counter2) && counter2 != 0) { in C
bgt firstloopfirstifelseprecursor @ goes to precursor if first condition is true
b firstloopelse @ else { in C

firstloopif:
add r6, r6, #1 @ counter++; in C
add r10, r10, #1 @ i++ in C
b firstFORLOOP @ goes back to firstFORLOOP

firstloopfirstifelseprecursor:
cmp r7, #0 @ checks if r7 != 0
bne firstloopfirstifelse @ goes to firstloopfirstifelse if condition is true
b firstloopsecondifelseprecursor @ goes to the next else if if condition isn't true

firstloopsecondifelseprecursor:
cmp r7, #0 @ checks if r7 == 0
beq firstloopfirstifelse @ goes to firstloopfirstifelse if condition is true
b firstloopelse @ else { in C

firstloopfirstifelse:
mov r7, r6 @ counter2 = counter; in C
mov r6, #0 @ counter = 0; in C
add r10, r10, #1 @ i++; in C
b firstFORLOOP @ goes back to firstFORLOOP

firstloopelse:
mov r6, #0 @ counter = 0; in C
add r10, r10, #1 @ i++; in C
b firstFORLOOP @ goes back to firstFORLOOP



whileifstatementpartone: @ if (counter2 != 0 && counter < counter2) { in C
cmp r6, r7 @ counter < counter2 in C
blt whileifstatementparttwo @ checks other condition if first is true
b whileparttwo @ goes to the next statement if not true

whileifstatementparttwo:
cmp r7, #0 @ counter2 != 0 in C
beq whileparttwo @ goes to the next statement if not true
mov r6, r7 @ counter = counter 2; in C


whileparttwo:
mov r7, #0 @ counter2 = 0; in C
mov r10, #0 @ i = 0; in C
b secondFORLOOP

secondFORLOOP: @ for (int i = 0; i < booths; i++) {
cmp r10,r5 @ checks if r10 > r5
bgt finalwhilestatement @leaves loop if the condition is true
mov r0, #4 @ r0 = 4
mul r0, r0, r10 @ r0 = (4 * i)
add r0, r0, r9  @ r0 = 4i + sp  
ldr r1, [r0] @ loads value of array location into r1
cmp r1, #1 @ if (test[i] == 1) { in C
beq secondloopif @ goes to secondloopif if statement is true
cmp r7, r6 @ else if (counter2 == counter) { in C
beq finalwhilestatement @ break; in C
add r8, r8, #1 @ placer =  placer + 1; in C
add r8, r8, r7 @ placer += counter2; in C
mov r7, #0 @ counter2 = 0; in C
add r10, r10, #1 @ i++; in C
b secondFORLOOP @ goes back to the loop

secondloopif:
add r7, r7, #1 @ counter2++; in C
add r10, r10, #1 @ i++; in C
b secondFORLOOP @ goes back to the loop

finalwhilestatement:
mov r3, #0 @ r3 = 0 (var)
sub r6, r6, #1 @ counter - 1 in C
add r3, r3, r6 @ var = counter - 1 in C
mov r2, #2 @ r2 = 2
udiv r3, r3, r2 @ (counter - 1) /2 in C
add  r8, r8, r3 @ var = placer + (((counter - 1) / 2));
mov r0, #4  @ r0 = 4
mov r1, #0 @ r1 = 0
mul r0, r0, r8 @ r0 = (4 * var)
add r0, r0, r9 @ r0 = 4var + sp
str r1, [r0] @ replaces the value of the array location with 0
mov r7, #0 @ counter2 = 0; in C
mov r6, #0 @ counter = 0; in C
mov r8, #0 @ placer = 0; in C
sub r4, r4, #1 @ voter--; in C
b firstwhileLOOP @goes back to the while loop

leave:
sub sp, fp, #4 @ restore the value of sp and fp
pop {fp, pc} @ returns to the calling function
