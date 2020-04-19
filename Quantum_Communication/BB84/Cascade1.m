function [AliceBitsOut, BobBitsOut] = Cascade1(bits_alice, bits_bob, ErrorRate)

NumIteration = 4;% define the times of passes
block_size = ceil(0.73/ErrorRate);% calculate the block size by the formula given
total_length = length(bits_alice);% record the length of the original secret key
remnant = rem(total_length,block_size*(2^(NumIteration-1)));

%add zeros to the bitstring
if remnant == 0
    AlicePadded = bits_alice;
    BobPadded = bits_bob;
else
    AlicePadded = zeros([1,total_length + block_size*(2^(NumIteration-1)) - remnant]);
    AlicePadded(1:total_length) = bits_alice;
    BobPadded = zeros([1,total_length + block_size*(2^(NumIteration-1)) - remnant]);
    BobPadded(1:total_length) = bits_bob;
end
 
N = length(AlicePadded);% record the length of the whole bitstring(with zeros padded)

permutation = zeros(NumIteration,N);
blocksize = zeros(1,NumIteration);
blocknum = zeros(1,NumIteration);
for p = 1:NumIteration
    %generate and store the permutation for each pass
    permutation(p,:) = randperm(N);
    
    %calculate and store the block size and length for each pass
    blocksize(p) = ceil(0.73/ErrorRate) * 2^(p-1);%the block size for different passes
    blocknum(p) = N/blocksize(p);% calcute the number of block
end

for pass = 1: NumIteration
    % apply the permutation
    AlicePadded = AlicePadded(permutation(pass,:));
    BobPadded = BobPadded(permutation(pass,:));
    
    % Divide Alice and Bob's string to blocks
    block_size = blocksize(pass);
    block_num = blocknum(pass);
    AliceBlock = reshape(AlicePadded, [block_size, block_num]);
    BobBlock = reshape(BobPadded, [block_size, block_num]);
    
    % calculate the parity value
    AliceParity = mod(sum(AliceBlock),2);
    BobParity = mod(sum(BobBlock),2);
    ParityDiff = abs(AliceParity - BobParity);
    
    for t = 1: block_num
        if ParityDiff == 1
            % if their parity value are different, do the binary search and
            % correct the error bit
            BobBlock(:,t) = BinarySearchErrorCorrection(AliceBlock(:,n)', BobBlock(:,n)')';
        end    
    end
    
    % resemble the block into the bitstring
    AlicePadded = reshape(AliceBlock,[1,N]);
    BobPadded = reshape(BobBlock,[1,N]);
    
    % go back to the pass before to correct error
    for pass_rev = pass:-1:2
        % recover the previous permutation
        AlicePadded = sort(AlicePadded);
        BobPadded = sort(BobPadded);
    
        % Divide Alice and Bob's string to blocks
        block_size = blocksize(pass_rev - 1);
        block_num = blocknum(pass_rev - 1);
        AliceBlock = reshape(AlicePadded, [block_size, block_num]);
        BobBlock = reshape(BobPadded, [block_size, block_num]);
        
        % calculate the parity value
        AliceParity = mod(sum(AliceBlock),2);
        BobParity = mod(sum(BobBlock),2);
        ParityDiff = abs(AliceParity - BobParity);
        
        for t = 1: block_num
            if ParityDiff == 1
                BobBlock(:,t) = BinarySearchErrorCorrection(AliceBlock(:,n)', BobBlock(:,n)')';
            end
        end
        % resemble the block into the bitstring
        AlicePadded = reshape(AliceBlock,[1,N]);
        BobPadded = reshape(BobBlock,[1,N]);
    end
    
    %return to the previous proceeding pass(e.g. from pass 1 to 3)
    for pass_rev_rev = 2:pass
        % apply the permutation
        AlicePadded = AlicePadded(permutation(pass_rev_rev,:));
        BobPadded = BobPadded(permutation(pass_rev_rev,:));
    end
end
% remove the zeros padded
AlicePadded = reshape(AlicePadded(1:total_length),[1,total_length]);
BobPadded = reshape(BobPadded(1:total_length), [1,total_length]);
AliceBitsOut =  AlicePadded;
BobBitsOut = BobPadded;
end

% The function for the binary search
% this function is the one in the refence code
function [ Bob ] = BinarySearchErrorCorrection( Alice,Bob )
% BinarySearchErrorCorrection Locate and correct 1 bit error using binary search
if (length(Alice) == 1)
    Bob = Alice;
    return;
else
    mid = ceil(length(Alice)/2);
    if (mod(sum(Alice(1:mid)),2) ~= mod(sum(Bob(1:mid)),2)) % If the error is in the first half of the string
        Bob(1:mid) = BinarySearchErrorCorrection(Alice(1:mid), Bob(1:mid));
    elseif (mod(sum(Alice(mid+1:length(Alice))),2) ~= mod(sum(Bob(mid+1:length(Bob))),2)) % If the error is in the second half of the string
        Bob(mid+1:length(Bob)) = BinarySearchErrorCorrection(Alice(mid+1:length(Alice)), Bob(mid+1:length(Bob)));
    else
        return; % If both first half and second half of the parity are the same, no error detected.
    end
end
end
