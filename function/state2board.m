function board=state2board(state)
state_=repmat(' ',9,1)
state_(any(state==+1,2))='x';
state_(any(state==-1,2))='o';
% state_(any(state==0,2))=' ';

board(:,1)=state_(1:3,1);
board(:,3)=state_(4:6,1);
board(:,5)=state_(7:9,1);
end