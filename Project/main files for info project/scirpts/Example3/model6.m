clear;clc
i=1;
%=================input parameter=========================================
factor=1.8;
%story
n=2;
%number of column=span+1
m=1;
%step
step=.02;
%time for free viberation
nnn=0/step;
E=2e10+.1;
%fy=2.e8+.1   ; %8
%mass=1.5e3+.00000001;
mass=2e3+.00000001;
%stiffness_dimension of 
%stiff=.14;
damageparamc=0.7
%damageparamb=.999;
damageparamb=1
%==================clear folders===========================
if(exist('eigen')); rmdir('eigen','s');end;mkdir('eigen')
if(exist('data')); rmdir('data','s');end;mkdir('data')
if(exist('data1')); rmdir('data1','s');end;mkdir('data1')
if(exist('strain')); rmdir('strain','s');end;mkdir('strain')
C=[ 1 1 255;255 1 1;1 255 1;128 128 128;1 255 255;255 1 255;128 128 1;1 128 128;128 1 128]/255;
%====================making input for opensees==========================
 scol(1,1)=0.18;
 scol(2,1)=0.18;
 scol(3,1)=0.18;
 scol(4,1)=0.16;
 scol(5,1)=0.16;
 scol(6,1)=0.14;

 sbeam(1,1)=.15;
 sbeam(2,1)=.15;
 sbeam(3,1)=.15;
 sbeam(4,1)=.15;
 sbeam(5,1)=.15;
 sbeam(6,1)=.15;

 scol'
 sbeam'
 sbeam=sbeam*100;
%  scol(1,1)=(17452260/E*12)^.25;
%  scol(2,1)=(17452260/E*12)^.25;
%  scol(3,1)=(17452260/E*12)^.25;
%  scol(4,1)=(10895360/E*12)^.25;
%  scol(5,1)=(10895360/E*12)^.25;
%  scol(6,1)=(6386660/E*12)^.25;

%  sbeam(1:6,1)=(8416406.2/E*12)^.25;

  fyc=[1;2;2;2;2;2]*1.2e8+.1;
  fyb=[2;2;2;2;2;2]*1.2e8+.1;

fid=fopen('data1\m.txt','w');
fprintf(fid,'%d\t',m);
fclose(fid);

fid=fopen('data1\n.txt','w');
fprintf(fid,'%d\t',n);
fclose(fid);

fid=fopen('data\damagec.txt','w');
fprintf(fid,'%d\t',damageparamc);
fclose(fid);

fid=fopen('data\damageb.txt','w');
fprintf(fid,'%d\t',damageparamb);
fclose(fid);

fid=fopen('data\E.txt','w');
fprintf(fid,'%d\t',E);
fclose(fid);

fid=fopen('data\factor.txt','w');
fprintf(fid,'%d\t',factor);
fclose(fid);

fid=fopen('data\mass.txt','w');
fprintf(fid,'%d\t',mass);
fclose(fid);

fid=fopen('data\step.txt','w');
fprintf(fid,'%d\t',step);
fclose(fid);
fid=fopen('data1\step.txt','w');
fprintf(fid,'%d\t',step);
fclose(fid);
%====================load records and correct it=========================
load record\recacc.txt
load record\recdis.txt

recacc=[recacc;zeros(nnn,1)]*factor;
recdis=[recdis;zeros(nnn,1)+recdis(end)]*factor;
t=((0:size(recacc,1)-1)*step)';
fid=fopen('data\lasttry.txt','w');
fprintf(fid,'%d\t',(max(t))/step);
fclose(fid);
%====================making files for dimenstion of col and beam=========================
for k=1:n;
   clear name1 name2 name3 name4
   
   name1=sprintf('data\\coldim%g.txt',k);
   fid=fopen(name1,'w');
   fprintf(fid,'%d\t',scol(k,1));
   fclose(fid);
   
   name2=sprintf('data\\beamdim%g.txt',k);
   fid=fopen(name2,'w');
   fprintf(fid,'%d\t',sbeam(k,1));
   fclose(fid);
   
   name3=sprintf('data\\fyc%g.txt',k);
   fid=fopen(name3,'w');
   fprintf(fid,'%d\t',fyc(k,1));
   fclose(fid);
   
   name4=sprintf('data\\fyb%g.txt',k);
   fid=fopen(name4,'w');
   fprintf(fid,'%d\t',fyb(k,1));
   fclose(fid);   
end

clear name1 name2 name3 name4
%====================Run OPENSEES=========================
!opensees model1_2.tcl
%===================Load data including acc & disp from OPENSEES=========================
for k=1:m*(n+1);
    clear y
    clear x
    clear name1 name2 name3 name4
    
   name1=sprintf('data\\node%gdisp.out',k)    ; 
   x=load (name1);
   disp(:,k)=[0;x(:,2)];
     
   name2=sprintf('data\\node%gacc.out',k)   ;  
   load (name2);
   y=load (name2)/9.81;
   acc(:,k)=[0;y(:,2)+0*recacc(2:end,1)];
end
%===================Depict=========================
%===================Displacement of each story relative to base(node1)=========================
figure(10001)
for k=1:m:m*(n+1)
clear name1 name2 name3 name4
subplot(n+1,1,1+(k-1)/m)
plot(t,disp(:,k))
grid on
xlabel('time');title('response-rel')
name3=sprintf('disp(m)story%g',k);
ylabel(name3)
end
%===================absolute Accelation of each story=========================
figure(10002)
for k=1:m:m*(n+1)
clear name1 name2 name3 name4
subplot(n+1,1,1+(k-1)/m)
accr(:,k)=acc(:,k).*(1+0*randn(length(acc),1)/20);
plot(t,accr(:,k),'color',[0.5 0.5 1])
hold on
plot(t,acc(:,k))
grid on
ylim([-1,1])
xlabel('time');title('response-abs')
name3=sprintf('acc(g)story%g',k);
ylabel(name3)
end
%===================ACC and Disp of Record=========================
figure(10003)
subplot(2,1,1)
plot(t,recacc)
grid on
xlabel('time');ylabel('acc(g)record');title('record')
subplot(2,1,2)
plot(t,recdis)
grid on
xlabel('time');ylabel('disp(cm)record');title('record')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%===================Load file=time stress strain at top and bottom of each story(column) at outer point of the section=========================
for k=1:n;
    clear name name1 name2 name3
   name2=sprintf('strain\\stiffnessd%g.txt',k);stiffness1{k}=load (name2);
   name2=sprintf('strain\\stiffnessu%g.txt',k);stiffness6{k}=load (name2);
   name2=sprintf('strain\\stiffnessb%g.txt',k);stiffnessb{k}=load (name2);
   name2=sprintf('strain\\stiffnessp%g.txt',k);stiffnessp{k}=load (name2);   
end   
%===================Depict stress of each story(column) at top and bottom at outer point of the section==========================
% figure
% for k=1:n;
%     clear name3
% subplot(n,1,k)
% plot( ss1{k}(:,1),ss1{k}(:,2),'color','blue'); hold on
% plot( ss6{k}(:,1),ss6{k}(:,2),'color','red');
% grid on
% xlabel('time(sec)')
% ylabel('stress-N/m^2')
%     name3(1,1:13)=num2str('stress-story-');
%     name3(1,14)=num2str(k);
%     title(name3)
% end
%===================Depict stifness of each story(column) at top and bottom section=========================
figure(10004)
for k=1:n
subplot(n,1,k)
plot(stiffness1{k}(:,1),stiffness1{k}(:,5),'color','blue'); hold on
plot(stiffness6{k}(:,1),stiffness6{k}(:,5),'color','red'); hold on
grid on
title('stiffness-story1')
xlabel('time')
ylabel('stiffness-N/m^2')
    name3(1,1:16)=num2str('stiffness-story-');
    name3(1,17)=num2str(k);
    title(name3)
%legend ('Lower Hinge','Upper Hinge')
end

figure(10005)
for k=1:n
subplot(n,1,k)
plot(stiffnessb{k}(:,1),stiffnessb{k}(:,5),'color','blue'); hold on
plot(stiffnessp{k}(:,1),stiffnessp{k}(:,5),'color','red'); hold on
grid on
title('stiffness-story1')
xlabel('time')
ylabel('stiffness-N/m^2')
    name3(1,1:16)=num2str('stiffness-story-');
    name3(1,17)=num2str(k);
    title(name3)
%legend ('Lower Hinge','Upper Hinge')
end



%===================Eigen========================
for k=1:n;
    clear name name1 name2 name3
   name1(1,1:19)=num2str('eigen\eigenvector1-');
   name1(1,20)=num2str(k);
   name1(1,21:24)=num2str('.txt');  
   name2(1,1:19)=num2str('eigen\eigenvector2-');
   name2(1,20)=num2str(k);
   name2(1,21:24)=num2str('.txt');  
fid=fopen(name1,'r');
mod = (fscanf(fid, '%f'))';
mode(:,k)=(mod(1:n)./mod(1))';
fclose(fid);
fid=fopen(name2,'r');
mod = (fscanf(fid, '%f'))';
modeelementry(:,k)=(mod(1:n)./mod(1))';
fclose(fid);
end
% %%%%%%%%%%%%%%%%%%%-output of matlab to EXCEL-%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename = 'data\datafile.xlsx';
% clear name
% clear name1
% clear name2
% clear name3
% %==========Disp================
% name(1,1:9)=num2str('Time(sec)');
% name(2,1:17)=num2str('relDisp(cm)story0');
% for k=1:n 
%  name(k+2,1:16)=num2str('relDisp(cm)story');
%  name(k+2,17)=num2str(k);
% end
% name(n+2+1,1)=num2str('#');
% name(n+3+1,1:9)=num2str('Time(sec)');
% name(n+3+2,1:17)=num2str('absDisp(cm)story0');
% for k=1:n 
%  name(n+5+k,1:16)=num2str('absDisp(cm)story');
%  name(n+5+k,17)=num2str(k);
% end
% 
% for k=1:size(name,1)
% title(k)={name(k,:)};
% end
% 
% xlswrite(filename,title,'disp','A1');
% clear name
% name(1,1)=num2str(char(64+1));
% name(1,2)=num2str(2);
% xlswrite(filename,t,'disp',name);
% for k=1:n+1
%     name(1,1)=num2str(char(64+1+k));
%     name(1,2)=num2str(2)   ;
%     xlswrite(filename,disp(:,m*(k-1)+1),'disp',name)
% end
% clear name
% name(1,1)=num2str(char(64+n+4));
% name(1,2)=num2str(2);
% xlswrite(filename,t,'disp',name);
% for k=1:n+1
%     name(1,1)=num2str(char(64+4+n+k));
%     name(1,2)=num2str(2)   ;
%     xlswrite(filename,disp(:,m*(k-1)+1)+recdis/100,'disp',name)
% end
% %==========ACC================
% clear name
% clear name1
% clear name2
% clear name3
% name(1,1:9)=num2str('Time(sec)');
% name(2,1:17)=num2str('relAccel(g)story0');
% for k=1:n 
%  name(k+2,1:16)=num2str('relAccel(g)story');
%  name(k+2,17)=num2str(k);
% end
% name(n+2+1,1)=num2str('#');
% name(n+3+1,1:9)=num2str('Time(sec)');
% name(n+3+2,1:17)=num2str('absAccel(g)story0');
% for k=1:n 
%  name(n+5+k,1:16)=num2str('absAccel(g)story');
%  name(n+5+k,17)=num2str(k);
% end
% 
% for k=1:size(name,1)
% title(k)={name(k,:)};
% end
% 
% xlswrite(filename,title,'Accl','A1');
% clear name
% name(1,1)=num2str(char(64+1));
% name(1,2)=num2str(2);
% xlswrite(filename,t,'Accl',name);
% for k=1:n+1
%     name(1,1)=num2str(char(64+1+k));
%     name(1,2)=num2str(2)   ;
%     xlswrite(filename,accr(:,m*(k-1)+1)+recacc,'Accl',name)
% end
% 
% clear name
% name(1,1)=num2str(char(64+n+4));
% name(1,2)=num2str(2);
% xlswrite(filename,t,'Accl',name);
% 
% for k=1:n+1
%     name(1,1)=num2str(char(64+4+n+k));
%     name(1,2)=num2str(2)   ;
%     xlswrite(filename,accr(:,m*(k-1)+1),'Accl',name)
% end
% %==========Mode================
% % clear mode
% % mode=mode(1);
% % for k=2:n
% % mode=[mode mode(i)];
% % end
% xlswrite('eigen\mode',mode)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear name name1 name2 name3
fid=fopen('data\modeTIME.txt','r');
period = (fscanf(fid, '%f'))';
fclose(fid);
fid=fopen('data\modeTIMEelementry.txt','r');
periodelementry = (fscanf(fid, '%f'))';
fclose(fid);

for k=1:m:m*(n+1)
    if k<10
   name1(1,1:9)=num2str('data1\acc');
   name1(1,10)=num2str(k);
   name1(1,11:14)=num2str('.txt');  
   elseif k<100
   name1(1,1:9)=num2str('data1\acc');
   name1(1,10:11)=num2str(k);
   name1(1,12:15)=num2str('.txt'); 
    end
fid=fopen(name1,'w');
fprintf(fid,'%d\t',accr(end/2:end,k));
fclose(fid);
end


fid=fopen('data1\time.txt','w');
fprintf(fid,'%d\t',t(end/2:end));
fclose(fid);



[1./periodelementry;modeelementry]
[1./period; mode]
% load data\Damage1.out;
% 
% figure
% plot(Damage1(:,2),'linewidth',1.5,'color','blue'); hold on
% grid on
% %title('Accumulated Damage')
% xlabel('cycle')
% ylabel('Damage')
 %close 1001
 %close 2001
 %close 3001
%close all