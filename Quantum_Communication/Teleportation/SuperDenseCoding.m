% This code performs a super-dense coding protocol.
% Input: Alice's two qubits
% Output: original information x1x2, the result of the detection based on
% the Bell measurement and the final information x1x2

clear;
% prepare|0> and |1>
s0 = [1; 0];s1 = [0; 1];
% define the matrix
I = [1 0; 0 1];H = 1/sqrt(2)*[1 1;1 -1];
Ux = [0 1; 1 0];Uz = [1 0; 0 -1];
% CNOT gate
CNOT = [1 0 0 0; 0 1 0 0; 0 0 0 1; 0 0 1 0];
% noiseless channels
E1 = I; E2 = I;
% prepare  projection operators for Bell measurement
Bell = cell(1,4);
Bell{1} = (1/sqrt(2)*(tensor({s0,s0})+tensor({s1,s1}))) * (1/sqrt(2)*(tensor({s0,s0})+tensor({s1,s1})))';
Bell{2} = (1/sqrt(2)*(tensor({s0,s0})-tensor({s1,s1}))) * (1/sqrt(2)*(tensor({s0,s0})-tensor({s1,s1})))';
Bell{3} = (1/sqrt(2)*(tensor({s0,s1})+tensor({s1,s0}))) * (1/sqrt(2)*(tensor({s0,s1})+tensor({s1,s0})))';
Bell{4} = (1/sqrt(2)*(tensor({s0,s1})-tensor({s1,s0}))) * (1/sqrt(2)*(tensor({s0,s1})-tensor({s1,s0})))';

% prepare the Bell state
state_AA = CNOT * tensor({H*s0,s0});
state_AA = tensor({I,E1}) * state_AA;

% randomly generate x1x2
% x1x2 is the classical information that Alice wants to transmit to Bob
x = randi([0,1],1,2);
xx = num2str(x);% convert integer to string for switch
disp(['Original x1x2 = ',xx]);
switch xx
    case '0  0'
        bell_state = state_AA; 
    case '0  1'
        bell_state = tensor({Ux, I}) * state_AA;
    case '1  0'
        bell_state = tensor({Uz, I}) * state_AA;
    case '1  1'
        bell_state = tensor({Ux*Uz,I}) * state_AA;
end

bell_state = tensor({E2,I}) * bell_state;

% calculate probabilities
for i = 1:4
    p(i) = bell_state' * Bell{i} * bell_state;
end

% detect the Bell state
detection = randsrc(1,1,[1,2,3,4;p(1),p(2),p(3),p(4)])
switch detection
    case 1
        x_12 = [0,0];
    case 2
        x_12 = [0,1];
    case 3
        x_12 = [1,0];
    case 4
        x_12 = [1,1];
end
disp(['x1x2 = ',num2str(x_12)]);
