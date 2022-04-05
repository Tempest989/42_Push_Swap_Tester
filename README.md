# 42_Push_Swap_Tester
A Tester for the 42 push_swap Project


### Purpose:
- To provide a means of conducting randomized tests for any number of integers arguments.
- Provide an evaluation tester that will conduct the tests that should be done in an evaluation to test for all possible errors and conduct speed tests for 3, 5, 100 and 500 integer arguments.


### How to Run:
1. Change the ***path_locale*** variable in the `run_mac.sh` file to point to the push_swap directory being tested.
2. Change the ***bonus*** variable in the `run_mac.sh` file to 1 if the Bonus is being tested.
3. The Tester can be Ran in Terminal by:
   - `bash run_mac.sh` will run all tests that should be conducted in an evaluation.
   - `bash run_mac.sh *` will run 100 tests for * integer arguments. Making * equal to 1, 2, 3 or 5 will run the corresponding evaluation test for that number of integer arguments. 


### Checking Outputs and Inputs on Errors or otherwise:
The inputs / outputs during each test are stored in multiple, seperate files, so when an error occurs, checking these files will show the situation that occured. These Files will be Generated whilst running the Tester.  
  
The **Output** files are:
- `output.txt`: Contains the output printed to *stdout* by the tested `push_swap` executable.
- `error.txt`: Contains the output printed to *strerr* by the tested `push_swap` executable.
- `check.txt`: Contains the output printed to *stdout* by the `checker_Mac` executable, given by 42.
- `check_error.txt`: Contains the output printed to *stderr* by the `checker_Mac` executable, given by 42.
- `bonus.txt`: Contains the output printed to *stdout* by the tested `checker` executable, for the bonus of push_swap.
- `bonus_error.txt`: Contains the output printed to *stderr* by the tested `checker` executable, for the bonus of push_swap.  
  
The **Input** can be found:
- Printed to terminal.
- Or found in the `*.txt` where * stands for the current number of integer arguments being tested (for example, 100 argument test input can be found in 100.txt)
