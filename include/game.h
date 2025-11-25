#pragma once

extern SDL_Window* window;
extern SDL_Renderer* renderer;
extern SDL_Texture* mapTexture;
extern SDL_Texture* snakeTexture;

bool gameInit(const char* appName, const char* creatorName);
void gameLoop();
void gameCleanup();
