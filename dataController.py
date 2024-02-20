# 用于管理运行所需数据的类
import scipy.io as scio


class DataController:
    def __init__(self):
        # 参数定义
        self.R = 3   # 待卸载任务数
        self.H = 4   # helper节点数
        self.L = []  # 每个任务的大小
        self.E = []  # 每个helper节点的容量
        self.p_ij = []  # 任务i在helper节点j的卸载成功率
        # 运行参数
        self.dqn_n_episodes = 10000  # DQN运行总轮数
        self.dqn_max_steps = 200000   # 每轮DQN的最大步数
        self.rl_reward = 10        # 奖励值
        self.rl_penalize = -100     # 惩罚值
        self.rl_normal = -1        # 普通值

        self.read_mat()

    # 读取mat文件的函数，保持文件名一致即可
    def read_mat(self):
        path = "data/"
        R_list = scio.loadmat(path + "R1.mat")['R1'][0]
        self.R = R_list[0]
        H_list = scio.loadmat(path + "H.mat")['H'][0]
        self.H = H_list[0]
        L_list = scio.loadmat(path + "L1.mat")['L1'][0]
        for i in range(self.R):
            self.L.append(L_list[i])
        E_list = scio.loadmat(path + "E1.mat")['E1'][0]
        for j in range(self.H):
            self.E.append(E_list[j])
        P_list = scio.loadmat(path + "P.mat")['P']
        for i in range(self.R):
            p_i = []
            for j in range(self.H):
                p_i.append(P_list[i][j])
            self.p_ij.append(p_i)
