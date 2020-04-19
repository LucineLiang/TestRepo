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

% prepare the noisy channel for Alice and CHarlie
errorA = zeros(1,4);
errorC = zeros(1,4);
errorA(1) = 0.99;
errorC(1) = 0.99;
% randomly generate b, c and d
for i = 2:4
    errorA(i) = rand(1);
    errorC(i) = rand(1);
end
% calculate the sum of b, c and d
error_sumA = sum(errorA)-errorA(1);
error_sumC = sum(errorC)-errorC(1);
% normalisation
for i = 2:4
    errorA(i) = errorA(i)/((1/0.0199)*error_sumA);
    errorC(i) = errorC(i)/((1/0.0199)*error_sumC);
end
% channel for Alice
channelA = errorA(1)*I + sqrt(errorA(2))*Ux + sqrt(errorA(3))*Uz + sqrt(errorA(4))*Ux*Uz;
% channel for Charlie
channelC = errorC(1)*I + sqrt(errorC(2))*Ux + sqrt(errorC(3))*Uz + sqrt(errorC(4))*Ux*Uz;

% Alice prepares a Bell state
state_AA = Bell_state{1};
% Charlie prepares a Bell state
state_CC = Bell_state{1};
% Bob receives the states through noisy channels
state_AA = tensor({I,channelA})*state_AA;
state_CC = tensor({channelC,I})*state_CC;
state_AACC = tensor({state_AA,state_CC});
% Bob performs the Bell measurement
p = zeros(1,4);
for i = 1:4
    p(i) = state_AACC' * tensor({I,Bell{i},I}) * state_AACC;
end
% calculate the state after measurement
detection = randsrc(1,1,[1,2,3,4;p(1),p(2),p(3),p(4)]);
disp(['detection = ', num2str(detection)]);
state_AACC1 = tensor({I,Bell{detection},I}) * state_AACC;
state_AACC2 = sqrt(state_AACC' * tensor({I,Bell{detection},I}) * state_AACC);
state_AACC = state_AACC1/state_AACC2;
switch detection
    case 1
        state_AACC = tensor({I,I,I,I})* state_AACC;
    case 2
        state_AACC = tensor({I,I,I,Uz})* state_AACC;
    case 3
        state_AACC = tensor({I,I,I,Ux})* state_AACC;
    case 4
        state_AACC = tensor({I,I,I,Uz*Ux})* state_AACC;
end
% trace out
state_AC = tensor({I,Bell_state{detection}',I})* state_AACC
% calculate the fidelity
f = abs(Bell_state{1}'* state_AC)^2
