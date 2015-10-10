function refreshParamView(varargin)

global Pstate GUIhandles

s = cell(1,length(Pstate.param));
for i = 1:length(Pstate.param)
    p = Pstate.param{i};
    switch(p{2})
        case 'float'
            s{i} = sprintf('%16s: %7.1f %s',p{1},p{3},p{5});
        case 'int'
            s{i} = sprintf('%16s: %7d %s',p{1},p{3},p{5});
        case 'string'
            s{i} = sprintf('%16s: %7s',p{1},p{3});
    end
end

if nargin==1  %necessary b/c we're switching lists
    set(GUIhandles.param.parameterList,'value',1);
end
set(GUIhandles.param.parameterList,'String',s);


