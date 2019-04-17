% This script processes the videos to make them grayscale and have
% reasonable aspect ratio

% Phone Pixel Aspect Ratio: 1920x1080p
% This is 2 million color pixels per video frame
% Can record in 1280x720p
% 921600 color pixels

% These aspect ratios are both 16:9
% Choose 256x144, reasonable 16:9 aspect ratio

clear variables; close all; clc;

videos = {'20190202_143602', '20190312_125426', '20190312_181033', '20190312_195723', '20190313_165031'};
vidfmt = '.mp4';
savfmt = '.mat';

w = 256;
h = 144;

for video = videos
    
    vid = [cell2mat(video) vidfmt];
    v = VideoReader(vid);
    
    numframes = double(int16(fix(v.FrameRate*v.Duration)));
    
    X = zeros([h*w numframes]);
    
    for j = 1:numframes
        frm = readFrame(v);
        gryfrm = rgb2gray(frm);
        ar = [h w];
        switch cell2mat(video)
            case '20190312_125426'
                ar = [w h];
        end
        Xfrm = imresize(gryfrm, ar);
        imshow(Xfrm); drawnow
        X(:,j) = double(reshape(Xfrm, [h*w 1]));
        if ~hasFrame(v)
            break
        end
    end

    save(['X' cell2mat(video) savfmt],'X')
end