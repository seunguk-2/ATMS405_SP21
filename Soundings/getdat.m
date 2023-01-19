blh = zeros(8,2,3);
% blh x: 3-hourly / y: 1-mean, 2-std / z: location
% (1-87344/2-Villa/3-87244)

for fi = 1:3

fl = importdata(['~/Downloads/Soundings/csv/list' num2str(fi) '.txt']);
ll = length(fl);

pls = 1000:-5:50;
temp = nan(ll,length(pls));
dept= nan(ll,length(pls));
rh = nan(ll,length(pls));
u = nan(ll,length(pls));
v = nan(ll,length(pls));
tt = nan(ll,1);
base = nan(ll,6);

for li = 1:ll
    fn = fl{li};
    dat = importdata(['~/Downloads/Soundings/csv/' fn]);
    dat = dat.data;
    d_p = dat(:,2);
    [~,idat,imat] = intersect(d_p,pls);
    temp(li,imat) = dat(idat,3); base(li,2) = dat(1,3);
    dept(li,imat) = dat(idat,4); base(li,3) = dat(1,4);
    rh(li,imat) = dat(idat,5); base(li,4) = dat(1,5);
    u(li,imat) = dat(idat,6); base(li,5) = dat(1,6);
    v(li,imat) = dat(idat,7); base(li,6) = dat(1,7);
    base(li,1) = d_p(1);
    if li == 202 % data over 250hPa seems to have a problem...
        temp(li,151:end) = NaN;
        dept(li,151:end) = NaN;
        rh(li,151:end) = NaN;
        u(li,151:end) = NaN;
        v(li,151:end) = NaN;
    end
    
    tk = fn(7:end-5);
    tt(li) = datenum([tk(1:4) '-' tk(5:6) '-' tk(7:8) ' ' tk(9:10) ':00:00']);
end

%
temp(temp==999) = NaN;
dept(dept==999) = NaN;
rh(rh==999) = NaN;
u(u==9999) = NaN;
v(v==9999) = NaN;
base(base==999) = NaN;
base(base==9999) = NaN;

% %%
% figure(1)
% [xt,yt] = meshgrid(tt,pls);
% % plot(tt,temp)
% % s = pcolor(temp');
% s = pcolor(tt,pls,rchn'); set(gca,'YDir','Reverse')
% s.EdgeColor = 'none';

%
esat = nan(ll,length(pls));
eprs = nan(ll,length(pls));
qval = nan(ll,length(pls));
virtT = nan(ll,length(pls));
virtPT = nan(ll,length(pls));
hypz = nan(ll,length(pls));
rchn = nan(ll,length(pls));
rin = nan(ll,1);
for i = 1:ll
    trv = ~isnan(temp(i,:));
    tokt = [base(i,2) temp(i,trv)];
    tokll = 1:length(tokt);
    esat(i,tokll) = es(tokt);
    tokr = [base(i,4) rh(i,trv)];
    eprs(i,tokll) = tokr.*esat(i,tokll)/100;
    tokp = [base(i,1) pls(trv)];
    toklp = 1:length(tokp);
    qval(i,1:length(tokp)) = q(eprs(i,tokll),tokp);
    virtT(i,tokll) = vtem(tokt,qval(i,toklp));
    virtPT(i,tokll) = thev(virtT(i,tokll),tokp);
    hypz(i,tokll) = hz(virtT(i,tokll),tokp);
    toku = [base(i,5) u(i,trv)];
    tokv = [base(i,6) v(i,trv)];
    rchn(i,tokll) = Ri(virtPT(i,tokll),hypz(i,tokll),toku,tokv);
end

rchn(rchn<-100) = NaN;
rchn(rchn>100) = NaN;

for i = 1:ll
    rin(i) = getri(rchn(i,:),hypz(i,:),0.25);
    fprintf('At time at #%d BLH = %.2f\n',i,rin(i));
end

arin = zeros(1,8);
srin = zeros(1,8);
for i = 1:8
    tmsk = tt-floor(tt);
    tmsk = (tmsk==(i-1)*0.125);
    arin(i) = nanmean(rin(tmsk));
    srin(i) = nanstd(rin(tmsk));
end

blh(:,1,fi) = arin;
blh(:,2,fi) = srin;

end

%%
figure(110);clf; hold on
% plot(3:3:24,arin([3:8 1:2]));
xxx = 0:3:21;
fg = fill([xxx, fliplr(xxx)],[arin+srin fliplr(arin-srin)],'r');
set(fg,'FaceAlpha',0.3);
% fill(0:3:21,[arin+srin arin-srin],'r');
plot(xxx,arin)
axis tight
% plot(arin+srin);
% plot(arin-srin);

%%
cl = {'r','g','b'};
loc = {'Cordoba Aero (490m)','M1 Cordoba (1139m)','Villa De Maria (341m)'};
fgs = [];
figure(111); clf; hold on
for i = 1:3
    xxx = 0:3:36;
    ys = [blh(:,1,i)' blh(1:5,1,i)']; ind = ~isnan(ys);
    ys2 = [blh(:,2,i)' blh(1:5,2,i)'];
    ys = ys(ind); ys2 = ys2(ind);
    finx = [xxx(ind) fliplr(xxx(ind))];
    finy = [ys+ys2 fliplr(ys-ys2)];
    fg = fill(finx,finy,cl{i}); set(fg,'FaceAlpha',0.25,'EdgeColor','none');
    pg = plot(xxx(ind),ys,['o-' cl{i}],'linewi',2);
    fgs = [fgs pg];
end
axis([3 27 0 3000]); grid on
xticks(3:6:36);
xticklabels({'00','06','12','18','24'});
legend(fgs,loc);

%% function / function handles
es = @(T) 611*exp(17.2*T./(273.3+T));
q = @(e,p) 0.622*e./(p*100-(1-0.622)*e);
vtem = @(T,q) (T+273.15).*(1+0.61*q);
thev = @(Tv,p) Tv.*(1e3./p).^(287/1005);
hz = @(Tv,p) 287*Tv/9.81.*log(max(p)./p);
Ri = @(thev,hz,u,v) 9.81/thev(1).*(thev-thev(1)).*(hz-hz(1))...
    ./((u-u(1)).^2+(v-v(1)).^2);

function RI = getri(ri,zz,ric)
k = 1;
while true
    if k > length(ri)/2
        RI = NaN; break;
    end
    rk1 = (ric - ri(k));
    rk2 = (ri(k+1) - ric);
    if rk1*rk2 > 0
        RI = zz(k)+(zz(k+1)-zz(k))*(rk1)/(rk2+rk1);
        break;
    end
    k = k + 1;
end
end

%% NOTES for some ideas
% So, how about comparing rainy days vs non-rainy days? Further, comapring
% extreme precipitation case. What makes the vertical structure change in
% rainy day? Is this affected by buoyancy change (temperature change) or
% mechanical forcing changes?
