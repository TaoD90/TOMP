function [ObjectiveFunction]=Compute_p_SpecialCase(R,P,X)

ObjectiveFunction=0;
for i=1:R
    if X(i,1)==1
        ObjectiveFunction=ObjectiveFunction+P(i,1);
    end
end
ObjectiveFunction = ObjectiveFunction/R;
