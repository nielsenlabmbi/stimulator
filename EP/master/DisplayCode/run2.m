function run2


%This function now gets called for play sample, as well. Hence the global
%conditional of Mstate.runnind

global GUIhandles  Mstate trialno

if Mstate.running
    nt = getnotrials;
end



if Mstate.running && trialno<=nt
    
    set(GUIhandles.main.showTrial,'string',['Trial ' num2str(trialno) ' of ' num2str(nt)] ), drawnow

    [c,~] = getcondrep(trialno);  %get cond and rep for this trialno

    %set eye shutter
    setShutter(c,trialno)

    %%%Organization of commands is important for timing in this part of loop
    tic
    buildStimulus(c,trialno)    %Tell stimulus to buffer the images
    waitforDisplayResp   %Wait for serial port to respond from display
    toc 
    mod = getmoduleID;
    startStimulus(mod)      %Tell Display to show its buffered images. TTL from stimulus computer "feeds back" to trigger acquisition
    %waitforDisplayResp
    
    trialno = trialno+1;


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else
    
    %This is executed at the end of experiment and when abort button is hit
    if get(GUIhandles.main.ephysflag,'value');
        stopACQ;
    end
    
    Mstate.running = 0;
    set(GUIhandles.main.runbutton,'string','Run')

    
end


