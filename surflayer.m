figure(157); clf; 
hold on
pf_c = {'k','b','r','c'};
p = [];
dtdzp = [51 38 55];
for i = 1:3
    p1 = plot(pf_m(i,:)-pf_m(i,1),xq,pf_c{i},'linewi',1.2);
    scatter(pf_m(i,dtdzp(i))-pf_m(i,1),dtdzp(i),'mo');
    p = [p p1];
end

title('Surface Layer {\theta}_{v} profiles - M1');
legend(p,{'RH 5th (14)','Prcp 95th (8)','T2m 95th (16)'},'Location','northeast');
ylim([0 100]);
md = mean(Dayprof,'omitnan')-mean(Dayprof(:,1));
plot(md,xq,'g');
scatter(md(1,44)-md(1,1),44,'mo');

%%
dtdz = pf_m(:,2:100)-pf_m(:,1:99);
for i = 1:99
    for j = 1:3
        if dtdz(j,i) > -0.01
            fprintf('j = %d, i = %d\n',j,i);
        end
    end
end
% 2 - 38 / 1 - 51 / 3 - 55
% prcp - 38 / dry - 51 / hot - 55 / avg - 44
figure(158)
plot(dtdz')

%%
imprint('~/Desktop/surf_virtPT.eps',4,3,0,300);