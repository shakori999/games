import os, sys, random
import pygame
from pygame.locals import *
from tkinter import filedialog
from tkinter import *

pygame.init()

# variablers will be use durring the program
vec = pygame.math.Vector2
h = 350
w = 700
acc = 0.3
fric = -0.10
fps = 60
fps_clock = pygame.time.Clock()
count = 0

#the main screen and the caption varibals
screen = pygame.display.set_mode((w, h))
pygame.display.set_caption("RPG")


class Background(pygame.sprite.Sprite):
    def __init__(self):
        super().__init__()
        self.bg_image = pygame.image.load("BG/sky.png")
        self.bg_Y = 0
        self.bg_X = 0
    def render(self):
        screen.blit(self.bg_image, (self.bg_X, self.bg_Y))
        

class Ground(pygame.sprite.Sprite):
    def __init__(self):
        super().__init__()
        self.image = pygame.image.load("BG/bgtrue.png")
        self.rect = self.image.get_rect(center = (350, 317))
    def render(self):
        screen.blit(self.image, (self.rect.x, self.rect.y))

class Player(pygame.sprite.Sprite):
    def __init__(self):
        super().__init__()
        self.image = pygame.image.load("BG/playerGrey_walk1.png")
        self.rect = self.image.get_rect()

        #position and direction
        self.vx = 0
        self.pos = vec((340, 240))
        self.vel = vec(0,0)
        self.acc = vec(0,0)
        self.direction = "RIGHT"

        #Movement
        self.jumping = False

    def move(self):
        
        #keep a constant acceleration of 0.5 in the downwa
        self.acc = vec(0, 0.5)

        #Will set running to False if the player has slower
        if abs(self.vel.x) > 0.3:
            self.running = True
        else:
            self.running = False

        #returns the current key presses
        pressed_key = pygame.key.get_pressed()

        #Accelerates the player in the direction of the key press
        if pressed_key[K_LEFT]:
            self.acc.x = -acc
        if pressed_key[K_RIGHT]:
            self.acc.x = acc
        
        #Formulas to calculate velocity while accounting the friction
        self.acc.x += self.vel.x * fric 
        self.vel += self.acc
        self.pos += self.vel + 0.5 * self.acc

        #move the player from the edge of the screen
        if self.pos.x > w:
            self.pos.x = 0
        if self.pos.x < 0:
            self.pos.x = w

        self.rect.topleft = self.pos
    
    def update(self):
        pass

    def attack(self):
        pass

    def jump(self):
        self.rect.x += 1

        hits = pygame.sprite.spritecollide(self , ground_group, False)

        self.rect.x -= 1

        if hits and not self.jumping:
            self.jumping = True
            self.vel.y = -12

    
    def gravity_check(self):
        hits = pygame.sprite.spritecollide(player1, ground_group, False)
        if self.vel.y > 0:
            if hits:
                lowest = hits[0]
                if self.pos.y < lowest.rect.bottom:
                    self.pos.y = lowest.rect.top - self.rect.height + 1
                    self.vel.y = 0
                    self.jumping = False
        

class Enemy(pygame.sprite.Sprite):
    def __init__(self):
        super().__init__()

background = Background()
ground = Ground()
ground_group = pygame.sprite.Group()
ground_group.add(ground)

player1 = Player()

while True:
    for event in pygame.event.get():
        if event.type == QUIT:
            pygame.quit()
            exit()
        if event.type == pygame.MOUSEBUTTONDOWN:
            pass
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_SPACE:
                player1.jump()
        
    background.render()
    ground.render()
    player1.move()
    screen.blit(player1.image, player1.rect)

    player1.gravity_check()

    pygame.display.update()
    fps_clock.tick(fps)