#include <SDL3/SDL.h>
#include <SDL3/SDL_main.h>
#include "game.h"

int main() {
    // Game Initialisation
    if (!gameInit("Snake++", "Axel LT")) {
        return 1;
    }

    // Game Loop
    gameLoop();

    // Clean up and exit
    gameCleanup();

    return 0;
}
