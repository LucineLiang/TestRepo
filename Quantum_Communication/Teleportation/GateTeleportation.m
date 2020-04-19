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

% generate the unitary matrix 
X = complex(rand(2),rand(2))/sqrt(2);
% factorize the matrix
[Q,R] = qr(X);
R = diag(diag(R)./abs(diag(R)));
% unitary matrix
U = Q*R;

% generate Alice's random quantum state
a = 0.233; b = sqrt(1-a^2);
s = a * s0 + b * s1;
% Alice and Bob share a Bell state
state_AB = Bell_state{1};
% apply the unitary gate U
state_AB = tensor({I,U})* state_AB;
% entangle Alice's state with the Bell state
state_AAB = tensor({s,state_AB});
%perform the Bell measurement
p = zeros(1,4);
for i = 1:4
    p(i) = state_AAB' * tensor({Bell{i},I}) * state_AAB;
end
p = real(p);
% calculate the state after Bell measurement
detection = randsrc(1,1,[1,2,3,4;p(1),p(2),p(3),p(4)])
state_AAB1 = tensor({Bell{detection},I}) * state_AAB;
state_AAB2 = sqrt(state_AAB' * tensor({Bell{detection},I}) * state_AAB);
state_AAB = state_AAB1/state_AAB2;
% revocer the state according to the detection
switch detection
    case 1
        state_B = tensor({I,I,U*I*U'})* state_AAB;
    case 2
        state_B = tensor({I,I,U*Uz*U'})* state_AAB;
    case 3
        state_B = tensor({I,I,U*Ux*U'})* state_AAB;
    case 4
        state_B = tensor({I,I,U*Uz*Ux*U'})* state_AAB;
end
% trace out
state_B = tensor({Bell_state{detection}',I})* state_B;
state_B
U*s
% check whether the transmission is successful
if sum((state_B - U*s).^2)<1e-10
    disp('Successful!');
else
    disp('Failed.');
end
