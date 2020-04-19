% This code performs a remote state preparation.
% Input: a Bell state shared by Alice and Bob and Alice's state.
% Output: the result of the detection based onthe measurement and Bob's state

clear;
% prepare|0> and |1>
s0 = [1; 0];s1 = [0; 1];
% define the matrix
I = [1 0; 0 1];H = 1/sqrt(2)*[1 1;1 -1];
Ux = [0 1; 1 0];Uz = [1 0; 0 -1];

% Alice and Bob share a Bell state
state_AB = 1/sqrt(2)*(tensor({s0,s0})+tensor({s1,s1}));
% Alice's knowledge about the state (refer to Mingjian's code)
phi = pi/2.33;
% Alice has a state
state_A = (s0 + exp(phi * 1i) * s1)/sqrt(2);
% prepare the basis
basis = cell(1,2);
basis{1} = (s0 + exp(phi * -1i) * s1)/sqrt(2);
basis{2} = (s0 - exp(phi * -1i) * s1)/sqrt(2);
% prepare the projection operators for the measurement
P = cell(1,2);
P{1} = basis{1} * basis{1}';
P{2} = basis{2} * basis{2}';
% perform the measurement
probability(1) = state_AB' * tensor({P{1},I}) * state_AB;
probability(2) = state_AB' * tensor({P{2},I}) * state_AB;
% calculate the state after measurement
detection = randsrc(1,1,[1,2;probability(1),probability(2)])
state_AB1 = tensor({P{detection},I}) * state_AB;
state_AB2 = sqrt(state_AB' * tensor({P{detection},I}) * state_AB);
state_AB = state_AB1/state_AB2;
% Trace out Alice's qubit
state_B = tensor({ basis{detection}', I }) * state_AB;
% Bob applies the recover matrix on the qubit
switch detection
    case 1
        state_B = I * state_B;
    case 2
        state_B = Uz * state_B;
end
state_A
state_B
% check whether the transmission is successful
if sum((state_B - state_A).^2)<1e-10
    disp('Successful!');
else
    disp('Failed.');
end
