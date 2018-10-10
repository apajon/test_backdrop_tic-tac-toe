function winner=WhoWin(state)
total=sum(state);

switch total
    case 0
        winner=-1;
    case 1
        winner=+1;
    otherwise
        msg='Bad state or no winner \n';
        errormsg=[msg];
        error(errormsg,[])
end
end