% Generate transactions from `outputpool` (list of extant outputs)
% IsthmusCrypto 2018.05
%
% Note: Hacky code, mostly just testing the format. Not generating 
%   realistic transaction patterns 

%% Parameters
c=0; % counter
NumberOfBlocksToGenerate = 100*600; % 100 days
NumberOfTxnsPerBlock = 10; % Arbitrary
nRingMembers = 7; % Spring 2018 mandate
load(<existing outputs>); % insert your output list here

%% Generate txns/blocks - uniform random for testing
for h = 1:NumberOfBlocksToGenerate
    for n = 1:NumberOfTxnsPerBlock
        c = c+1; % increment
        
        % generate mock stealth address
        nums = randi(numel(symbols),[1 stLength]); 
        st = symbols(nums);
        txns(c,1:2) = {h, st};
        
        % select ring members from pool of past transactions
        lop = length(outputpool);
        for r = 3:(nRingMembers+2)
            
            % select a nonzero ring member
            rm = 0;
            while rm == 0
                rm = round(lop*rand());
            end
            
            % ring member signs 
            txns{c,r} = outputpool{rm};
        end
        
        outputpool{lop+1} = st; % add output to pool for future ring members
    end
end

% Save it
fid = fopen('SyntheticBlockchain_Uniform.csv','wt');
if fid>0
    for k=1:size(txns,1)
        fprintf(fid,'%s,%f\n',txns{k,:});
    end
    fclose(fid);
end
