function saveLog(x,varargin)

%An important thing to note on the way this is saved:  Since domains are
%only saved once, I can't put variables in the looper that
%would change this.  Also, rseeds are saved on top of each other. The
%sequences would also change if other parameters change, such as nori.

global Mstate

root = '/log_files/';

expt = [Mstate.anim '_' Mstate.unit '_' Mstate.expt];

fname = [root expt '.mat'];


frate = Mstate.refresh_rate;

if isempty(varargin)  %from 'make'  (happens on first trial only)... save domains and frame rate

    domains = x; 
    save(fname,'domains','frate')    
    
else %from 'play'... save sequence as 'rseedn'
    
    eval(['rseed' num2str(varargin{1}) '=x;' ])
    eval(['save ' fname ' rseed' num2str(varargin{1}) ' -append'])    
    
end

