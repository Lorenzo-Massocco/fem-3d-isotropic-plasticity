function dir_dofs = Read_Dirichlet(inpFile)

nodeSets = containers.Map();

fid = fopen(inpFile,'r');
if fid == -1
    error('Cannot open file %s', inpFile);
end

%% --- Step 1: Read node sets ---
tline = fgetl(fid);
while ischar(tline)
    tline = strtrim(tline);
    if startsWith(lower(tline),'*nset')
        tokens = regexp(tline,'nset\s*=\s*([\w-]+)','tokens','once');
        if isempty(tokens)
            tline = fgetl(fid);
            continue
        end
        setName = strtrim(tokens{1});

        nodes = [];
        tline = fgetl(fid);
        while ischar(tline) && ~startsWith(strtrim(tline),'*')
            tline2 = strrep(tline,',',' ');
            nums = sscanf(tline2,'%f');
            nodes = [nodes; nums];
            tline = fgetl(fid);
        end
        nodeSets(setName) = nodes;
    else
        tline = fgetl(fid);
    end
end
fclose(fid);

%% --- Step 2: Read boundary conditions ---
fid = fopen(inpFile,'r');
dir_map = containers.Map('KeyType','double','ValueType','any');

tline = fgetl(fid);
while ischar(tline)
    tline = strtrim(tline);
    if startsWith(lower(tline),'*boundary')
        tline = fgetl(fid);
        while ischar(tline) && ~startsWith(strtrim(tline),'*')
            line = strtrim(tline);
            if isempty(line) || startsWith(line,'!')
                tline = fgetl(fid);
                continue
            end

            line2 = strrep(line,',',' ');
            parts = strsplit(line2);
            parts = parts(~cellfun('isempty',parts));

            if numel(parts) < 3
                tline = fgetl(fid);
                continue
            end

            nodeRef   = parts{1};
            dof_start = str2double(parts{2});
            dof_end   = str2double(parts{3});
            if numel(parts) >= 4
                val = str2double(parts{4});
            else
                val = 0;
            end

            if isKey(nodeSets,nodeRef)
                nodesNum = nodeSets(nodeRef);
            else
                nodesNum = str2double(nodeRef);
                if isnan(nodesNum)
                    tline = fgetl(fid);
                    continue
                end
            end

            for n = nodesNum'
                if ~isKey(dir_map,n)
                    dir_map(n) = NaN(1,3);
                end
                u = dir_map(n);
                u(dof_start:dof_end) = val;
                dir_map(n) = u;
            end

            tline = fgetl(fid);
        end
    else
        tline = fgetl(fid);
    end
end
fclose(fid);

%% --- Step 3: Convert to num_dofs × 2 (NO NaNs) ---
dir_dofs = [];

nodesAll = keys(dir_map);
for i = 1:length(nodesAll)
    nodeID = nodesAll{i};
    u = dir_map(nodeID);   % [ux uy uz]

    for localDOF = 1:3
        if ~isnan(u(localDOF))
            globalDOF = 3*(nodeID-1) + localDOF;
            dir_dofs = [dir_dofs;
                        globalDOF, u(localDOF)];
        end
    end
end

% Sort by global DOF
[~,idx] = sort(dir_dofs(:,1));
dir_dofs = dir_dofs(idx,:);

end

