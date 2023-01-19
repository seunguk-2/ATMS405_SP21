figure(19); clf; hold on
i = 13;
datdi = pdi;
di = (datdi(i)-31):(datdi(i)+5);
pdat = rin(di);
tdat = tt(di);
plot(tdat,pdat);
scatter(tt(datdi(i)),rin(datdi(i)),'x');

% plot(tt,rin)
% yyaxis right
% plot(tt,qval(:,1))
% plot(tt,virtT(:,1)./(1+0.61*qval(:,1)));

datetick;

%%
figure(56); clf; hold on
j = 6;
datdi = ddi;
for i = (datdi(j)-5):(datdi(j)+1)
    ii = i - datdi(j)+6;
    liw = 1; if (i==datdi(j)); liw = 2; end
    plot(virtPT(i,:)',hypz(i,:)','.-','color',[0.5+0.05*ii 0.9-0.1*ii 0.05*ii],'linewi',liw);
end
ylim([0 3000]);
legend({'D-5','D-4','D-3','D-2','D-1','D','D+1'},'Location','northwest')

%% Hourly changes
figure(56); clf; hold on
j = 10;
datdi = ddi;
date = fl{datdi(j)+7}(7:16);
dn = datenum(date,'yyyymmddhh'); lg = {};
ii = 1;
for i = -12:4:12
    dwn = datestr(dn+(i-8)/8,'yyyymmddhh');
    dwnt = datestr(dn+(i-8)/8-1/8,'ddhh');
    for k = 1:length(fl)
        if contains(fl{k},dwn)
            liw = 1; if (i==8); liw = 1; end
%             subplot(1,3,1)
%             plot(virtPT(k,:)',hypz(k,:)','.-','linewi',liw,...
%                 'color',[0.3+0.1*ii 0.8-0.08*ii 0 ]); hold on; ylim([0 500]);
            subplot(1,3,2)
            plot(qval(k,:)',hypz(k,:)','.-','linewi',liw,...
                'color',[0.3+0.1*ii 0.8-0.08*ii 0 ]); hold on; ylim([0 500]);
%             subplot(1,3,3)
%             plot(ptemp(k,:)',hypz(k,:)','.-','linewi',liw,...
%                 'color',[0.3+0.1*ii 0.8-0.08*ii 0 ]); hold on; ylim([0 3000]);
            lg = [lg dwnt]; ii = ii + 1;
%             pause(1);
        end
    end     
end
% subplot(1,3,1);  legend(lg,'Location','northwest');
% title('Virtual Potential Temperature');
subplot(1,3,2);  legend(lg,'Location','northeast');
title('Specific Humidity'); xlim([2 12]*1e-3);
% subplot(1,3,3);  %legend(lg,'Location','northeast');
% title('Potential Temperature');
% title(date)

%% Daily changes
figure(57); clf; hold on

j = 4;
datdi = tdi;
date = fl{datdi(j)}(7:16);
dn = datenum(date,'yyyymmddhh'); lg = {};
for i = 0:4
    dwn = datestr(dn+(i-4),'yyyymmddhh');
    dwnt = datestr(dn+(i-4)-1/8,'mmm-dd');
    for k = 1:length(fl)
        if contains(fl{k},dwn)
            liw = 1; if (i==4); liw = 2; end
            subplot(1,3,1)
            plot(virtPT(k,:)',hypz(k,:)','.-','linewi',liw,...
                'color',[0.6+0.08*i 1-0.1*i 0.06*i]); hold on
            subplot(1,3,2)
            plot(qval(k,:)',hypz(k,:)','.-','linewi',liw,...
                'color',[0.6+0.08*i 1-0.1*i 0.06*i]); hold on
            subplot(1,3,3)
            plot(ptemp(k,:)',hypz(k,:)','.-','linewi',liw,...
                'color',[0.6+0.08*i 1-0.1*i 0.06*i]); hold on
            lg = [lg dwnt];
        end
    end     
end
subplot(1,3,1); ylim([0 3000])
legend(lg,'Location','northwest');
title('Virtual Potential Temperature');
subplot(1,3,2); ylim([0 3000])
% legend(lg,'Location','northeast');
title('Specific Humidity');
subplot(1,3,3); ylim([0 3000])
% legend(lg,'Location','northeast');
title('Potential Temperature');
% title(date)

%%
% imprint('~/Desktop/Dev_temp_12h_112021.eps',10,6,0,300);
imprint('~/Desktop/Dev_q_12h_112109_1000m.eps',8,5,0,300);

%% count hours
timestr = {'03Z','06Z','09Z','12Z','15Z','18Z','21Z','00Z','03Z'};
ext_hr_cnt = zeros(3,9);
for j = 1:3
    if j==1; datdi = ddi;
    elseif j==2; datdi = pdi;
    else; datdi = tdi;
    end
    
    for i = 1:length(datdi)
        zt = fl{datdi(i)}(end-6:end-4);
%         zt = datdi{i}(end-2:end);
        ext_hr_cnt(j,:) = ext_hr_cnt(j,:) + strcmp(timestr,zt);
    end
end

figure(58); clf
bar(ext_hr_cnt'); ylim([0 10]); xlim([3 8]);
xticklabels({num2str((0:3:24)','%02d')});
ylabel('Count'); xlabel('Local Time');
legend({'Dry','Prcp','Temp'})
title('Extreme event count');

%%
imprint('~/Desktop/Ext_count_case_sh.eps',5,8,0,300);
%%
lh = LH; sh = SH;
lh(abs(LH)>1200)=NaN; sh(abs(SH)>1200)=NaN;
%%
% Rsum = fdat;

figure(504); clf; hold on
tx = 0:1/12:48-1/12;
rmsm = nan(3,288);
for k = 1:3
    if k == 1; datdi = tdi; pc = [1 0.8 0.8];
    elseif k==2; datdi = ddi; pc = [0.8 1 0.8];
    else; datdi = pdi; pc = [0.8 0.8 1];
    end
    
    rsm = nan(length(datdi),288);
    for j = 1:length(datdi)
        date = fl{datdi(j)}(7:14);
        %     dn = datenum(date,'yyyymmddhh'); lg = {};
        for i = 1:length(flist)
            if contains(flist{i},date)
                tid = ((i-1)*288+1):((i-1)*288+288);
                rm = mean(Rswin(:,tid),1,'omitnan');
                plot(tx,[rm'; rm'],'color',pc);
%                 plot(Rsum(:,tid)','color',pc);
                rsm(j,:) = rm;
            end
        end
    end
    rmsm(k,:) = mean(rsm,1,'omitnan');
%     plot(tx,rmsm(k,:),'color',floor(pc));
end
for j = 1:5
    pd = mean(reshape(Rswin(j,:),1,288,[]),3,'omitnan');
    plot(tx,[pd'; pd'],...
        'color',[0.85 0.85 0.85],'linewi',1.5);
end
p = [];
for k = 1:3
    pc = zeros(1,3); pc(k) = 1;
    p1 = plot(tx,[rmsm(k,:) rmsm(k,:)],'color',pc,'linewi',1.2);
    p = [p p1];
end

pd = mean(mean(reshape(Rswin(:,:),5,288,[]),3,'omitnan'),'omitnan');
p1 = plot(tx,[pd'; pd'],'k','linewi',1.5);
p = [p p1];

xticks(0:3:48);
xticklabels(num2str((-3:3:45)','%02d'));
xlabel('Local Time (hr)'); ylabel('Radiation (W/m2)');
xlim([3 27]); ylim([-100 1300]);grid on;
legend(p,{'Hot','Dry','Prcp','Avg'})
title('Incoming shortwave radiation');

%%
imprint('~/Desktop/Rad_sw.eps',8,5,0,300);

%%
figure(505); clf; hold on
plot(mean(reshape(Rswin,5,288,[]),3,'omitnan')')

%%
figure(506); clf; hold on
tx = 0:1/12:48-1/12;
rmsm = nan(3,288);
for k = 1:3
    if k == 1; datdi = tdi; pc = [1 0.8 0.8];
    elseif k==2; datdi = ddi; pc = [0.8 1 0.8];
    else; datdi = pdi; pc = [0.8 0.8 1];
    end
    
    rsm = nan(length(datdi),288);
    for j = 1:length(datdi)
        date = fl{datdi(j)}(7:14);
        %     dn = datenum(date,'yyyymmddhh'); lg = {};
        for i = 1:length(flist)
            if contains(flist{i},date)
                tid = ((i-1)*288+1):((i-1)*288+288);
                rm = mean(lh(1,tid),1,'omitnan');
                plot(tx,[rm'; rm'],'color',pc);
%                 plot(Rsum(:,tid)','color',pc);
                rsm(j,:) = rm;
            end
        end
    end
    rmsm(k,:) = mean(rsm,1,'omitnan');
%     plot(tx,rmsm(k,:),'color',floor(pc));
end
for j = 5:5
    pd = mean(reshape(lh(1,:),1,288,[]),3,'omitnan');
    plot(tx,[pd'; pd'],...
        'color',[0.85 0.85 0.85],'linewi',1.5);
end
p = [];
for k = 1:3
    pc = zeros(1,3); pc(k) = 1;
    p1 = plot(tx,[rmsm(k,:) rmsm(k,:)],'color',pc,'linewi',1.2);
    p = [p p1];
end

pd = (mean(reshape(lh(1,:),1,288,[]),3,'omitnan'));
p1 = plot(tx,[pd'; pd'],'k','linewi',1.5);
p = [p p1];

xticks(0:3:48);
xticklabels(num2str((-3:3:45)','%02d'));
xlabel('Local Time (hr)'); ylabel('Radiation (W/m2)');
xlim([3 27]); ylim([-50 500]);grid on;
legend(p,{'Hot','Dry','Prcp','Avg'})
title('Latent Heat Flux (s14)');
%%
imprint('~/Desktop/SH_s14.eps',8,5,0,300);