#!/bin/bash

#-------------------------------------------------------------------------------------

# What you can change

path_locale="${HOME}/Documents/42/push_swap/"
# path_locale="../push_swap/"
bonus=0
system="linux"

# PLEASE DON'T CHANGE ANYTHING BELOW THIS LINE UNLESS YOU MEAN TO CHANGE THE TESTER

#--------------------------------------------------------------------------------------

parameter_num=$1
check='^[0-9]+$'

function call_working
{
	if [ "${1}" -ne "0" ]
	then
		printf "${2} Call has Failed\n"
		exit 0
	fi	
}

function stats_update
{
	lines=$(wc -l < output.txt)
	call_working $? "Word Count Core Function"

	track=$((track+lines))
	(( completed += 1 ))
	if [ "${lines}" -lt "${min}" ]
	then
		min=${lines}
	elif [ "${min}" -eq "-1" ]
	then
		min=${lines}
	fi
	if [ "${lines}" -gt "${max}" ]
	then
		max=${lines}
	fi
}

function stats_output
{
	printf "\nCompleted %d Number Tests Successfully!!\n" "${1}"
	printf "\nCompleted %d Tests\n" "${completed}"
	printf "\nTotal Moves = %d\n" "${track}"
	printf "\nMinimum Moves = %d\n" "${min}"
	printf "Maximum Moves = %d\n" "${max}"
	printf "\nAverage Moves = "
	echo $((${track} / ${completed}))
	printf "\n"
	echo "------------------------------------------------"
	printf "\n"
}

function ko_error_checks
{
	checker_output=$(cat check.txt)
	call_working $? "Cat Core Function"

	checker_error=$(cat check_error.txt)
	call_working $? "Cat Core Function"

	error_check=$(cat error.txt)
	call_working $? "Cat Core Function"

	if [ "${checker_error}" == "Error" ] && [ "${error_check}" != "Error" ]
	then
		printf "Checker gave an Error whilst Push_Swap gave None or an Incorrect Error Message: "
		tput bold
		tput smso
		tput setaf 1
		printf "KO\n\n"
		tput sgr0
		printf "Hint: Error Messages Do Not Go through Stdout, Check Subject.pdf\n"
		exit 0
	elif [ "${checker_error}" != "Error" ] && [ "${error_check}" == "Error" ]
	then
		printf "Checker gave no Error whilst Push_Swap gave Error: "
		tput bold
		tput smso
		tput setaf 1
		printf "KO\n\n"
		tput sgr0
		exit 0
	elif [ "${checker_error}" == "Error" ] && [ "${error_check}" == "Error" ]
	then
		check=$(wc -l < output.txt)
		call_working $? "Word Count Core Function"

		if [ "${check}" -ne "0" ]
		then
			printf "Other Output given apart from Error: "
			tput bold
			tput smso
			tput setaf 1
			printf "KO\n\n"
			tput sgr0
			exit 0
		fi
	elif [ "${check_output}" == "KO" ]
	then
		printf "Checker Output: "
		tput bold
		tput smso
		tput setaf 1
		printf "KO\n\n"
		tput sgr0
		printf "Please Check ${1}.txt for the Given Input, output.txt for Push_Swap's Output, errror.txt for Push_Swap's Error Output and Check.txt for the Checker's Output.\n"
		exit 0
	fi
	if [ "${bonus}" -eq "2" ]
	then
		exit 0
	fi
}

function checker_timeout
{
	if [ "${1}" -eq "142" ]
	then
		printf "Checker Stopped Due to Timeout! (over 1 second)\n"
		exit 0
	elif [ "${1}" -ne "0" ] && [ "${1}" -ne "255" ]
	then
		printf "Error Returned from Checker Executable. %d\n" "${outcome}"
		exit 0
	fi
}

function normal_timeout
{
	if [ "${1}" -eq "142" ]
	then
		printf "${2} Stopped Due to Timeout! (over 1 second)\n"
		exit 0
	elif [ "${1}" -ne "0" ]
	then
		printf "\nNon-Zero Exit Status returned from ${2} Executable.\n\n"
		printf "Please Make all Exit Statuses 0. Except if a Major Error occurs where the Running of the Tester should be Stopped, such as Malloc Function Call Failing etc and Not when an Invalid Input is Given etc.\n\n"
		exit 0
	fi
}

function bonus_file_check
{
	diff $1 $2 > diff.txt
	outcome=$?
	if [ "${outcome}" -gt "1" ]
	then
		printf "Diff Core Function Call Failed\n"
	elif [ "${outcome}" -eq "1" ]
	then
		printf "Bonus Checker Output and Proper Checker Output Different\n"
		bonus=2
	fi
}

function basics_test
{
	if [ "$#" -eq "5" ]
	then
		timeout -k 1s 1s ${path_locale}push_swap $1 $2 $3 $4 $5 2> error.txt 1> output.txt
	elif [ "$#" -eq "1" ]
	then
		timeout -k 1s 1s ${path_locale}push_swap $1 2> error.txt 1> output.txt
	elif [ "$#" -eq "2" ]
	then
		timeout -k 1s 1s ${path_locale}push_swap $1 $2 2> error.txt 1> output.txt
	elif [ "$#" -eq "3" ]
	then
		timeout -k 1s 1s ${path_locale}push_swap $1 $2 $3 2> error.txt 1> output.txt
	else
		timeout -k 1s 1s ${path_locale}push_swap 2> error.txt 1> output.txt
	fi

	normal_timeout $? "Push_Swap"

	if [ "$#" -eq "5" ]
	then
		timeout -k 1s 1s ./checker_${system} $1 $2 $3 $4 $5 < output.txt 2> check_error.txt 1> check.txt
	elif [ "$#" -eq "1" ]
	then
		timeout -k 1s 1s ./checker_${system} $1 < output.txt 2> check_error.txt 1> check.txt
	elif [ "$#" -eq "2" ]
	then
		timeout -k 1s 1s ./checker_${system} $1 $2 < output.txt 2> check_error.txt 1> check.txt
	elif [ "$#" -eq "3" ]
	then
		timeout -k 1s 1s ./checker_${system} $1 $2 $3 < output.txt 2> check_error.txt 1> check.txt
	else
		timeout -k 1s 1s ./checker_${system} < output.txt 2> check_error.txt 1> check.txt
	fi

	checker_timeout $?

	if [ "${bonus}" -eq "1" ]
	then
		if [ "$#" -eq "5" ]
		then
			timeout -k 1s 1s ${path_locale}checker $1 $2 $3 $4 $5 < output.txt 2> bonus_error.txt 1> bonus.txt
		elif [ "$#" -eq "1" ]
		then
			timeout -k 1s 1s ${path_locale}checker $1 < output.txt 2> bonus_error.txt 1> bonus.txt
		elif [ "$#" -eq "2" ]
		then
			timeout -k 1s 1s ${path_locale}checker $1 $2 < output.txt 2> bonus_error.txt 1> bonus.txt
		elif [ "$#" -eq "3" ]
		then
			timeout -k 1s 1s ${path_locale}checker $1 $2 $3 < output.txt 2> bonus_error.txt 1> bonus.txt
		else
			timeout -k 1s 1s ${path_locale}checker < output.txt 2> bonus_error.txt 1> bonus.txt
		fi

		normal_timeout $? "Bonus Checker"

		bonus_file_check "check.txt" "bonus.txt"
		bonus_file_check "check_error.txt" "bonus_error.txt"
	fi

	ko_error_checks $#

	stats_update
}

function large_tests
{
	txtfile="${1}.txt"
	timeout -k 1s 1s ./random w > $txtfile

	normal_timeout $? "Initial RNG Script"

	track=0
	completed=0
	max=0
	min=-1

	while [ "${completed}" -lt "100" ]
	do
		ran_parameters=$(awk '{ print $1, $2, $3; exit }' $txtfile)

		timeout -k 1s 1s ./random ${1} ${ran_parameters} > $txtfile

		normal_timeout $? "RNG Script"

		# input=$(cat $txtfile)
		# call_working $? "Cat Core Function"

		timeout -k 1s 1s xargs -a $txtfile ${path_locale}push_swap 2> error.txt 1> output.txt
		
		normal_timeout $? "Push_Swap"

		timeout -k 1s 1s xargs -a $txtfile ./checker_${system} < output.txt 2> check_error.txt 1> check.txt

		checker_timeout $?

		if [ "${bonus}" -eq "1" ]
		then
			timeout -k 1s 1s xargs -a $txtfile ${path_locale}checker < output.txt 2> bonus_error.txt 1> bonus.txt

			normal_timeout $? "Bonus Checker"

			bonus_file_check "check.txt" "bonus.txt"
			bonus_file_check "check_error.txt" "bonus_error.txt"
		fi

		ko_error_checks $1

		stats_update
	done

	stats_output ${1}
}

function indentity_tests
{
	if [ "$#" -eq "1" ]
	then
		timeout -k 1s 1s ${path_locale}push_swap ${1} &> output.txt
	elif [ "$#" -eq "4" ]
	then
		timeout -k 1s 1s ${path_locale}push_swap ${1} ${2} ${3} ${4} &> output.txt
	else
		timeout -k 1s 1s ${path_locale}push_swap ${1} ${2} ${3} ${4} ${5} ${6} ${7} ${8} ${9} ${10} &> output.txt
	fi
	normal_timeout $? "Push_Swap"
	if [ -s output.txt ]
	then
		printf "Output Given when Stack is inputted in ascending order: "
		tput bold
		tput smso
		tput setaf 1
		printf "KO\n\n"
		tput sgr0
		exit 0
	fi
}

function additional_bonus_tests
{
	timeout -k 1s 1s ./checker_${system} ${1} < output.txt 2> check_error.txt 1> check.txt

	checker_timeout $?

	if [ "${bonus}" -eq "1" ]
	then
		timeout -k 1s 1s ${path_locale}checker ${1} < output.txt 2> bonus_error.txt 1> bonus.txt

		normal_timeout $? "Bonus Checker"

		bonus_file_check "check.txt" "bonus.txt"
		bonus_file_check "check_error.txt" "bonus_error.txt"
	fi
	if [ "${bonus}" -eq "2" ]
	then
		exit 0
	fi
}

if [ "$#" -eq "0" ]
then
	parameter_num=1
fi

if ! [[ $parameter_num =~ $check ]]
then
	printf "Please Provide a Valid Number of Arguements to be Given to the Push_Swap Executable\nValid Arguments are from 1 or above or No Arguments at all to Run All Tests\n"
	exit 0
fi

if ! [[ $bonus =~ $check ]] || [[ $bonus -ne "0" && $bonus -ne "1" ]]
then
	printf "Change the bonus variable to equal either 0 or 1 at the top of fast.sh.\n"
	exit 0
fi

if [ "${system}" != "mac" ] && [ "${system}" != "linux" ]
then
	printf "Change the system variable to equal either mac or linux at the top of fast.sh.\n"
	exit 0
fi

file_type="${parameter_num}.txt"

if [ ! -f "${path_locale}push_swap" ]
then
	printf "Compiled Executable push_swap not found!\nAttempting to Compile Via Makefile...\n"
	if [ ! -f "${path_locale}Makefile" ]
	then
		printf "No Makefile Found, Please Create One or Compile Your Push_Swap Project Before Running this Script!\n"
		printf "And Make Sure the path_locale Variable in fast.sh is Pointing to the Correct Directory.\n"
		exit 0
	else
		printf "Running Make...\n"
		if ! make -C ${path_locale}
		then
			printf "Make Call Failed!\n"
			exit 0
		fi
		if [ ! -f "${path_locale}push_swap" ]
		then
			printf "\nWrong Name for Compiled Executable, Please Change Executable Name in Either the Makefile or during your own Compiling before Running This Script!\n"
			exit 0
		fi
		printf "Project Compiled Successfully via Makefile!!\n\n"
	fi
fi

if [ "${bonus}" -eq "1" ] && [ ! -f "${path_locale}checker" ]
then
	printf "Compiled Executable checker not found!\nAttempting to Compile Via Makefile...\n"
	if [ ! -f "${path_locale}Makefile" ]
	then
		printf "No Makefile Found, Please Create One or Compile Your Push_Swap Project Before Running this Script!\n"
		exit 0
	else
		printf "Running Make...\n"
		if ! make bonus -C ${path_locale}
		then
			exit 0
		fi
		if [ ! -f "${path_locale}checker" ]
		then
			printf "\nWrong Name for Compiled Executable, Please Change Executable Name in Either the Makefile or in this run.sh Script!\n"
			exit 0
		fi
		printf "Project Compiled Successfully via Makefile!!\n\n"
	fi
fi

if [ "$parameter_num" -eq "1" ]
then
	printf "\n------------Starting 1 Number Tests:------------\n\n"
	max=0
	min=-1
	completed=0
	track=0
	printf "Testing Input: Nothing\n"
	basics_test
	printf "Testing Input: -12\n"
	basics_test -12
	printf "Testing Input: 12\n"
	basics_test 12
	printf "Testing Input: 0\n"
	basics_test 0
	printf "Testing Input: 2147483647\n"
	basics_test 2147483647
	printf "Testing Input: -2147483648\n"
	basics_test -2147483648
	printf "Testing Input: 2147483648\n"
	basics_test 2147483648
	printf "Testing Input: -2147483649\n"
	basics_test -2147483649
	printf "Testing Input: abc\n"
	basics_test abc
	printf "Testing Input: 12abc14\n"
	basics_test 12abc14
	printf "Testing Input: Null Terminating Character\n"
	basics_test ""
	stats_output 1
fi

if [ "$#" -eq "0" ]
then
	parameter_num=2
fi
if [ "$parameter_num" -eq "2" ]
then
	printf "\n------------Starting 2 Numbers Tests:-----------\n\n"
	max=0
	min=-1
	completed=0
	track=0
	printf "Testing Input: 14 12\n"
	basics_test 14 12
	printf "Testing Input: -12 14\n"
	basics_test -12 14
	printf "Testing Input: -12 -14\n"
	basics_test -12 -14
	printf "Testing Input: 12 12\n"
	basics_test 12 12
	printf "Testing Input: -12 -12\n"
	basics_test -12 -12 
	printf "Testing Input: 12 -12\n"
	basics_test 12 -12
	printf "Testing Input: 87 2147483647\n"
	basics_test 87 2147483647
	printf "Testing Input: -99 -2147483648\n"
	basics_test -99 -2147483648
	printf "Testing Input: 1 2147483648\n"
	basics_test 1 2147483648
	printf "Testing Input: 3434 -2147483649\n"
	basics_test 3434 -2147483649
	printf "Testing Input: -8764 abc\n"
	basics_test -8764 abc
	printf "Testing Input: 12345 12abc14\n"
	basics_test 12345 12abc14
	printf "Testing Input: 404 Null Terminating Character\n"
	basics_test 404 ""
	stats_output 2
fi

if [ "$#" -eq "0" ]
then
	parameter_num=3
fi
if [ "$parameter_num" -eq "3" ]
then
	printf "\n------------Starting 3 Numbers Tests:-----------\n\n"
	max=0
	min=-1
	completed=0
	track=0
	printf "Testing Input: 1 2 3\n"
	basics_test 1 2 3
	printf "Testing Input: 1 3 2\n"
	basics_test 1 3 2
	printf "Testing Input: 2 1 3\n"
	basics_test 2 1 3
	printf "Testing Input: 2 3 1\n"
	basics_test 2 3 1
	printf "Testing Input: 3 1 2\n"
	basics_test 3 1 2
	printf "Testing Input: 3 2 1\n"
	basics_test 3 2 1
	stats_output 3
fi

if [ "$#" -eq "0" ]
then
	parameter_num=5
fi

if [ "$parameter_num" -eq "5" ]
then
	printf "\n------------Starting 5 Numbers Tests:-----------\n"
	max=0
	min=-1
	completed=0
	track=0
	if [ ! -f "Combinations_of_5.txt" ]
	then
		printf "\nCombinations_of_5.txt file doesn't exist, please re-create it manually or by the Git.\n"
		exit 0
	fi
	while read line
	do
		echo ${line} > 5.txt
		basics_test ${line}
	done < Combinations_of_5.txt
	basics_test ${line}
	stats_output 5
fi

if [ "$#" -eq  "0" ]
then
	printf "\n------------Starting Identity Tests:------------\n\n"
	printf "Testing Input: 42\n"
	indentity_tests 42
	printf "Testing Input: 0 1 2 3\n"
	indentity_tests 0 1 2 3
	printf "Testing Input: 0 1 2 3 4 5 6 7 8 9\n"
	indentity_tests 0 1 2 3 4 5 6 7 8 9
	printf "\nFinshed All Indentity Tests Successfully!\n\n"
	echo "------------------------------------------------"
	printf "\n\n"
fi

if [ ! -f "random" ] 
then
	printf "Generating RNG Executable....\n"
	if ! gcc random.c -o random
	then
		printf "RNG Compilation Failed!\n"
		exit 0
	fi
	printf "Generation of RNG Executable: Successful!\n\n"
fi

if [ "$#" -eq "0" ]
then
	printf "\n------------Starting 100 Numbers Tests:---------\n"
	large_tests 100
	printf "\n------------Starting 500 Numbers Tests:---------\n"
	large_tests 500
fi
if [ "$#" -ne "0" ] && [ "${parameter_num}" -ne "1" ] && [ "${parameter_num}" -ne "2" ] && [ "${parameter_num}" -ne "3" ] && [ "${parameter_num}" -ne "5" ]
then
	printf "\n------------Starting %d Numbers Tests:----------\n\n" "${parameter_num}"
	large_tests ${parameter_num}
fi

if [ "${bonus}" -eq "1" ]
then
	printf "\n------------Additional Tests for Bonus:---------\n\n"
	printf "Given Input Will be: -13\n"
	printf "\nCurrent Output Commands Given: sa ra s\n"
	printf "sa\nra\ns\n" > output.txt
	additional_bonus_tests -13
	printf "Current Output Commands Given: ra rr!\n"
	printf "ra\nrr!\n" > output.txt
	additional_bonus_tests -13
	printf "Current Output Commands Given: sa rraextra\n"
	printf "sa\nrraextra\n" > output.txt
	additional_bonus_tests -13
	printf "Current Output Commands Given: sa (no "
	echo "\n)"
	printf "sa" > output.txt
	additional_bonus_tests -13
	printf "\nGiven Input Will be: 1 2 3 4\n"
	printf "\nCurrent Output Commands Given: pb\n"
	printf "pb\n" > output.txt
	additional_bonus_tests 1 2 3 4
	printf "\nFinshed All Additional Bonus Tests Successfully!\n\n"
	echo "------------------------------------------------"
	printf "\n\n"
fi

tput bold
tput smso
printf "Finished Testing\n"
tput setaf 2 
if [ "$#" -eq "0" ]
then
	printf "Mandatory "
else
	printf "%d Numbers Tests " "${parameter_num}"
fi
if [ "${bonus}" -eq "1" ]
then
	printf "and Bonus "
fi
printf "PASSED!!! CONGRATULATIONS!\n\n"
tput sgr0
exit 0