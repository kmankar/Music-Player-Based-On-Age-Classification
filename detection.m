function detection(capt1)
    FaceDetect = vision.CascadeObjectDetector('FrontalFaceCART');
    BB = FaceDetect(capt1);

    if  size(BB, 1) == 1
        I = imcrop(capt1,BB(1,:));

        width = BB(1,3);
        height = BB(1,4);

        NoseDetect = vision.CascadeObjectDetector('Nose');
        BBN = NoseDetect(I);

        MouthDetect = vision.CascadeObjectDetector('Mouth','MergeThreshold',50);
        BBM = MouthDetect(I);

        EyeDetect = vision.CascadeObjectDetector('EyePairBig');
        BBE = EyeDetect(I);

        if size(BBN,1)>0 && size(BBM,1)>0 && size(BBE,1)>0

            mouthPos = [BBM(1,1)+(BBM(1,3)/2), BBM(1,2)+(BBM(1,4)/2)];
            nosePos = [BBN(1,1)+(BBN(1,3)/2), BBN(1,2)+(BBN(1,4)*3/5)];
            leftPos = [BBE(1,1)+BBE(1,3)*5/6,BBE(1,2)+BBE(1,4)/2];
            rightPos = [BBE(1,1)+BBE(1,3)*1/6,BBE(1,2)+BBE(1,4)/2];

            eyeLevel = (rightPos(2)+leftPos(2))/2;

            BBF = [BBE(1,1),BBE(1,2)-BBE(1,4)*3/2,BBE(1,3),BBE(1,4)];
            BBUR = [BBE(1,1),eyeLevel,BBE(1,3)*1/3,BBE(1,4)];
            BBUL = [BBE(1,1)+BBE(1,3)*2/3,eyeLevel,BBE(1,3)*1/3,BBE(1,4)];
            BBRC = [BBM(1,1)-BBM(1,3)*1/2,BBM(1,2)-BBM(1,4)*1/2,BBM(1,3)*1/2,BBM(1,4)];
            BBLC = [BBM(1,1)+BBM(1,3),BBM(1,2)-BBM(1,4)*1/2,BBM(1,3)*1/2,BBM(1,4)];

            [r1,r2,r3,r4,r5,r6] = ratios(rightPos,leftPos,nosePos,eyeLevel,mouthPos,height);
            [w1,w2,w3,w4,w5] = wrinkles(I,BBF,BBUL,BBUR,BBLC,BBRC);

            features = [r1,r2,r3,r4,r5,r6,w1,w2,w3,w4,w5];
            result = classifier(features); 

            mapping_age(result);

        else
            if size(BBN,1)==0
                errordlg('Nose not detected');
            elseif size(BBM,1)==0
                errordlg('Mouth not detected');
            elseif size(BBE,1)==0
                errordlg('Eyes not detected');
            end
        end
    else
        if   size(BB, 1) > 1
            errordlg('Multiple faces detected.');
        else
            errordlg('No face detected.');
        end
    end
end