function modID = getmoduleID

%this only returns moduleIDs for the parameter window, not the mapper

global GUIhandles

mi = get(GUIhandles.param.module,'value');

mList=moduleListMaster('P');

modID=mList{mi}{1};
