function [bitstring, states_out, basis_chosen] = Preparation(n)
bitstring = randi([0,1], 1, n); %generates the secret key
states_out = zeros(2,n); %the matrix used to store the modelated quantum states
basis_chosen = zeros(1,n); %the matrix used to store the basis choices

for a = 1: n
    choice = randi(2); % randomly decide which basis to be used, choices between 1 & 2
    basis_chosen(a) = choice; %store the choice
    if choice == 1
        %display('basis +'); %1 means the plus basis
        basis_0 = [1; 0];
        basis_1 = [0; 1];
        if bitstring(a)==0
            %disp('[1; 0]'); %in the plus basis, if the key is 0, the state is [1; 0]
            states_out(1, a) = 1;
            states_out(2, a) = 0; %write the state into the matrix
        else 
            %disp('[0; 1]'); %in the plus basis, if the key is 1, the state is [0; 1]
            states_out(1, a) = 0;
            states_out(2, a) = 1; %write the state into the matrix
        end
    else
        %display('basis x'); %2 means the cross basis
        basis_0 = [1/sqrt(2); 1/sqrt(2)];
        basis_1 = [-1/sqrt(2); 1/sqrt(2)];
        if bitstring(a)==0
            %disp('[1/sqrt(2); 1/sqrt(2)]');
            states_out(1, a) = 1/sqrt(2);
            states_out(2, a) = 1/sqrt(2);
        else 
            %disp('[-1/sqrt(2); 1/sqrt(2)]');
            states_out(1, a) = -1/sqrt(2);
            states_out(2, a) = 1/sqrt(2);
        end
    end
end
end
