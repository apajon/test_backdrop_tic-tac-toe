function []=TrainNeuralNetwork2(NeuralNet,k_max,v)
k_temp=0;

tic
while k_temp<k_max
    %Initialize the game state
    state=zeros(9,1);
    for g=1:9
        NeuralNet.neurones.lvl_0(g).activation_unit=state(g);
    end
    NeuralNet.updateActivation();
    
    newPlay=[];
    
    while ~EndGame(state)&&~isempty(state(any(state==0,2)))      

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
            NeuralNet.neurones.lvl_0(newPlay(end)).activation_unit=state(newPlay(end));
        elseif state(newPlay)~=0
            msg='Error with newPlay \n';
            errormsg=[msg];
            error(errormsg,[])
        end
%         state2board(state)
        
        %Compute activation values and units of hidden and output neurons
        NeuralNet.updateActivation();
        if ~isempty(state(any(state==0,2)))
            activation_units=NeuralNet.getActivation_unit(NeuralNet.NumberOfLayer)*0+0.5;
            if sum(state)==1
                activation_units=1-activation_units;
                activation_units=min(1,activation_units');
                activation_units=max(0,activation_units');
            end
            activation_units(any(state~=0,2))=0;

            activation_units=activation_units./sum(activation_units);
            
            newPlay=[newPlay;randsrc(1,1,[1:9;activation_units'])];
            
        end
    end
    
    if ~EndGame(state)&&isempty(state(any(state==0,2)))
        winner=0.5;
    else
        winner=WhoWin(state);
    end
    
    for k=size(newPlay,1):-1:1
        NeuralNet.updateActivation();
        if winner==0.5
            NeuralNet.neurones.(['lvl_' num2str(NeuralNet.NumberOfLayer+1)])(1).target_unit=0.5;
        else
            if (winner==1&&mod(k,2)==1) || (winner==0&&mod(k,2)==0)   
                a=NeuralNet.neurones.(['lvl_' num2str(NeuralNet.NumberOfLayer+1)])(1).activation_unit;
                NeuralNet.neurones.(['lvl_' num2str(NeuralNet.NumberOfLayer+1)])(1).target_unit=a+0.5(1-a);
            elseif (winner==1&&mod(k,2)==0) || (winner==0&&mod(k,2)==1) 
                NeuralNet.neurones.(['lvl_' num2str(NeuralNet.NumberOfLayer+1)])(1).target_unit=0;
            end
        end
        NeuralNet.Backprop(v);
        
        state(newPlay(k))=0;
        NeuralNet.neurones.lvl_0(newPlay(k)).activation_unit=0;
    end
    
%     state2board(state)
    
    k_temp=k_temp+1;
 
end
toc
end