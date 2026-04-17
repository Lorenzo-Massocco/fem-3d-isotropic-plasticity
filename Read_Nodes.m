function nodes = Read_Nodes(inpFile)

fid = fopen(inpFile,'r');
tline = fgetl(fid);
nodes = [];
while ischar(tline)
    if startsWith(tline,'*Node')
        tline = fgetl(fid);
        while ischar(tline) && ~startsWith(tline,'*')
            data = sscanf(tline,'%f,%f,%f,%f');
            nodes(data(1),:) = data(2:4)';
            tline = fgetl(fid);
        end
    else
        tline = fgetl(fid);
    end
end
fclose(fid);

end