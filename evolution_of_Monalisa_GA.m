clc
clear
close all

error = 0;
fitness = 0;
fitness_old = 0;

targ_img = imread('img.png');
figure;
imshow(targ_img);
init_img = 255 * ones(128, 128, 'uint8');
imageSize = size(init_img);
figure;
h = imshow(init_img);
randx = randi([1 127],1,1);
randy = randi([1 127],1,1);

while fitness <= 0.9
    if fitness >= 0.7
        radius = randi([1 4],1,1);
        gray_value = randi([20 240],1,1);
    elseif fitness >= 0.55
        radius = randi([1 6],1,1);
        gray_value = randi([30 230],1,1);
    elseif fitness >= 0.4
        radius = randi([1 8],1,1);
        gray_value = randi([40 220],1,1);
    else
        radius = randi([1 10],1,1);
        gray_value = randi([50 200],1,1);
    end
    randx = de2bi(randx); 
    randy = de2bi(randy);
    [k1,k2] = size(randx);
    [l1,l2] = size(randy);
    m = randi([1 7],1,1);
    n = randi([1 7],1,1);
    while k2 < 7 
        randx = [randx,0];
        k2 = k2+1;
    end
    while l2 < 7 
        randy = [randy,0];
        l2 = l2+1;
    end
    randx(1,m) = ~randx(1,m); 
    randy(1,n) = ~randy(1,n); 
    randx = binaryVectorToDecimal(randx,'LSBFirst')';
    randy = binaryVectorToDecimal(randy,'LSBFirst')';
    ci = [randx, randy, radius];    
    [xx,yy] = ndgrid((1:imageSize(1))-ci(1),(1:imageSize(2))-ci(2));
    mask = (xx.^2 + yy.^2) < ci(3)^2;
    temp_init_img = init_img;
    init_img(mask) = gray_value;
    temp_init = double(init_img);
    temp_targ = double(targ_img);
    for ii = 1:1:128
        for jj = 1:1:128
            d1 = temp_init(ii,jj);
            d2 = temp_targ(ii,jj);
            diff = abs(d1 - d2)/(128*128*d1);
            error = error + diff;
        end
    end
    fitness = 1 - error; 
    if fitness > fitness_old  
        h = imshow(init_img);
        hold on;
        drawnow;
        axis('on', 'image');
        grid on;
    else
        init_img = temp_init_img;
        h = imshow(init_img);
        hold on;
        drawnow;
        axis('on', 'image');
        grid on;
    end
    fitness_old = fitness;
    error = 0;
end