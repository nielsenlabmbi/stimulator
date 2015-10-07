function success = setParamVal(psymbol,pval)

global Pstate

idx = -1;
success = 0;

for i = 1:length(Pstate.param)
    if strcmp(psymbol,Pstate.param{i}{1})
    	idx = i;
        break;
    end
end

if idx > -1
    Pstate.param{idx}{3} = pval;
    success = 1;
end
