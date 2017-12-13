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

m_db=[];
md_db=[];
std_db=[];
for k=4:1:4
    x=(db(k).year);
    y=cell2mat(db(k).price);
    figure,plot(x,y,'o');
    % First proce estimation
    unique_x = unique(x);
    for m=1:1:length(unique_x)
        Index=find(x==unique_x(m));
        m_db(k,m) = mean(y(Index));
        md_db(k,m) = median(y(Index));
        std_db(k,m) = std(y(Index));
    end
    max_mdb=max(m_db(k,:));
    mean_std=mean(std_db(k,:));
    md_db=md_db';std_db=std_db'; 
    m_db=m_db'; 

    %   Median vs Mean
    figure,plot(unique_x,m_db);hold on;plot(unique_x,md_db,'r');
%   Outlier removal
    
    md_db2=interp(md_db,2);
    unique_x1=upsample(unique_x,2);
    unique_x2=upsample(unique_x+0.5,2,1);
    unique_xR=unique_x1+unique_x2;
    figure,plot(unique_xR,md_db2);hold on;plot(unique_x,md_db,'r');
    
    p = polyfit(unique_x,md_db,5);
    figure,plot(unique_xR,md_db2);hold on;plot(unique_x,md_db,'r');
   
    y1 = polyval(p,unique_xR);
    figure,plot(unique_xR,y1);hold on;plot(unique_x,md_db,'r');
   
  
    figure,boxplot(x,y);
    title(unique_entry(k));xlabel('Year');ylabel('Price');grid on;ylim([0 max_mdb+mean_std]);
    
       
    figure,
    h2=boxplot(y,x);title(unique_entry(k));xlabel('Year');ylabel('Price');grid on;
    %axis([min(x) max(x) 0 3*mean(y)]);
    
 
    % Define values  
    % h=findobj(gca,'tag','Outliers');
    % delete(h);

end
