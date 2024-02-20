import torch
import pfrl
import numpy

from loguru import logger
import matplotlib.pyplot as plt
import seaborn as sns

from env import Environment
from QFunction import QFunction
from dataController import DataController


# DQN实现类
class DQN:
    def __init__(self, data: DataController):
        self.data = data
        self.env = None
        self.agent = None
        self.gen_env()
        self.episodes_best_p = []
        self.Rs = []

    # 创建环境
    def gen_env(self):
        # 生成一个全零初始分配值
        start = [[0 for i in range(self.data.H)] for j in range(self.data.R)]
        self.env = Environment(self.data, start)

        # 输入维度是obs的size，输出维度是动作向量
        # obs_size = self.env.observation_space.low.size
        obs_size = self.data.R * self.data.H
        n_actions = self.env.action_space.n
        q_func = QFunction(obs_size, n_actions)

        # Use Adam to optimize q_func. eps=1e-2 is for stability.
        optimizer = torch.optim.Adam(q_func.parameters(), eps=0.01)

        # Set the discount factor that discounts future rewards.
        gamma = 0.9

        # Use epsilon-greedy for exploration
        explorer = pfrl.explorers.ConstantEpsilonGreedy(
            epsilon=0.3, random_action_func=self.env.action_space.sample)

        # DQN uses Experience Replay.
        # Specify a replay buffer and its capacity.
        # 经验回放设置
        replay_buffer = pfrl.replay_buffers.ReplayBuffer(capacity=1000000)

        # Since observations from CartPole-v0 is numpy.float64 while
        # As PyTorch only accepts numpy.float32 by default, specify
        # a converter as a feature extractor function phi.
        # 将(model_num, server_num)输入转换为一维张量
        phi = lambda x: torch.tensor(numpy.array(x).astype(numpy.float32, copy=False), dtype=torch.float32).view(-1)

        # Set the device id to use GPU. To use CPU only, set it to -1.
        gpu = -1

        # Now create an agent that will interact with the self.environment.
        self.agent = pfrl.agents.DQN(
            q_func,
            optimizer,
            replay_buffer,
            gamma,
            explorer,
            replay_start_size=500,
            update_interval=1,
            target_update_interval=100,
            phi=phi,
            gpu=gpu,
        )

    # DQN执行过程
    def start(self):
        self.env.reset()
        for i in range(1, self.data.dqn_n_episodes + 1):
            obs = self.env.reset()
            R = 0  # return (sum of rewards)
            t = 0  # time step (stable reward count)
            while True:
                if isinstance(obs, tuple):
                    obs = list(obs)
                    obs = obs[0]
                action = self.agent.act(obs)
                obs, reward, terminated, truncated, _ = self.env.step(action)
                R += reward
                if terminated or truncated:
                    break
            if i % 100 == 0:
                logger.debug('episode: {0} p: {1} x: {2}'.format(i, self.env.best_p, self.env.best_x))
            self.Rs.append(R)
            self.episodes_best_p.append(self.env.best_p)

    # 绘制结果曲线
    def draw_plot(self, title="learning curve"):
        sns.set()
        plt.figure()  # 创建一个图形实例，方便同时多画几个图
        plt.title(f"{title}")
        plt.xlim(0, self.data.dqn_n_episodes, 10)  # 设置x轴的范围
        plt.xlabel('episodes')
        plt.plot(self.episodes_best_p, label='best_p')
        # plt.plot(self.Rs, label='reward')
        plt.legend()
        plt.show()
