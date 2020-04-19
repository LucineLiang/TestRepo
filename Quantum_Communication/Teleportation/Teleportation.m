% This code performs a quantum teleportation protocol.
% Input: Alice's random quantum state and a Bell state shared by Alice and
% Bob
% Output: the result of the detection based onthe Bell measurement and
% Bob's quantum state

clear;
% prepare|0> and |1>
s0 = [1; 0];s1 = [0; 1];
% define the matrix
I = [1 0; 0 1];H = 1/sqrt(2)*[1 1;1 -1];
Ux = [0 1; 1 0];Uz = [1 0; 0 -1];
% prepare  projection operators for Bell measurement
Bell = cell(1,4);
Bell{1} = (1/sqrt(2)*(tensor({s0,s0})+tensor({s1,s1}))) * (1/sqrt(2)*(tensor({s0,s0})+tensor({s1,s1})))';
Bell{2} = (1/sqrt(2)*(tensor({s0,s0})-tensor({s1,s1}))) * (1/sqrt(2)*(tensor({s0,s0})-tensor({s1,s1})))';
Bell{3} = (1/sqrt(2)*(tensor({s0,s1})+tensor({s1,s0}))) * (1/sqrt(2)*(tensor({s0,s1})+tensor({s1,s0})))';
Bell{4} = (1/sqrt(2)*(tensor({s0,s1})-tensor({s1,s0}))) * (1/sqrt(2)*(tensor({s0,s1})-tensor({s1,s0})))';
% prepare Bell states
Bell_state = cell(1,4);
Bell_state{1} = 1/sqrt(2)*(tensor({s0,s0})+tensor({s1,s1}));
Bell_state{2} = 1/sqrt(2)*(tensor({s0,s0})-tensor({s1,s1}));
Bell_state{3} = 1/sqrt(2)*(tensor({s0,s1})+tensor({s1,s0}));
Bell_state{4} = 1/sqrt(2)*(tensor({s0,s1})-tensor({s1,s0}));

% generate Alice's random quantum state
a = 0.233; b = sqrt(1-a^2);
s = a * s0 + b * s1;
% Alice and Bob share a Bell state
state_AB = Bell_state{1};
% entangle Alice's state with the Bell state
state_AAB = tensor({s,state_AB});
%perform the Bell measurement
p = zeros(1,4);
for i = 1:4
    p(i) = state_AAB' * tensor({Bell{i},I}) * state_AAB;
end
% calculate the state after Bell measurement
detection = randsrc(1,1,[1,2,3,4;p(1),p(2),p(3),p(4)])
state_AAB1 = tensor({Bell{detection},I}) * state_AAB;
state_AAB2 = sqrt(state_AAB' * tensor({Bell{detection},I}) * state_AAB);
state_AAB = state_AAB1/state_AAB2;
% Trace out first two qubits
state_B = tensor({Bell_state{detection}, I})' * state_AAB;
% recover the state
switch detection
    case 1
        state_B = state_B;
    case 2
        state_B = Uz * state_B;
    case 3
        state_B = Ux * state_B;
    case 4
        state_B = Uz * Ux * state_B;
end
state_B
