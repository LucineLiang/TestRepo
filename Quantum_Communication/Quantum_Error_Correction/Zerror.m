% This code is for quantum Z error correction.
% Input: a random quantum state to be protected
% Output: the received quantum state after error correction and decoding
% In the quantum state preparation part, the value of 'a' could be set as
% 0.233 to test whether the result is correct.

clear

%prepare|+> and |->
state_zero = 1/sqrt(2) * [1;1];
state_one = 1/sqrt(2) * [1;-1];

I = [1, 0; 0, 1];
Uz = [1, 0; 0, -1];

%CNOT gate
CNOT = kron(state_zero*state_zero',kron(I,I))+kron(state_one*state_one',kron(Uz,Uz));

% calculate and store the four projection operators
P1_part1 = kron(state_one,kron(state_zero,state_zero));
P1_part2 = kron(state_zero,kron(state_one,state_one));
P1 = P1_part1 * P1_part1' + P1_part2 * P1_part2';
P2_part1 = kron(state_zero,kron(state_one,state_zero));
P2_part2 = kron(state_one,kron(state_zero,state_one));
P2 = P2_part1 * P2_part1' + P2_part2 * P2_part2';
P3_part1 = kron(state_zero,kron(state_zero,state_one));
P3_part2 = kron(state_one,kron(state_one,state_zero));
P3 = P3_part1 * P3_part1' + P3_part2 * P3_part2';
P4_part1 = kron(state_zero,kron(state_zero,state_zero));
P4_part2 = kron(state_one,kron(state_one,state_one));
P4 = P4_part1 * P4_part1' + P4_part2 * P4_part2';

%% State
% generate the random qubit
a = rand(1);
% a = 0.233;
b = sqrt(1-a^2); %randomly generate a and b
s = a * state_zero + b * state_one;%qubit

%% Encoding
% add two zero states
s_c = kron(s,kron(state_zero,state_zero));
% use CNOT gate to convert the state into a|000>+b|111>
sc_encoded = CNOT * s_c;

%% Channel (add Z error)
% add error to one qubit (in three) randomly
flip = randi(3);
switch flip
    case 1
        sc_encoded = kron(Uz,kron(I,I)) * sc_encoded;
    case 2
        sc_encoded = kron(I,kron(Uz,I)) * sc_encoded;
    case 3
        sc_encoded = kron(I,kron(I,Uz)) * sc_encoded;
end

%% Decoding
% perform the projection measurement and calculate the probability for each case
p = zeros(1,4);
p(1) = sc_encoded' * P1 * sc_encoded;
p(2) = sc_encoded' * P2 * sc_encoded;
p(3) = sc_encoded' * P3 * sc_encoded;
p(4) = sc_encoded' * P4 * sc_encoded;

% decide which qubit is flipped by the probability calcualted
for i = 1:4
    if p(i) > 0.9
        flag = i;% if probability = 1, the corresponding qubit is flipped
    end
end
% correct the corresponding qubit
switch flag
    case 1
        sc = kron(Uz,kron(I,I)) * sc_encoded;
    case 2
        sc = kron(I,kron(Uz,I)) * sc_encoded;
    case 3
        sc = kron(I,kron(I,Uz)) * sc_encoded;
end

% convert a|000>+b|111> to a|000>+b|100>
Sc = CNOT * sc;
% remove the two |0> padded
S = kron(I,kron(state_zero',state_zero')) * Sc
