function moveShutter(eye,pos)

global DcomState


msg=['S;' num2str(eye) ';' num2str(pos) ';~'];
disp(msg)
fwrite(DcomState.serialPortHandle,msg);
    