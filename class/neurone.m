classdef neurone<handle
    
    %%
    properties
        parent              %neurone parent [Id_layer Id_number weight;...]
                            %aka the neuron input connection map and  
                            %associated weight
        children            %neurone children [Id_level Id_number;...]
                            %aka the neuron output connection map
        b                   %bias unit
        activation_function %'sigmoid' or 'hyperbolic'
        activation_value    %sum of weighted connections
        activation_unit     %activation unit
        target_unit         %the expected activation unit int the case of output neuron
        error_signal        %error signal of the activation unit
    end
    %%
    methods
        %%
        function obj=neurone(parent,b,activation_function)
            %create the neuron with parent connection and bias
            %parrent is of the form [Id_layer Id_number weight;...]
            %bias b is a single scalar
            if ~size(parent,2)==3
                msg='size(,2) of parent must be 3 \n';
                errormsg=[msg];
                error(errormsg,[])
            end
            if (~size(b,1)==1 || ~size(b,2)==1)
                msg='b must be a single scalar \n';
                errormsg=[msg];
                error(errormsg,[])
            end
            switch activation_function
                case {'','sigmoid','hyperbolic'}
                otherwise
                    msg='choose activation_function \n';
                    msg1='"sigmoid" or\n';
                    msg2='"hyperbolic" or\n';
                    msg3='[]\n';
                    errormsg=[msg msg1 msg2 msg3];
                    error(errormsg,[])
            end
            
            obj.parent=parent;
            obj.b=b;
            obj.activation_function=activation_function;
        end
        %%
        function []=updateActivation_value(obj,value)
            %update activation_value with value and update activation_unit
            obj.activation_value=value;
            obj.updateActivation_unit();
        end
        %%
        function []=updateActivation_unit(obj)
            %update activation_unit based on activation_value and a sigmoid
            %function
            if isempty(obj.activation_function)
                msg='choose activation_function \n';
                msg1='"sigmoid" or\n';
                msg2='"hyperbolic" \n';
                errormsg=[msg msg1 msg2];
                error(errormsg,[])
            end
            switch obj.activation_function
                case 'sigmoid'
                    obj.activation_unit=Sigmoid(obj.activation_value);
                case 'hyperbolic'
                    obj.activation_unit=tanh(obj.activation_value);
                otherwise
                    msg='choose activation_function \n';
                    msg1='"sigmoid" or\n';
                    msg2='"hyperbolic" \n';
                    errormsg=[msg msg1 msg2];
                    error(errormsg,[])
            end
        end
        %%
        function dfnet=computeDfnet(obj)
            %derivation of function in activation_unit
            if isempty(obj.activation_function)
                msg='choose activation_function \n';
                msg1='"sigmoid" or\n';
                msg2='"hyperbolic" \n';
                errormsg=[msg msg1 msg2];
                error(errormsg,[])
            end
            switch obj.activation_function
                case 'sigmoid'
                    dfnet=obj.activation_unit*(1-obj.activation_unit);
                case 'hyperbolic'
                    dfnet=1-obj.activation_unit^2;
                otherwise
                    msg='choose activation_function \n';
                    msg1='"sigmoid" or\n';
                    msg2='"hyperbolic" \n';
                    errormsg=[msg msg1 msg2];
                    error(errormsg,[])
            end           
        end
    end
end