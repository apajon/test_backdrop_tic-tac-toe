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
            NeuralNet.neurones.(['lvl_' '1'])(k_temp)=neurone([zeros(size(count_temp,1),1) count_temp ones(size(count_temp,1),1)],0,'hyperbolic');
        end
        clear k count
        
%         for k_temp=1:NeuronesByCouche_temp(3)
%             count_temp=[1:NeuronesByCouche_temp(2)]';
%             NeuralNet.neurones.(['lvl_' '2'])(k_temp)=neurone([ones(size(count_temp,1),1)*(NumberOfLayer_temp-1) count_temp ones(size(count_temp,1),1)],0,'sigmoid');
%         end
%         clear k count

        count_temp=[1:NeuronesByCouche_temp(NumberOfLayer_temp)]';
        NeuralNet.neurones.(['lvl_' num2str(NumberOfLayer_temp+1)])=neurone([ones(size(count_temp,1),1)*NumberOfLayer_temp count_temp zeros(size(count_temp,1),1)],0,'sigmoid');
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
board=state2board(state);
board=[' ' '|' ' ' '|' ' '
    ' ' '|' ' ' '|' ' '
    ' ' '|' ' ' '|' ' '];
state=board2state(board);

%% Backprop learning / self training

%learning step
v=0.1;

%recursive training aka train on all cases
% RecursiveTrain(NeuralNet,state,v)

%%
k_max=1; %number of learning iterations
TrainNeuralNetwork2(NeuralNet,k_max,v)

% %% Test of Play
% PlayTicTacToe(NeuralNet)

%%
state=zeros(9,1);
for k=1:9
    state(k)=+1;
    for g=1:9
        NeuralNet.neurones.lvl_0(g).activation_unit=state(g);
    end
    NeuralNet.updateActivation();

    disp(NeuralNet.neurones.(['lvl_' num2str(NeuralNet.NumberOfLayer+1)]).activation_unit)
end
