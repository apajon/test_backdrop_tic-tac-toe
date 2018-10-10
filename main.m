%%%%% %%%%%
%Code by Dr.Adrien Pajon email: adrien.pajon@gmail.com
%Based on the paper "Réseaux de neurones" Pr.Bruno Bouzy
%a copy of this paper is in this repo at 'ReseauxDeNeurones1.pdf'
%%%%% %%%%%
%%
clear all

clc

addpath class/ function/

%% Creation of the Neural Network

% Number of hidden Layer
NumberOfLayer_temp=1;

% Number of neurons in each layer [inputs hidden1 ... hiddenN outputs]
NeuronesByCouche_temp=[9 9 1];

%Creation of the neural network without the neurons connections
NeuralNet=NeuralNetwork(NumberOfLayer_temp,NeuronesByCouche_temp);

%% Add connection with weight 
test=1;
% 1 : connections with weight 0
% 2 : connections with fixed weight 

%Only set parent map conection with weight and bias unit for hidden and output neurons
switch test
    case 1
        %no need to set input neurons
%         for k=1:NeuronesByCouche(1)
%                  NeuralNet.neurones.lvl_0(g)=neurone([0 0 0],0,[]);
%         end
        for k_temp=1:NeuronesByCouche_temp(2)
            count_temp=[1:NeuronesByCouche_temp(1)]';
            NeuralNet.neurones.(['lvl_' '1'])(k_temp)=neurone([zeros(size(count_temp,1),1) count_temp zeros(size(count_temp,1),1)],0,'hyperbolic');
        end
        clear k count

        count_temp=[1:NeuronesByCouche_temp(2)]';
        NeuralNet.neurones.(['lvl_' '2'])=neurone([zeros(size(count_temp,1),1) count_temp zeros(size(count_temp,1),1)],0,'sigmoid');
    case 2

end

%Generate the children map connection for hidden and input neurons
NeuralNet.buildChildren();

clear *_temp test
%% Rule
% 'x' are +1
% 'o' are -1
% ' ' are 0
% 'x' always begin

%% Initialize board
state=zeros(9,1);
board=state2board(state)
board=[' ' '|' ' ' '|' ' '
    ' ' '|' ' ' '|' ' '
    ' ' '|' ' ' '|' ' '];
state=board2state(board);

%% Backprop learning / self training

%learning step
v=0.1;

k_temp=0;
k_max=1; %number of learning iterations
while k_temp<k_max
%     for i=[3 1 2 4]%1:size(tableInputXOR,1)
%         % add input and output of XOR table for learning
%         NeuralNet.neurones.lvl_0(1).activation_unit=tableInputXOR(i,1);
%         NeuralNet.neurones.lvl_0(2).activation_unit=tableInputXOR(i,2);
%         NeuralNet.neurones.lvl_2(1).target_unit=xor(NeuralNet.neurones.lvl_0(1).activation_unit,...
%                                                     NeuralNet.neurones.lvl_0(2).activation_unit);
% 
%         %Compute activation values and units of hidden and output neurons
%         NeuralNet.updateActivation();
% 
%         %Backprop core on connection weight for 1 example with the learning step v
%         NeuralNet.Backprop(v);
%     end

    state=zeros(9,1);
    for g=1:9
         NeuralNet.neurones.lvl_0(g).activation_unit=state(g);
    end

    while ~EndGame(state)||isempty(state(any(state==0,2)))
        if sum((state(any(state==0,2))))~=9
            switch sum(state)
                case 0
                    state(newPlay)=+1;
                case 1
                    state(newPlay)=-1;
                otherwise
                    msg='Error with state \n';
                    errormsg=[msg];
                    error(errormsg,[])
            end
            NeuralNet.neurones.lvl_0(newPlay).activation_unit=state(newPlay);
        end
        %Compute activation values and units of hidden and output neurons
        NeuralNet.updateActivation();
        
%         newPlay=;
        state2board(state)
    end
    
    if isempty(state(any(state==0,2)))
        winner=0.5;
    else
        winner=WhoWin(state);
    end
    
    k_temp=k_temp+1;
end

% %% Test of the convergence of the Neural Network
% for i=1:4
%     NeuralNet.neurones.lvl_0(1).activation_unit=tableInputXOR(i,1);
%             NeuralNet.neurones.lvl_0(2).activation_unit=tableInputXOR(i,2);
%             NeuralNet.neurones.lvl_2(1).target_unit=xor(NeuralNet.neurones.lvl_0(1).activation_unit,...
%                                                         NeuralNet.neurones.lvl_0(2).activation_unit);
%     NeuralNet.updateActivation();
% 
%     NeuralNet.neurones.lvl_2(1).activation_unit
% end