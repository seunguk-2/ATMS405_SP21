% let's find vertical profiles
% follow up code of /Users/seunguk/Downloads/Soundings/getdat.m

%%
pdi = [];
for i = 1:length(fl)
    for j = 1:length(pdl)
        if contains(fl{i},[pdl{j}])
            fprintf('%s for %d \n',fl{i},i);
            pdi = [pdi i];
        end
    end
end

% For dry hours
ddi = [];
for i = 1:length(fl)
    for j = 1:length(ddl)
        if contains(fl{i},[ddl{j}])
            fprintf('%s for %d \n',fl{i},i);
            ddi = [ddi i];
        end
    end
end

% For HOT hours
tdi = [];
for i = 1:length(fl)
    for j = 1:length(tdl)
        if contains(fl{i},[tdl{j}])
            fprintf('%s for %d \n',fl{i},i);
            tdi = [tdi i];
        end
    end
end

%%
% interpolate into vertical level.
figure(984); clf
datdi = tdi;
plot(qval(datdi,:)',hypz(datdi,:)','.-'); hold on
% plot(virtPT(pdi-14,:)',hypz(pdi-14,:)','.k-'); hold on
% plot(virtT(pdi,:)',hypz(pdi,:)','.r-'); hold on
% plot(virtT(pdi-15,:)',hypz(pdi-15,:)','.k-'); hold on
% axis([290 320 0 5000]);
ylim([0 5000]);

title('{\theta}_{v} profile - 90th percentile rainy hours');
xlabel('Temperature (K)');
ylabel('Height (m)');

%%
for i = 1:length(ddi)
    fprintf('Day %d BLH = %.2f m\n',ddi(i),rin(ddi(i)));
%     fprintf('Day %d BLH = %.2f m\n',pdi(i),rin(pdi(i)));
end
% rin(pdi-14)

hrain(:,phours)/3

%%
imprint('~/Desktop/prcp90_2000.eps',5,8,0,300);

% 371 for 

%%
i = 7;
datdi = tdi;
di = (datdi(i)-20):(datdi(i)+5);
figure(9183); clf
[xt,yt] = meshgrid(tt,pls);
s = pcolor(tt(di)-1/8,pls,virtPT(di,:)'); set(gca,'YDir','Reverse'); hold on
% pcolor(tt(pdi(3)),pls,qval(pdi(3),:)')
line([tt(datdi(i))-1/8 tt(datdi(i))-1/8],[0 1000],'Color','r');
ylim([500 1000]);
caxis([290 315]);
% s.EdgeColor = 'none';
datetick;
title(datdi(i));



%%
% interpolate into vertical level.
figure(986); clf
plot(virtPT(ddi,:)',hypz(ddi,:)','.r-'); hold on
plot(virtPT(pdi,:)',hypz(pdi,:)','.b-'); hold on
% axis([290 320 0 5000]);
ylim([0 5000]);

title('{\theta}_{v} profile - 20th percentile dry hours');
xlabel('Temperature (K)');
ylabel('Height (m)');

for i = 1:length(ddi)
    fprintf('Day %d BLH = %.2f m\n',ddi(i),rin(ddi(i)));
%     fprintf('Day %d BLH = %.2f m\n',pdi(i),rin(pdi(i)));
end
% rin(pdi-14)

% hrain(:,phours)/3

%%
% interpolate into vertical level.
figure(987); clf
% plot(virtPT(tdi,:)',hypz(tdi,:)','.r-'); hold on
plot(virtPT(pdi,:)',hypz(pdi,:)','.b-'); hold on
% plot(virtPT(ddi,:)',hypz(ddi,:)','.k-'); hold on
% axis([290 320 0 5000]);
ylim([0 2000]);

title('{\theta}_{v} profile - 95th percentile warm hours');
xlabel('Temperature (K)');
ylabel('Height (m)');

for i = 1:length(pdi)
%     fprintf('Day %d BLH = %.2f m\n',tdi(i),rin(tdi(i)));
    fprintf('Day %d BLH = %.2f m\n',pdi(i),rin(pdi(i)));
end


%% LET's TRY VERTICAL INTERPOLATION 1m
Tprof = zeros(length(tdi),3001);
Pprof = zeros(length(pdi),3001);
Dprof = zeros(length(ddi),3001);

j = 1; xq = 0:3000;
% Temp
for i = 1:length(tdi)
    indat = virtPT(tdi(i),:);
%     indat = qval(tdi(i),:);
%     indat = ptemp(tdi(i),:);
    inlin = hypz(tdi(i),:);
    xxx = 1:length(indat);
    innan = xxx(~isnan(indat) & ~isnan(inlin));
    rmz = [];
    for k = 2:length(innan)
        if inlin(innan(k)) == 0
            rmz = [rmz k];
        end
    end
    innan(rmz) = [];
    intp_dat = interp1(inlin(innan),indat(innan),xq,'linear');
    if sum(isnan(intp_dat)) == 0
        Tprof(i,:) = Tprof(i,:) + intp_dat(1:3001);
    end
end

% Precip
for i = 1:length(pdi)
    indat = virtPT(pdi(i),:);
%     indat = qval(pdi(i),:);
%     indat = ptemp(pdi(i),:);
    inlin = hypz(pdi(i),:);
    xxx = 1:length(indat);
    innan = xxx(~isnan(indat) & ~isnan(inlin));
    rmz = [];
    for k = 2:length(innan)
        if inlin(innan(k)) == 0
            rmz = [rmz k];
        end
    end
    innan(rmz) = [];
    intp_dat = interp1(inlin(innan),indat(innan),xq,'linear');
    if sum(isnan(intp_dat)) == 0
        Pprof(i,:) = Pprof(i,:) + intp_dat(1:3001);
    end
end
pn = rin(pdi);
pn = ~isnan(pn);
Pprof = Pprof(pn,:);
sp = sum(Pprof(:,:),2); sp = (sp ~= 0);
Pprof = Pprof(sp,:);

% Dryness
for i = 1:length(ddi)
    indat = virtPT(ddi(i),:);
%     indat = qval(ddi(i),:);
%     indat = ptemp(ddi(i),:);
    inlin = hypz(ddi(i),:);
    xxx = 1:length(indat);
    innan = xxx(~isnan(indat) & ~isnan(inlin));
    rmz = [];
    for k = 2:length(innan)
        if inlin(innan(k)) == 0
            rmz = [rmz k];
        end
    end
    innan(rmz) = [];
    intp_dat = interp1(inlin(innan),indat(innan),xq,'linear');
    if sum(isnan(intp_dat)) == 0
        Dprof(i,:) = Dprof(i,:) + intp_dat(1:3001);
    end
end

%%
figure(131); clf
pf_m = [mean(Dprof); mean(Pprof); mean(Tprof)];
pf_s = [std(Dprof); std(Pprof); std(Tprof)];
hold on
pf_c = {'k','b','r'};
p = [];
for i = 1:3
    p1 = plot(pf_m(i,:),xq,pf_c{i},'linewi',1.2);
    p = [p p1];
    plot(pf_m(i,:)-pf_s(i,:),xq,pf_c{i},'linest','--');
    plot(pf_m(i,:)+pf_s(i,:),xq,pf_c{i},'linest','--');
end
title('Extreme condition {\theta}_{v} profiles - 87344');
legend(p,{'RH 10th (4)','Prcp 95th (13)','T2m 95th (11)'},'Location','northwest');


%%
imprint('~/Desktop/ext_profs_omited_37844.eps',5,8,0,300);

%% All averaged profile?
% 
fle = length(fl);
Aprof = nan(fle,3001); j = 1;
Dayprof = zeros(fle,3001); dj = 1;
nDayprof = zeros(fle,3001); ndj = 1;
for i = 1:fle
    indat = virtPT(i,:);
%     indat = qval(i,:);
%     indat = ptemp(i,:);
    inlin = hypz(i,:);
    xxx = 1:length(indat);
    innan = xxx(~isnan(indat) & ~isnan(inlin));
    rmz = [];
    for k = 2:length(innan)
        if inlin(innan(k)) == 0
            rmz = [rmz k];
        end
    end
    innan(rmz) = [];
    intp_dat = interp1(inlin(innan),indat(innan),xq,'linear');
    if sum(isnan(intp_dat)) == 0
%         Aprof(i,:) = Aprof(i,:) + intp_dat(1:3001);
        Aprof(i,:) = intp_dat(1:3001);
        j = j + 1;
        zt = str2double(fl{i}(15:16));
        if (zt>=15)&&(zt<=18) == 0
            Dayprof(dj,:) = Dayprof(dj,:) + intp_dat(1:3001);
            dj = dj + 1;
%         elseif (zt==00) 
        elseif (zt>=3)&&(zt<=6) == 0
            nDayprof(ndj,:) = nDayprof(ndj,:) + intp_dat(1:3001);
            ndj = ndj + 1;
        end
    end
end
Aprof = Aprof(1:j-1,:);
Dayprof = Dayprof(1:dj-1,:);
nDayprof = nDayprof(1:ndj-1,:);

%%
figure(14); clf
plot(mean(Aprof,'omitnan'),xq,'k'); hold on
plot(mean(Dayprof),xq,'r');
plot(mean(nDayprof),xq,'b');

%%
figure(151); clf; 
% plot(mean(Aprof,'omitnan'),xq,'k'); hold on
pf_m = [mean(Dprof); mean(Pprof); mean(Tprof); mean(Bprof)];
pf_s = [std(Dprof); std(Pprof); std(Tprof); std(Bprof)];
hold on
pf_c = {'k','b','r','c'};
p = [];
for i = 1:3
    p1 = plot(pf_m(i,:),xq,pf_c{i},'linewi',1.2);
    p = [p p1];
    plot(pf_m(i,:)-pf_s(i,:),xq,pf_c{i},'linest','--');
    plot(pf_m(i,:)+pf_s(i,:),xq,pf_c{i},'linest','--');
end
title('Extreme condition {\theta}_{v} profiles - M1');
legend(p,{'RH 5th (14)','Prcp 95th (8)','T2m 95th (16)'},'Location','northeast');

plot(mean(nDayprof,'omitnan'),xq,'g');
% plot(mean(nDayprof),xq,'b');
% xlim([0 18e-3]);

%%
imprint('~/Desktop/profs_ext_mean_PT.eps',5,8,0,300);

%%
rin95 = rin; rin95(isnan(rin95)) = [];
rin95 = prctile(rin95,99);
rind = 1:length(rin);
bdi = (rin>rin95); dump = 1:length(bdi); bdi = dump(bdi);
Bprof = zeros(length(bdi),3001);
% MAX heights
for i = 1:length(bdi)
    indat = virtPT(bdi(i),:);
%     indat = qval(bdi(i),:);
    inlin = hypz(bdi(i),:);
    xxx = 1:length(indat);
    innan = xxx(~isnan(indat) & ~isnan(inlin));
    rmz = [];
    for k = 2:length(innan)
        if inlin(innan(k)) == 0
            rmz = [rmz k];
        end
    end
    innan(rmz) = [];
    intp_dat = interp1(inlin(innan),indat(innan),xq,'linear');
    if sum(isnan(intp_dat)) == 0
        Bprof(i,:) = Bprof(i,:) + intp_dat(1:3001);
    end
end

figure(152); clf; hold on
plot(virtPT(bdi,:)',hypz(bdi,:)','.-'); hold on
ylim([0 3000]);

%% Development of heated boundary layer
i = 7;
datdi = tdi;
date = fl{datdi(i)}(7:16);
dn = datenum(date,'yyyymmddhh')-1/8;
di = dn-5:1:dn+1;
devt = nan(7,191);
devh = nan(7,191);
devq = nan(7,191);
devrin = nan(7,1);
ii = 1;
for k = di
    dwn = datestr(k,'yyyymmddhh');
    for l = 1:length(fl)
        if contains(fl{l},dwn)
            devh(ii,:) = hypz(l,:); 
            devq(ii,:) = qval(l,:); 
            devrin(ii) = rin(l);
            devt(ii,:) = virtPT(l,:); ii = ii + 1;
        end
    end
end
Vprof = zeros(7,5001);
xq2 = 0:5000;
for j = 1:7
    indat = devq(j,:);
    inlin = devh(j,:);
    xxx = 1:length(indat);
    innan = xxx(~isnan(indat) & ~isnan(inlin));
    rmz = [];
    for k = 2:length(innan)
        if inlin(innan(k)) == 0
            rmz = [rmz k];
        end
    end
    innan(rmz) = [];
    intp_dat = interp1(inlin(innan),indat(innan),xq2,'linear');
    if sum(isnan(intp_dat)) == 0
        Vprof(j,:) = Vprof(j,:) + intp_dat(1:5001);
    end
end
%%
figure(9183); clf; hold on
s = imagesc(di-6/8,xq2,Vprof'*1e3);
plot(di-6/8,devrin,'x','color',[1 1 1],'MarkerSize',10);
axis tight; ylim([0 4000]);
% colormap(cmocean('thermal')); caxis([298 321]); 
colormap(flipud(cmocean('tempo'))); caxis([0 14]); 
colorbar; title('VirtPT Develop (K)');
datetick('x','mmm-dd','keeplimits','keepticks');
xlabel('Date'); ylabel('Height (m)');

%%
imprint('~/Desktop/Dev_4000m_q.eps',6,8,0,300);

%% Development of heated boundary layer - 6-hourly
i = 7;
datdi = tdi;
date = fl{datdi(i)}(7:16);
dn = datenum(date,'yyyymmddhh')-1/8;
di = dn-5:1/4:dn+1;
devt = nan(25,191);
devh = nan(25,191);
devq = nan(25,191);
devrin = nan(25,1);
ii = 1;
for k = di
    dwn = datestr(k,'yyyymmddhh');
    for l = 1:length(fl)
        if contains(fl{l},dwn)
            devh(ii,:) = hypz(l,:); 
            devq(ii,:) = qval(l,:); 
            devrin(ii) = rin(l);
            devt(ii,:) = virtPT(l,:); 
        end
    end
    ii = ii + 1;
end
Vprof = zeros(25,5001);
xq2 = 0:5000;
for j = 1:25
    indat = devt(j,:);
    inlin = devh(j,:);
    xxx = 1:length(indat);
    innan = xxx(~isnan(indat) & ~isnan(inlin));
    rmz = [];
    for k = 2:length(innan)
        if inlin(innan(k)) == 0
            rmz = [rmz k];
        end
    end
    innan(rmz) = [];
    if ~isempty(innan)
    intp_dat = interp1(inlin(innan),indat(innan),xq2,'linear');
    if sum(isnan(intp_dat)) == 0
        Vprof(j,:) = Vprof(j,:) + intp_dat(1:5001);
    end
    end
end
%%
Vprof(Vprof==0)=NaN;
figure(9183); clf; hold on
s = imagesc(di(:)-6/8,xq2,Vprof(:,:)');
plot(di-6/8,devrin,'x','color',[1 1 1],'MarkerSize',10);
axis tight; ylim([0 4000]);
colormap(cmocean('thermal')); caxis([294 322]); 
% colormap(flipud(cmocean('tempo'))); caxis([0 14]); 
colorbar; title('VirtPT Develop (K)');
datetick('x','mmm-dd-hh','keeplimits','keepticks');
xlabel('Date'); ylabel('Height (m)');