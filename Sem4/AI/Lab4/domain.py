# -*- coding: utf-8 -*-

from asyncore import read
from random import *
from tabnanny import check
from tracemalloc import start
from utils import *
import numpy as np

#define directions
UP = 0
DOWN = 2
LEFT = 1
RIGHT = 3

    
class Map():
    def __init__(self, n = 20, m = 20):
        self.n = n
        self.m = m
        self.surface = np.zeros((self.n, self.m))
        self.sensors = []
    
    def randomMap(self, fill = 0.2):
        for i in range(self.n):
            for j in range(self.m):
                if random() <= fill :
                    self.surface[i][j] = 1
        for i in range(self.n):
            for j in range(self.m):
                if random() <= fill/10 :
                    if self.surface[i][j] == 0:
                        self.surface[i][j] = 2
                        self.sensors.append(Sensor((i,j)))
                
    def __str__(self):
        string=""
        for i in range(self.n):
            for j in range(self.m):
                string = string + str(int(self.surface[i][j]))
            string = string + "\n"
        return string
                

    def readMap(self, strings):
        for i in range(self.n):
            for j in range(self.m):
                self.surface[i][j] = int(strings[i][j])


class Sensor():
    def __init__(self, location):
        self.__x = location[0]
        self.__y = location[1]
        self.__visible_squares = [0,0,0,0,0,0] 


    def get_location(self):
        return (self.__x, self.__y)
    
    def get_visible(self):
        return self.__visible_squares;

    def calculate_visible(self, map):
        readings = [0, 0, 0, 0]
        x = self.__x;
        y = self.__y;


        #UP
        xf = x - 1
        while ((xf >= 0) and (map.surface[xf][y] == 0)):
            xf = xf - 1
            readings[UP] = readings[UP] + 1

        # DOWN
        xf = x + 1
        while ((xf < map.n) and (map.surface[xf][y] == 0)):
            xf = xf + 1
            readings[DOWN] = readings[DOWN] + 1
        # LEFT
        yf = y + 1
        while ((yf < map.m) and (map.surface[x][yf] == 0)):
            yf = yf + 1
            readings[LEFT] = readings[LEFT] + 1
        # RIGHT
        yf = y - 1
        while ((yf >= 0) and (map.surface[x][yf] == 0)):
            yf = yf - 1
            readings[RIGHT] = readings[RIGHT] + 1

        for i in range(5):
            self.__visible_squares[i+1] += self.__visible_squares[i]
            if readings[UP] >= i+1:
                self.__visible_squares[i+1] += 1
            if readings[DOWN] >= i+1:
                self.__visible_squares[i+1] += 1
            if readings[LEFT] >= i+1:
                self.__visible_squares[i+1] += 1
            if readings[RIGHT] >= i+1:
                self.__visible_squares[i+1] += 1


class Ant():
    def __init__(self, starting_location, food):
        self.path = []
        self.shortest_path = 999999
        self.score = 0
        self.home = [starting_location[0], starting_location[1]]
        self.location = [starting_location[0], starting_location[1]]
        self.food = [food[0], food[1]]
        self.returning = 0

    def move(self, map):
        x = self.location[0]
        y = self.location[1]

        if(self.returning):
            map.surface[x][y] += 1
            direction = self.path.pop();
            if direction == DOWN:
                self.location[0] += 1
            if direction == UP:
                self.location[0] -= 1
            if direction == LEFT:
                self.location[1] += 1
            if direction == RIGHT:
                self.location[1] -= 1

            if self.location == self.home:
                self.returning = 0
            
        else:
            roulette = []
            if x > 0:
                if map.surface[x-1][y]>=0:
                    roulette = roulette + [DOWN] * int(map.surface[x-1][y] + 1)
            if x < 19:
                if map.surface[x+1][y]>=0:
                    roulette = roulette + [UP] * int(map.surface[x+1][y] + 1)

            if y > 0:
                if map.surface[x][y-1]>=0:
                    roulette = roulette + [LEFT] * int(map.surface[x][y-1] + 1)
            if y < 19:
                if map.surface[x][y+1]>=0:
                    roulette = roulette + [RIGHT] * int(map.surface[x][y+1] + 1)

            if(roulette):
                direction = choice(roulette)
                self.path.append(direction);

                if direction == DOWN:
                    self.location[0] -= 1
                if direction == UP:
                    self.location[0] += 1
                if direction == LEFT:
                    self.location[1] -= 1
                if direction == RIGHT:
                    self.location[1] += 1

            if self.location == self.food:
                self.returning = 1;
                if self.shortest_path > len(self.path):
                    self.shortest_path = len(self.path)


class Colony():
    def __init__(self, size, starting_location, end):
        self.size = size
        self.ants = [Ant(starting_location, end) for i in range(self.size)]

    def get_ants(self):
        return self.ants

    def get_best(self):
        maximum = 0;
        best_ant = None
        for ant in self.ants:
            if ant.score > maximum:
                maximum = ant.score
                best_ant = ant
        
        return ant