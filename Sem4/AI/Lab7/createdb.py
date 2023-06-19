import math

import torch

distribution = 20 * torch.rand(1000, 2) - 10

fv = []
for i in range(1000):
    a = distribution[i][0]
    b = distribution[i][1]
    fr = torch.sin(a + b / math.pi)
    fv.append(fr)

fv = torch.tensor(fv)
result = torch.column_stack((distribution, fv))

torch.save(result, "mydataset.dat")


