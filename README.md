# brainfuck-interpreter
This is a Brainfuck interpreter written in x86-64 assembly using AT&T syntax.

### Compilation
To compile the interpreter, use gcc with the -no-pie flag to disable position-independent code:
```
gcc -no-pie -o brainfuck brainfuck.s
```
### Usage
Run the interpreter with your Brainfuck source file as an argument:
```
./brainfuck my_file.b
```
Replace my_file.b with the path to your Brainfuck program.

### Example
To run a simple hello world Brainfuck program:
```
gcc -no-pie -o brainfuck brainfuck.s
./brainfuck hello_world.b
```
