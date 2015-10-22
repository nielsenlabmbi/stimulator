function startStimulus(modID)

global DcomState


msg = ['G;' modID ';~'];

fwrite(DcomState.serialPortHandle,msg);

