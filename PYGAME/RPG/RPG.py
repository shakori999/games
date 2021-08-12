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
        self.image = pygame.image.load("BG/ground.png")
        self.rect = self.image.get_rect(center = (350, 150))
    def render(self):
        screen.blit(self.image, (self.rect.x, self.rect.y))

class Player(pygame.sprite.Sprite):
    def __init__(self):
        super().__init__()
        self.image = pygame.image.load("BG/playerGrey_walk1.png")
        self.rect = self.image.get_rect(center = (350, 150))

        #position and direction
        self.vx = 0
        self.pos = vec((340, 240))
        self.vel = vec(0,0)
        self.acc = vec(0,0)
        self.direction = "Right"
    def render(self):
        screen.blit(self.image, (self.pos.x, self.pos.y))

    def move(self):
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
        self.rect.midbottom = self.pos
    
    def update(self):
        pass

    def attack(self):
        pass

    def jump(self):
        pass

        

class Enemy(pygame.sprite.Sprite):
    def __init__(self):
        super().__init__()

background = Background()
ground = Ground()
player1 = Player()

while True:
    for event in pygame.event.get():
        if event.type == QUIT:
            pygame.quit()
            exit()
        if event.type == pygame.MOUSEBUTTONDOWN:
            pass
        if event.type == pygame.KEYDOWN:
            pass
        
    background.render()
    ground.render()
    player1.move()
    player1.render() 
    pygame.display.update()
    fps_clock.tick(fps)