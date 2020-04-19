% This program simulates the [9,1,3] Shor code which can correct one-qubit
% error with any type of the error, X error, Z error or XZ error.
% The transmission channel of this program is a special case of the general
% channel, which all three types of error have an equal probabilities.
% Input: a random quantum state to be protected
% Ouputs: the syndrome decided after the stabilizer measurement and the
%         recoverd quantum state
% In the quantum state preparation part, the value of 'a' could be set as
% 0.233 to test whether the result is correct.

clear

% prepare|0> and |1>
s0 = [1; 0];s1 = [0; 1];
% define the matrix
I = [1 0; 0 1];Ux = [0 1; 1 0];Uz = [1 0; 0 -1];H = 1/sqrt(2)*[1 1;1 -1];

%% Generate the qubit
a = 0.233; % a = rand(1);
b = sqrt(1-a^2); % randomly generate a and b
s = a * s0 + b * s1; % qubit

%% Encoding
zero_8 = tensor1({s0},8);
sc = tensor1({s,zero_8});% add eight |0>s
sc = C_NOT(sc,9,1,[4,7]);% apply CNOT gate to the first qubit
sc = tensor1({H,I,I},3)*sc;% apply Hadmard gate to these three qubits
sc = C_NOT(sc,9,1,[2,3]);% apply CNOT gate to the first qubit
sc = C_NOT(sc,9,4,[5,6]);% apply CNOT gate to the fourth qubit
sc = C_NOT(sc,9,7,[8,9]);% apply CNOT gate to the seventh qubit

%% Channel
% here the channel is a special case with equal probability for three kinds of error
Error = {I,I,I,I,I,I,I,I,I};
% decide the position that the error occurs
error_position = randi(9);
error_type = randi(3);
switch error_type
    case 1
        Error{error_position} = Ux; % X error
    case 2
        Error{error_position} = Uz; % Z error
    case 3
        Error{error_position} = Ux * Uz; % XZ error
end
sc_error = tensor1(Error) * sc; % add error to the quantum state

%% Error Detection
% add another 8 |0>s
sc_error_17 = tensor1({sc_error,zero_8});
I_9 = tensor1({I},9);
H_8 = tensor1({H},8);
IH_17 = tensor1({I_9, H_8});
sc_error_17 = IH_17 * sc_error_17;% apply Hadmard gate

% apply CZ gates
sc_error_17 = C_Z(sc_error_17,17,10,[1,2]);
sc_error_17 = C_Z(sc_error_17,17,11,[2,3]);
sc_error_17 = C_Z(sc_error_17,17,12,[4,5]);
sc_error_17 = C_Z(sc_error_17,17,13,[5,6]);
sc_error_17 = C_Z(sc_error_17,17,14,[7,8]);
sc_error_17 = C_Z(sc_error_17,17,15,[8,9]);

% apply CNOT gates
sc_error_17 = C_NOT(sc_error_17,17,16,[1,2,3,4,5,6]);
sc_error_17 = C_NOT(sc_error_17,17,17,[4,5,6,7,8,9]);

% apply Hadmard gate
sc_error_17 = IH_17 * sc_error_17;

syndrome = zeros(8,1); % define the matrix for storing the syndrome

for round = 1:8
    % prepare the space for storing
    probability = zeros(1,2);
    P = cell(1,2);
    Recover = cell(1,2);
    
    % generate the projection operator for this round
    P{1} = tensor1({tensor1({I}, 17 - round), s0*s0'});
    P{2} = tensor1({tensor1({I}, 17 - round), s1*s1'});
    
    % prepare the trace operator to remove one qubit every round
    Recover{1} = tensor1({tensor1({I}, 17 - round), s0'});
    Recover{2} = tensor1({tensor1({I}, 17 - round), s1'});
    
    % Calculate the probability
    for i = 1:2
        probability(i) = sc_error_17' * P{i} * sc_error_17;
    end
    
    if probability(1) > 0.9
        sc_error_17 = P{1} * sc_error_17;% get the state after measurement
        sc_error_17 = Recover{1} * sc_error_17;% trace out one qubit
        syndrome(9-round) = 0;% record the syndrome
    end
    
    if probability(2) > 0.9
        sc_error_17 = P{2} * sc_error_17;
        sc_error_17 = Recover{2} * sc_error_17;
        syndrome(9-round) = 1;
    end
end
disp(['The syndrome is: ', num2str(syndrome')]);

%% Error Correction
syn = [1 0 0 0 0 0 0 0; %X1
       1 1 0 0 0 0 0 0; %X2
       0 1 0 0 0 0 0 0; %X3
       0 0 1 0 0 0 0 0; %X4
       0 0 1 1 0 0 0 0; %X5
       0 0 0 1 0 0 0 0; %X6
       0 0 0 0 1 0 0 0; %X7
       0 0 0 0 1 1 0 0; %X8
       0 0 0 0 0 1 0 0; %X9
       0 0 0 0 0 0 1 0; %Z123
       0 0 0 0 0 0 1 1; %Z456
       0 0 0 0 0 0 0 1; %Z789
       1 0 0 0 0 0 1 0; %X1Z1
       1 1 0 0 0 0 1 0; %X2Z2
       0 1 0 0 0 0 1 0; %X3Z3
       0 0 1 0 0 0 1 1; %X4Z4
       0 0 1 1 0 0 1 1; %X5Z5
       0 0 0 1 0 0 1 1; %X6Z6
       0 0 0 0 1 0 0 1; %X7Z7
       0 0 0 0 1 1 0 1; %X8Z8
       0 0 0 0 0 1 0 1; %X9Z9
       0 0 0 0 0 0 0 0];% no error

% compare the syndrome calculated with the syndrome table
for row = 1:22
    if isequal(syndrome', syn(row,:))
        flag = row;% record the row with the same syndrome
    end
end

% generate the correction matrix
correction = {I,I,I,I,I,I,I,I,I};
if flag < 10
    correction{flag} = Ux;
elseif flag < 13
    % Z1 Z2 and Z3 are the same error. When recovering the error, multiply
    % Uz to any one of these three positions. Here, Z1 Z2 Z3 are all
    % considered as Z3. Z4 Z5 Z6->Z6,Z7 Z8 Z9->Z9
    correction{(flag-9)*3} = Uz;
elseif flag < 22
    correction{flag-12} = Uz * Ux;
end
% correct the error
sc_9 = tensor1(correction) * sc_error_17;

%% Decoding 
sc_9 = C_NOT(sc_9,9,1,[2,3]);% apply CNOT gate to the first qubit
sc_9 = C_NOT(sc_9,9,4,[5,6]);% apply CNOT gate to the fourth qubit
sc_9 = C_NOT(sc_9,9,7,[8,9]);% apply CNOT gate to the seventh qubit
sc_9 = tensor1({H,I,I},3)*sc_9;% apply Hadmard gate to these three qubits
sc_9 = C_NOT(sc_9,9,1,[4,7]);% apply CNOT gate to the first qubit

zero_8T = tensor1({s0'},8);
S = tensor1({I,zero_8T})*sc_9;% recover the original state
S = full(S) %recover it to the full matrix form
