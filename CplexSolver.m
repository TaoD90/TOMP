function [OptimalValue]=CplexSolver(R,TempH,L,E1,P)

x = binvar(R,TempH);
    % ���Լ������
    C=[];
    for i=1:TempH
        Temp=0;
        for j=1:R
            Temp=Temp+L(j)*x(j,i);
        end
        C=[C;Temp<=E1(i)];
    end
    for i=1:R
        Temp=0;
        for j=1:TempH
            Temp=Temp+x(i,j);
        end
        C=[C;Temp<=1];
    end
    % ����
    ops = sdpsettings('verbose',0,'solver','cplex');
    % Ŀ�꺯��
     Temp=0;
     for i=1:R
        for j=1:TempH
            Temp=Temp+x(i,j)*P(i,j);
        end
     end
     z=-Temp;
    reuslt = optimize(C,z);
    if reuslt.problem == 0 % problem =0 �������ɹ�
        OptimlSolution=value(x);
        OptimalValue=-value(z)/R   % ��ת
    else
        disp('������');
    end