function [w1,w2,w3,w4,w5] = wrinkles(I,BBF,BBUL,BBUR,BBLC,BBRC)
    [~, ~, n] = size(I);
    if n > 1
        I = rgb2gray(I);
    end

    ForeImage = imcrop(I,BBF(1,:));
    BW1 = edge(ForeImage,'Canny',0.5);

    LeftUnderImage = imcrop(I,BBUL(1,:));
    BW2 = edge(LeftUnderImage,'Canny',0.5);

    RightUnderImage = imcrop(I,BBUR(1,:));
    BW3 = edge(RightUnderImage,'Canny',0.5);

    LeftCheekImage = imcrop(I,BBLC(1,:));
    BW4 = edge(LeftCheekImage,'Canny',0.5);

    RightCheekImage = imcrop(I,BBRC(1,:));
    BW5 = edge(RightCheekImage,'Canny',0.5);


    CC1 = bwconncomp(BW1);
    w1 = CC1.NumObjects;

    CC2 = bwconncomp(BW2);
    w2 = CC2.NumObjects;

    CC3 = bwconncomp(BW3);
    w3 = CC3.NumObjects;

    CC4 = bwconncomp(BW4);
    w4 = CC4.NumObjects;

    CC5 = bwconncomp(BW5);
    w5 = CC5.NumObjects;

end