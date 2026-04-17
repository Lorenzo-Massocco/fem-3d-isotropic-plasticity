function elem = Read_Elements(inpFile)

fid = fopen(inpFile,'r');
tline = fgetl(fid);
elem = [];
while ischar(tline)
    if startsWith(tline,'*Element')
        tline = fgetl(fid);
        while ischar(tline) && ~startsWith(tline,'*')
            data = sscanf(tline,'%f,%f,%f,%f,%f');
            elem(data(1),:) = data(2:5)';  % assuming 4-node tetra
            tline = fgetl(fid);
        end
    else
        tline = fgetl(fid);
    end
end
fclose(fid);

end