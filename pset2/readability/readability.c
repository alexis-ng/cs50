#include <stdio.h>
#include <cs50.h>
#include <string.h>
#include <ctype.h>
#include <math.h>

int count_letter(int num, string text);
int count_words(int num, string text);
int count_sent(int num, string text);
float letter_avg(int letter, int word);
float sent_avg(int sentence, int word);
float index(float L, float S);

int main(void)
{
    string text = get_string("Text: "); //text
    int number = strlen(text);

    int letter = count_letter(number, text); //letter #
    // printf("%i letter(s)\n", letter);

    int word = count_words(number, text); //word #
    // printf("%i word(s)\n", word);

    int sent = count_sent(number, text); //sent #
    // printf("%i sentence(s)\n", sent);

    float l_avg = letter_avg(letter, word); //L
    // printf("%i\n", l_avg);

    float s_avg = sent_avg(sent, word); //S
    // printf("%f\n", s_avg);

    index(l_avg, s_avg); //index
    // printf("Grade %1.0f", round(ind));




}

int count_letter(int num, string text)
{
    int j = 0;
    int l = 0;

    for (int i = 0; i < num; i++)
    {
        char c = text[j];
        if (isalpha(c))
        {
            l++;
        }
        j++;
    }

    return l;
}

int count_words(int num, string text)
{
    int j = 0;
    int w = 1;

    for (int i = 0; i < num; i++)
    {
        char c = text[j];
        if (isspace(c))
        {
            w++;
        }
        j++;
    }

    return w;
}

int count_sent(int num, string text)
{
    int j = 0;
    int s = 0;

    for (int i = 0; i < num; i++)
    {
        char c = text[j];
        if (c == '.' || c == '!' || c == '?')
        {
            s++;
        }
        j++;
    }
    return s;
}

float letter_avg(int letter, int word)
{
    float l = letter * 100;
    float avg = l / word;
    return avg;
}

float sent_avg(int sentence, int word)
{
    float s = sentence * 100;
    float avg = s / word;
    return avg;
}

float index(float L, float S)
{
    float index = 0.0588 *  L - 0.296 *  S - 15.8;

    if (index < 1)
    {
        printf("Before Grade 1\n");
    }
    else if (index > 16)
    {
        printf("Grade 16+\n");
    }
    else
    {
        printf("Grade %1.0f\n", round(index));

    }

    return index;
}