% This code performs a third-party controlled teleportation.
% Input: Alice's state, GHZ gate
% Output: the choice on the recovery operator, Bob's state

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

% prepare the GHZ gate for Alice, Bob and Charlie
state_GHZ = 1/sqrt(2)*(tensor({s0,s0,s0})+tensor({s1,s1,s1}));
% generate Alice's random quantum state
a = 0.233; b = sqrt(1-a^2);
s = a * s0 + b * s1;
% apply the GHZ gate to Alice's qubit
state_A = tensor({s,state_GHZ});
%perform the Bell measurement
p = zeros(1,4);
for i = 1:4
    p(i) = state_A' * tensor({Bell{i},I,I}) * state_A;
end
detection = randsrc(1,1,[1,2,3,4;p(1),p(2),p(3),p(4)])
% calculate the state after Alice's measurement
state_A1 = tensor({Bell{detection},I,I}) * state_A;
state_A2 = sqrt(state_A' * tensor({Bell{detection},I,I}) * state_A);
state_A = state_A1/state_A2;

% Charlie performs Hadmard measurement on the state
Hadmard = cell(1,2);
Hadmard_P = cell(1,2);
Hadmard{1} = 1/sqrt(2)*[1;1];
Hadmard{2} = 1/sqrt(2)*[1;-1];
Hadmard_P{1} = Hadmard{1} * Hadmard{1}';
Hadmard_P{2} = Hadmard{2} * Hadmard{2}';
p_C = zeros(1,2);
for i = 1:2
    p_C(i) = state_A' * tensor({I,I,I,Hadmard_P{i}}) * state_A;
end
detection2 = randsrc(1,1,[1,2;p_C(1),p_C(2)])
% calculate the state after Charlie's measurement
state_A1 = tensor({I,I,I,Hadmard_P{detection2}}) * state_A;
state_A2 = sqrt(state_A' * tensor({I,I,I,Hadmard_P{detection2}}) * state_A);
state_B = state_A1/state_A2;

% decide the recovery matrix by the detection
switch detection2
    case 1
        state_B = state_B;
    case 2
        state_B = tensor({I,I,Uz,I}) * state_B;
end
switch detection
    case 1
        state_B = state_B;
    case 2
        state_B = tensor({I,I,Uz,I}) * state_B;
    case 3
        state_B = tensor({I,I,Ux,I}) * state_B;
    case 4
        state_B = tensor({I,I,Uz*Ux,I}) * state_B;
end

% trace out Alice and Charlie's qubits
state_B = tensor({Bell_state{detection}',I,Hadmard{detection2}'}) * state_B
