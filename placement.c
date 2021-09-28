#include <stdio.h>

int placement (int test[], int voters, int booths) {
int counter = 0;
int counter2 = 0;
int placer = 0;
int helper = 0;
int var;
//checked

while (voters > 0) {
for (int i = 0; i < booths; i++) {
if (test[i] == 1) { 
  counter++;  // counter = 5
}

else if ((counter > counter2) && counter2 != 0) { 
  counter2 = counter;
  counter = 0;

}
else if (helper == 0) {
counter2 = counter; //counter2 = 4
counter = 0; //counter = 0
helper = 1;
}

else {
  counter = 0; 
}

}

if (counter2 != 0 && counter < counter2) {
  counter = counter2;
}
counter2 = 0;

for (int i = 0; i < booths; i++) {
if (test[i] == 1) {
  counter2++; 
}
else if (counter2 == counter) {
  break;
}
else {
  placer += (counter2 + 1);
  counter2 = 0;
}

}
var = placer + (((counter - 1) / 2)); //var = 4
counter = 0;
placer = 0;
counter2 = 0;
test[var] = 0;
helper = 0;
voters--;

}

for (int i = 0; i < booths; i++) {
  printf("%d ", test[i]);
}


return 0;
}