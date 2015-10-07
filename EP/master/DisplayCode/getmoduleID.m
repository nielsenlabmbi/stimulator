function modID = getmoduleID

global GUIhandles

modID = get(GUIhandles.param.module,'value');

switch modID
    case 1
        modID = 'PG';
    case 2
        modID = 'FG';
    case 3
        modID = 'RD';
    case 4
        modID = 'FN';
    case 5
        modID = 'MP';
    case 6
        modID = 'AG';
    case 7
        modID = 'RK';
    case 8
        modID = 'OF';
    case 9
        modID = 'FP';
    case 10
        modID = 'IM';
    case 11
        modID = 'CS';
	case 12
        modID = 'GA';
    case 13
        modID = 'RP';
	case 14
		modID = 'GM';
end