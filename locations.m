bal = [-64.212	-31.298
-64.73	-32.13
-63.726	-29.906];
	
flx = [
-62.36068333	-31.28495
-62.09375	-32.72371667
-62.07463333	-32.71578333
-62.96025	-32.8036
-64.88676667	-32.86536667
-62.82341667	-33.15558333
-64.39513333	-32.47223333];
	
	
met = [
-63.64116667	-31.33128333
-62.81066667	-31.38093333
-60.91148333	-31.39168333
-61.43495	-32.80568333
-63.3552	-33.3048
-63.63676667	-33.40331667
-64.80933333	-32.17568333
-63.88206667	-31.66796667];


%%
figure(476); clf
scatter(bal(:,1),bal(:,2),'ko'); hold on
scatter(flx(:,1),flx(:,2),'rx');
scatter(met(:,1),met(:,2),'bx');

% met 
% s13 La Insolente
% s15 Pilar
% s1
%
% flux
% s14
% s9

%% Variable check
fn = '~/Desktop/UIUC/2021Spring/ATMS 405/Project/EOL_Fluxes/isfs_tc_20180520.nc';
finfo = ncinfo(fn);
ll = length(finfo.Variables);
sn = 'h2o';
varnl = cell(1,ll);
j = 1;
for i = 1:ll
    vn = finfo.Variables(i).Name;
    if contains(vn,sn)
        varnl{j} = vn; j = j + 1;
    end
end
temp = varnl{1:j-1};

for i = 1:j-1
    fprintf('%s\n',varnl{i});
end

%%
flist = importdata('~/Desktop/UIUC/2021Spring/ATMS 405/Project/EOL_Fluxes/list_s.txt');
fll = length(flist);

rain = nan(3,288*fll);
rain_t = nan(3,288*fll);

rnv = {'Rainr_1m_s1','Rainr_1m_s13','Rainr_1m_s15'};
rntv = {'Rainr_tip_1m_s1','Rainr_tip_1m_s13','Rainr_tip_1m_s15'};

for i = 1:fll
    fn = ['~/Desktop/UIUC/2021Spring/ATMS 405/Project/EOL_Fluxes/' flist{i}];
    
    finfo = ncinfo(fn);
    for j = 1:length(finfo.Variables)
        vn = finfo.Variables(j).Name;
        tid  = ((i-1)*288+1):((i-1)*288+288);
        for k = 1:3
            if strcmp(vn,rnv{k})
                rain(k,tid) = ncread(fn,rnv{k});
            end
            if strcmp(vn,rntv{k})
                rain_t(k,tid) = ncread(fn,rntv{k});
            end
        end
    end
end

%%
drain = nan(3,fll);
draint = nan(3,fll);

for i = 1:fll
    tid = ((i-1)*288+1):((i-1)*288+288);
    drain(:,i) = sum(rain(:,tid),2);
    draint(:,i) = sum(rain_t(:,tid),2);
end

%%
% daily accum rain
p95 = nan(1,3);
p95(1) = prctile(drain(1,:),95);
p95(2) = prctile(drain(2,:),95);
p95(3) = prctile(drain(3,:),95);

days = 1:fll;
pdays = [];
for i = 1:3
    pday = days(drain(i,:)>=p95(i));
    % intersect days
    if i == 1
        pdays = pday;
    else
        pdays = intersect(pdays,pday);
    end
    % all days
%     pdays = unique([pdays pday]);
end

pdl = cell(1,length(pdays));
for i = 1:length(pdays)
    pdl{i} = flist{pdays(i)}(9:16);
end

%%
% 3-hour accum rain 
hrain = nan(3,fll*8);
hraint = nan(3,fll*8);

for i = 1:fll*8
    tid = ((i-1)*36+1):((i-1)*36+36);
    hrain(:,i) = sum(rain(:,tid),2);
    hraint(:,i) = sum(rain_t(:,tid),2);
end

p95 = nan(1,3);
p95(1) = prctile(hrain(1,:),95);
p95(2) = prctile(hrain(2,:),95);
p95(3) = prctile(hrain(3,:),95);

hours = 1:fll*8;
phours = [];
for i = 1:3
    phour = hours(hrain(i,:)>=p95(i));
    % intersect days
    if i == 1
        phours = phour;
    else
        phours = intersect(phours,phour);
    end
    % all days
%     pdays = unique([pdays pday]);
end

pdl = cell(1,length(phours));
for i = 1:length(phours)
    ymh = floor((phours(i)-1)/8)+1;
%     hhh = floor((phours(i)-(ymh-1)*8)/3)*3-3;
%     hhh = mod(phours(i)-1,8)-1;
    ymh = flist{ymh}(9:16);
%     if hhh < 0
%         hhh = hhh + 8; hhh = hhh*3;
%         ymh = datenum(ymh,'yyyymmdd')-1;
%         ymh = datestr(ymh,'yyyymmdd');
%     else
%         hhh = hhh*3;
%     end
    hhh = mod(phours(i)-1,8)*3;
    hhh = num2str(hhh,'%02d');
    pdl{i} = [ymh hhh 'Z'];
end
%%
figure(4398)
plot(hrain(2,:))
% i = 131;
% tid = ((i-1)*288+1):((i-1)*288+288);
% plot(rain(2,tid))

%%
% Now soil moisture! NO RH
flist = importdata('~/Desktop/UIUC/2021Spring/ATMS 405/Project/EOL_Fluxes/list_s.txt');
fll = length(flist);

qsoil = nan(5,288*fll);

rnv = {'RH_2m_s1','RH_2m_s13','RH_2m_s15',...
    'RH_2m_s9','RH_2m_s14'};

for i = 1:fll
    fn = ['~/Desktop/UIUC/2021Spring/ATMS 405/Project/EOL_Fluxes/' flist{i}];
    
    finfo = ncinfo(fn);
    for j = 1:length(finfo.Variables)
        vn = finfo.Variables(j).Name;
        tid  = ((i-1)*288+1):((i-1)*288+288);
        for k = 1:5
            if strcmp(vn,rnv{k})
                qsoil(k,tid) = ncread(fn,rnv{k});
            end
        end
    end
end

%%
% 3-hour mean rh
hrh = nan(5,fll*8);

for i = 1:fll*8
    tid = ((i-1)*36+1):((i-1)*36+36);
    hrh(:,i) = mean(qsoil(:,tid),2);
end

rh95 = nan(1,5);
for i = 1:5
    rh95(i) = prctile(hrh(i,:),5);
end

hours = 1:fll*8;
dhours = [];
for i = 1:5
    dhour = hours(hrh(i,:)<=rh95(i));
    % intersect days
    if i == 1
        dhours = dhour;
    else
        dhours = intersect(dhours,dhour);
    end
    % all days
%     pdays = unique([pdays pday]);
end

ddl = cell(1,length(dhours));
for i = 1:length(dhours)
    ymh = floor((dhours(i)-1)/8)+1;
%     hhh = floor((phours(i)-(ymh-1)*8)/3)*3-3;
%     hhh = mod(dhours(i)-1,8)-1;
    ymh = flist{ymh}(9:16);
%     if hhh < 0
%         hhh = hhh + 8; hhh = hhh*3;
%         ymh = datenum(ymh,'yyyymmdd')-1;
%         ymh = datestr(ymh,'yyyymmdd');
%     else
%         hhh = hhh*3;
%     end
    hhh = mod(dhours(i)-1,8)*3;
    hhh = num2str(hhh,'%02d');
    ddl{i} = [ymh hhh 'Z'];
end

%%
figure(4399)
plot(qsoil(1,:))

%% HERE GOES TEMPERATURE
% Now soil moisture! NO RH
flist = importdata('~/Desktop/UIUC/2021Spring/ATMS 405/Project/EOL_Fluxes/list_s.txt');
fll = length(flist);

fdat = nan(5,288*fll);

rnv = {'T_2m_s1','T_2m_s13','T_2m_s15',...
    'T_2m_s9','T_2m_s14'};

for i = 1:fll
    fn = ['~/Desktop/UIUC/2021Spring/ATMS 405/Project/EOL_Fluxes/' flist{i}];
    
    finfo = ncinfo(fn);
    for j = 1:length(finfo.Variables)
        vn = finfo.Variables(j).Name;
        tid  = ((i-1)*288+1):((i-1)*288+288);
        for k = 1:5
            if strcmp(vn,rnv{k})
                fdat(k,tid) = ncread(fn,rnv{k});
            end
        end
    end
end

%%
% 3-hour mean t2m
ht2m = nan(5,fll*8);

for i = 1:fll*8
    tid = ((i-1)*36+1):((i-1)*36+36);
    ht2m(:,i) = mean(fdat(:,tid),2);
end

t2m95 = nan(1,5);
for i = 1:5
    t2m95(i) = prctile(ht2m(i,:),95);
end

hours = 1:fll*8;
thours = [];
for i = 1:5
    thour = hours(ht2m(i,:)>=t2m95(i));
    % intersect days
    if i == 1
        thours = thour;
    else
        thours = intersect(thours,thour);
    end
    % all days
%     pdays = unique([pdays pday]);
end

tdl = cell(1,length(thours));
for i = 1:length(thours)
    ymh = floor((thours(i)-1)/8)+1;
%     hhh = floor((phours(i)-(ymh-1)*8)/3)*3-3;
%     hhh = mod(thours(i)-1,8)-1;
    ymh = flist{ymh}(9:16);
%     if hhh < 0
%         hhh = hhh + 8; hhh = hhh*3;
%         ymh = datenum(ymh,'yyyymmdd')-1;
%         ymh = datestr(ymh,'yyyymmdd');
%     else
%         hhh = hhh*3;
%     end
    hhh = mod(thours(i)-1,8)*3;
    hhh = num2str(hhh,'%02d');
    tdl{i} = [ymh hhh 'Z'];
end

%%
figure(4399)
plot(fdat(5,:))

%% HERE GOES Radiation
% Rsum Rin?
flist = importdata('~/Desktop/UIUC/2021Spring/ATMS 405/Project/EOL_Fluxes/list_s.txt');
fll = length(flist);

fdat = nan(5,288*fll);

rnv = {'Rsum_s1','Rsum_s13','Rsum_s15',...
    'Rsum_s9','Rsum_s14'};

for i = 1:fll
    fn = ['~/Desktop/UIUC/2021Spring/ATMS 405/Project/EOL_Fluxes/' flist{i}];
    
    finfo = ncinfo(fn);
    for j = 1:length(finfo.Variables)
        vn = finfo.Variables(j).Name;
        tid  = ((i-1)*288+1):((i-1)*288+288);
        for k = 1:5
            if strcmp(vn,rnv{k})
                fdat(k,tid) = ncread(fn,rnv{k});
            end
        end
    end
end

Rsum = fdat;
%% HERE GOES Radiation2
% Rsum Rin?
flist = importdata('~/Desktop/UIUC/2021Spring/ATMS 405/Project/EOL_Fluxes/list_s.txt');
fll = length(flist);

fdat = nan(5,288*fll);

rnv = {'Rsw_in_s1','Rsw_in_s13','Rsw_in_s15',...
    'Rsw_in_s9','Rsw_in_s14'};

for i = 1:fll
    fn = ['~/Desktop/UIUC/2021Spring/ATMS 405/Project/EOL_Fluxes/' flist{i}];
    
    finfo = ncinfo(fn);
    for j = 1:length(finfo.Variables)
        vn = finfo.Variables(j).Name;
        tid  = ((i-1)*288+1):((i-1)*288+288);
        for k = 1:5
            if strcmp(vn,rnv{k})
                fdat(k,tid) = ncread(fn,rnv{k});
            end
        end
    end
end

Rswin = fdat;