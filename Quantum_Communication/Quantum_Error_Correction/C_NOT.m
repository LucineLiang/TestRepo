% This function can perform Control NOT gate for 9 qubits or 17 qubits.
% It is mainly used in Shor code main function to simplify the calculation.
% Inputs: quantum state will be applied Control NOT gate, the length of the
%         qubit string (accept 9 and 17 here), the sequence number of the
%         control bit, and the matrix of the target bits.
% Output: quantum state after applying the Control NOT gate
function [state_out] = C_NOT(state_in, bit_length, control_bit, target_bits)
% define matrix required
I = [1,0;0,1];
Ux = [0,1;1,0];
s0 = [1;0];
s1 = [0;1];

% case 1 CNOT gate for 9 qubits
if bit_length == 9
    state_1 = {I,I,I,I,I,I,I,I,I};
    state_2 = {I,I,I,I,I,I,I,I,I};
    % change the control bit in the first part to |0><0|  
    state_1{control_bit} = s0 * s0';
    % change the control bit in the second part to |1><1|
    state_2{control_bit} = s1 * s1';
    
    % change each target bit in the second part to X
    for i = 1:length(target_bits)
        state_2{target_bits(i)} = Ux;
    end
end

% case 2 CNOT gate for 17 qubits    
if bit_length == 17    
    state_1 = {I,I,I,I,I,I,I,I,I,I,I,I,I,I,I,I,I};
    state_2 = {I,I,I,I,I,I,I,I,I,I,I,I,I,I,I,I,I};
    % change the control bit in the first part to |0><0|
    state_1{control_bit} = s0 * s0';   
    % change the control bit in the second part to |1><1|
    state_2{control_bit} = s1 * s1';
    
    % change each target bit in the second part to X
    for i = 1:length(target_bits)
        state_2{target_bits(i)} = Ux;
    end
end
% perform tensor product to each part, then add them together to get the CNOT gate
Cnot = tensor1(state_1)+tensor1(state_2);
state_out = Cnot * state_in;% apply the CNOT gate to the state
end
