function makeTexture_DG

%Reverse correlation with drifting grating; this function only generates
%one line of the grating per spatial frequency, as well as the distribution
%of conditions; the rest is handled in playTexture_DG
%this assumes a normalized color scale from 0 to 1

global Mstate screenPTR screenNum loopTrial

global Gtxtr  Masktxtr  Gseq %'play' will use these

%clean up
if ~isempty(Gtxtr)
    Screen('Close',Gtxtr);  %First clean up: Get rid of all textures/offscreen windows
end

Gtxtr = [];  


%get parameters
P = getParamStruct;
screenRes = Screen('Resolution',screenNum);


%convert stimulus size to pixel
xN=deg2pix(P.x_size,'round');
yN=deg2pix(P.y_size,'round');


%create the mask - needs to be screen size to deal with the rotation
xdom=linspace(-screenRes.width/2,screenRes.width/2,screenRes.width);
ydom=linspace(-screenRes.height/2,screenRes.height/2,screenRes.height);
[xdom,ydom] = meshgrid(xdom,ydom); %this results in a matrix of dimension height x width
r = sqrt(xdom.^2 + ydom.^2);

maskradiusN=deg2pix(P.mask_radius,'round');

if strcmp(P.mask_type,'gauss')
    mask = 1-exp((-r.^2)/(2*maskradiusN^2));
elseif strcmp(P.mask_type,'disc') %disc is the default
    mask =1-(r<=maskradiusN);
else
    xran = [P.x_pos-floor(xN/2)+1  P.x_pos+ceil(xN/2)];
    yran = [P.y_pos-floor(yN/2)+1  P.y_pos+ceil(yN/2)];
    mask=ones(size(r));
    mask(yran(1):yran(2),xran(1):xran(2))=0;
end

maskblob = 0.5*ones(screenRes.height,screenRes.width,2);
maskblob(:,:,2) = mask;
Masktxtr = Screen(screenPTR, 'MakeTexture', maskblob,[],[],2);  %need to specify correct mode to allow for floating point numbers


%make orientation domains
oridom = linspace(P.min_ori,P.min_ori+P.orirange,P.n_ori+1);
oridom = oridom(1:end-1);
    
%make spatial frequency domain
if strcmp(P.sf_domain,'log')
    sfdom = logspace(log10(P.min_sf),log10(P.max_sf),P.n_sfreq);
elseif strcmp(P.sf_domain,'lin')
    sfdom = linspace(P.min_sf,P.max_sf,P.n_sfreq);
end
sfdom = unique(sfdom);
    
%make phase domain
phasedom = linspace(0,360,P.n_phase+1);
phasedom = phasedom(1:end-1); 

%number of images to present per trial
N_Im = round(P.stim_time*screenRes.hz/P.h_per); 

%create random stream for trial
s = RandStream.create('mrg32k3a','NumStreams',1,'Seed',P.rseed);
oriseq = randi(s,[1 length(oridom)],1,N_Im); 
sfseq = randi(s,[1 length(sfdom)],1,N_Im); 
phaseseq = randi(s,[1 length(phasedom)],1,N_Im); 

%add blanks
blankflag = zeros(1,N_Im);
if P.blankProb > 0
    nblanks = round(P.blankProb*N_Im);
    dumseq = randperm(s,N_Im);
    bidx=find(dumseq<=nblanks);
    
    %blank condition is identified with the following indices
    oriseq(bidx) = 1;
    sfseq(bidx) = length(sfdom) + 1;
    phaseseq(bidx) = 1;
    blankflag(bidx) = 1;
end


%save these in global structure for use by playTexture
Gseq.oridom=oridom;
Gseq.sfdom=sfdom;
Gseq.phasedom=phasedom;
Gseq.oriseq=oriseq;
Gseq.sfseq=sfseq;
Gseq.phaseseq=phaseseq;
Gseq.blankflag=blankflag;

%now generate textures - we need one per spatial frequency

%stimuli will need to be larger to deal with rotation
%all stimuli will be generated as a square with a side length equal to
%twice length of the diagonal of the chosen stimulus rectangle
%width is computed in degree because spatial frequency is in degree
stimsize=2*sqrt((P.x_size/2).^2+(P.y_size/2).^2);


%we also need to add extra so that we can slide the window to generate
%motion - need one extra cycle; to keep all stimuli the same size, we'll go
%with the lowest spatial frequency here
stimsize=stimsize+1/min(sfdom);

stimsizeN=deg2pix(stimsize,'ceil');

x_ecc=linspace(-stimsize/2,stimsize/2,stimsizeN);

for i=1:length(sfdom)
    sdom = x_ecc*sfdom(i)*2*pi; %radians
    grating = cos(sdom);

    if strcmp(P.s_profile,'square')
        thresh = cos(P.s_duty*pi);
        grating=sign(grating-thresh);
    end
        
    Gtxtr(i) = Screen('MakeTexture',screenPTR, grating,[],[],2);
end


%save sequence data
if Mstate.running
    Pseq = struct;
    Pseq.oriseq = oriseq;
    Pseq.sfseq = sfseq;
    Pseq.phaseseq = sfseq;
    Pseq.blankflag=blankflag;
    
    if loopTrial == 1
        domains = struct;
        domains.oridom = oridom;
        domains.sfdom = sfdom;
        saveLog(domains)
    end
    saveLog(Pseq,P.rseed)  %append log file with the latest sequence
    
    
end





