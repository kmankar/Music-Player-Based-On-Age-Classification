function [r1,r2,r3,r4,r5,r6] = ratios(rightPos,leftPos,nosePos,eyeLevel,mouthPos,height)
    t1 = leftPos(1) - rightPos(1);
    t2 = nosePos(2) - eyeLevel;
    t3 = mouthPos(2) - eyeLevel;
    t4 = height - eyeLevel;
    t5 = height;

    r1 = t1 / t2;
    r2 = t1 / t3;
    r3 = t1 / t4;
    r4 = t2 / t3;
    r5 = t3 / t4;
    r6 = t4 / t5;
end