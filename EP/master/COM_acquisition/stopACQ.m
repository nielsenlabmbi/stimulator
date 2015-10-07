function stopACQ

global Mstate

title = [Mstate.anim '_' sprintf('u%s',Mstate.unit) '_' Mstate.expt];
dd = [Mstate.dataRoot '\' Mstate.anim ...
    '\' sprintf('u%s',Mstate.unit) '_' Mstate.expt ...
    '\' title];

cbmex('fileconfig',dd,'',0); %stop acq
cbmex('close'); %close connection to blackrock system