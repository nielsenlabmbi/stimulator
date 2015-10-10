function makeGratingTexture_periodic

%make one cycle of the grating

global Mstate screenPTR screenNum ImRGB2 ImRGB mask mask2 P %movieBlock

global Gtxtr TDim TDim2 Gtxtr2 %'playgrating' will use these

Screen('Close')  %First clean up: Get rid of all textures/offscreen windows

Gtxtr = []; TDim = [];  %reset

P = getParamStruct;
screenRes = Screen('Resolution',screenNum);

pixpercmX = screenRes.width/Mstate.screenXcm;
pixpercmY = screenRes.height/Mstate.screenYcm;
if P.plaid_bit == 3
    P.x_pos2 = P.x_pos;
    P.y_pos2 = P.y_pos;
    P.x_size2 = P.x_size;
    P.y_size2 = P.y_size;
    if P.mask_radius2 < P.mask_radius;
        P.mask_radius2 = P.mask_radius;
    end
end
    

if strcmp(P.altazimuth,'none')
    
    %The following assumes the screen is curved
    xcm = 2*pi*Mstate.screenDist*P.x_size/360;  %stimulus width in cm
    xN = round(xcm*pixpercmX);  %stimulus width in pixels
    ycm = 2*pi*Mstate.screenDist*P.y_size/360;   %stimulus height in cm
    yN = round(ycm*pixpercmY);  %stimulus height in pixels
    
else
    
    %The following assumes a projection of spherical coordinates onto the
    %flat screen
    xN = 2*Mstate.screenDist*tan(P.x_size/2*pi/180);  %grating width in cm
    xN = round(xN*pixpercmX);  %grating width in pixels
    yN = 2*Mstate.screenDist*tan(P.y_size/2*pi/180);  %grating height in cm
    yN = round(yN*pixpercmY);  %grating height in pixels
    
end

xN = round(xN/P.x_zoom);  %Downsample for the zoom
yN = round(yN/P.y_zoom);

if P.plaid_bit >= 2
    if strcmp(P.altazimuth,'none')
        
        %The following assumes the screen is curved
        xcm = 2*pi*Mstate.screenDist*P.x_size2/360;  %stimulus width in cm
        xN2 = round(xcm*pixpercmX);  %stimulus width in pixels
        ycm = 2*pi*Mstate.screenDist*P.y_size2/360;   %stimulus height in cm
        yN2 = round(ycm*pixpercmY);  %stimulus height in pixels
        
    else
        
        %The following assumes a projection of spherical coordinates onto the
        %flat screen
        xN2 = 2*Mstate.screenDist*tan(P.x_size2/2*pi/180);  %grating width in cm
        xN2 = round(xN2*pixpercmX);  %grating width in pixels
        yN2 = 2*Mstate.screenDist*tan(P.y_size2/2*pi/180);  %grating height in cm
        yN2 = round(yN2*pixpercmY);  %grating height in pixels
        
    end
    
    xN2 = round(xN2/P.x_zoom);  %Downsample for the zoom
    yN2 = round(yN2/P.y_zoom);
end
%create the mask
xdom = linspace(-P.x_size/2,P.x_size/2,xN);
ydom = linspace(-P.y_size/2,P.y_size/2,yN);
[xdom ydom] = meshgrid(xdom,ydom);
r = sqrt(xdom.^2 + ydom.^2);
if strcmp(P.mask_type,'disc')
    mask = zeros(size(r));
    id = find(r<=P.mask_radius);
    mask(id) = 1;
elseif strcmp(P.mask_type,'gauss')
    mask = exp((-r.^2)/(2*P.mask_radius^2));
else
    mask = ones(size(r));
end
mask = single(mask);

if P.plaid_bit >= 2
    xdom = linspace(-P.x_size2/2,P.x_size2/2,xN2);
    ydom = linspace(-P.y_size2/2,P.y_size2/2,yN2);
    [xdom ydom] = meshgrid(xdom,ydom);
    r = sqrt(xdom.^2 + ydom.^2);
    if strcmp(P.mask_type,'disc')
        mask2 = zeros(size(r));
        id = find(r<=P.mask_radius2);
        mask2(id) = 1;
    elseif strcmp(P.mask_type,'gauss')
        mask2 = exp((-r.^2)/(2*P.mask_radius2^2));
    else
        mask2 = ones(size(r));
    end
    mask2 = single(mask2);
end
if P.plaid_bit == 3
    dif = (size(mask2) - size(mask))/2;
    maskmult = ones(size(mask2));
    maskmult(dif(1)+1:dif(1)+size(mask,1),dif(2)+1:dif(2)+size(mask,2)) = 1 - mask;
    mask2 = mask2.*maskmult;
end

%%%%%%%%%

%%%%%%
%%%%%%BETA VERSION
[sdom tdom x_ecc y_ecc] = makeGraterDomain_beta(xN,yN,P.ori,P.s_freq,P.t_period,P.altazimuth);%orig


if P.plaid_bit == 1
    %I am ignoring t_period2 for now, and just setting it to t_period
    %     if strcmp(P.altazimuth,'altitude')
    %         AZ2 = 'azimuth'
    %     elseif strcmp(P.altazimuth,'azimuth')
    %         AZ2 = 'altitude';
    %     end
    AZ2 = P.altazimuth;
    [sdom2 tdom2 x_ecc2 y_ecc2] = makeGraterDomain(xN,yN,P.ori2,P.s_freq2,P.t_period,AZ2,P.x_size,P.y_size);
elseif P.plaid_bit >= 2
    AZ2 = P.altazimuth;
    [sdom2 tdom2 x_ecc2 y_ecc2] = makeGraterDomain(xN2,yN2,P.ori2,P.s_freq2,P.t_period,AZ2,P.x_size2,P.y_size2);
end



flipbit = 0;

if ~P.separable
    %movieBlock = zeros(length(sdom(:,1)),length(sdom(1,:)),length(tdom));
    for i = 1:length(tdom)
        
        Im = makePerGratFrame_insep(sdom,tdom,i,1);
        
        if P.plaid_bit == 1
            Im = makePerGratFrame_insep(sdom2,tdom2,i,2) + Im;
        elseif P.plaid_bit >= 2
            Im2 = makePerGratFrame_insep(sdom2,tdom2,i,2);
        end
        
        if P.noise_bit
            if rem(i,P.noise_lifetime) == 1
                %                 nwx = round(P.noise_width/P.x_zoom);
                %                 nwy = round(P.noise_width/P.y_zoom);
                %                 noiseIm = makeNoiseIm(size(Im),nwx,nwy,P.noise_type);
                
                noiseIm = makeNoiseIm_beta(size(Im),P,x_ecc,y_ecc);
                
                flipbit = 1-flipbit;
                if flipbit
                    noiseIm = 1-noiseIm;
                end
            end
            
            Im = Im - 2*noiseIm;
            Im(find(Im(:)<-1)) = -1;
            
            
            
        end
        
        %movieBlock(:,:,i) = Im;
        
        ImRGB = ImtoRGB(Im,P.colormod,P,mask);
        if P.plaid_bit >= 2
            ImRGB2 = ImtoRGB(Im2,P.colormod,P,mask2);
        end
        
        Gtxtr(i) = Screen(screenPTR, 'MakeTexture', ImRGB);
        if P.plaid_bit >= 2
            if P.plaid_bit == 3
                ulmask2(:,:,1) = mask2;
                ulmask2(:,:,2) = ulmask2(:,:,1);
                ulmask2(:,:,3) = ulmask2(:,:,1);
                ulmask(:,:,1) = mask;
                ulmask(:,:,2) = ulmask(:,:,1);
                ulmask(:,:,3) = ulmask(:,:,1);
                dif = (size(ImRGB2) - size(ImRGB))/2;
                ImRGB2 = im2double(ImRGB2);
                ImRGB2 = ImRGB2*255;
                ImRGB = im2double(ImRGB);
                ImRGB = ImRGB*255;
                ImRGB2 = ImRGB2 - P.background;
                ImRGB = ImRGB - P.background;
                ImRGB2(dif(1)+1:dif(1)+size(ImRGB,1),dif(2)+1:dif(2)+size(ImRGB,2),:) = ImRGB2(dif(1)+1:dif(1)+size(ImRGB,1),dif(2)+1:dif(2)+size(ImRGB,2),:).*ulmask2(dif(1)+1:dif(1)+size(ImRGB,1),dif(2)+1:dif(2)+size(ImRGB,2),:)+ImRGB.*ulmask;
                ImRGB2 = ImRGB2 + P.background;
                ImRGB = ImRGB + P.background;
                ImRGB = uint8(ImRGB);
                ImRGB2 = uint8(ImRGB2);
            end
            Gtxtr2(i) = Screen(screenPTR, 'MakeTexture', ImRGB2);
        end
        
    end
    
else
    
    [amp temp] = makeSeparableProfiles(tdom,sdom,x_ecc,y_ecc,1);
    if P.plaid_bit
        [amp2 temp2] = makeSeparableProfiles(tdom2,sdom2,x_ecc2,y_ecc2,2);
    end
    
    for i = 1:length(tdom)
        
        Im = amp(i)*temp;
        
        if P.plaid_bit == 1
            Im = Im + amp2(i)*temp2;
        end
        ImRGB = ImtoRGB(Im,P.colormod,P,mask);
        Gtxtr(i) = Screen(screenPTR, 'MakeTexture', ImRGB);
        if P.plaid_bit >= 2
            Im2 = amp2(i)*temp2;
            ImRGB2 = ImtoRGB(Im2,P.colormod,P,mask2);
            if P.plaid_bit == 3
                ulmask2(:,:,1) = mask2;
                ulmask2(:,:,2) = ulmask2(:,:,1);
                ulmask2(:,:,3) = ulmask2(:,:,1);
                ulmask(:,:,1) = mask;
                ulmask(:,:,2) = ulmask(:,:,1);
                ulmask(:,:,3) = ulmask(:,:,1);
                ulmask = uint8(ulmask);
                ulmask2 = uint8(ulmask2);
                dif = (size(ImRGB2) - size(ImRGB))/2;
                ImRGB2 = im2double(ImRGB2);
                ImRGB2 = ImRGB2*255;
                ImRGB = im2double(ImRGB);
                ImRGB = ImRGB*255;
                ImRGB2 = ImRGB2 - P.background;
                ImRGB = ImRGB - P.background;
                ImRGB2(dif(1)+1:dif(1)+size(ImRGB,1),dif(2)+1:dif(2)+size(ImRGB,2),:) = ImRGB2(dif(1)+1:dif(1)+size(ImRGB,1),dif(2)+1:dif(2)+size(ImRGB,2),:).*ulmask2(dif(1)+1:dif(1)+size(ImRGB,1),dif(2)+1:dif(2)+size(ImRGB,2),:)+ImRGB.*ulmask;
                ImRGB2 = ImRGB2 + P.background;
                ImRGB = ImRGB + P.background;
                ImRGB = uint8(ImRGB);
                ImRGB2 = uint8(ImRGB2);
            end
            Gtxtr2(i) = Screen(screenPTR, 'MakeTexture', ImRGB2);
        end
    end
    
end



TDim = size(ImRGB(:,:,1));
TDim(3) = length(Gtxtr);
if P.plaid_bit >= 2
    TDim2 = size(ImRGB2(:,:,1));
end

