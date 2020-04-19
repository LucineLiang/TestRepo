% This code performs an entanglement distillation protocol which convert
% 'less entangled' state to 'more entangled' state.
% Input: Alice's random choice
% Ouput: input fidelity, expected output fidelity, actual output fidelity

clear;
% prepare|0> and |1>
s0 = [1; 0];s1 = [0; 1];
% define the matrix
I = [1 0 0 0;0 1 0 0;0 0 1 0;0 0 0 1];
I2 = [1 0; 0 1];H = 1/sqrt(2)*[1 1;1 -1];
Ux = [0 1; 1 0];Uz = [1 0; 0 -1]; Y = [0 -1i;1i 0];
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
% prepare the coefficient of the initial state
d = 1/3 + (2/3)*rand(1);%d = 0.5;
% input state rhoAB
rhoAB1 = d * Bell_state{4} * Bell_state{4}'+ (1-d) * I/4;
rhoAB2 = rhoAB1;
% input fadelity
Fin = Bell_state{4}'* rhoAB1 * Bell_state{4};
disp(['The input fidelity = ', num2str(Fin)]);
% expected output fadelity
Fout_op = (Fin^2+1/9*(1-Fin)^2)/(Fin^2+2/3*Fin*(1-Fin)+5/9*(1-Fin)^2);
disp(['The expected output fidelity = ', num2str(Fout_op)]);

%% step 1
Pauli = cell(1,4);
Pauli{1} = I2; Pauli{2} = Ux; Pauli{3} = Y; Pauli{4} = Uz;
choice = randi(4);
% Alice randomly chooses a Pauli operator U
UA = Pauli{choice};
% Alice sends her choice to Bob
UB = UA;
% they perform a square root calculation on U respectively
state_AB = tensor({sqrtm(UA),sqrtm(UB)})* rhoAB1 * tensor({sqrtm(UA)',sqrtm(UB)'});
state_AB2 = tensor({sqrtm(UA),sqrtm(UB)})* rhoAB2 * tensor({sqrtm(UA)',sqrtm(UB)'});

%% step 2
% Alice applies a Y gate to her state
state_AB = tensor({Y,I2})* state_AB * tensor({Y',I2'});
state_AB2 = tensor({Y,I2})* state_AB2 * tensor({Y',I2'});

%% step 3
CNOT1 =tensor({s0*s0',I2,I2,I2})+ tensor({s1*s1',I2,Ux,I2});% Alice's CNOT gate
CNOT2 =tensor({I2,s0*s0',I2,I2})+ tensor({I2,s1*s1',I2,Ux});% Bob's CNOT gate
state_ABAB = tensor({state_AB, state_AB2});
state_ABAB = CNOT1*state_ABAB*CNOT1';% Alice applies her CNOT gate
state_ABAB = CNOT2*state_ABAB*CNOT2';% Bob applies his CNOT gate

%% step 4
p = zeros(1,4);
% measurement by standard basis
p(1) = trace(state_ABAB*tensor({I2,I2,s0*s0',s0*s0'}));
p(2) = trace(state_ABAB*tensor({I2,I2,s1*s1',s0*s0'}));
p(3) = trace(state_ABAB*tensor({I2,I2,s0*s0',s1*s1'}));
p(4) = trace(state_ABAB*tensor({I2,I2,s1*s1',s1*s1'}));
% compare the results. If the results are the same, keep the state.
detection = randsrc(1,1,[1,2,3,4;p(1),p(2),p(3),p(4)]);
disp(['detection = ', num2str(detection)]);
switch detection
    case 1
        disp('Keep the state.');% the results are the same
        flag = 0;% record the result
        % calculate the state after measurement
        state_out = tensor({I2,I2,s0*s0',s0*s0'})*state_ABAB*tensor({I2,I2,s0*s0',s0*s0'})'/p(1);
    case 2
        disp('Throw the state.');% the results are different
        flag = 1;
    case 3
        disp('Throw the state.');% the results are different
        flag = 1;
    case 4
        disp('Keep the state.');% the results are the same
        flag = 0;% record the result
        % calculate the state after measurement
        state_out = tensor({I2,I2,s1*s1',s1*s1'})*state_ABAB*tensor({I2,I2,s1*s1',s1*s1'})'/p(4);
end

%% step 5
if flag == 0
    % Alice applies the Y gate on her state
    state_out = tensor({Y,I2,I2,I2})*state_out*tensor({Y',I2,I2,I2});
    % trace out
    state_AB = tensor({I,s0',s0'})*state_out*tensor({I,s0,s0})+...
        tensor({I,s0',s1'})*state_out*tensor({I,s0,s1})+...
        tensor({I,s1',s0'})*state_out*tensor({I,s1,s0})+...
        tensor({I,s1',s1'})*state_out*tensor({I,s1,s1});
    % calculate the actual output fidelity
    Fout =  Bell_state{4}'* state_AB * Bell_state{4};
    disp(['The actual output fidelity = ', num2str(Fout)]);
end
