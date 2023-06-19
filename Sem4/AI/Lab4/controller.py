import statistics
import igraph
import math
import copy
from repository import *


class controller():
    def __init__(self, args):
        # args - list of parameters needed in order to create the controller
        self.repo = args[0]
        self.energy = 0

    #args: 
    def solver(self, args):
        self.starting_location = args[0]
        self.energy = args[1]
        self.sensors = self.repo.getSensors();

        visibleArray = []
        #calculate for each sensor the number of squares seen at each energy level
        for i in self.sensors:
            i.calculate_visible(self.repo.getMap())
            visibleArray.append(i.get_visible())
        

        #make a graph, where each vertice is a sensor, and each edge between sensors is
        #the energy required to path between them

        g = igraph.Graph()
        g.es["weight"] = 1.0


        for i in self.sensors:
            g.add_vertex(str(i.get_location()))

    
        # now we can calculate using ACO the energy cost
        # not sure how to handle this, i will just calculate it for every pair


        for i in self.sensors:
            for j in self.sensors:
                if(i != j):
                    g[str(i.get_location()), str(j.get_location())] = self.aco(i.get_location(), j.get_location())
                    print(g[str(i.get_location()), str(j.get_location())])




    def aco(self, start, end):

        colony = Colony(10, start, end)
        pheromoneMap = copy.deepcopy(self.repo.getMap())

        for i in range(pheromoneMap.n):
            for j in range(pheromoneMap.m):
                if(pheromoneMap.surface[i][j] == 1):
                    pheromoneMap.surface[i][j] = -1
                if(pheromoneMap.surface[i][j] == 2):
                    pheromoneMap.surface[i][j] = -2

        for steps in range(100):
            for ant in colony.get_ants():
                ant.move(pheromoneMap)

        return colony.get_best().shortest_path