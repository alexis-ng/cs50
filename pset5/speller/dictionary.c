// Implements a dictionary's functionality

#include <stdbool.h>
#include <string.h>
#include <strings.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#include "dictionary.h"

// Represents a node in a hash table
typedef struct node
{
    char word[LENGTH + 1];
    struct node *next;
}
node;

// Number of buckets in hash table
const unsigned int N = 25;

// Hash table
node *table[N];

//word checker
node *wrd = NULL;
char *dt = NULL;
long fsize;
// int first;


// Returns true if word is in dictionary else false
bool check(const char *word)
{
    int hn = hash(word);
    int cmp = 1;

    if (table[hn] != NULL)
    {
        if (strcasecmp(table[hn]->word, word) == 0)
        {
            return true;
        }
        node *cnode = table[hn]->next;

        if (cnode)
        {
            while (strcasecmp(cnode->word, word) != 0)
            {
                // return true;

                if (cnode->next == NULL)
                {
                    return false;
                }
                else
                {
                    cnode = cnode->next;
                }

            }

            if (strcasecmp(cnode->word, word) == 0)
            {
                return true;
            }
        }
    }

    return false;

    // return true;
}

// Hashes word to a number
unsigned int hash(const char *word)
{
    int first;

    if (isupper(word[0]))
    {
        first = word[0] - 65;
    }
    if (islower(word[0]))
    {
        first = word[0] - 97;
    }


    return first;

}

// Loads dictionary into memory, returning true if successful else false
bool load(const char *dictionary)
{
    char b;
    int hn;
    char buf[LENGTH + 1];
    FILE *f;
    f = fopen(dictionary, "r");
    // int i=0;
    while (fscanf(f, "%s", buf) != EOF)
    {
        printf("read from file: %s ==> %u\n", buf, hash(buf));
        // int len = strlen(buf);

        // printf("%i\n", len);
        hn = hash(buf);
        // node* cnode = table[hn];

        // cnode =  malloc(sizeof(node));
        // strcpy(cnode->word, buf);


        if (table[hn] == NULL)
        {
            table[hn] = malloc(sizeof(node));
            strcpy(table[hn]->word, buf);
            table[hn]->next = NULL;
        }
        else
        {
            node *pnode = table[hn];
            node *cnode = table[hn]->next;

            while (cnode != NULL)
            {
                pnode = cnode;
                cnode = cnode->next;
            }

            pnode->next = malloc(sizeof(node));
            strcpy(pnode->next->word, buf);
            pnode->next->next = NULL;
        }

        printf("table->word = %s\n", table[hn]->word);

        //overflow

        // table[hn]->next = n;


        // printf("------\n");
        // i++;
    }

    // test code
    // node* testnode = table[2];
    // printf("first: %s\n",testnode->word);
    // // printf("2nd: %s\n",testnode->next->word);
    // while (testnode->next != NULL) {
    //     testnode = testnode->next;
    //     printf("second: %s\n",testnode->word);

    // break;
    // }
    // printf("++++++++\n");
    fclose(f);

    return true;

    // if (buffer != NULL)
    // {
    //     return true;
    // }
    // else
    // {
    //     return false;
    // }

}

// Returns number of words in dictionary if loaded else 0 if not yet loaded
unsigned int size(void)
{

    int count = 0;
    for (int i = 0; i < N + 1; i++)
    {
        node *head = table[i];
        while (head)
        {
            count++;
            head = head->next;
        }
    }

    return count;
}

// Unloads dictionary from memory, returning true if successful else false
bool unload(void)
{
    node *temp;

    for (int i = 0; i < N + 1; i++)
    {
        node *head = table[i];
        while (head)
        {
            temp = head;
            head = head->next;
            free(temp);
        }


    }
    return true;
    // return false;

}

