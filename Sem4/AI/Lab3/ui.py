
# imports
from cProfile import run
from gui import *
from controller import *
from repository import *
from domain import *





class App():
    def __init__(self):
        self.individualSize = 10
        self.populationSize = 10
        self.startingLocation = [10,10]
        self.generations = 30
        self.control = controller([repository("map.txt"), 15])
        self.path = []
        self.statistics = None

    def main(self):
        running = True
        while running:
            command = self.menu()
            match command:
                case "1a":
                    self.control.repo.randomMap()
                    print("Random map generated!")
                case "1b":
                    self.control.repo.readMap()
                    print("Read map from " + self.control.repo.getFileName())
                case "1c":
                    self.control.repo.writeMap()
                    print("Wrote map to " + self.control.repo.getFileName())
                case "1d":
                    print(str(self.control.repo.getMap()))
                case "2b":
                    start_time = time.time()
                    print("Started time...")
                    self.path, self.statistics = self.control.solver([self.startingLocation, self.control.repo.getMap(),self.populationSize, self.individualSize, self.generations])
                    end_time = time.time()
                    print("Execution time: " + str(end_time-start_time))
                    print(self.path)
                case "2d":
                    movingDrone(self.control.repo.getMap(), self.path)
                case _:
                    print("Invalid selection! Should be something like 1a, 1b, 2d etc.")
                    

    def menu(self):
        print("1a - create random map\n1b - load a map\n1c - save a map\n1d - visualize map\n2a - parameters setup\n2b run the solver\n2c statistics\n2d view drone\n\n")
        return input()

if __name__ == "__main__":
    app = App()
    app.main()

# create a menu
#   1. map options:
#         a. create random map
#         b. load a map
#         c. save a map
#         d visualise map
#   2. EA options:
#         a. parameters setup
#         b. run the solver
#         c. visualise the statistics
#         d. view the drone moving on a path
#              function gui.movingDrone(currentMap, path, speed, markseen)
#              ATENTION! the function doesn't check if the path passes trough walls