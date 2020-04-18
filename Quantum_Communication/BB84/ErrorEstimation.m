function [substring_alice, substring_bob, error_rate] = ErrorEstimation(bits_alice, bits_bob, ratio)
sifted_length = length(bits_alice);
%remnant string
substring_alice = zeros(1,1);
substring_bob = zeros(1,1); 
length_remnant = 0;

%sub-bits string
substring_alice_test = zeros(1,1);
substring_bob_test = zeros(1,1); 
length_sub = 0;

for d = 1: sifted_length
    test = binornd(1, ratio);% decide whether this will be tested or not
    if test == 0 % this bit will not be tested
        length_remnant = length_remnant + 1;
        substring_alice(length_remnant) = bits_alice(d);
        substring_bob(length_remnant) = bits_bob(d);% directly add this bit to the output string
    elseif test == 1 % this bit is tested
        length_sub = length_sub + 1;
        substring_alice_test(length_sub) = bits_alice(d);
        substring_bob_test(length_sub) = bits_bob(d);% add to the test bit string
    end
end
error_rate = sum(abs(substring_alice_test-substring_bob_test))/length_sub;% calculate the error rate
end
