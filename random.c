#include <stdio.h>
#include <time.h>
#include <stdlib.h>

void randScatter(int START_POINT, unsigned int tracker, unsigned int max)
{
    long mask;  /* XOR Mask */
    unsigned long point;
    int val;
    unsigned int range = 0x7fff; /* 32K */

    mask = 0x6000; /* Range for 32K numbers */

    /* Now cycle through all sequence elements. */

    point = START_POINT;

    do {
        val = point % range;    /* Get random-appearing value */
		if (rand() % 2 == 0)
        	printf("%d ", val);
		else
			printf("-%d ", val);

        /* Compute the next value */

        if (point & 1) {
            /* Shift if low bit is set. */

            point = (point >> 1) ^ mask;
        } else {
            /* XOR if low bit is not set */

            point = (point >> 1);
        }
		tracker++;
    }  while (point != START_POINT && tracker < max); /* loop until we've completed cycle */
}

int	ft_atoi(char *str)
{
	if (str[0] == '0' && str[1] == '\0')
		return (0);
	int track = 0;
	int output = 0;
	if (str[0] == '-')
		track++;
	while (str[track] >= '0' && str[track] <= '9' && output >= -32767 && output <= 32767)
	{
		output = (output * 10) + (str[track] - '0');
		track++;
	}
	if (output < 0)
		output *= -1;
	return (output);
}

int main(int ac, char **av)
{
	if (av[1] == NULL || (av[1][0] != 'w' && (av[2] == NULL || av[3] == NULL || av[4] == NULL)))
	{
		printf("Incorrect Arguments Passed to RNG Generator\n");
		return (1);
	}
	if (av[1][0] == 'w')
	{
		srand(time(NULL));
		randScatter(rand() % 32767 + 1, 0, 3);
	}
	else
	{
		int rand3 = ft_atoi(av[4]);
		int	rand1 = ft_atoi(av[2]);
		if (rand1 == 0)
			rand1 = rand3;
		int	rand2 = ft_atoi(av[3]);
		if (rand2 == 0)
			rand2 = rand3;
		srand(rand1 * rand2 * (1 + rand3 % 4));
		int	input = ft_atoi(av[1]);
		randScatter(rand() % 32767 + 1, 0, input);
	}
	return (0);
}