%dadeha az newfolder call shavad
clc
clear
n=3;
%tul=5;
%tul=10;
tedadedade=5;
tul=20
C=[ 1 1 255;255 1 1;1 255 1;128 128 128;1 255 255;255 1 255;128 128 1;1 128 128;128 1 128]/255;

mohsen=0

for type=6:9;
clear input2 input3 input4 
clear output2 output3 output4 

for k=1:(n+1);
    clear y
    clear x
    clear name1 name2
   
   name2(1,1:7)=num2str('3story\');   
   name2(1,8)=num2str(type);
   name2(1,9:12)=num2str('\acc');
   name2(1,13)=num2str(k);
   name2(1,14:17)=num2str('.txt');
   load (name2);
   [k,name2]
end

for i=1:10000
   input2(:,i)=[acc3(i:i+tedadedade-1)';acc4(i:i+tedadedade-1)';acc2(i:i+tedadedade-2)'];
   input3(:,i)=[acc4(i:i+tedadedade-1)';acc2(i:i+tedadedade-1)';acc3(i:i+tedadedade-2)'];
   input4(:,i)=[acc2(i:i+tedadedade-1)';acc3(i:i+tedadedade-1)';acc4(i:i+tedadedade-2)'];
   
   output2(:,i)=acc2(i+tedadedade-1); 
   output3(:,i)=acc3(i+tedadedade-1);
   output4(:,i)=acc4(i+tedadedade-1);
    
end


        figure(100+type+mohsen)
        subplot(3,1,1)
        plot(output2(:,1+tul:end))
        hold on
        ylim([-1.5 1.5])      
        subplot(3,1,2)
        plot(output3(:,1+tul:end))
        hold on
        ylim([-1.5 1.5])        
        subplot(3,1,3)
        plot(output4(:,1+tul:end))
        hold on
        ylim([-1.5 1.5])
        clear network1_outputs2 outputs2 network1_outputs3 outputs3 network1_outputs4 outputs4 
for i=1:size(input2,2)-tul
        clear net2 net3 net4 %network1_outputs2 outputs2 network1_outputs3 outputs3 network1_outputs4 outputs4
net2=newrbe(input2(:,i:i+tul-1),output2(:,i:i+tul-1),1);
network1_outputs2(:,i)=net2(input2(:,i+tul));
outputs2(:,i)=output2(i+tul);


net3=newrbe(input3(:,i:i+tul-1),output3(:,i:i+tul-1),1);
network1_outputs3(:,i)=net3(input3(:,i+tul));
outputs3(:,i)=output3(i+tul);

net4=newrbe(input4(:,i:i+tul-1),output4(:,i:i+tul-1),1);
network1_outputs4(:,i)=net4(input4(:,i+tul));
outputs4(:,i)=output4(i+tul);

end
dim=size(network1_outputs2,2);
figure(type+mohsen)
subplot(4,1,1)
erornesbi=abs((outputs2-network1_outputs2)./outputs2);
plot(1:dim,abs((outputs2-network1_outputs2)./outputs2),'b')
hold on
subplot(4,1,2)
erornesbi=abs((outputs2-network1_outputs2)./outputs2);
plot(1:dim,cumsum(abs((outputs2-network1_outputs2)./outputs2)),'b')
hold on
subplot(4,1,3)
eror=abs((outputs2-network1_outputs2));
plot(1:dim,abs((outputs2-network1_outputs2)),'b')
hold on
subplot(4,1,4)
plot(1:dim,cumsum(abs((outputs2-network1_outputs2))),'b')
hold on


dim=size(network1_outputs3,2);
figure(type+mohsen)
subplot(4,1,1)
erornesbi=abs((outputs3-network1_outputs3)./outputs3);
plot(1:dim,abs((outputs3-network1_outputs3)./outputs3),'r')
subplot(4,1,2)
erornesbi=abs((outputs3-network1_outputs3)./outputs3);
plot(1:dim,cumsum(abs((outputs3-network1_outputs3)./outputs3)),'r')
subplot(4,1,3)
eror=abs((outputs3-network1_outputs3));
plot(1:dim,abs((outputs3-network1_outputs3)),'r')
subplot(4,1,4)
plot(1:dim,cumsum(abs((outputs3-network1_outputs3))),'r')


dim=size(network1_outputs4,2);
figure(type+mohsen)
subplot(4,1,1)
erornesbi=abs((outputs4-network1_outputs4)./outputs4);
plot(1:dim,abs((outputs4-network1_outputs4)./outputs4),'g')
subplot(4,1,2)
erornesbi=abs((outputs4-network1_outputs4)./outputs4);
plot(1:dim,cumsum(abs((outputs4-network1_outputs4)./outputs4)),'g')
subplot(4,1,3)
eror=abs((outputs4-network1_outputs4));
plot(1:dim,abs((outputs4-network1_outputs4)),'g')
subplot(4,1,4)
plot(1:dim,cumsum(abs((outputs4-network1_outputs4))),'g')




% figure
% plot(outputs)
% ylim([-1.5 1.5])
figure(100+type+mohsen)
subplot(3,1,1)
plot(network1_outputs2,'r')
ylim([-1.5 1.5])
subplot(3,1,2)
plot(network1_outputs3,'r')
ylim([-1.5 1.5])
subplot(3,1,3)
plot(network1_outputs4,'r')
ylim([-1.5 1.5])


% network1_outputs=net1(input);
% dim=size(network1_outputs,2)
% figure
% for i=1:size(network1_outputs,1)
% plot(1:dim,abs((output(i,:)-network1_outputs(i,:))./output(i,:)),'color',C(i,:))
% hold on
% end
end