function [bits_out, state_after_measurement,basis_bob] = Measurement(n, states_out)

basis_alice = zeros(1, n);
basis_bob = zeros(1, n);
probability = zeros(2, n);
state_after_measurement = zeros(2, n);
bits_out = zeros(1, n);

for b = 1: n
    bob_choice = randi(2); %Bob's choice of the basis
    basis_bob(b) = bob_choice; %store Bob's choice
    s(1) = states_out(1, b);
    s(2) = states_out(2, b);
    if bob_choice == 1
        m0 = [1; 0]; % plus basis
        m1 = [0; 1];
    else
        m0 = [1/sqrt(2); 1/sqrt(2)]; % cross basis
        m1 = [-1/sqrt(2); 1/sqrt(2)];
    end
    probability(1, b) = (abs(s * m0))^2;
    probability(2, b) = (abs(s * m1))^2; %calculate the probability
    if probability(1, b) > 0.9
        state_after_measurement(1, b) = m0(1);
        state_after_measurement(2, b) = m0(2);
        bits_out(b) = 0; %the first state is 100% sure
    elseif probability(1, b) < 0.1
        state_after_measurement(1, b) = m1(1);
        state_after_measurement(2, b) = m1(2);
        bits_out(b) = 1; %the second state is 100% sure
    else %the probability is 50% which means the basis is wrong
        guess = randi(2); %randomly choose one state from another basis
        if bob_choice == 1 && guess == 1 % another basis is the cross one
            state_after_measurement(1, b) = 1/sqrt(2);
            state_after_measurement(2, b) = 1/sqrt(2);
            bits_out(b) = 0; %this case is corresponding to state 0
        elseif bob_choice == 1 && guess == 2 % same basis, different state
            state_after_measurement(1, b) = -1/sqrt(2);
            state_after_measurement(2, b) = 1/sqrt(2);
            bits_out(b) = 1; %this case is corresponding to state 1
        elseif bob_choice == 2 && guess == 1 % another basis is the plus one
            state_after_measurement(1, b) = 1;
            state_after_measurement(2, b) = 0;
            bits_out(b) = 0; %this case is corresponding to state 0
        else
            state_after_measurement(1, b) = 0;
            state_after_measurement(2, b) = 1;
            bits_out(b) = 1; %this case is corresponding to state 1
        end
    end
end
end
