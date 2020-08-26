% ©2020 Janiele Eduarda Silva Costa Custodio. See the license terms in the file 'LICENSE.txt' which should
% have been included with this distribution. A copy of the license is also
% available at <https://github.com/janielecustodio/2020-02-OA-046/blob/master/LICENSE>.


%% OHCA spatial data
OHCAs =  table2array(readtable('VBOHCAR.xlsx',...
    'Sheet','OHCAs','Range','D1:E2707'));
i_OHCAs = size(OHCAs,1);
j_OHCAs = size(OHCAs,2);

%% Base stations spatial data
Bases = table2array(readtable('VBOHCAR.xlsx',...
    'Sheet','Base_Stations','Range','D1:E41'));
i_Bases = size(Bases,1);
j_Bases = size(Bases,2);

%% Distances
dist_in = table2array(readtable('VBOHCAR.xlsx',...
    'Sheet','Distances','Range','A1:H108241'));

% Road Distances
d_road = zeros(i_OHCAs, i_Bases);
for i = 1:i_OHCAs
    for j = 1:i_Bases
        d_road(i,j) = dist_in((i_OHCAs*(j-1) + i),7);        
    end
end

% Haversine Distances
d_haversine = zeros(i_OHCAs, i_Bases);
for i = 1:i_OHCAs
    for j = 1:i_Bases
        d_haversine(i,j) = dist_in((i_OHCAs*(j-1) + i),8);        
    end
end
%% Sample Definition

% Number of samples to generate
k = input(['How many additional samples you want to generate?\n'...
'(Choose an integer greater than or equal to 0) \n\n']);

% Type of sample to generate
type_of_sample=1;
if k>1
type_of_sample = input(['Which method do you want to use to generate the additional samples?\n'...
'1) Shuffle baseline instance \n' ...
'2) Generate different samples of the same size \n']);
end

if type_of_sample ~= 1 && type_of_sample ~= 2
    while type_of_sample ~= 1 && type_of_sample~=2
        type_of_sample = input(  ['Please choose 1 or 2\n']);
    end
end


%% 1. Random sample of OHCA occurrences
x = input(sprintf(  ['How many cardiac arrest occurrences?\n'...
                    '(Choose a value from 1 to %d)\n\n'], i_OHCAs));
if x>i_OHCAs || x<1
    while x>i_OHCAs || x<1
        x = input(sprintf(  ['Please choose a value from 1 to %d)\n\n'],...
                            i_OHCAs));
    end
end


%% Bases sampling
q = input(['\n How do you want to select the base stations? (select 1 or 2) \n'...
            '(1) Random Sample?\n' ...
            '(2) Catchment area? \n']);
if q>2 || q<1
    while q>2 || q<1
        q = input(sprintf('Please select 1 or 2 \n'));
    end
end

f = input(['How do you want to calculate the distances? (select 1 or 2) \n'...
            '(1) Haversine method \n'...
            '(2) Road distances \n']);       
if f>2 || f<1
    while f>2 || f<1
        f = input(sprintf('Please select 1 or 2 \n'));
    end
end

if q == 1
y = input(sprintf('How many bases in the sample? \n (Choose a value from 1 to %d) \n',i_Bases));
if y>i_Bases || y<1
    while y>i_Bases || y<1
        y = input(sprintf('Please select a value from 1 to %d \n',i_Bases));
    end
end
end

if type_of_sample==1 
    n=0;
else
    n=k;
end

for i = 1:(n+1)
A = rand(i_OHCAs,1);
[sd,ra]=sort(A,'ascend');
A_select = ra<=x;
OHCAs_selected = OHCAs(A_select,:);
ID_OHCAs = linspace(1,i_OHCAs,i_OHCAs)';
ID_A_select = ID_OHCAs(A_select,:);
OHCAs_out = [ID_A_select OHCAs_selected];
name_OHCA = sprintf('OHCAs_out_sample%d.csv',i);
csvwrite(name_OHCA,OHCAs_out);

if q==1
%% 1.1. Randomly selects y Candidate Base Stations
B = rand(i_Bases,1);
[sd,rb]=sort(B,'ascend');
B_select = rb<=y;
ID_Bases_rand = linspace(1,i_Bases,i_Bases)';
ID_Bases_random = ID_Bases_rand(B_select,:);

Bases_selected_random = Bases(B_select,:);
Bases_out = [ID_Bases_random Bases(B_select,:)];
name_bases = sprintf('Bases_out_sample%d.csv',i);
csvwrite(name_bases,Bases_out);

if f==2
    dist_out = [0, ID_Bases_random'; ID_A_select d_road(A_select,B_select)];
    name_dist = sprintf('dist_out_sample%d.csv',i);
    csvwrite(name_dist,dist_out);
elseif f==1
dist_out = [0, ID_Bases_random'; ID_A_select d_haversine(A_select,B_select)];
name_dist = sprintf('dist_out_sample%d.csv',i);
csvwrite(name_dist,dist_out);
end

elseif q==2 && f==2

%% 1.2. Selects all candidate base stations within the catchment area of at least one location
z = input(sprintf(['What is the catchment area in meters?'...
                    'n (Choose a value greater than %d) \n'],...
                    max(min(d_road(A_select,:),[],2))));

if z < max(min(d_road(A_select,:),[],2))
    while z < max(min(d_road(A_select,:),[],2))
    z = input(sprintf('Please choose a value greater than %d meters \n',...
        max(min(d_road(A_select,:),[],2))));
    end
end

select_bases = d_road(A_select,:)<z; 
ID_Bases = linspace(1,i_Bases,i_Bases)';
ID_Bases_select = ID_Bases(sum(select_bases,1)'>0,:);
Bases_selected_catchment = Bases(sum(select_bases,1)'>0,:);
Bases_out = [ID_Bases_select Bases_selected_catchment];
name_bases = sprintf('Bases_out_sample%d.csv',i);
csvwrite(name_bases,Bases_out);

dist_out = [0, ID_Bases_select';ID_A_select d_road(A_select,ID_Bases_select)];
name_dist = sprintf('dist_out_sample%d.csv',i);
csvwrite(name_dist,dist_out);

elseif q == 2 && f==1
%% 1.2. Selects all candidate base stations within the catchment area of at least one location
z = input(sprintf(['What is the catchment area in meters?'...
                    '\n (Choose a value greater than %d) \n'],...
                    max(min(d_road(A_select,:),[],2))));

if z < max(min(d_road(A_select,:),[],2))
    while z < max(min(d_road(A_select,:),[],2))
    z = input(sprintf('Please choose a value greater than %d meters \n',...
        max(min(d_road(A_select,:),[],2))));
    end
end

select_bases = d_haversine(A_select,:)<z; 
ID_Bases = linspace(1,i_Bases,i_Bases)';
ID_Bases_select = ID_Bases(sum(select_bases,1)>0,:);
Bases_out = Bases(sum(select_bases,1)>0,:);
Bases_out = [ID_Bases_select Bases_out];

name_base = sprintf('Bases_out_sample%d.csv',i);
csvwrite(name_base,Bases_out);

dist_out = [0, ID_Bases_select';ID_A_select d_road(A_select,ID_Bases_select)];
name_dist = sprintf('dist_out_sample%d.csv',i);
csvwrite(name_dist,dist_out)
end
end

if type_of_sample==1
for i = 1:k
rows_OHCAs = size(OHCAs_out,1);
r_row = randperm(rows_OHCAs,rows_OHCAs);
name_OHCA = sprintf('OHCAs_out_sample1_shuffle%d.csv',i);
csvwrite(name_OHCA,OHCAs_out(r_row,:));

rows_bases = size(Bases_out,1);
r_row = randperm(rows_bases,rows_bases);
name_bases = sprintf('Bases_out_sample1_shuffle%d.csv',i);
csvwrite(name_bases,Bases_out(r_row,:));

ID_OHCAs = dist_out(:,1);
ID_OHCAs = ID_OHCAs(2:end, :);
ID_Bases = dist_out(1,:);
ID_Bases = ID_Bases(:,2:end);
dist_out_shuffle = dist_out(2:end, 2:end);
rows_dist = size(dist_out_shuffle,1);
col_dist = size(dist_out_shuffle,2);
r_row = randperm(rows_dist,rows_dist);
r_col = randperm(col_dist,col_dist);
dist_out_shuffle = [0 ID_Bases(:,r_col); ID_OHCAs(r_row,:) dist_out_shuffle(r_row,r_col)];
name_bases = sprintf('dist_out_sample1_shuffle%d.csv',i);
csvwrite(name_bases,dist_out_shuffle);
end
end
