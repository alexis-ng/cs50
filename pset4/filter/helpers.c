#include "helpers.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>



// Convert image to grayscale
void grayscale(int height, int width, RGBTRIPLE image[height][width])
{
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            float red = image[i][j].rgbtRed;
            float blue = image[i][j].rgbtBlue;
            float green = image[i][j].rgbtGreen;

            float gray = round((red + blue + green) / 3); //grayscale
            image[i][j].rgbtRed = gray;
            image[i][j].rgbtBlue = gray;
            image[i][j].rgbtGreen = gray;
        }
    }
    return;
}

// Convert image to sepia
void sepia(int height, int width, RGBTRIPLE image[height][width])
{
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            float originalRed = image[i][j].rgbtRed;
            float originalBlue = image[i][j].rgbtBlue;
            float originalGreen = image[i][j].rgbtGreen;

            float sepiaRed = .393 * originalRed + .769 * originalGreen + .189 * originalBlue;
            float sepiaGreen = .349 * originalRed + .686 * originalGreen + .168 * originalBlue;
            float sepiaBlue = .272 * originalRed + .534 * originalGreen + .131 * originalBlue;

            if (sepiaRed > 255) //if greater than 255 set to 255
            {
                sepiaRed = 255;
            }
            if (sepiaBlue > 255)
            {
                sepiaBlue = 255;
            }

            if (sepiaGreen > 255)
            {
                sepiaGreen = 255;
            }

            image[i][j].rgbtRed = round(sepiaRed);
            image[i][j].rgbtBlue = round(sepiaBlue);
            image[i][j].rgbtGreen = round(sepiaGreen);
        }
    }
    return;
}

// Reflect image horizontally
void reflect(int height, int width, RGBTRIPLE image[height][width])
{
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < (width / 2); j++)
        {
            int newpos = (width - 1) - j; //flips width

            int refRed = image[i][newpos].rgbtRed; //reflects red
            image[i][newpos].rgbtRed = image[i][j].rgbtRed;
            image[i][j].rgbtRed = refRed;

            int refBlue = image[i][newpos].rgbtBlue; //reflects blue
            image[i][newpos].rgbtBlue = image[i][j].rgbtBlue;
            image[i][j].rgbtBlue = refBlue;

            int refGreen = image[i][newpos].rgbtGreen; //reflects green
            image[i][newpos].rgbtGreen = image[i][j].rgbtGreen;
            image[i][j].rgbtGreen = refGreen;


        }
    }
    return;
}

// Blur image
void blur(int height, int width, RGBTRIPLE image[height][width])
{
    RGBTRIPLE image1[height][width]; //creates temp

    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            image1[i][j] = image[i][j];
        }
    }
    
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            int totalRed = image1[i][j].rgbtRed;
            int totalBlue = image1[i][j].rgbtBlue;
            int totalGreen = image1[i][j].rgbtGreen;
            int count = 1;


            if (i < (height - 1)) //comment
            {
                
                totalRed +=  image1[i + 1][j].rgbtRed;
                totalBlue += image1[i + 1][j].rgbtBlue;
                totalGreen += image1[i + 1][j].rgbtGreen;
                count++;
                // }
            }

            if (j < width - 1) //comment
            {
                totalRed +=  image1[i][j + 1].rgbtRed;
                totalBlue += image1[i][j + 1].rgbtBlue;
                totalGreen += image1[i][j + 1].rgbtGreen;
                count++;

            }

            if (i < (height - 1) && j < (width - 1)) //comment
            {
                totalRed +=  image1[i + 1][j + 1].rgbtRed;
                totalBlue += image1[i + 1][j + 1].rgbtBlue;
                totalGreen += image1[i + 1][j + 1].rgbtGreen;
                count++;
            }
            if (i > 0) //comment
            {
                totalRed +=  image1[i - 1][j].rgbtRed;
                totalBlue += image1[i - 1][j].rgbtBlue;
                totalGreen += image1[i - 1][j].rgbtGreen;
                count++;
            }

            if (i > 0 && j < width - 1) //comment
            {
                totalRed +=  image1[i - 1][j + 1].rgbtRed;
                totalBlue += image1[i - 1][j + 1].rgbtBlue;
                totalGreen += image1[i - 1][j + 1].rgbtGreen;
                count++;

            }

            if (j > 0)
            {
                totalRed +=  image1[i][j - 1].rgbtRed;
                totalBlue += image1[i][j - 1].rgbtBlue;
                totalGreen += image1[i][j - 1].rgbtGreen;
                count++;

            }

            if (i < height - 1 && j > 0)
            {
                totalRed +=  image1[i + 1][j - 1].rgbtRed;
                totalBlue += image1[i + 1][j - 1].rgbtBlue;
                totalGreen += image1[i + 1][j - 1].rgbtGreen;
                count++;
            }

            if (i > 0 && j > 0)
            {
                totalRed +=  image1[i - 1][j - 1].rgbtRed;
                totalBlue += image1[i - 1][j - 1].rgbtBlue;
                totalGreen += image1[i - 1][j - 1].rgbtGreen;
                count++;
            }


            int blurRed = round((float)totalRed / (float)count); //avg red
            int blurBlue = round((float)totalBlue / (float)count); //avg blue
            int blurGreen = round((float)totalGreen / (float)count); //avg green
    
            image[i][j].rgbtRed = blurRed;
            image[i][j].rgbtBlue = blurBlue;
            image[i][j].rgbtGreen = blurGreen;

        }
    }
    return;
}
