function makeTexture_PerGrating

%make periodic grating
%types of stimuli: one grating (plaid_bit=0), two overlapping gratings,
%both visible entirely (plaid_bit=1, surround_bit=0), two gratings, one in
%center, one in surround (plaid_bit=1, surround_bit=1)
%gratings have to have the same center
%this just generates the basic grating and mask, movement and visibility is
%handled in playtexture
%this assumes a normalized color scale from 0 to 1

global  screenPTR screenNum 

global Gtxtr  Masktxtr   %'play' will use these

%clean up
if ~isempty(Gtxtr)
    Screen('Close',Gtxtr);  %First clean up: Get rid of all textures/offscreen windows
end

if ~isempty(Masktxtr)
    Screen('Close',Masktxtr);  %First clean up: Get rid of all textures/offscreen windows
end

Gtxtr = [];  
Masktxtr=[];


%get parameters
P = getParamStruct;
screenRes = Screen('Resolution',screenNum);


%convert stimulus size to pixel
xN=deg2pix(P.x_size,'round');
yN=deg2pix(P.y_size,'round');

if P.plaid_bit==1
    xN2=deg2pix(P.x_size2,'round');
    yN2=deg2pix(P.y_size2,'round');
end


%create the masks 
mN=deg2pix(P.mask_radius,'round');
mask=makeMask(screenRes,x_pos,y_pos,xN,yN,mN,P.mask_type);
Masktxtr(1) = Screen(screenPTR, 'MakeTexture', mask,[],[],2);  %need to specify correct mode to allow for floating point numbers

if P.plaid_bit==1
    mN=deg2pix(P.mask_radius2,'round');
    mask=makeMask(screenRes,x_pos,y_pos,xN2,yN2,mN,P.mask_type2);
    Masktxtr(2) = Screen(screenPTR, 'MakeTexture', mask,[],[],2);  %need to specify correct mode to allow for floating point numbers
end



%generate texture

%stimuli will need to be larger to deal with rotation
stimsize=2*sqrt((P.x_size/2).^2+(P.y_size/2).^2);

%add extra so that we can slide the window to generate motion 
stimsize=stimsize+1/P.s_freq;

%use ceil to make sure that we definitely have enough pixels
stimsizeN=deg2pix(stimsize,'ceil');

if P.plaid_bit==1
    stimsize2=2*sqrt((P.x_size2/2).^2+(P.y_size2/2).^2);
    stimsize2=stimsize2+1/P.s_freq2;
    stimsizeN2=deg2pix(stimsize2,'ceil');
end



%generate grating
x_ecc=linspace(-stimsize/2,stimsize/2,stimsizeN);
sdom = x_ecc*P.s_freq*2*pi; %radians
grating = cos(sdom);

if strcmp(P.s_profile,'square')
    thresh = cos(P.s_duty*pi);
    grating=sign(grating-thresh);
end
Gtxtr(1) = Screen('MakeTexture',screenPTR, grating,[],[],2);

if P.plaid_bit==1
    x_ecc=linspace(-stimsize2/2,stimsize2/2,stimsizeN2);
    sdom = x_ecc*P.s_freq2*2*pi; %radians
    grating = cos(sdom);

    if strcmp(P.s_profile2,'square')
        thresh = cos(P.s_duty2*pi);
        grating=sign(grating-thresh);
    end
    Gtxtr(2) = Screen('MakeTexture',screenPTR, grating,[],[],2);
end







