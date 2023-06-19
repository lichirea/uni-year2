
# imports
from cProfile import run
from gui import *
from controller import *
from repository import *
from domain import *





class App():
    def __init__(self):
        self.startingLocation = [10,10]
        self.control = controller([repository("map.txt")])
        self.path = []
        self.energy = 0

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
                case "2a":
                    location = input("Starting location x y: ").split(' ')
                    self.startingLocation = [int(location[0]), int(location[1])]
                    self.energy = int(input("Energy: "))
                case "2b":
                    self.path = self.control.solver([self.startingLocation, self.energy])
                    end_time = time.time()
                    print(self.path)
                case "2c":
                    movingDrone(self.control.repo.getMap(), self.path)
                case _:
                    print("Invalid selection! Should be something like 1a, 1b, 2d etc.")
                    

    def menu(self):
        print("1a - create random map\n1b - load a map\n1c - save a map\n1d - visualize map\n2a - parameters setup\n2b run the solver\n2c view drone\n")
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