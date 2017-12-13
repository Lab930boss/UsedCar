close all
clear all

tic
[num,txt,raw] = xlsread('test.xlsx');
toc
%% Extracting data from Exel
N=length(raw(:,1));
car_model=raw(2:1:N,14);
car_model_detail=raw(2:1:N,15);
year=raw(2:1:N,21);
transmission=raw(2:1:N,19);
num_options=raw(2:1:N,28);
price=raw(2:1:N,24);


%% Data sorting 
base_data= [car_model car_model_detail year transmission num_options price];
base_data_sort=sortrows(base_data,[1 2 3]);

%%
R_sort=2;
unique_entry = unique(base_data_sort(:,R_sort)); 

%% DB construction
tic
db(length(unique_entry))=struct('name',[],'year',[],'price', []);
for k=1:1:length(unique_entry)
    IndexC=strfind(base_data_sort(:,R_sort),unique_entry(k));
    Index = find(not(cellfun('isempty', IndexC)));
    
    db(k).name=unique_entry(k);
    db(k).year=str2double(base_data_sort(Index,3));
    db(k).price=(base_data_sort(Index,6));
end
toc
%%
close all

m_db=[]
std_db=[]
for k=1:1:1
    x=(db(k).year);
    y=cell2mat(db(k).price);
    
    % First proce estimation
    unique_x = unique(x);
    for m=1:1:length(unique_x)
        Index=find(x==unique_x(m));
        m_db(k,m) = mean(y(Index));
        std_db(k,m) = std(y(Index));
    end
    m_db=m_db';std_db=std_db';
    
    % Outlier removal
    
%     m_db2=interp(m_db,2);
%     unique_x1=upsample(unique_x,2);
%     unique_x2=upsample(unique_x+0.5,2,1);
%     unique_xR=unique_x1+unique_x2;
%     
%     figure,plot(unique_xR,m_db2);hold on;plot(unique_x,m_db,'r');
%     
%     p = polyfit(unique_xR,m_db2,5);
%     figure,plot(unique_xR,m_db2);hold on;plot(unique_x,m_db,'r');
%     
%     y1 = polyval(p,x1);
    figure,plot(x1,y1);hold on;plot(unique_x,m_db,'r');
    
    figure,boxplot(y,x);
    title(unique_entry(k));xlabel('Year');ylabel('Price');grid on;ylim([0 max(m_db(k,:))+mean(std_db(k,:))]);
    
    
    
    figure,
    h2=boxplot(y,x);title(unique_entry(k));xlabel('Year');ylabel('Price');grid on;
    %axis([min(x) max(x) 0 3*mean(y)]);
    
 
    % Define values  
    % h=findobj(gca,'tag','Outliers');
    % delete(h);

end
