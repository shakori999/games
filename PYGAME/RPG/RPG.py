import sys, random, time
import tkinter
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
hit_cooldown = pygame.USEREVENT + 1

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

#Attack animation for the Right
attack_ani_r = [
    pygame.image.load("BG/playerGrey_walk1.png"),
    pygame.image.load("BG/playerGrey_walk2.png"),
    pygame.image.load("BG/playerGrey_walk3.png"),
    pygame.image.load("BG/playerGrey_switch2.png"),
    pygame.image.load("BG/playerGrey_switch1.png"),
]

#Health bar animation
health_ani = [
    pygame.image.load("BG/Helath_10.png"),
    pygame.image.load("BG/Helath_20.png"),
    pygame.image.load("BG/Helath_40.png"),
    pygame.image.load("BG/Helath_60.png"),
    pygame.image.load("BG/Helath_80.png"),
    pygame.image.load("BG/Helath_100.png"),
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
        self.rect = self.image.get_rect( )


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

        #combat
        self.attacking = False
        self.attack_frame = 0
        self.cooldown = False

        #bars
        self.health = 5

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
        #If attack frame has reached end of sequence, return to 0
        if self.attack_frame > 4:
            self.attack_frame = 0
            self.attacking = False
        
        #Check direction for correct animation to display
        if self.direction == "RIGHT":
            self.image = attack_ani_r[self.attack_frame]
        
        #Update the current attack frame
        self.attack_frame += 1

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
    
    def player_hit(self):
        if self.cooldown == False:
            self.cooldown = True
            pygame.time.set_timer(hit_cooldown, 1000)

            self.health = self.health - 1
            health.image = health_ani[self.health]

            if self.health <=0:
                self.kill()
                pygame.display.update()

            pygame.display.update()

class Enemy(pygame.sprite.Sprite):
    def __init__(self):
        super().__init__()
        self.image = pygame.image.load("BG/enemyWalking_1.png")
        self.rect = self.image.get_rect()     
        self.pos = vec(0,0)
        self.vel = vec(0,0)

        #movement 
        self.direction = random.randint(0,1) 
        self.vel.x = random.randint(2,6) / 2

        # Sets the intial position of the enemy
        if self.direction == 0:
            self.pos.x = 0
            self.pos.y = 240
        if self.direction == 1:
            self.pos.x = 500
            self.pos.y = 240

    def move(self):
        # Causes the enemy to change directions upon reaching the end of screen    
        if self.pos.x >= (w - 20):
                self.direction = 1
        elif self.pos.x <= 0:
                self.direction = 0
        # Updates position with new values     
        if self.direction == 0:
            self.pos.x += self.vel.x
        if self.direction == 1:
            self.pos.x -= self.vel.x
        
        self.rect.center = self.pos # Updates rect

    def update(self):
      # Checks for collision with the Player
      hits = pygame.sprite.spritecollide(self, player_groupd, False)
 
      # Activates upon either of the two expressions being true
      if hits and player1.attacking == True:
            self.kill()
 
      # If collision has occured and player not attacking, call "hit" function            
      elif hits and player1.attacking == False:
            player1.player_hit()


    def render(self):
            # Displayed the enemy on screen
            screen.blit(self.image, (self.pos.x, self.pos.y))
        
class Castle(pygame.sprite.Sprite):
    def __init__(self):
        super().__init__()
        self.hide = False
        self.image = pygame.image.load("BG/castle.png")
        self.image = pygame.transform.scale(self.image, (200, 200))
        
    
    def update(self):
        if self.hide == False:
            screen.blit(self.image, (450, 90))

class EventHandler():
    def __init__(self):
        self.enemy_count = 0
        self.stage = 1
        self.battle = False
        self.enemy_generation = pygame.USEREVENT + 2

        self.stage_enemies = []
        for x in range(1, 21):
            self.stage_enemies.append(int((x **2/2) + 1))

    def stage_handler(self):
        self.root = Tk() 
        self.root.geometry("200x170")

        button1 = Button(self.root, text = "First dungen", width = 18, height = 2,
                        command = self.world1)
        button2 = Button(self.root, text = "second dungen", width = 18, height = 2,
                        command = self.world2)
        button3 = Button(self.root, text = "third dungen", width = 18, height = 2,
                        command = self.world3)

        button1.place(x = 40, y = 15)
        button2.place(x = 40, y = 65)
        button3.place(x = 40, y = 115)
        
        self.root.mainloop()

    def world1(self):
        self.root.destroy()
        pygame.time.set_timer(self.enemy_generation, 2000)
        castle.hide = True
        self.battle = True

    def world2(self):
        self.battle = True

    def world3(self):
        self.battle = True

    def next_stage(self):
        self.stage += 1
        self.enemy_count = 0
        print("stage: " + str(self.stage))
        pygame.time.set_timer(self.enemy_generation, 1500 - (50 * self.stage))

class HealthBar(pygame.sprite.Sprite):
    def __init__(self):
        super().__init__()
        self.image = pygame.image.load("BG/Helath_100.png")
        self.image = pygame.transform.scale(self.image, (250, 40))

    def render(self):
        screen.blit(self.image, (10, 10))
 
        
background = Background()

ground = Ground()
ground_group = pygame.sprite.Group()
ground_group.add(ground)

player1 = Player()
player_groupd = pygame.sprite.Group()
player_groupd.add(player1)

Enemies = pygame.sprite.Group()

#castle
castle = Castle()
handler = EventHandler()

#Bars
health = HealthBar()

while True:
    for event in pygame.event.get():
        # close the game with close button
        if event.type == QUIT:
            pygame.quit()
            sys.exit()

        #For events that occur upon clicing the mouse
        if event.type == pygame.MOUSEBUTTONDOWN:
            pass

        if event.type == hit_cooldown:
            player1.cooldown = False
            pygame.time.set_timer(hit_cooldown, 0)

        if event.type == handler.enemy_generation:
            if handler.enemy_count < handler.stage_enemies[handler.stage - 1]:
                enemy = Enemy()
                Enemies.add(enemy)
                print("generate enemy")
                handler.enemy_count += 1
        
        #Event handling for a range of different key presses
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_SPACE:
                player1.jump()
            if event.key == pygame.K_RETURN:
                if player1.attacking == False:
                    player1.attack()
                    player1.attacking = True
            if event.key == pygame.K_e and 450 < player1.rect.x < 550:
                handler.stage_handler()
            if event.key == pygame.K_n:
                if handler.battle == True and len(Enemies) == 0:
                    print("work")
                    handler.next_stage()
        
    #Player related functions
    player1.update()
    if player1.attacking == True:
        player1.attack()

    player1.move()
    player1.gravity_check()

    #Display and Background related functions
    background.render()
    ground.render()

    castle.update()
    #enemy
    for entity in Enemies:
        entity.update()
        entity.move()
        entity.render()

    #Rendering Player and enemies
    if player1.health > 0:
        screen.blit(player1.image, player1.rect)
    health.render()

    pygame.display.update()
    fps_clock.tick(fps)