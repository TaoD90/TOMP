function [SimulatedResult] = SimulatedAnnealagorithm(Greedy_x,TempR,H,L,E1,P,mu,gamma,xi)


% 定义目标函数
% 定义目标函数



% 定义目标函数


% 设置模拟退火算法参数
initial_temperature = 100; % 初始温度
final_temperature = 1; % 终止温度
cooling_factor = 0.9; % 降温因子
max_iterations = 10000; % 最大迭代次数

% 初始化解空间
%solution = randi([0 1], TempR, H) % 随机生成初始解
%Greedy_x = [0     1     0     0
%     0     0     1     0
%     1     0     0     0
%     0     0     0     1
%     1     0     0     0
%     0     0     0     0
%     1     0     0     0
%     0     0     0     1
%     0     0     0     1
%     0     0     0     1
%     1     0     0     0
%     0     0     0     0
%     0     0     0     0
%     0     0     0     1
%     0     0     0     0]

%solution =Greedy_x;

L;
E1;

solution = randi([0 1], TempR, H); % 随机生成初始解
temp_result=objectiveFunction(solution,TempR,H,L,E1,P); % 最佳目标函数值
E2=E1;
for j=1:H
    counter1=0;
    for i=1:TempR
        E2(j) = E2(j) - solution(i,j)*L(i);
        if E2(j)<0
            solution(i,j) = 0;
            E2(j) = E2(j) + L(i);
        end
    end
end

A=ones(1,TempR);
for i=1:TempR
    counter2 = 0;
    for j = 1:H
        A(i) = A(i) - solution(i,j);
        if A(i)<0
            solution(i,j) = 0;
            A(i) = A(i) + 1;
        end
    end
end

best_solution = solution ;% 最佳解


 
% E1=[8     4     2    10]
% L=[3     1     2     1     2     4     2     3     2     2     1     2     2     1     4]
% H=4
% TempR=15

best_f = objectiveFunction(best_solution,TempR,H,L,E1,P); % 最佳目标函数值;


% 模拟退火算法迭代过程
temperature = initial_temperature; % 当前温度;

for iter = 1:max_iterations
    % 生成新的解
    
    random_row = randi(TempR); % 随机选择行索引
    random_col = randi(H); % 随机选择列索引
    %new_value = randi([0 1], 1, 1);
    solution(random_row, random_col) = ~solution(random_row, random_col);
    new_solution = solution;
    
    
    
    % 计算目标函数值的变化
    objectiveFunction(new_solution,TempR,H,L,E1,P);
    objectiveFunction(best_solution,TempR,H,L,E1,P);
    delta_f = objectiveFunction(new_solution,TempR,H,L,E1,P) - objectiveFunction(best_solution,TempR,H,L,E1,P);
    
    % 判断是否接受新解
    if delta_f > 0 || exp(delta_f / temperature) > rand()
     %   solution = new_solution;
        
        % 更新最佳解
        if objectiveFunction(solution,TempR,H,L,E1,P) > best_f
            best_solution = new_solution;
            best_f = objectiveFunction(best_solution,TempR,H,L,E1,P);
        end
    end
    
    % 降温
    temperature = temperature * cooling_factor;
    
    % 输出当前迭代结果
  %  fprintf('Iteration %d: f = %.4f\n', iter, best_f);
    
    % 检查是否满足终止条件
    if temperature < final_temperature
        break;
    end
end

SimulatedResult=best_f;
