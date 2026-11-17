# Snake ASM

LLMs are cool and all, but let's sit down and do some hand coding.
This project recreates the classic game SNAKE in assembly.
To split the work, we (Brandon and David) *will* individually create two clients for a two peer, multiplayer SNAKE game.

> Mmmm, I guess "will" can become "have created" once we're done.

## Protocol

Before we *delve* into assembly, we need to devise a simple game protocol.
Here is our protocol:

Our clients connect peer to peer using fixed ports:

- Brandon's server: 6769
- David's server 6967

We also need agree on a tick rate.
We will use ***TODO*** ticks per second.

At start, create a server socket then poll until both clients are connected.
After both clients issue `COMMAND_READY`, the game starts.
`COMMAND_READY` should contain the size of the game window.
The minimum of the two should be used as the game size.

When both clients issue and receive `COMMAND_EAT_AND_GEN_SNACK`, average and ceil the result.
This averaged coordinate will be the location of the next snack.
Coordinates should be sent as screen coordinates, ie (0, 0) top left with the horizontal axis as `x`.

### Protocol

```C
typedef enum {
    // Takes [uint32_t width, uint32_t height]
    COMMAND_READY,
    COMMAND_GAME_END,
    // Takes [uint32_t direction]
    COMMAND_UPDATE_DIRECTION,
    // Takes [uint32_t x, uint32_t y]
    COMMAND_EAT_AND_GEN_SNACK,
} Commands;

typedef enum {
    DIRECTION_UP,
    DIRECTION_DOWN,
    DIRECTION_LEFT,
    DIRECTION_RIGHT,
} Direction;

typedef struct {
    uint32_t command_byte;
    union {
        uint32_t direction;
        uint32_t width;
        uint32_t x;
    } byte1;
    union {
        uint32_t height;
        uint32_t y;
    } byte2;
} NetworkPacket;
```

