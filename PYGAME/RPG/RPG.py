import sys, random, time
import pygame
from pygame.locals import *
from tkinter import filedialog
from tkinter import *

pygame.init() # Begin pygame

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

#the animation for the charecter from Right
run_ani_R = [
    pygame.image.load("BG/playerGrey_stand.png"),
    pygame.image.load("BG/playerGrey_walk1.png"),
    pygame.image.load("BG/playerGrey_walk2.png"),
    pygame.image.load("BG/playerGrey_walk3.png"),
    pygame.image.load("BG/playerGrey_walk2.png"),
    pygame.image.load("BG/playerGrey_walk1.png"),
]

#the animation for the charecter from Left 
run_ani_L = [
    pygame.image.load("BG/playerGrey_stand.png"),
    pygame.image.load("BG/playerGrey_walk1.png"),
    pygame.image.load("BG/playerGrey_walk2.png"),
    pygame.image.load("BG/playerGrey_walk3.png"),
    pygame.image.load("BG/playerGrey_walk2.png"),
    pygame.image.load("BG/playerGrey_walk1.png"),
]


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
        self.image = pygame.image.load("BG/playerGrey_stand.png")
        self.rect = self.image.get_rect()

        #position and direction
        self.vx = 0
        self.pos = vec((340, 200))
        self.vel = vec(0,0)
        self.acc = vec(0,0)
        self.direction = "RIGHT"

        #Movement
        self.jumping = False
        self.running = False
        self.move_frame = 0

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

        self.rect.topleft = self.pos # Update rect with new pos
    
    def update(self):
        #Return to base frame if at end of movement sequence
        if self.move_frame > 5:
            self.move_frame = 0
            return
        # move the character to the next frame if the conditions are met
        if self.jumping == False and self.running == True:
            if self.vel.x > 0:
                self.image = run_ani_R[self.move_frame]
                self.direction = "RIGHT"
            elif self.vel.x < 0:
                self.image = run_ani_L[self.move_frame]
                self.direction = "LEFT"
            self.move_frame += 1
        
        #Returns to base frame if standing still and incorrect frame not showing
        if abs(self.vel.x) < 0.2 and self.move_frame != 0:
            self.move_frame = 0
            if self.direction == "RIGHT":
                self.image = run_ani_R[self.move_frame]
            elif self.direction == "LEFT":
                self.image = run_ani_L[self.move_frame]
            

    def attack(self):
        pass

    def jump(self):
        self.rect.x += 1

        #Check to see if playe ris in contact with ground!
        hits = pygame.sprite.spritecollide(self , ground_group, False)

        self.rect.x -= 1

        # If touching the ground , and not currenctly jumping then, let him jump
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
player_groupd = pygame.sprite.Group()

while True:
    for event in pygame.event.get():
        # close the game with close button
        if event.type == QUIT:
            pygame.quit()
            sys.exit()

        #For events that occur upon clicing the mouse
        if event.type == pygame.MOUSEBUTTONDOWN:
            pass
        
        #Event handling for a range of different key presses
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_SPACE:
                player1.jump()
        
    #Player related functions
    player1.update()
    player1.move()
    player1.gravity_check()


    #Display and Background related functions
    background.render()
    ground.render()

    #Rendering Player
    screen.blit(player1.image, player1.rect)

    pygame.display.update()
    fps_clock.tick(fps)