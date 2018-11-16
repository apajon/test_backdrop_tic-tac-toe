function []=TrainNeuralNetwork(NeuralNet,k_max,v)
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
            activation_units=NeuralNet.getActivation_unit(NeuralNet.NumberOfLayer);
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
    
    if isempty(state(any(state==0,2)))
        winner=0.5;
    else
        winner=WhoWin(state);
    end
    
    NeuralNet.neurones.(['lvl_' num2str(NeuralNet.NumberOfLayer+1)])(1).target_unit=winner;
    NeuralNet.Backprop(v);
    
%     state2board(state)
    
    k_temp=k_temp+1;
    if mod(k_temp,10)==0
        k_temp
    end
end
toc
end