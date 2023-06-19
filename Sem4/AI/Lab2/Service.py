import math
import pickle
from random import random
import numpy as np

#Creating some colors
import pygame



#define directions
UP = 0
DOWN = 2
LEFT = 1
RIGHT = 3

#define indexes variations
v = [[-1, 0], [1, 0], [0, 1], [0, -1]]





def searchAStar(mapM, droneD, initialX, initialY, finalX, finalY):
    # TO DO
    # implement the search function and put it in controller
    # returns a list of moves as a list of pairs [x,y]
    open = []
    open.append([initialX, initialY])
    closed = []
    parents = {}


    while open:
        current = getLowestCost(open, [finalX, finalY])
        closed.append(current)


        if current == [finalX, finalY]:
            return retrace([initialX, initialY], [finalX, finalY], parents)


        neighbors = []
        if current[0] > 0:
            neighbors.append([current[0]-1, current[1]])
        if current[0] < 19:
            neighbors.append([current[0]+1, current[1]])
        if current[1] > 0:
            neighbors.append([current[0], current[1]-1])
        if current[1] < 19:
            neighbors.append([current[0], current[1]+1])

        for n in neighbors:
            if mapM.getSurface()[n[0]][n[1]] == 1 or n in closed:
                continue

            if n not in open:
                open.append(n)
                parents[tuple(n)] = current
            else:
                newCost = getCost(current, [initialX, initialY]) + getCost(current, n)
                oldCost = getCost(parents[tuple(n)], [initialX, initialY]) + getCost(parents[tuple(n)], n)
                if newCost < oldCost:
                    parents[tuple(n)] = current



def retrace(start, end, parents):
    path = []
    current = end

    while current != start:
        path.append(current)
        current = parents[tuple(current)]

    return path


def getLowestCost(open, final):
    minimumPair = []
    minimumCost = 99999
    for pair in open:
        if getCost(pair, final) < minimumCost:
            minimumPair = pair
            minimumCost = getCost(pair, final)

    open.remove(minimumPair)
    return minimumPair

def getCost(pair, final):
    return math.dist(pair, final)

###############################################################################################

def searchGreedy(mapM, droneD, initialX, initialY, finalX, finalY):
    initial = [initialX, initialY]
    current = initial
    final = [finalX, finalY]

    path = []
    path.append(current)

    while current != final:
        neighbors = []
        if current[0] > 0:
            neighbors.append([current[0] - 1, current[1]])
        if current[0] < 19:
            neighbors.append([current[0] + 1, current[1]])
        if current[1] > 0:
            neighbors.append([current[0], current[1] - 1])
        if current[1] < 19:
            neighbors.append([current[0], current[1] + 1])

        nxt = neighbors[0]
        nxtCost = getCost(nxt, final)
        neighbors.remove(nxt)

        for n in neighbors:
            if mapM.getSurface()[n[0]][n[1]] == 1:
                continue

            if getCost(n, final) < nxtCost:
                nxt = n
                nxtCost = getCost(nxt, final)

        path.append(nxt)
        current = nxt

    return path




def dummysearch():
    # example of some path in test1.map from [5,7] to [7,11]
    return [[5, 7], [5, 8], [5, 9], [5, 10], [5, 11], [6, 11], [7, 11]]