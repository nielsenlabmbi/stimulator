function outlist = moduleListMaster(listtype)

%list of all modules on the master
%Plist is the list for the paramSelect window, Mlist for the master window
%organization: module code (for communication with the slave), description (for parameter GUI), parameter
%file name
%the first one is the module that is automatically loaded when starting
%stimulator
%we don't use the config files for the mapper (causes issues with
%switching from mapper to paramSelect)


Plist{1} = {'PG' 'BW Grating' 'configPstate_PerGrating' };
Plist{2} = {'RD' 'Random Dot' 'configPstate_RDK' };
Plist{3} = {'RG' 'RC 1 Grating' 'configPstate_RCGrating' };
Plist{4} = {'RT' 'RC 2 Gratings' 'configPstate_RC2Gratings' };
Plist{5} = {'RP' 'RC Grat Plaid' 'configPstate_RCGratPlaid' };
Plist{6} = {'OF' 'Optic Flow' 'configPstate_OpticFlow' };
Plist{7} = {'IM' 'Images' 'configPstate_Img' };
Plist{8} = {'GA' 'GA' 'configPstate_GA' };
Plist{9} = {'AD' 'Adaptation' 'configPstate_Adapt' };


Mlist{1} = {'MG' 'BW Grating'};
Mlist{2} = {'MM' 'Bar'};


if strcmp(listtype,'P')
    outlist=Plist;
else
    outlist=Mlist;
end