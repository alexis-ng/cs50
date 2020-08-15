#include <stdio.h>
#include <cs50.h>
#include <math.h>

int main(void)
{


    float change;

    do
    {
        change = get_float("Change owed: \n");
    }
    while (change <= 0);

    int cents = round(change * 100);
   

    int q = cents / 25; //quarter
    
    int qr = cents % 25; //remainder

    int d = qr / 10; //# of dimes
       
    int dr = qr % 10; //remainder
  

    int n = dr / 05; //# of nickels
   
    int nr = dr % 05; //remainder
   
    int p = nr / 01; //# of pennies

    printf("%i", q + d + n + p); //total
    

}