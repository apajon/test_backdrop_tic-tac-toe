function board=state2board(state)
state_=repmat(' ',9,1);
state_(any(state==+1,2))='x';
state_(any(state==-1,2))='o';
% state_(any(state==0,2))=' ';

board=repmat('|',3,7);
board(:,2)=state_(1:3,1);
board(:,4)=state_(4:6,1);
board(:,6)=state_(7:9,1);
end