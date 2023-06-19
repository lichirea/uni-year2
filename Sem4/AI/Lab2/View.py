from msilib.schema import Error
from random import randint
import pygame
import time

from Model.Drone import Drone
from Model.Map import BLUE, Map
from Service import dummysearch, searchAStar, searchGreedy

WHITE = (255, 255, 255)
GREEN = (0, 255, 0)
RED = (255, 0, 0)
BETWEEN = (255, 255, 0)


def main():
    # we create the map
    m = Map()
    # m.randomMap()
    # m.saveMap("test2.map")
    m.loadMap("test1.map")

    # initialize the pygame module
    pygame.init()
    # load and set the logo
    logo = pygame.image.load("logo32x32.png")
    pygame.display.set_icon(logo)
    pygame.display.set_caption("Path in simple environment")

    # we position the drone somewhere in the area
    x = randint(0, 19)
    y = randint(0, 19)

    # create drona
    d = Drone(x, y)

    # create a surface on screen that has the size of 400 x 480
    screen = pygame.display.set_mode((400, 400))
    screen.fill(WHITE)

    # define a variable to control the main loop
    running = True

    # main loop
    while running:
        # event handling, gets all event from the event queue
        for event in pygame.event.get():
            # only do something if the event is of type QUIT
            if event.type == pygame.QUIT:
                # change the value to False, to exit the main loop
                running = False
            if event.type == pygame.KEYDOWN:
                d.move(m)  # this call will be erased

        screen.blit(d.mapWithDrone(m.image()), (0, 0))
        pygame.display.flip()

    #path = dummysearch()
    start_time = time.time()
    print("Started time...")
    try:
        path1 = searchAStar(m, d, x, y, 7, 11)
        path2 = searchGreedy(m, d, x, y, 7, 11)
    except Error as e:
        print(e)

    end_time = time.time()
    print("Execution time: " + str(end_time-start_time))
    screen.blit(displayWithPath(m.image(), path1, path2), (0, 0))

    pygame.display.flip()
    time.sleep(5)
    pygame.quit()


def displayWithPath(image, path1, path2):
    mark = pygame.Surface((20, 20))
    mark.fill(GREEN)
    for move in path1:
        image.blit(mark, (move[1] * 20, move[0] * 20))


    for move in path2:
        if move not in path1:
            mark.fill(RED)
            image.blit(mark, (move[1] * 20, move[0] * 20))
        else:
            mark.fill(BETWEEN)
            image.blit(mark, (move[1] * 20, move[0] * 20))
            mark.fill(RED)

    return image


# run the main function only if this module is executed as the main script
# (if you import this as a module then nothing is executed)
if __name__ == "__main__":
    # call the main function
    main()
