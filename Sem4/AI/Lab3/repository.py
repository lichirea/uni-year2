# -*- coding: utf-8 -*-

from fileinput import filename
import pickle
from domain import *


class repository():
    def __init__(self, filename):
         
        self.__populations = []
        self.cmap = Map()
        self.file = filename
        
    def createPopulation(self, args):
        # args = [starting_point, MAP, populationSize, individualSize] -- you can add more args    
        return Population(args[0], args[1], args[2], args[3])

    def randomMap(self):
        self.cmap.randomMap();

    def getMap(self):
        return self.cmap;

    def readMap(self):
        f = open(self.file, "r")
        strings = []
        for i in range(self.cmap.n):
            strings.append(f.readline())
        self.cmap.readMap(strings)
        f.close()
        
    def writeMap(self):
        f = open(self.file, "w")
        f.write(str(self.cmap))
            
    def getFileName(self):
        return self.file;

        
    # TO DO : add the other components for the repository: 
    #    load and save from file, etc
            