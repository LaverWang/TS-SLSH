function [spike] = encode_phase(I)
i=0;
shift=0;
for row=1:28
    for col=1:28
        i=i+1;
        if I(row,col)==1
           spike(i)=mod((pi-(i-1)*pi/392-shift)*1000/(10*pi),300);
        else 
            spike(i)=mod(((1-i)*pi/392-shift)*1000/(pi*10),300);
        end
    end
end
