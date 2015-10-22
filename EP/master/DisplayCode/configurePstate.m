function configurePstate(modID,listtype)
%this function sets the global variable Pstate by calling the correct
%config function

%modID: number of module
Mlist=moduleListMaster(listtype);

eval(Mlist{modID}{3});