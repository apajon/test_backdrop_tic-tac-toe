function []=TrainNeuralNetworkSomeRandom(NeuralNet,k_max,propRand)
k_temp=0;

tic
while k_temp<k_max
    %Initialize the game state
    state=zeros(9,1);
    NeuralNet.changeInput(state)
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
            if randsrc(1,1,[0:1;[1-propRand propRand]])
                activation_units=NeuralNet.getActivation_unit(NeuralNet.NumberOfLayer+1)*0+0.5;
            else
                activation_units=NeuralNet.getActivation_unit(NeuralNet.NumberOfLayer+1);
            end
%             if sum(state)==1
%                 activation_units=1-activation_units;
%                 activation_units=min(1,activation_units');
%                 activation_units=max(0,activation_units');
%             end
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

    TrainFromPlay(NeuralNet,state,newPlay,winner)
    
%     state_=state;
%     for k=size(newPlay,1)-1:-1:1
%         state_(newPlay(k))=0;
%         
%         target=ones(9,1)*0.5;
%         target(any(state_~=0,2))=0;
%         
%         if winner==0.5
%             target(newPlay(k))=0.5;
%         elseif (winner==1&&mod(k,2)==1) || (winner==0&&mod(k,2)==0)   
%             target(newPlay(k))=1;
%         elseif (winner==1&&mod(k,2)==0) || (winner==0&&mod(k,2)==1)
%             target(newPlay(k))=0;
%         else
%             msg='Error with winner \n';
%             errormsg=[msg];
%             error(errormsg,[])
%         end
%         
%         NeuralNet.changeInput(state_);
%         NeuralNet.updateActivation();
%         
%         NeuralNet.changeTarget(target);
%         
%         NeuralNet.Backprop(v);        
%         
% %         NeuralNet.changeInput(state_);
% %         NeuralNet.changeTarget(target);
% %         
% %         NeuralNet.updateActivation();
% %         if winner==0.5
% %             NeuralNet.neurones.(['lvl_' num2str(NeuralNet.NumberOfLayer+1)])(1).target_unit=0.5;
% %         else
% %             if (winner==1&&mod(k,2)==1) || (winner==0&&mod(k,2)==0)   
% %                 a=NeuralNet.neurones.(['lvl_' num2str(NeuralNet.NumberOfLayer+1)])(1).activation_unit;
% %                 NeuralNet.neurones.(['lvl_' num2str(NeuralNet.NumberOfLayer+1)])(1).target_unit=a+0.5*(1-a);
% %             elseif (winner==1&&mod(k,2)==0) || (winner==0&&mod(k,2)==1) 
% %                 NeuralNet.neurones.(['lvl_' num2str(NeuralNet.NumberOfLayer+1)])(1).target_unit=0;
% %             end
% %         end
% %         NeuralNet.Backprop(v);
% % 
% %         state(newPlay(k))=0;
% %         NeuralNet.neurones.lvl_0(newPlay(k)).activation_unit=0;
%     end
    
%     NeuralNet.neurones.(['lvl_' num2str(NeuralNet.NumberOfLayer+1)])(1).target_unit=winner;
%     NeuralNet.Backprop(v);
    
%     state2board(state)
    
    k_temp=k_temp+1;
    
    if mod(k_temp,20)==0
        clc
%         disp([num2str(k_temp) '/' num2str(k_max)])
        percent=k_temp/k_max;
        percent=round(percent*10);
        disp(['{' repmat('=',1,percent-1) '>' repmat(' ',1,10-percent) '} ' num2str(k_temp) '/' num2str(k_max)])
    end
    if mod(k_temp,50)==0
        save('NeuralNet.mat','NeuralNet')
    end
end
toc
end