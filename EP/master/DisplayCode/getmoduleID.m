function modID = getmoduleID

global GUIhandles

mi = get(GUIhandles.param.module,'value');

mList=moduleListMaster;

modID=mList{mi}{1};
