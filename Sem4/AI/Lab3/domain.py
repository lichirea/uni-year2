# -*- coding: utf-8 -*-

from random import *
from tabnanny import check
from utils import *
import numpy as np

#define directions
UP = 0
DOWN = 2
LEFT = 1
RIGHT = 3




# the class gene can be replaced with int or float, or other types
# depending on your problem's representation


def gene():
    return np.random.randint(0, 3);

class Individual:
    def __init__(self, size = 0):
        self.__size = size
        self.__x = [gene() for i in range(self.__size)]
        self.__f = 0;
    
    def getFit(self):
        return self.__f

    def getGenes(self):
        return self.__x;

    def fitness(self, map, starting_point, environment_size):
        environment = np.zeros((environment_size[0], environment_size[1]));
        x = starting_point[0]
        y = starting_point[1]        

        self.checkSurroundings(map, environment, starting_point)

        for gene in self.__x:
            if x > 0:
                if gene == 0 and map.surface[x-1][y]==0:
                    x = x - 1
            if x < 19:
                if gene == 2 and map.surface[x+1][y]==0:
                    x = x + 1

            if y > 0:
              if gene == 1 and map.surface[x][y-1]==0:
                  y = y - 1
            if y < 19:
              if gene == 3 and map.surface[x][y+1]==0:
                  y = y + 1

            self.checkSurroundings(map, environment, [x,y])
        
        for i in range(map.n):
            for j in range(map.m):
                if environment[i][j] == 0:
                    self.__f = self.__f + 1
        

    ####
    def checkSurroundings(self, map, environment, location):
        readings=[0,0,0,0]
        x = location[0]
        y = location[1]

        # UP 
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


        #mark walls
        wals = readings;
        i = x - 1
        if wals[UP] > 0:
            while ((i>=0) and (i >= x - wals[UP])):
                environment[i][y] = 0
                i = i - 1
        if (i>=0):
            environment[i][y] = 1
            
        i = x + 1
        if wals[DOWN] > 0:
            while ((i < map.n) and (i <= x + wals[DOWN])):
                environment[i][y] = 0
                i = i + 1
        if (i < map.n):
            environment[i][y] = 1
            
        j = y + 1
        if wals[LEFT] > 0:
            while ((j < self.__m) and (j <= y + wals[LEFT])):
                environment[x][j] = 0
                j = j + 1
        if (j < map.m):
            environment[x][j] = 1
        
        j = y - 1
        if wals[RIGHT] > 0:
            while ((j >= 0) and (j >= y - wals[RIGHT])):
                environment[x][j] = 0
                j = j - 1
        if (j >= 0):
            environment[x][j] = 1

        
    ####


    
    def mutate(self, mutateProbability = 0.04):
        if random() < mutateProbability:
            location = randint(0, self.__size - 1)
            while True:
                newGene = randint(0, 3)
                if(self.__x[location] != newGene):
                    self.__x[location] = newGene
                    return
            # perform a mutation with respect to the representation
        
    
    def crossover(self, otherParent, crossoverProbability = 0.8):
        offspring1, offspring2 = Individual(self.__size), Individual(self.__size) 
        gene1 = []
        gene2 =[]
        if random() < crossoverProbability:
            point = randint(1, self.__size-1);
            gene1 = [];
            for i in range(self.__size):
                if(i <= point):
                    gene1.append(self.__x[i])
                else:
                    gene1.append(otherParent.__x[i])

            gene2 = [];
            for i in range(self.__size):
                if(i <= point):
                    gene2.append(self.__x[i])
                else:
                    gene2.append(otherParent.__x[i])
            
            # perform the crossover between the self and the otherParent 
        
            offspring1.__x = gene1
            offspring2.__x = gene2

        return offspring1, offspring2

    
    
class Population():
    def __init__(self, starting_point, map, populationSize = 10, individualSize = 10):
        self.starting_point = starting_point;
        self.map = map;
        self.__populationSize = populationSize
        self.__v = []
        for i in range(populationSize):
            self.__v.append(Individual(individualSize))
        
    def evaluate(self):
        # evaluates the population
        for x in self.__v:
            x.fitness(self.map, self.starting_point, [self.map.n, self.map.m])
            
    def bestFit(self):
        best = self.__v[0]
        for i in self.__v:
            if i.getFit() > best.getFit():
                best = i
        
        return best

    def replacePop(self, pop):
        self.__v = pop

    def getSize(self):
        return self.__populationSize

    def selection(self, k = 4):
        # perform a selection of k individuals from the population
        # and returns that selection
        meanFitness = 0
        for individual in self.__v:
            meanFitness = meanFitness + individual.getFit();
        meanFitness = meanFitness / self.__populationSize;

        proportionalFitness = []
        for individual in self.__v:
            proportionalFitness.append([individual.getFit() / meanFitness, individual])
        
        selection = []
        while k > 0:
            roulette = random()
            np.random.shuffle(proportionalFitness)
            for i in proportionalFitness:
                if i[0] < roulette:
                    selection.append(i[1])
                    k -= 1
                    break
        
        return selection

    

    
class Map():
    def __init__(self, n = 20, m = 20):
        self.n = n
        self.m = m
        self.surface = np.zeros((self.n, self.m))
    
    def randomMap(self, fill = 0.2):
        for i in range(self.n):
            for j in range(self.m):
                if random() <= fill :
                    self.surface[i][j] = 1
                
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