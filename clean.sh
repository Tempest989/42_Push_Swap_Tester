#!/bin/bash

printf "rm 5.txt 100.txt 500.txt bonus_error.txt bonus.txt check.txt check_error.txt diff.txt error.txt output.txt random\n"
rm 5.txt 100.txt 500.txt bonus_error.txt bonus.txt check.txt check_error.txt diff.txt error.txt output.txt random
printf "If you have any other files like %s or %s or any other Number.txt in this directory, they can be deleted as well\n" "4.txt" "123.txt"
exit 0
