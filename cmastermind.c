//Angeline Vu
#include <stdio.h>
#include <string.h>
#include <time.h>
#include "mt19937.h"

//prototypes
char generate_random();

int main(void)
{
	//seed
	init_genrand(time(0));
	char password[7] = "      \0";
	char guess[7] = "      \0";
	int win = 0;			//no bools :(

	int pw_flags[6];		//case flags
	int guess_flags[6];		

	printf("\n\t\t- M A S T E R M I N D -\n\nUsing hex digits [0-9a-f], deduce the 6 digit password.\n\n    X: a digit entered is in the correct position\n    0: a digit entered is in the wrong position\n\nEnsure only 6 digits per guess. You have 20 attempts.\n\n");

	//generate password
	int digit = 0;
	for (int i = 0; i < 6; ++i)
		password[i] = generate_random();

	//printf("password: %s\n", password);

	//get user input
	char ch;
	for (int i = 0; i < 20; ++i)
	{

		digit = 0;
		printf("Attempt #%d: ", i + 1);
		do
		{
			scanf(" %c", &ch);
			guess[digit] = ch;
			++digit;
		} while (digit < 6);

		//check guess
		if (!strcmp(password, guess))
		{
			win = 1;
			break;
		}

		//reset flags
		for (int i = 0; i < 6; ++i)
		{
			pw_flags[i] = 0;
			guess_flags[i] = 0;
		}

		//check correct digit in position
		int count = 0;
		for (int i = 0; i < 6; ++i)
		{
			if (guess[i] == password[i])
			{
				pw_flags[i] = 1;
				guess_flags[i] = 1;
				++count;
			}
		}

		//print correct number of
		for (int i = 0; i < count; ++i)
			printf("X");

		//check correct digit not in position
		for (int i = 0; i < 6; ++i)
		{
			if (!pw_flags[i])
			{
				for (int j = 0; j < 6; ++j)
				{
					if (password[i] == guess[j] && !guess_flags[j])
					{
						printf("0");
						guess_flags[j] = 1;
						break;
					}
				}
			}
		}
		printf("\n\n");
	}

	if (win)
		printf("\nGood job, Mastermind. You entered the correct password.\n");
	else
		printf("\nYou are no Mastermind. Better luck next time. %s\n", password);
	return 0;
}

//returns a random char [0-9a-f]
char generate_random()
{
	char alphabet[16] = "0123456789abcdef";
	int rand = genrand_int31();
	return alphabet[rand%16];
}
