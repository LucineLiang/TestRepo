function [BobBitsOut] = ErrorCorrection2(bits_alice, bits_bob)
H = [1 1 1 0 1 0 0; 1 1 0 1 0 1 0; 0 1 1 1 0 0 1]; %define the check matrix for [7,4] code
string_7 = zeros(7, 1);
string_7_a = zeros(7, 1);
BobBitsOut = [];
err = [0 0 0 0 0 0 0];

length_original = length(bits_bob); %store the length of the original string
tag = mod(length(bits_bob), 7); % remnent bits that cannot form a 7-bit string
round = (length(bits_bob)-tag)/7 + 1; % the number of the 7-bit strings
if tag ~= 0
    for append = 1:(7-tag)
        bits_alice = [bits_alice, 0];
        bits_bob = [bits_bob, 0]; %add zeros 
    end
end

for n = 1: round
    err = [0 0 0 0 0 0 0];
    choice = randi(7);% choose which bit will have error
    flip = binornd(1, 0.15);% choose whether the error occurs, probability = 0.15
    err(choice) = flip;% update the error matrix
    
    string_7_a = (bits_alice(1, (7*n-6):(7*n)))';%use 7 bits every round
    % In order to test the code, here only one bit might be wrong in a
    % block. Thus, Alice's string is used here as Bob's.
    string_7 = (bits_alice(1, (7*n-6):(7*n)))';
    string_7 = mod((string_7 + err'),2);% flip the bit where error occurs
    syndrome_alice = mod((H * string_7_a),2);%calculate Alice's syndrome
    syndrome_bob = mod((H * string_7),2);%calculate Bob's syndrome
    for a = 1:3
        syndrome_alice(a,1) = mod(syndrome_alice(a,1),2);
        syndrome_bob(a,1) = mod(syndrome_bob(a,1),2);
        syndrome(a,1) = abs(syndrome_bob(a,1)-syndrome_alice(a,1));%calculate the s
    end

    % according to the syndrome s, the coset leader can be determined
    if syndrome == [1;1;0]
        coset_leader = [1 0 0 0 0 0 0];
    elseif syndrome == [1;1;1]
        coset_leader = [0 1 0 0 0 0 0];
    elseif syndrome == [1;0;1]
        coset_leader = [0 0 1 0 0 0 0];
    elseif syndrome == [0;1;1]
        coset_leader = [0 0 0 1 0 0 0];
    elseif syndrome == [1;0;0]
        coset_leader = [0 0 0 0 1 0 0];
    elseif syndrome == [0;1;0]
        coset_leader = [0 0 0 0 0 1 0];
    elseif syndrome == [0;0;1]
        coset_leader = [0 0 0 0 0 0 1];
    elseif syndrome == [0;0;0]
        coset_leader = [0 0 0 0 0 0 0];
    end
    
    bits_bob_correct = abs(string_7' - coset_leader);%correct Bob's 7-bit string
    BobBitsOut = [BobBitsOut, bits_bob_correct];
end
%remove zeros padded
BobBitsOut(:, (length_original+1) : (length_original-tag+7)) = [];
end
