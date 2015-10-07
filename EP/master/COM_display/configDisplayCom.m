function configDisplayCom

global DcomState

%Modification of MP285Config, for configuration of udp port connection to visual stimulus PC (pep) 	

%DcomState is not initialized in the .ini file, nor is it saved in the state.headerString 

rip = '172.30.11.142';

% close all open udp port objects on the same port and remove
% the relevant object form the workspace
port = instrfindall('RemoteHost',rip);
if length(port) > 0; 
    fclose(port); 
    delete(port);
    clear port;
end

% make udp object named 'stim'
DcomState.serialPortHandle = udp(rip,'RemotePort',8000,'LocalPort',9000);

set(DcomState.serialPortHandle, 'OutputBufferSize', 1024)
set(DcomState.serialPortHandle, 'InputBufferSize', 1024)
set(DcomState.serialPortHandle, 'Datagramterminatemode', 'off')

%Establish serial port event callback criterion  
DcomState.serialPortHandle.BytesAvailableFcnMode = 'Terminator';
DcomState.serialPortHandle.Terminator = '~'; %Magic number to identify request from Stimulus ('c' as a string)
DcomState.serialPortHandle.bytesavailablefcn = @Displaycb;  

% open and check status 
fopen(DcomState.serialPortHandle);
stat=get(DcomState.serialPortHandle, 'Status');
if ~strcmp(stat, 'open')
    disp([' StimConfig: trouble opening port; cannot proceed']);
    DcomState.serialPortHandle=[];
    out=1;
    return;
end



