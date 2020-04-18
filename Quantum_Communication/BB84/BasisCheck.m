function [bits_alice, bits_bob] = BasisCheck(bitstring, bits_out, basis_chosen, basis_bob, n)
sifted_length = 0; %the length of the sifted string
bits_alice = zeros(1, 1); %store Alice's sifted string
bits_bob = zeros(1, 1); %store Bob's sifted string
for c = 1: n
    if basis_chosen(c) == basis_bob(c)
        %if the bit sent is the same as received, store it as the sifted string
        sifted_length = sifted_length + 1;
        bits_alice(sifted_length) = bitstring(c);
        bits_bob(sifted_length) = bits_out(c);
    end
end
end
