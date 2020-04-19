clear all;

n = 10000;
ratio = 0.1; % according to the reference code
eve = zeros(1, 51); %store the ratio of Eve interception
error_eve = zeros(1, 51); %store the error rate
seq = 0;

for eve_ratio = 0:0.02:1
    seq = seq + 1; %count the times of the loop
    eve(seq) = eve_ratio; % the matrix used to store the ratio of Eve interception
    
    %step 1 and 2 of BB84(Alice's bit string and states)
    [bitstring, states_out, basis_chosen] = Preparation(n);
    
    %Eve's interception
    flag = logical(binornd(1, eve_ratio, n, 1));
    picked_length = sum(flag);
    states_out_eve = states_out;
    %Eve measures the quantum states
    [~, states_out_eve(:,flag), ~] = Measurement(picked_length, states_out(:,flag));
    
    %step 3 of BB84(Bob chooses his basis and measures his states and string)
    [bits_out, state_after_measurement,basis_bob] = Measurement(n, states_out_eve);

    %step 4 of BB84(compare the basis and store the correct results)
    [bits_alice, bits_bob] = BasisCheck(bitstring, bits_out, basis_chosen, basis_bob, n);

    %select part of the sifted string to esimate error
    [substring_alice, substring_bob, error_rate] = ErrorEstimation(bits_alice, bits_bob, ratio);
    error_eve(seq) = error_rate;
end


%plot the figure
scatter(eve, error_eve, 'b*')
hold on
x = 0:0.1:1;
y = 0.25 * x;
plot(x,y,'r--')
title('Interception rate vs Error rate diagram')
xlabel('Interception Rate')
ylabel('Error Rate')
