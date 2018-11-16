function []=RecursiveTrain(NeuralNet,state,v)
    for k=find(state==0)'
        state_=state;
        switch sum(state_)
            case 0
                state_(k)=+1;
            case 1
                state_(k)=-1;
            otherwise
                msg='Error with state \n';
                errormsg=[msg];
                error(errormsg,[])
        end

        if EndGame(state_)
            switch WhoWin(state_)
                case +1
                    reward=1;
                case -1
                    reward=0;
                otherwise
                    msg='Error with WhoWin(state_) \n';
                    errormsg=[msg];
                    error(errormsg,[])
            end
        elseif sum(state_==0)==0
            reward=0.5;
        else
            reward=[];     
            for g=find(state_==0)'
                state_temp=state_;
                switch sum(state_)
                    case 0
                        state_temp(g)=+1;
                    case 1
                        state_temp(g)=-1;
                    otherwise
                        msg='Error with state_ \n';
                        errormsg=[msg];
                        error(errormsg,[])
                end
                for l=1:9 
                    NeuralNet.neurones.lvl_0(l).activation_unit=state_temp(l);
                end
                NeuralNet.updateActivation();
                
                reward=[reward;NeuralNet.neurones.(['lvl_' num2str(NeuralNet.NumberOfLayer+1)]).activation_unit];
            end
            switch sum(state_temp)
                case 0
                    reward=max(reward);
                case 1
                    reward=min(reward);
                otherwise
                    msg='Error with state_ \n';
                    errormsg=[msg];
                    error(errormsg,[])
            end
        end

        for l=1:9 
            NeuralNet.neurones.lvl_0(l).activation_unit=state_(l);
        end
        NeuralNet.updateActivation();
        NeuralNet.neurones.(['lvl_' num2str(NeuralNet.NumberOfLayer+1)]).target_unit =reward;
        NeuralNet.Backprop(v);
        
        RecursiveTrain(NeuralNet,state_,v)
    end
end