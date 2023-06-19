import statistics
from repository import *


class controller():
    def __init__(self, args):
        # args - list of parameters needed in order to create the controller
        self.repo = args[0]
        self.battery = args[1]
        self.generations = 10;

    def iteration(self, args):
        # args - list of parameters needed to run one iteration
        population = args[0]
        # a iteration:
        # selection of the parrents
        # create offsprings by crossover of the parents
        # apply some mutations
        # selection of the survivors
        population.evaluate()
        selection = population.selection(population.getSize() / 5) # keep 20%

        
        #crossover random parents
        i = len(selection)
        
        nParents = population.getSize()
        count = population.getSize()
        while count:
            x = 0
            y = 0
            while x == y:
                x = randint(0, i-1)
                y = randint(0, i-1)
            offsprings = selection[x].crossover(selection[y])
            selection.append(offsprings[0])
            selection.append(offsprings[1])
            count -= 1

        count = len(selection) / 5 # mutate 10% of individuals

        while count > 0:
            x = randint(nParents, len(selection)-1)
            selection[x].mutate() 
            count -= 1


        population.replacePop(selection)    
        survivors = population.selection(population.getSize())
        population.replacePop(survivors)
        return population
        
    def run(self, args):
        # args - list of parameters needed in order to run the algorithm
        population = args[0]
        # until stop condition
        #    perform an iteration
        #    save the information need it for the satistics
        while self.generations:
            population = self.iteration([population])

            self.generations -= 1

        return population.bestFit().getFit(), None
        # return the results and the info for statistics
    
    
    def solver(self, args):
        # args - list of parameters needed in order to run the solver - starting location, population size, ind size
        self.generations = args[3]

        # create the population,
        # run the algorithm
        # return the results and the statistics
        pop = Population(args[0], self.repo.getMap(), args[2], args[3])
        path, stats =  self.run([pop])
        #CONFIGURE STATISTICS
        return path, stats
        






       