function []=TrainFromPlay(NeuralNet,state,newPlay,winner)
state_=state;
for k=size(newPlay,1)-1:-1:1
    state_(newPlay(k))=0;

    target=ones(9,1)*0.5;
    target(any(state_~=0,2))=0;

    if winner==0.5
        target(newPlay(k))=0.5;
    elseif (winner==1&&mod(k,2)==1) || (winner==0&&mod(k,2)==0)   
        target(newPlay(k))=1;
    elseif (winner==1&&mod(k,2)==0) || (winner==0&&mod(k,2)==1)
        target(newPlay(k))=0;
    else
        msg='Error with winner \n';
        errormsg=[msg];
        error(errormsg,[])
    end

    NeuralNet.changeInput(state_);
    NeuralNet.updateActivation();

    NeuralNet.changeTarget(target);

    NeuralNet.Backprop();        
end

end