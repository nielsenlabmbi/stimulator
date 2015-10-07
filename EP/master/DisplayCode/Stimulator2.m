function Stimulator2

%Initialize stimulus parameter structures
configurePstate('FG')
configureMstate
configureLstate

%Host-Host communication
configDisplayCom    %stimulus computer



%Open GUIs
hm = MainWindow;
movegui(hm,[10,560]);

hl = Looper ;
movegui(hl,[380,445]);

hp = paramSelect;
movegui(hp,[10,170]);

%hg = gaGui;
%movegui(hg,[380,240]);
