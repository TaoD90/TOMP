from dataController import DataController
from dqn import DQN
from loguru import logger

'''
# Python 3.7.16

# pytorch
pip install torch==1.8.1+cu111 -f https://download.pytorch.org/whl/torch_stable.html -i https://pypi.tuna.tsinghua.edu.cn/simple/ --trusted-host mirrors.aliyun.com

# pip
pip install numpy pandas matplotlib -i https://pypi.tuna.tsinghua.edu.cn/simple
pip install docplex cplex -i https://pypi.tuna.tsinghua.edu.cn/simple
pip3 install --user gym[classic_control] matplotlib seaborn -i  https://pypi.tuna.tsinghua.edu.cn/simple
pip install pfrl -i https://pypi.tuna.tsinghua.edu.cn/simple
pip install loguru -i https://pypi.tuna.tsinghua.edu.cn/simple
pip install scipy -i https://pypi.tuna.tsinghua.edu.cn/simple
'''


if __name__ == '__main__':
    # clear the log before logging
    open('runtime.log', 'w').close()
    logger.add('runtime.log')

    data = DataController()
    dqn = DQN(data)
    dqn.start()
    dqn.draw_plot()
