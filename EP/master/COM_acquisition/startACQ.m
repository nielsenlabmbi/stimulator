function startACQ

global Mstate

title = [Mstate.anim '_' sprintf('u%s',Mstate.unit) '_' Mstate.expt];
dd = [Mstate.dataRoot '\' Mstate.anim ...
    '\' sprintf('u%s',Mstate.unit) '_' Mstate.expt ...
    '\' title];

cbmex('open'); %open connection to blackrock system
cbmex('fileconfig',dd,'',0); %need to start app first
cbmex('fileconfig',dd,'',1); %now start recording