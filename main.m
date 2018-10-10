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
NumberOfLayer=1;

% Number of neurons in each layer [inputs hidden1 ... hiddenN outputs]
NeuronesByCouche=[9 9 1];

%Creation of the neural network without the neurons connections
NeuralNet=NeuralNetwork(NumberOfLayer,NeuronesByCouche);

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
        for k=1:NeuronesByCouche(2)
            count=[1:NeuronesByCouche(1)]';
            NeuralNet.neurones.(['lvl_' '1'])(k)=neurone([zeros(size(count,1),1) count zeros(size(count,1),1)],0,'hyperbolic');
        end

        count=[1:NeuronesByCouche(2)]';
        NeuralNet.neurones.(['lvl_' '2'])=neurone([zeros(size(count,1),1) count zeros(size(count,1),1)],0,'sigmoid');
    case 2

end

%Generate the children map connection for hidden and input neurons
NeuralNet.buildChildren();

%% Backprop learning

%learning step
v=0.1;

board=[' ' '|' ' ' '|' ' '
    ' ' '|' ' ' '|' ' '
    ' ' '|' ' ' '|' ' '];
state=board2state(board);

j=0;
j_max=1; %number of learning iterations



while j<j_max
    for i=[3 1 2 4]%1:size(tableInputXOR,1)
        % add input and output of XOR table for learning
        NeuralNet.neurones.lvl_0(1).activation_unit=tableInputXOR(i,1);
        NeuralNet.neurones.lvl_0(2).activation_unit=tableInputXOR(i,2);
        NeuralNet.neurones.lvl_2(1).target_unit=xor(NeuralNet.neurones.lvl_0(1).activation_unit,...
                                                    NeuralNet.neurones.lvl_0(2).activation_unit);

        %Compute activation values and units of hidden and output neurons
        NeuralNet.updateActivation();

        %Backprop core on connection weight for 1 example with the learning step v
        NeuralNet.Backprop(v);
    end
    
    j=j+1;
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