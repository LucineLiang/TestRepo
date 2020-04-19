function [final_key] = PrivacyAmplification(s, BobBitsOut)
round = 20; % divide the bit string into 20 blocks
N = length(BobBitsOut);% store the length of the original secret key
tag = mod(N,20);%calculate the remnent part
N_block = (N-tag)/round;% calculate the first block size (for zero padding)
zero = N_block - tag; % the number of the zeros added at the rear of the bit string
L_block = floor(N_block * (1-s));% decide the length of blocked L
L = L_block * round; % store the total number of L
I_l = eye(L_block);% generate an identity matrix as the first part of the generator matrix G
string_a = zeros(1,N_block);
final_key = [];

T = zeros(L_block, (N_block-L_block));
for t = 1:L_block
    for tt = 1:(N_block-L_block)
        T(t, tt) = randi([0,1]);% generate the second random part of G
    end
end
G = [I_l, T];% combine the generator matrix G

if tag ~= 0
    for append = 1:zero
        BobBitsOut = [BobBitsOut, 0]; %add zeros 
    end
end

for r = 1: round
    string_a = BobBitsOut(1,N_block*r-(N_block-1):N_block*r);
    final_key_part = mod((G * string_a'),2);% claculate the final key
    final_key = [final_key; final_key_part];
end
final_key = final_key';
final_key = reshape(final_key(1:L),[1,L]);%remove zeros added
end
