#include <SDL3/SDL.h>
#include <SDL3_image/SDL_image.h>
#include <cmath>
#include "game.h"
#include "constants.h"

SDL_Window* window;
SDL_Renderer* renderer;
SDL_Texture* mapTexture;
SDL_Texture* snakeTexture;

bool gameInit(const char* appName, const char* creatorName) {
    // Metadata Initialization
    if (!SDL_SetAppMetadata(appName, nullptr, nullptr)) {
        SDL_Log("SDL_SetAppMetadata failed: %s", SDL_GetError());
        SDL_Quit();
        return false;
    }

    if (!SDL_SetAppMetadataProperty(SDL_PROP_APP_METADATA_NAME_STRING, appName)) {
        SDL_Log("SDL_SetAppMetadataProperty app name failed: %s", SDL_GetError());
        SDL_Quit();
        return false;
    }

    if (!SDL_SetAppMetadataProperty(SDL_PROP_APP_METADATA_CREATOR_STRING, creatorName)) {
        SDL_Log("SDL_SetAppMetadataProperty creator name failed: %s", SDL_GetError());
        SDL_Quit();
        return false;
    }

    if (!SDL_SetAppMetadataProperty(SDL_PROP_APP_METADATA_TYPE_STRING, "game")) {
        SDL_Log("SDL_SetAppMetadataProperty app type failed: %s", SDL_GetError());
        SDL_Quit();
        return false;
    }

    // SDL, window, renderer and textures initilization
    if (!SDL_Init(SDL_INIT_VIDEO)) {
        SDL_Log("SDL_Init failed: %s", SDL_GetError());
        SDL_Quit();
        return false;
    }

    if (!SDL_CreateWindowAndRenderer("Snake++", screenWidth, screenHeight, 0, &window, &renderer)) {
        SDL_Log("SDL_CreateWindowAndRenderer failed: %s", SDL_GetError());
        SDL_Quit();
        return false;
    }

    mapTexture = IMG_LoadTexture(renderer, "../assets/map.png");
    snakeTexture = IMG_LoadTexture(renderer, "../assets/snake.png");
    
    if (!mapTexture) {
        SDL_Log("Failed to load map texture: %s", SDL_GetError());
        SDL_DestroyRenderer(renderer);
        SDL_DestroyWindow(window);
        SDL_Quit();
        return false;
    }

    if (!snakeTexture) {
        SDL_Log("Failed to load snake texture: %s", SDL_GetError());
        SDL_DestroyRenderer(renderer);
        SDL_DestroyWindow(window);
        SDL_Quit();
        return false;
    }

    return true;
}

void gameLoop() {
    // Map dimensions
    float mapHeight, mapWidth;
    SDL_GetTextureSize(mapTexture, &mapWidth, &mapHeight);

    SDL_FRect viewport{mapWidth/2, mapHeight/2, screenWidth, screenHeight};
    SDL_FRect snake{mapWidth/2, mapHeight/2, 0.0f, 0.0f};
    SDL_GetTextureSize(snakeTexture, &snake.w, &snake.h);
    SDL_FRect snakeViewport{snake.x - viewport.x, snake.y - viewport.y, snake.w, snake.h};
    
    SDL_Event event;
    bool running = true;

    Uint64 perfFreq = SDL_GetPerformanceFrequency();
    Uint64 lastCounter = SDL_GetPerformanceCounter();



    float snakeAngle = 0.0f;



    while (running) {
        Uint64 currentCounter = SDL_GetPerformanceCounter();
        float deltaTime = (float)(currentCounter - lastCounter) / perfFreq; // Convert to seconds
        lastCounter = currentCounter;

        float currentZoomFactor;
        const bool* keys = SDL_GetKeyboardState(nullptr);
        while (SDL_PollEvent(&event)) {
            switch(event.type) {
                case SDL_EVENT_QUIT:
                    running = false;
                    break;
                case SDL_EVENT_MOUSE_WHEEL:
                    // Adjust viewport size based on mouse wheel scroll
                    float viewportChangeX = event.wheel.y * zoomSpeed * deltaTime;
                    float viewportChangeY = viewportChangeX * aspectRatio;
                    float newOldRatio = viewport.w / (viewport.w + viewportChangeX);

                    viewport.w += viewportChangeX;
                    viewport.h += viewportChangeY;
                    viewport.x -= viewportChangeX / 2;
                    viewport.y -= viewportChangeY / 2;

                    snakeViewport.w *= newOldRatio;
                    snakeViewport.h *= newOldRatio;

                    if (viewport.h < 500) {
                        viewport.x -= (500 / aspectRatio - viewport.w) / 2;
                        viewport.y -= (500 - viewport.h) / 2;
                        viewport.h = 500;
                        viewport.w = 500 / aspectRatio;
                        snakeViewport.w /= newOldRatio;
                        snakeViewport.h /= newOldRatio;
                    }
                    else if (viewport.h > mapHeight) {
                        viewport.x -= (mapHeight / aspectRatio - viewport.w) / 2;
                        viewport.y -= (mapHeight - viewport.h) / 2;
                        viewport.h = mapHeight;
                        viewport.w = mapHeight / aspectRatio;
                        snakeViewport.w /= newOldRatio;
                        snakeViewport.h /= newOldRatio;
                    }
                    else if (viewport.w > mapWidth) {
                        viewport.x -= (mapWidth * aspectRatio - viewport.w) / 2; // Not sure about *
                        viewport.y -= (mapWidth - viewport.h) / 2;
                        viewport.w = mapWidth;
                        viewport.h = mapWidth * aspectRatio;
                        snakeViewport.w /= newOldRatio; // Not sure about /
                        snakeViewport.h /= newOldRatio;
                    }

                    if (viewport.x < 0) viewport.x = 0;
                    else if (viewport.x + viewport.w > mapWidth) viewport.x = mapWidth - viewport.w;
                    if (viewport.y < 0) viewport.y = 0;
                    else if (viewport.y + viewport.h > mapHeight) viewport.y = mapHeight - viewport.h;
                    break;
            }
        }

        // Handle viewport movement
        float dx{0.0f};
        float dy{0.0f};
        float length{0.0f};
        
        if (keys[SDL_SCANCODE_W]) dy -= 1.0f;
        if (keys[SDL_SCANCODE_S]) dy += 1.0f;
        if (keys[SDL_SCANCODE_A]) dx -= 1.0f;
        if (keys[SDL_SCANCODE_D]) dx += 1.0f;
        length = std::sqrt(dx * dx + dy * dy);

        if (length > 0.0f) {
            if (dx != 0.0f) viewport.x += viewportSpeed * deltaTime * dx / length;
            if (dy != 0.0f) viewport.y += viewportSpeed * deltaTime * dy / length;
        }

        if (viewport.x < 0) viewport.x = 0;
        else if (viewport.x + viewport.w > mapWidth) viewport.x = mapWidth - viewport.w;
        if (viewport.y < 0) viewport.y = 0;
        else if (viewport.y + viewport.h > mapHeight) viewport.y = mapHeight - viewport.h;

        currentZoomFactor = screenWidth / viewport.w;

        // Snake movement
        float currentSnakeSpeed = snakeSpeed;
        SDL_PumpEvents();
        if (keys[SDL_SCANCODE_Q]) snakeAngle -= (snakeAngle > -360.0f) ? snakeRotationSpeed * deltaTime: -360.0f;
        if (keys[SDL_SCANCODE_E]) snakeAngle += (snakeAngle < 360.0f) ? snakeRotationSpeed * deltaTime: -360.0f;
        if (keys[SDL_SCANCODE_SPACE]) currentSnakeSpeed *= snakeDashMultiplier;

        snake.x += currentSnakeSpeed * deltaTime * std::cos(snakeAngle * M_PI / 180.0f);
        snake.y += currentSnakeSpeed * deltaTime * std::sin(snakeAngle * M_PI / 180.0f);
        
        if (snake.x < 0) snake.x = 0;
        else if (snake.x + snake.w > mapWidth) snake.x = mapWidth - snake.w;
        if (snake.y < 0) snake.y = 0;
        else if (snake.y + snake.h > mapHeight) snake.y = mapHeight - snake.h;

        snakeViewport.x = (snake.x - viewport.x) * currentZoomFactor;
        snakeViewport.y = (snake.y - viewport.y) * currentZoomFactor;
        
        SDL_RenderClear(renderer);
        SDL_RenderTexture(renderer, mapTexture, &viewport, nullptr);
        SDL_RenderTextureRotated(renderer, snakeTexture, nullptr, &snakeViewport, snakeAngle, nullptr, SDL_FLIP_NONE);
        SDL_RenderPresent(renderer);

        float targetFrameTime = 1.0f / TARGET_FPS;
        float frameTime = (float)(SDL_GetPerformanceCounter() - currentCounter) / perfFreq;
        if (frameTime < targetFrameTime) SDL_Delay((Uint32)((targetFrameTime - frameTime) * 1.0e3f));
    }
}

void gameCleanup() {
    SDL_DestroyTexture(mapTexture);
    SDL_DestroyTexture(snakeTexture);
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
}
