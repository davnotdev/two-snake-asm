# Resources and Research

Useful resources for development.

## Assembly Resources

- https://web.stanford.edu/class/cs107/resources/x86-64-reference.pdf
- `%rcx` and `%r11` are not preserved after system call

## Linux System Calls

- https://filippo.io/linux-syscall-table/

## Terminal Rendering 

We need to use ANSI escape sequences.
I typically use a library like `ncurses` or `termbox` to do this, but obviously we can't use those in good faith for this project.
From my testing:

```C
#include <stdio.h>
#include <time.h>

void sleep_ms(long msec) {
    struct timespec ts;
    ts.tv_sec = msec / 1000;
    ts.tv_nsec = (msec % 1000) * 1000000;
    nanosleep(&ts, &ts);
}

int main() {
    // Disable cursor.
    printf("\033[?25l");

    int movedown = 1;
    int counter = 0;

    // Move to (0, 0)
    printf("\033[0;0H");

    while (1) {
        // Move to (0, 0)
        printf("\033[0;0H");

        if (movedown) {
            for (int i = 0; i < counter; i++) {
                // Move Down 2 Units
                printf("\033[2B");
            }
            // Move to column 0
            printf("\033[0G");
            counter++;
        } else {
            counter--;
            for (int i = 0; i < counter; i++) {
                // Move Down 2 Units
                printf("\033[2B");
            }
            // Move to column 0
            printf("\033[0G");
        }

        if (counter <= 0) {
            movedown = 1;
        }

        if (counter >= 10) {
            movedown = 0;
        }

        printf("Hello Counter: %d", counter);

        fflush(stdout);
        sleep_ms(200);

        // Move to column 0
        printf("\033[0G");
        // Clear Screen
        printf("\033[2J");
    }
}
```

- https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797

Getting terminal size

#include <sys/ioctl.h>
#include <stdio.h>
#include <unistd.h>

```C
int main (int argc, char **argv)
{
    struct winsize w;
    ioctl(STDOUT_FILENO, TIOCGWINSZ, &w);

    printf ("lines %d\n", w.ws_row);
    printf ("columns %d\n", w.ws_col);
    return 0;  // make sure your main returns int
}
```

- https://stackoverflow.com/questions/1022957/getting-terminal-width-in-c

## Raw Terminal 

We need enable raw terminal mode using `ioctl`.

- https://viewsourcecode.org/snaptoken/kilo/02.enteringRawMode.html
- https://www.man7.org/linux/man-pages/man3/tcsetattr.3p.html
- https://github.com/kraj/musl/blob/3e699121d78610e42a4eb36c3420486f2bfb5217/src/termios/tcsetattr.c#L5

