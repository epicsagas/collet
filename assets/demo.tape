Output assets/demo.gif

Set Shell "zsh"
Set FontSize 14
Set FontFamily "JetBrains Mono"
Set Width 1200
Set Height 680
Set Theme "Dracula"
Set TypingSpeed 60ms
Set Padding 20

Env PATH "/Volumes/Micron/projects/collet/target/release:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"

# Prep working directory
Type "mkdir -p /tmp/collet-demo && cd /tmp/collet-demo"
Enter
Sleep 500ms

# Create buggy file
Type "echo 'def add(a, b): return a - b' > calc.py"
Enter
Sleep 400ms

# Show the bug
Type "cat calc.py"
Enter
Sleep 800ms

# Run collet to fix the bug
Type "collet --headless -p 'Fix the bug in calc.py: add() subtracts instead of adding'"
Enter
Sleep 75s

# Show the fix
Type "cat calc.py"
Enter
Sleep 1500ms
