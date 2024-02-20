from typing import Optional, Union, List, Tuple

from gym import Env
from gym import spaces
from copy import deepcopy

from gym.core import RenderFrame, ActType, ObsType

from dataController import DataController

'''
DRL运行环境
data: 运行算法所需的数据类，对应dataController.py
start: 起始状态，代表每轮DRL最开始的卸载状态
'''


class Environment(Env):
    def __init__(self, data: DataController, start: list):
        self.data = data
        self.count = 0
        self.start = start                            # 最初的分配状态
        self.current_state = deepcopy(self.start)     # 当前的运行分配状态
        self.max_count = self.data.dqn_max_steps
        self.observation_space = spaces.MultiBinary([self.data.R, self.data.H])   # 每个任务i对每个helper节点j的分配状态
        self.action_space = spaces.Discrete(self.data.R * self.data.H)            # 对第k个状态进行改变
        # 记录最优结果
        self.best_x = []
        self.best_p = -1
        self.current_p = -1

    # 运行单步逻辑
    def step(self, action: ActType) -> Tuple[ObsType, float, bool, bool, dict]:
        self.count += 1
        # 对当前的动作给出新的状态
        # 动作设定为[新的分配状态，变更位置(将y数组展开成一维的位置)]
        new_x = deepcopy(self.current_state)
        action_size = self.data.H
        row = action // action_size
        col = action % action_size
        # logger.debug("{} {} {} {}".format(self.current_state, action, row, col))
        if new_x[row][col] == 1:
            new_x[row][col] = 0
        else:
            new_x[row][col] = 1
        self.current_state = deepcopy(new_x)

        # 判断当前状态是否达到终止条件，或者超过最大可执行次数
        limited = self.limitation()
        truncated = False
        info = {}
        new_p = self.objective()
        # 如果当前step导致限制条件不满足，则进行惩罚，然后退出
        if limited:
            reward = self.data.rl_penalize
            truncated = True
        # 如果当前step对目标函数进行了优化，目标值变大了，则进行奖励
        elif new_p >= self.current_p and not limited:
            reward = self.data.rl_reward
            # 把最好的满足条件的结果保存下来
            if new_p >= self.best_p:
                self.best_x = deepcopy(new_x)
                self.best_p = new_p
        # 其他情况正常进行惩罚
        else:
            reward = self.data.rl_normal
        if self.count > self.max_count:
            truncated = True
        self.current_p = new_p
        return self.current_state, reward, False, truncated, info

    # 渲染界面，一般不需要
    def render(self) -> Optional[Union[RenderFrame, List[RenderFrame]]]:
        pass

    # 重置环境
    def reset(self):
        self.count = 0
        self.current_state = deepcopy(self.start)
        return self.current_state

    # 目标函数
    def objective(self):
        p = 0
        p_ij = self.data.p_ij
        for i in range(self.data.R):
            # 总概率等于每个任务i成功的概率和
            for j in range(self.data.H):
                # 每个任务成功的概率等于该任务在helper节点j上卸载成功率
                p += p_ij[i][j] * self.current_state[i][j]
        return p / self.data.R

    # 限制条件
    # 满足条件则返回False，否则返回True
    def limitation(self):
        # 每个helper节点的总卸载量不能大于该节点的容量
        for helper_id in range(self.data.H):
            task_size = 0
            for task_id in range(self.data.R):
                task_size += self.current_state[task_id][helper_id] * self.data.L[task_id]
            if task_size > self.data.E[helper_id]:
                return True
        # 每个任务至多只能卸载到一个helper节点上
        for task_id in range(self.data.R):
            helper_num = 0
            for helper_id in range(self.data.H):
                helper_num += self.current_state[task_id][helper_id]
            if helper_num > 1:
                return True
        return False
