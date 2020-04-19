% This function can perform Control Z gate for 17 qubits.
% It is mainly used in Shor code main function to simplify the calculation.
% Inputs: quantum state will be applied Control Z gate, the length of the
%         qubit string (only accept 17 here), the sequence number of the
%         control bit, and the matrix of the target bits.
% Output: quantum state after applying the Control NOT gate

function [state_out] = C_Z(state_in, bit_length, control_bit, target_bits)
% define matrix required
I = [1,0;0,1];
Uz = [1,0;0,-1];
s0 = [1;0];
s1 = [0;1];

% check whether the CZ gate is for 17 qubits    
if bit_length == 17    
    state_1 = {I,I,I,I,I,I,I,I,I,I,I,I,I,I,I,I,I};
    state_2 = {I,I,I,I,I,I,I,I,I,I,I,I,I,I,I,I,I};
    % change the control bit in the first part to |0><0|
    state_1{control_bit} = s0 * s0';   
    % change the control bit in the second part to |1><1|
    state_2{control_bit} = s1 * s1';
    
    % change each target bit in the second part to Z
    for i = 1:length(target_bits)
        state_2{target_bits(i)} = Uz;
    end
end
% perform tensor product to each part, then add them together to get the CZ gate
CZ = tensor1(state_1)+tensor1(state_2);
state_out = CZ * state_in;% apply the CZ gate to the state
end
