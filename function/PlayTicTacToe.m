function []=PlayTicTacToe(NeuralNet)
%% Test of Play
WhoPlayFirst=randsrc(1,1,1:2);
%1 : human
%2 : Bot
switch WhoPlayFirst
    case 1
        disp(['Human play first'])
    case 2
        disp(['Bot play first'])
end

%Initialize board
state=zeros(9,1);

while ~EndGame(state)&&~isempty(state(any(state==0,2)))
    if (WhoPlayFirst==2 && sum(state)==0) || (WhoPlayFirst==1 && sum(state)==1)
        %bot to play
        for g=1:9
            NeuralNet.neurones.lvl_0(g).activation_unit=state(g);
        end
        NeuralNet.updateActivation();
        
        if ~isempty(state(any(state==0,2)))
            activation_units=NeuralNet.getActivation_unit(NeuralNet.NumberOfLayer);
            if sum(state)==1
                activation_units=1-activation_units;
                activation_units=min(1,activation_units');
                activation_units=max(0,activation_units');
            end
            activation_units(any(state~=0,2))=0;

            activation_units=activation_units./sum(activation_units);

            newPlay=randsrc(1,1,[1:9;activation_units']);
            
            if ~isempty(newPlay) && sum(state(newPlay)==0) %sum(any(state==0,2))~=9
                switch sum(state)
                    case 0
                        state(newPlay(end))=+1;
                    case 1
                        state(newPlay(end))=-1;
                    otherwise
                        msg='Error with state \n';
                        errormsg=[msg];
                        error(errormsg,[])
                end
            elseif state(newPlay)~=0
                msg='Error with newPlay \n';
                errormsg=[msg];
                error(errormsg,[])
            end
            
        end

    else %Human to play
        humanPlay=[];
        disp(['Pity Human to play'])
        while isempty(humanPlay)
            disp(['Choose your board placement :'])
            disp(find(state'==0))
            state2board(state)
            humanPlay=input('Press a number !')
            
            if ~sum(state(humanPlay)==0)
                humanPlay=[];
                disp(['Idiot Human choose an empty placement'])
            end     
        end
        
        switch sum(state)
            case 0
                state(humanPlay)=+1;
            case 1
                state(humanPlay)=-1;
            otherwise
                msg='Error with state \n';
                errormsg=[msg];
                error(errormsg,[])
        end
    end
    
end

if isempty(state(any(state==0,2)))
    winner=0.5;
else
    winner=WhoWin(state);
end

if winner==0.5
    disp(['Tie : Not so bad pity human'])
elseif (winner==0&&WhoPlayFirst==2) || (winner==1&&WhoPlayFirst==1)
    disp(['You Win : Well play pity human'])
elseif (winner==0&&WhoPlayFirst==1) || (winner==1&&WhoPlayFirst==2)
    disp(['You Lose : Bad play dumb human'])
else
    disp(['Bad results'])
end

NeuralNet.neurones.(['lvl_' num2str(NeuralNet.NumberOfLayer+1)])(1).target_unit=winner;
NeuralNet.Backprop(v);
end