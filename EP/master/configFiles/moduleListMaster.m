function Mlist = moduleListMaster

%list of all modules on the master
%organization: module code (for communication with the slave), description (for parameter GUI), parameter
%file name
%the first one is the module that is automatically loaded when starting
%stimulator

Mlist{1} = {'RG' 'RC 1 Grating' 'configPstate_RCGrating' };
Mlist{2} = {'RT' 'RC 2 Gratings' 'configPstate_RC2Gratings' };
Mlist{3} = {'RP' 'RC Grat Plaid' 'configPstate_RCGratPlaid' };
