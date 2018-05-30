clc;clear

% % % % net = timedelaynet(0:5,1);  %input is two cells 1*n 1*n
% % % % [Xs,Xi,Ai,Ts] = preparets(net,X,T);
% % % % net = train(net,Xs,Ts,Xi,Ai);
% % % 
% % % % net = narnet(1:2,10);     %input is one cell 1*n
% % % % [Xs,Xi,Ai,Ts] = preparets(net,{},{},T);
% % % % net = train(net,Xs,Ts,Xi,Ai);
% % % 
% % % % net = narxnet(1:5,1:5,1);  %input is two cells 2*n 1*n
% % % % [Xs,Xi,Ai,Ts] = preparets(net,X,{},T);
% % % % net = train(net,Xs,Ts,Xi,Ai);


StartPointforDelay=0
LengthOfDelay=5
NumberOfNeurons=1
load('dataforANN\0.25g\MAtlab.mat')
%load('dataforANN\1.00g\MAtlab.mat')


%choose traon 0 or adapt 1
SWITCH1=0
%chose type of netwrok
SWITCH2=3   % 1 for timedelaynet
            % 2 for narnet
            % 3 for narxnet
acc0=(MakingData1(acc0,0.01/.001))';
acc1=(MakingData1(acc1,0.01/.001))';
%[X,T,Xi] = DATANN2(acc0,acc1,LengthOfDelay, 0) ;
%[X,T,Xi] = DATANN1(acc0,acc1,LengthOfDelay, 0) ;


X=acc0;
T=acc1;
X=con2seq(X);
T=con2seq(T);

if SWITCH2==1
net = timedelaynet(StartPointforDelay:LengthOfDelay,NumberOfNeurons);
[Xs,Xi,Ai,Ts] = preparets(net,X,T);
net = train(net,Xs(:,1:end/5),Ts(:,1:end/5),Xi,Ai);
elseif SWITCH2==2
net = narnet(StartPointforDelay+1:LengthOfDelay,NumberOfNeurons);
[Xs,Xi,Ai,Ts] = preparets(net,{},{},T);
net = train(net,Xs(:,1:end/5),Ts(:,1:end/5),Xi,Ai);
elseif SWITCH2==3
net = narxnet(StartPointforDelay:LengthOfDelay,StartPointforDelay+1:LengthOfDelay,NumberOfNeurons);
[Xs,Xi,Ai,Ts] = preparets(net,X,{},T);
net = train(net,Xs(:,1:end/5),Ts(:,1:end/5),Xi,Ai);
%net = adapt(net,Xs(:,end/5:end),Ts(:,end/5:end),Xi,Ai);
end


view(net)
[Y,Xf,Af] = net(Xs,Xi,{});
figure
subplot(2,1,1)
plot(cat(2,Y{:}),'r');hold on
plot(cat(2,T{:}),'b')
plot(length(T)/5*[1 1],max(abs(acc1))*[-1.2 1.2],'k')
ylim(max(abs(acc1))*[-1.2 1.2])
legend('Predicted','Actual')
subplot(2,1,2)
plot(cat(2,Y{:})-cat(2,Ts{:}),'k');hold on
plot(length(T)/5*[1 1],max(abs(acc1))*[-1.2 1.2],'k')
ylim(max(abs(acc1))*[-1.2 1.2])
legend('Error')









function [X,T,Xi] = DATANN1(ExternalInput,Feedback,Span, Delay)                               
%Delay=0  ;                                                %The gap between input and output, default Delay=0, it means X9n) is effective in y(n)
%Span=1;                                                  % How much data you wanna use as history, 
                                                         % For example 1 means, just current data(0) and one data before
                                                         % If yoiu want use Feedback as input, it automatically will be shifted one step, cause you can use the same Feedback step as input and output                                                                                       
ExternalInput = con2seq([ExternalInput']');
Feedback=con2seq(Feedback);
%if Span(1)==0 && length(Span)==1;    
for i=1:Span
    Xi(i) = ExternalInput(i);
end
X = ExternalInput(Span+1:(end-Delay));
T = Feedback(Span+1+Delay:end);
XXX=(cell2mat(X))';
YYY=cell2mat(T)';
sprintf('The following shows data during the time, vertical axes shows passing time, first column is x, second column is y(-1) and nex column is y')
[XXX,YYY]
end

function [X,T,Xi] = DATANN2(ExternalInput,Feedback,Span, Delay)                               
%Delay=0  ;                                                %The gap between input and output, default Delay=0, it means X9n) is effective in y(n)
%Span=1;                                                  % How much data you wanna use as history, 
                                                         % For example 1 means, just current data(0) and one data before
                                                         % If yoiu want use Feedback as input, it automatically will be shifted one step, cause you can use the same Feedback step as input and output                                                                                       
ExternalInput = con2seq([ExternalInput',[0 Feedback(1:end-1)]']');
Feedback=con2seq(Feedback);
%if Span(1)==0 && length(Span)==1;    
for i=1:Span
    Xi(i) = ExternalInput(i);
end
X = ExternalInput(Span+1:(end-Delay));
T = Feedback(Span+1+Delay:end);
XXX=(cell2mat(X))';
YYY=cell2mat(T)';
sprintf('The following shows data during the time, vertical axes shows passing time, first column is x, second column is y(-1) and nex column is y')
[XXX,YYY]
end


function Y = MakingData1(X,Alpha)
% 1 This function wipe out the useluess data based on the time step   
% 2 This function make the data as a column
% Alpha is the ratio of original to the required time step. for example
% Alpha=.02/.001=20
Beta=ceil(length(X)/Alpha)
X(Beta*Alpha)=0
X=reshape(X,Alpha,[]);
Y=X(1,:)'
end