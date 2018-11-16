function state=board2state(board)
board_=[board(:,2);board(:,4);board(:,6)];

state=zeros(9,1);
state(any(board_=='x',2))=+1;
state(any(board_=='o',2))=-1;
% state(any(state==' ',2))=0;
end