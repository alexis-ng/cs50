#include <stdio.h>
#include <cs50.h>

int main(void)
{
    int height;
    do
    {
        height = get_int("Height: \n");
    }
    while (height < 1 || height > 8);

    int n = height - (height - 1); //#
    int m = height - n; //spaces

    for (int i = 0; i < height; i++)
    {
        for (int k = 0; k < m; k++)
        {
            printf(" "); //aligns right
        }

        for (int j = 0; j < n; j++)
        {

            printf("#"); //prints left pyramid

        }

        for (int c = 0; c < 1; c++)
        {
            printf("  "); //prints space
        }

        for (int b = 0; b < n; b++)
        {
            printf("#");//prints right pyramid
        }

        printf("\n");
        n++;
        m = m - 1;



    }





}