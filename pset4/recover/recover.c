#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>


int main(int argc, char *argv[])
{
    if (argc != 2) //if more or less than 1 arg
    {
        printf("requires one argument");
        return 1;
    }

    // struct stat st;
    // stat(argv[1], &st);
    // int filesize = st.st_size;

    FILE *file = fopen(argv[1], "r");
    if (file == NULL)
    {
        printf("Cannot Open");
        return 1;
    }

    unsigned char *buf;
    int bufsize = 512;
    buf = (unsigned char *)malloc(bufsize * sizeof(unsigned char));

    int label = 0;
    int count = 0;
    FILE *jpg = NULL;
    while (fread(buf, 1, 512, file) == 512)
    {
        // printf("%d\n",count*512);
        count++;

        // if (jpg == NULL) {
        if (buf[0] == 0xff && buf[1] == 0xd8 && buf[2] == 0xff && (buf[3] & 0xf0) == 0xe0)
        {
            if (jpg)
            {
                fclose(jpg);
                label++;
            }
            char str[50];
            sprintf(str, "%03d.jpg", label); //writes jpg name
            jpg = fopen(str, "w"); //open new file
            if (jpg)
            {
                fwrite(buf, 512, 1, jpg); //writes old into new
//             fclose(jpg);
            }
//
        }
        else
        {
            if (jpg)
            {
                //fread 512 byte and fwrite to the jpg file
                fwrite(buf, 512, 1, jpg);
            }

        }
    }


    free(buf);
}
