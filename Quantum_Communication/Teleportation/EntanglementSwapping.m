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

% Alice and Charlie possess a bipartite state
state_AC = Bell_state{randi(4)};
% Alice and Bob share a Bell state
state_AB = Bell_state{1};
state_ACAB = tensor({state_AC, state_AB});
%perform the Bell measurement
p = zeros(1,4);
for i = 1:4
    p(i) = state_ACAB' * tensor({I,Bell{i},I}) * state_ACAB;
end
detection = randsrc(1,1,[1,2,3,4;p(1),p(2),p(3),p(4)]);
state_ACAB1 = tensor({I,Bell{detection},I}) * state_ACAB;
state_ACAB2 = sqrt(state_ACAB' * tensor({I,Bell{detection},I}) * state_ACAB);
state_ACAB = state_ACAB1/state_ACAB2;
% recover the quantum state according to the measurement
switch detection
    case 1
        state_ACAB = tensor({I,I,I,I})* state_ACAB;
    case 2
        state_ACAB = tensor({I,I,I,Uz})* state_ACAB;
    case 3
        state_ACAB = tensor({I,I,I,Ux})* state_ACAB;
    case 4
        state_ACAB = tensor({I,I,I,Uz*Ux})* state_ACAB;
end
% trace out
state_BC = tensor({I,Bell_state{detection}',I})* state_ACAB;
state_AC
state_BC
if sum(abs(state_AC - state_BC)) < 1e-10
    disp('Successful!')
end
