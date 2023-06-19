# -*- coding: utf-8 -*-

from fileinput import filename
import pickle
from domain import *


class repository():
    def __init__(self, filename):
         
        self.__populations = []
        self.cmap = Map()
        self.file = filename
        

    def randomMap(self):
        self.cmap.randomMap();

    def getMap(self):
        return self.cmap

    def getSensors(self):
        return self.cmap.sensors

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