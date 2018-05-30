clc;clear
%%
%Genreating Data
ExternalInput=rand(1,100);
Feedback(1:2)=0;
for i=3:length(ExternalInput)
Feedback(i)=2*ExternalInput(i)+4*ExternalInput(i-1)+1*Feedback(i-1);
end
%%
END=round(length(ExternalInput)*0.5)                     %value for keeping some data for test
Delay=0 ;                                                %The gap between input and output, default Delay=0, it means X9n) is effective in y(n)
Span=2;                                                  % How much data you wanna use as history, 
                                                         % For example 1 means, just current data(0) and one data before
                                                         % If yoiu want use Feedback as input, it automatically will be shifted one step, cause you can use the same Feedback step as input and output
                                                         
%%                                                         
%This is function for making the data as the way we want                                                         
[X,T,Xi] = DATANN2(ExternalInput,Feedback,Span, Delay);
%%
% Design one linear layer with one neuron so we have b1 and w1 to wn which
% n is the number of inputs
net = newlind(X(1:END),T(1:END),Xi);
view(net)
Y = net(X,Xi);
sprintf('The following shows weights')
sprintf('x0 y0 x(-1) y(-1) ...')
net.iw{1,1}
sprintf('The following shows biases')
net.b{1,1}
%%
%%figures
figure
plot(cell2mat(Y),'.');hold on
plot(cell2mat(T),'LineWidth',1)
plot(cell2mat(T(1:END)),'r','LineWidth',1);hold on
xlabel('Time');
ylabel('Value');
title('Output and Target Signals');
legend('Output','Target Used in Trainign','Target not Used in Trainign');
figure
E = (cell2mat(T)-cell2mat(Y))./cell2mat(T);
plot(E,'r')
hold off
xlabel('Time');
ylabel('Error %');
title('Error Signal');
%%
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
