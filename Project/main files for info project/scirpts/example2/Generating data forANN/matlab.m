clc;clear all
% record hamishe az sefr shoru mishavad
% repsonse hamishe aval az delta t shoru mishavad
if(exist('data')); rmdir('data','s');end;mkdir('data')
factor=1
fid=fopen('data\factor.txt','w');
fprintf(fid,'%d\t',factor);
fclose(fid);
!opensees model.tcl
acc0= load ('RSN143TABAS.AT2(dt=0.001).txt')*factor;

   x=load ('data\node3disp.out');
   disp1=[0;x(:,2)];
   t=[0;x(:,1)];
   acc0=acc0(1:length(t),1);
   x=load ('data\node3acce.out')/9.81;
   acc1=[0;x(:,2)]+acc0;
   x=load ('data\stiffness11.out');
   stiff11=[0;x(:,5)];
   x=load ('data\stiffness19.out');
   stiff19=[0;x(:,5)];
   


figure
subplot(4,1,1);
plot(t,acc0,'b');hold on
title ('GM. Record')
xlabel('Time, Sec')
ylabel('Acc, g')

subplot(4,1,2);
plot(t,disp1,'b'); hold on
title ('Response to EQ.')
xlabel('Time, Sec')
ylabel('Disp, cm')

subplot(4,1,3);
plot(t,acc1,'b'); hold on
plot(t,acc0,'r');
title ('Response to EQ.')
xlabel('Time, Sec')
ylabel('Acc, g')


subplot(4,1,4);
plot(t,stiff11,'r');hold on
plot(t,stiff19,'b');
title('stiffness')
xlabel('time')
ylabel('stiffness-N/m^2')







