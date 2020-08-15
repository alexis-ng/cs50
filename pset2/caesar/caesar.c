#include <stdio.h>
#include <cs50.h>
#include <string.h>
#include <ctype.h>
#include <math.h>
#include <stdlib.h>

int convert(string plaintext, int key);
string cipher(string original, int key);
int main(int argc, string argv[])
{
    if (argc > 2) //if handle 1+ number, break
    {
        printf("Usage: ./caesar key \n");
        return 1;
    }
    if (argc == 1) //if no key, break
    {
        printf("Usage: ./caesar key \n");
        return 1;
    }
    for (int i = 1; i < strlen(argv[1]); i++) //if letter, break
    {
        if ((argv[1][i] < 48) || (argv[1][i] > 57))
        {
            printf("Usage: ./caesar key \n");
            return 1;
        }
    }
    string plain = get_string("Plaintext: ");
    int k = atoi(argv[1]);
    cipher(plain, k); //converts and prints

}

string cipher(string original, int key)
{
    int j = 0;
    int num = strlen(original);
    int neu = 0;

    printf("ciphertext: ");

    // Iterate over every character
    for (int i = 0; i < num; i++)
    {
        int n = original[i];
        int c = 0;

        if (isupper(original[i]))
        {
            c = n - 65; //sets char to 0-26
        }
        else if (islower(original[i]))
        {
            c = n - 97; //sets char to 0-26
        }

        neu = (c + key) % 26;

        if (isupper(original[i]))
        {
            char asc = neu + 65; //trans to char
            printf("%c", asc);

        }
        else if (islower(original[i]))
        {
            char asc = neu + 97; //trans to char
            printf("%c", asc);
        }
        else
        {
            printf("%c", original[i]);
        }
    }
    printf("\n");
    return 0;
}