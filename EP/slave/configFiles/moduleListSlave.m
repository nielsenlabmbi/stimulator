function Mlist = moduleListSlave

%list of all modules on the slave
%organization: module code (for communication with the master), parameter
%file name, maketexture file name, playtexture file name
%the first one is the module that is automatically loaded when starting
%stimulator

Mlist{1} = {'RG' 'configPstate_RCGrating' 'makeTexture_RCGrating' 'playTexture_RCGrating' };
Mlist{2} = {'RT' 'configPstate_RC2Gratings' 'makeTexture_RC2Gratings' 'playTexture_RC2Gratings' };
Mlist{3} = {'RP' 'configPstate_RCGratPlaid' 'makeTexture_RCGratPlaid' 'playTexture_RCGratPlaid' };
