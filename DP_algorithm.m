function [UperBound_SpecialCase,FesibleSolution_SpecialCase]=DP_algorithm(R,H,gamma,mu,xi,L,E,P)
X=zeros(R,H);
g={};

psi=zeros(2,R);
for r=1:R
    for t=0:1
        X(r) = t;
        p=Compute_p_SpecialCase(R,P,X);
        psi(t+1,r)=p;
        X(r,1) = 0;
    end
end

E1 = E*H;
for q=1:R
    for u=0:E1
        if q==1
            if u==0
                phi(u+1,1)=psi(u+1,1);
                g{u+1,1}=0;
            else
                if u>=L(q)
                    u;
                    phi(u+1,1)=max(psi(1:2,1));
                    for t=0:1
                        if max(psi(1:2,1))==psi(t+1,1)
                           g{u+1,1}=t;
                        end
                    end
                else
                    phi(u+1,1)=psi(1,1);
                    g{u+1,1}=0;
                end
            end
        else
            if u==0
                phi(u+1,q-1);
                psi(u+1,q);
                phi(u+1,q)=psi(u+1,q)+phi(u+1,q-1);
                t_star=0;
            else
               if u>=L(q)
                   phi(u+1,q-1)+psi(1,q);
                   phi(u+1-L(q),q-1)+psi(2,q);
                   if  phi(u+1,q-1)+psi(1,q)>=phi(u+1-L(q),q-1)+psi(2,q)
                       phi(u+1,q)=phi(u+1,q-1)+psi(1,q);
                       t_star=0;
                   else
                       phi(u+1,q)=phi(u+1-L(q),q-1)+psi(2,q);
                       t_star=1;
                   end
               else
                   phi(u+1,q)=psi(1,q)+phi(u+1,q-1);
                   t_star=0;
               end
            end
            g{u+1,q}=cat(2,g{u-L(q)*t_star+1,q-1},t_star);
        end
    end
end
X(:,1)=g{u+1,q};
UperBound_SpecialCase=Compute_p_SpecialCase(R,P,X);


%%%%%% Find Feasible Solution
X_opt=zeros(R,H);
AssignedTasks=find(X(:,1)==1);
UnassignedTasks=find(X(:,1)==0);
AssignedTasks_Pro=P(AssignedTasks,1);
MaxTask=max(AssignedTasks_Pro);
X1=X;
for i=1:sum(X(:,1))
    if MaxTask>0
        for k=1:R
            if P(k,1)==MaxTask
                TaskLocation=k;
            end
        end
        Label=1;
        while Label<=H
            if L(TaskLocation)<E(Label)
                X_opt(TaskLocation,Label)=1;
                E(Label)=E(Label)-L(TaskLocation);
                X(TaskLocation,1)=0;
                AssignedTasks=find(X(:,1)==1);
                AssignedTasks_Pro=P(AssignedTasks,1);
                MaxTask=max(AssignedTasks_Pro);
                break
            else
                Label=Label+1;
            end
        end
    end
end
FirstRound=X_opt;
UnAssignedTasks_Pro=P(UnassignedTasks,1);
MaxTask=max(UnAssignedTasks_Pro);
for i=1:R-sum(X(:,1))
    if MaxTask>0
        for k=1:R
            if P(k,1)==MaxTask
                UnTaskLocation=k;
            end
        end
        Label=1;
        while Label<=H
            if L(UnTaskLocation)<E(Label)
                X_opt(UnTaskLocation,Label)=1;
                E(Label)=E(Label)-L(UnTaskLocation);
                X1(UnTaskLocation,1)=1;
                UnAssignedTasks=find(X1(:,1)==0);
                UnAssignedTasks_Pro=P(UnAssignedTasks,1);
                MaxTask=max(UnAssignedTasks_Pro);
                break
            else
                Label=Label+1;
            end
        end
    end
end
SecondRound=X_opt;
Diff=sum(SecondRound-FirstRound);
X_opt=X_opt;
FesibleSolution_SpecialCase=0;
for i=1:R
    for j=1:H
        if X_opt(i,j)==1
           FesibleSolution_SpecialCase=FesibleSolution_SpecialCase+P(i,j);
        end
    end
end
FesibleSolution_SpecialCase=FesibleSolution_SpecialCase/R;










