function f = objectiveFunction(x,TempR,H,L,E1,P)
    % 在这里定义目标函数，根据问题具体情况编写
    % x 是一个二进制向量，表示0-1解空间中的一个解
    % values 是物品价值的向量
    % weights 是物品重量的矩阵，每行对应一个物品，每列对应一个维度
    % capacity 是背包的容量向量，每个维度对应一个限制条件
    % f 是目标函数值，根据最大化或最小化问题进行定义
     % 计算总价值和总重量
     sum=0;
     for i=1:TempR
         for j=1:H
             sum=sum+x(i,j)*P(i,j);
         end
     end  

     for j=1:H
         constraint1=0;
         for i=1:TempR
             constraint1=constraint1+x(i,j)*L(i);
         end
         total_capa(j)=constraint1;
     end
     total_capa;
      for i=1:TempR
         constraint2=0;
         for j=1:H
             constraint2=constraint2+x(i,j);
         end
         total_task(i)=constraint2;
     end
     total_task;
     counter=0;
     for i=1:TempR
         if total_task(i)>1
             counter=counter+1;
         end
     end
     for j=1:H
         if total_capa(j)>E1(j)
              counter=counter+1;
         end
     end
     
     if counter>0
         f=0;
     else
         f=sum/TempR;
     end

end