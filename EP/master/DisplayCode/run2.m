function run2


%This function now gets called for play sample, as well. Hence the global
%conditional of Mstate.runnind

global GUIhandles Pstate Mstate trialno

if Mstate.running
    nt = getnotrials;
end




EphysBit = get(GUIhandles.main.ephysflag,'value');  %Flag for the link with scanimage

if Mstate.running && trialno<=nt
    

  
    set(GUIhandles.main.showTrial,'string',['Trial ' num2str(trialno) ' of ' num2str(nt)] ), drawnow

    [c r] = getcondrep(trialno);  %get cond and rep for this trialno

    %set eye shutter
    setShutter(c,trialno)

    %%%Organization of commands is important for timing in this part of loop
    tic
    buildStimulus(c,trialno)    %Tell stimulus to buffer the images
    waitforDisplayResp   %Wait for serial port to respond from display
    toc 
    startStimulus      %Tell Display to show its buffered images. TTL from stimulus computer "feeds back" to trigger acquisition
    %waitforDisplayResp
    
    %We don't want anything significant to happen after startStimulus, so that
    %scanimage will be ready to accept TTL
    
    trialno = trialno+1;


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else
    
    %Before, I had this in the 'mainwindow callback routine, which messed
    %things up on occasion.
    %This is executed at the end of experiment and when abort button is hit
    if get(GUIhandles.main.ephysflag,'value');
        stopACQ;
    end
    
    Mstate.running = 0;
    set(GUIhandles.main.runbutton,'string','Run')

    
end


