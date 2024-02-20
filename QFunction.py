import pfrl
import torch
import torch.nn


# 一个深度神经网络，用来输出Q值
class QFunction(torch.nn.Module):

    def __init__(self, obs_size, n_actions):
        super().__init__()
        self.fc1 = torch.nn.Linear(obs_size, 64)
        self.fc2 = torch.nn.Linear(64, 32)
        self.fc3 = torch.nn.Linear(32, n_actions)

    def forward(self, x):
        h = x
        h = torch.nn.functional.relu(self.fc1(h))
        h = torch.nn.functional.relu(self.fc2(h))
        h = self.fc3(h)
        return pfrl.action_value.DiscreteActionValue(h)
