function EndGame=EndGame(state)
%EndGame=0 or 1
%0 for game not finish
%1 when we have a winner

EndGame=false;

%win collumn
if abs(sum(state(1:3)))==3||abs(sum(state(4:6)))==3||abs(sum(state(7:9)))==3
    EndGame=true;
end

%win row
if abs(sum(state(1:3:9)))==3||abs(sum(state(2:3:9)))==3||abs(sum(state(3:3:9)))==3
    EndGame=true;
end

%win diagonal
if abs(sum(state([1 5 9])))==3||abs(sum(state([3 5 7])))==3
    EndGame=true;
end 

end