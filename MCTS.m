function [Result,X]=MCTS(R,H,mu,gamma,xi,P,E,L)





Number=1;
Result=-100;

TempP=0;
for k=1:Number
    X=zeros(R,H);
    for i=1:R
        counter=1;
        while counter<=H
            AssignedHelper=randi([1 H]);
            if L(i)<E(AssignedHelper)
                X(i,AssignedHelper)=1;
                E(AssignedHelper)=E(AssignedHelper)-L(i);
                counter=H+1;
            else
                 counter=counter+1;
            end
        end
    end
    X;
    TempP=0;
     for i=1:R
        for j=1:H
            if X(i,j)==1
                TempP=TempP+P(i,j);
            end
        end
     end
     if TempP>Result
         Result=TempP;
     end
end
Result=Result/R;
X;