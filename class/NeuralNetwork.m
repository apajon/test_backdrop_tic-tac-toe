classdef NeuralNetwork<handle
    %%
    properties
        NumberOfLayer       %number of hidden layer
        neurones            %storage of neurons
    end
    %%
    methods
        %%
        function obj=NeuralNetwork(NumberOfLayer,NeuronesByLayer)
            %Create the Neural Network with neurons without parent map and
            %without bias
            %NumberOfLayer is a single scalar that represent the number of
            %hidden layer
            %NeuronesByLayer is vector with the number of neurons in input,
            %hidden and output layers of the form :
            %NeuronesByLayer=[inputs hidden1 ... hiddenN outputs]
            %The layers are part of neurones and named 'lvl_N' with 
            %N=[0 .. M]. N=0 which is the input layer, N=M is the output
            %layer and N=[2 .. M-1] the hidden layers
            if (~size(NumberOfLayer,1)==1 || ~size(NumberOfLayer,2)==1)
                msg='NumberOfLayer must be a single scalar \n';
                errormsg=[msg];
                error(errormsg,[])
            end
            if ~isvector(NeuronesByLayer)
                msg='NeuronesByLayer of NeuralNetwork() must be a vector \n';
                errormsg=[msg];
                error(errormsg,[])
            end
            
            obj.NumberOfLayer=NumberOfLayer;
            
            for i=0:obj.NumberOfLayer+1
                for j=1:NeuronesByLayer(i+1)
                    obj.neurones.(['lvl_' num2str(i)])(j)=neurone([0 0 0],0,'');
                end
            end
        end
        %%
        function []=updateActivation(obj)
            %update the activation_value of hidden and output neurons of 
            %the Neural Network
            for i=1:obj.NumberOfLayer+1
                for j=1:size(obj.neurones.(['lvl_' num2str(i)]),2)
                    value_temp=0;
                    for k=1:size(obj.neurones.(['lvl_' num2str(i)])(j).parent,1)
                        parent_Id_level=obj.neurones.(['lvl_' num2str(i)])(j).parent(k,1);
                        parent_Id_number=obj.neurones.(['lvl_' num2str(i)])(j).parent(k,2);
                        parent_weight=obj.neurones.(['lvl_' num2str(i)])(j).parent(k,3);
                        value_temp=value_temp+obj.neurones.(['lvl_' num2str(parent_Id_level)])(parent_Id_number).activation_unit*parent_weight;
                    end
                    obj.neurones.(['lvl_' num2str(i)])(j).updateActivation_value(value_temp+1*obj.neurones.(['lvl_' num2str(i)])(j).b);
                end
            end
        end
        %%
        function []=buildChildren(obj)
            %Build the children map connection for hidden and input neurons
            for i=obj.NumberOfLayer+1:-1:1
                for j=1:size(obj.neurones.(['lvl_' num2str(i)]),2)
                    for k=1:size(obj.neurones.(['lvl_' num2str(i)])(j).parent,1)
                        parent=obj.neurones.(['lvl_' num2str(i)])(j).parent(k,:);
                        obj.neurones.(['lvl_' num2str(parent(1))])(parent(2)).children=[obj.neurones.(['lvl_' num2str(parent(1))])(parent(2)).children;...
                            [i j]];
                    end
                end
            end
        end
        %%
        function []=Backprop(obj,v)
            %Backprop algorithm to update the weight based on known example
            for i=obj.NumberOfLayer+1:-1:1
                for j=1:size(obj.neurones.(['lvl_' num2str(i)]),2)
                    if i==obj.NumberOfLayer+1
                        error_temp=obj.neurones.(['lvl_' num2str(i)])(j).computeDfnet()*...
                            (obj.neurones.(['lvl_' num2str(i)])(j).target_unit-...
                            obj.neurones.(['lvl_' num2str(i)])(j).activation_unit);
                    else
                        children=obj.neurones.(['lvl_' num2str(i)])(j).children;
                        error_temp=0;
                        for k=1:size(children,1)
                            error_temp=error_temp+(obj.neurones.(['lvl_' num2str(children(k,1))])(children(k,2)).error_signal*...
                                obj.neurones.(['lvl_' num2str(children(k,1))])(children(k,2)).parent(find(obj.neurones.(['lvl_' num2str(children(k,1))])(children(k,2)).parent(:,1:2)==[i j],1),3));
                        end
                        error_temp=error_temp*obj.neurones.(['lvl_' num2str(i)])(j).computeDfnet();
                    end
                    
                    for k=1:size(obj.neurones.(['lvl_' num2str(i)])(j).parent,1)
                        parent=obj.neurones.(['lvl_' num2str(i)])(j).parent(k,1:2);
                        obj.neurones.(['lvl_' num2str(i)])(j).parent(k,3)=obj.neurones.(['lvl_' num2str(i)])(j).parent(k,3)+v*error_temp*obj.neurones.(['lvl_' num2str(parent(1))])(parent(2)).activation_unit;
                    end
                    obj.neurones.(['lvl_' num2str(i)])(j).b=obj.neurones.(['lvl_' num2str(i)])(j).b+v*error_temp*1;
                    
                    obj.neurones.(['lvl_' num2str(i)])(j).error_signal=error_temp;
                    
                end
            end
        end
    end
end