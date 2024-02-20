function  [GreedyResult,Greedy]=GreedyAlgorithm(R,H,L,E1,P,mu,gamma,xi)

E=E1;
Greedy=zeros(R,H);
for i=1:R
    for j=1:H
        Weight(i,j)=1/xi(i,j)+1/mu(j)+1/gamma(j);
      %  Weight(i,j)=1/mu(j)+1/gamma(j);
    end
    Vect=Weight(i,:);
    Label=1;
    counter=1;
    while Label==1 && counter<=H
        MaxValue=max(Vect);
        MaxW_Location=find(MaxValue==Vect);
        if L(i)<E(MaxW_Location)
            Greedy(i,MaxW_Location)=1;
            Label=0;
            E(MaxW_Location)=E(MaxW_Location)-L(i);
        else
            Vect(MaxW_Location)=0;
        end
        counter=counter+1;
    end
end
GreedyTemp=0;
for i=1:R
    for j=1:H
        if Greedy(i,j)==1
            GreedyTemp=GreedyTemp+P(i,j);
        end
    end
end
Greedy;
 GreedyResult=GreedyTemp/R;