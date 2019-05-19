clear; clc; fclose all;addpath('PEER_NGA_Records');warning('off','all');direc = pwd;
%% ================= NGAWEST2 GMs to AT2 and SPECTRA to .txt ====================== %%
% author : JAWAD FAYAZ (email: jfayaz@uci.edu)
%  visit: (https://jfayaz.github.io)

% ------------------------------ Instructions ------------------------------------- 
% This code rewrites the Ground Motion Time-History files downloaded from the 
% NGAWEST2 Database, into vector files 
%
% The two directions of the ground motion record will be named as per the filenameX and
% filenameY, and the Extension. For the given example in this code, the ground motions 
% will be renamed as 'GM1i' and 'GM2i', where 'i' is the ground motion number which goes 
% from 1 to 'n', where 'n' represents the total number of ground motions present in the 
% .csv file. The index "i' is as per given in the .csv file. 
% 
% The code also provides the option to write 4 lines of headers containing information
% of the Earthquake and the Ground Motion, if variable Header is kept to 'Yes'
%
% For example: 
%     'GM11.AT2' --> Ground Motion 1 in direction 1 (direction 1 can be either one of the bi-directional GM as we are rotating the ground motions it does not matter) 
%     'GM21.AT2' --> Ground Motion 1 in direction 2 (direction 2 is the other direction of the bi-directional GM)
%     'GM12.AT2' --> Ground Motion 2 in direction 1 (direction 1 can be either one of the bi-directional GM as we are rotating the ground motions it does not matter)  
%     'GM22.AT2' --> Ground Motion 2 in direction 2 (direction 2 is the other direction of the bi-directional GM)
% 
% This code will also write the downloaded Spectra (both Combined and Unscaled Component)
% of the ground motion (present in the .csv file) to .txt files with indeces 
% corresponding to the GM .AT2 file. Two folders : 'GM_Spectra' and
% 'Unscaled_Component_Spectra' will be created to store the spectra.
%
% The .txt files in the 'GM_Spectra folder' will contain the combined spectra of the GMs 
% which will be written as: 'Type of Spectra'_GM1.txt,  where 'Type of Spectra' can be 
% RotD50, SRSS etc. which is selected by the user while downloading the GMs from the database.
% For example:
%    'RotD50_GM1.txt' --> contain RotD50 Spectra of the 2 components of Ground Motion 1
%
% While the .txt files in 'Unscaled_Component_Spectra' will contain Unscaled Component 
% spectra of indiviual components of the GMs
% For example: 
%     'Comp_GM11.txt' --> Component Spectra of Ground Motion 1 in direction 1 (direction 1 can be either one of the bi-directional GM as we are rotating the ground motions it does not matter) 
%     'Comp_GM21.txt' --> Component Spectra of Ground Motion 1 in direction 2 (direction 2 is the other direction of the bi-directional GM)
%
%     
%  INPUT:
%  Input Variables includes:
%  .csv file which is downloaded from the NGA database alongwith the GM Time-Histories
%  filenameX
%  filenameY
%  Extension
%
%  OUTPUT:
%  Rewritten GM files will be outputted in a new folder named "Formatted_GMs"
%  Combined Spectra of the GMs will be rewritten in a new folder named "GM_Spectra"
%  Component Spectra of each component of GMs will be rewritten in a new folder named "Unscaled_Component_Spectra"
%
%%%%% ============================================================= %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ====================== USER INPUTS =============================== %%

% CSV File containing all the info of Recorded GMs (Please use same file provided by NGA Database)
file ='_SearchResults.csv';    

% Name to which the GM files will be renamed to in sequence
% in X-Direction
filenameX = 'GM1'; 
% in Y-Direction
filenameY = 'GM2'; 

% Extension to which the GM files will be renamed to in sequence
Extension = '.AT2';

% Do you want 4 lines of headers containing information of the Earthquake and the Ground Motion
Header = 'Yes';

%%%%%%================= END OF USER INPUT ========================%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ---------- Renaming GMs ----------
mkdir([direc,'\Formatted_GMs'])
directory_files= struct2cell(dir('PEER_NGA_Records\*.AT2'))'; 
[Data_nos, Data_txt]=xlsread(file,1);
No_of_GMs = max(Data_nos(:,1));
index_GM = find(Data_nos(:,1)==1);
fprintf('Total Number of GMS %d!!!\n',No_of_GMs) 
cd([direc,'\PEER_NGA_Records'])
for i = 1:No_of_GMs
    temp_X = strsplit((char(Data_txt(index_GM(1)+3+i,20))),' ');
    oldfile_X = temp_X{2};
    newfile_X = [direc,'\Formatted_GMs\',filenameX,num2str(i),Extension];
    copyfile(oldfile_X ,newfile_X);

    temp_Y = strsplit((char(Data_txt(index_GM(1)+3+i,21))),' ');
    oldfile_Y = temp_Y{2};
    newfile_Y = [direc,'\Formatted_GMs\',filenameY,num2str(i),Extension];
    copyfile(oldfile_Y ,newfile_Y);
    
    Dur_5_75(i,1) = Data_nos(index_GM(1)+i-1,7);
    Dur_5_95(i,1) = Data_nos(index_GM(1)+i-1,8);
    Arias_Int(i,1) = Data_nos(index_GM(1)+i-1,9);
    Year(i,1) = Data_nos(index_GM(1)+i-1,11);
    Mw(i,1) = Data_nos(index_GM(1)+i-1,13);
    RjB(i,1) = Data_nos(index_GM(1)+i-1,15);
    Rrup(i,1) = Data_nos(index_GM(1)+i-1,16);
    Vs30(i,1) = Data_nos(index_GM(1)+i-1,17);
    Lowest_Usable_Freq(i,1) = Data_nos(index_GM(1)+i-1,18);

    Earthquake(i,1) = Data_txt(index_GM(1)+3+i,10);
    Station(i,1) = Data_txt(index_GM(1)+3+i,12);
    Mechanism(i,1) = Data_txt(index_GM(1)+3+i,14);
end


%% ---------- ReWritting GMs ---------- 
cd([direc,'\Formatted_GMs'])
for i = 1:No_of_GMs 
    
    %%%%% For X - Direction
    file1 = [filenameX,num2str(i),Extension];
    myStructure1 = importdata(file1,' ',4);
    data1 = myStructure1.data;
    text1 = myStructure1.textdata;
    npts_split1 = strsplit(text1{4,2},',');
    npts1 = npts_split1{1};
    dt1 = text1{4,4};
    gm_history1 = reshape(data1',size(data1,1)*size(data1,2),1);
    gm_history1(isnan(gm_history1)) = [];

    fid = fopen (file1,'w');
    if strcmpi(Header,'Yes')==1
        fprintf(fid,'PEER NGA DATABASE RECORD IN X-DIRECTION \n');
        fprintf(fid,'Earthquake:%s, Year:%.0f, Station:%s, Mechanism:%s \n', Earthquake{i,1},Year(i,1),Station{i,1},Mechanism{i,1});
        fprintf(fid,'Mw=%.1f, Rrup=%.2f, RjB=%.2f, Arias Intensity=%.2f, D5-95=%.2f, D5-75=%.2f, Vs30=%.1f, Lowest Usable Frequncy=%.2f \n', Mw(i,1),Rrup(i,1),RjB(i,1),Arias_Int(i,1),Dur_5_95(i,1),Dur_5_75(i,1),Vs30(i,1),Lowest_Usable_Freq(i,1));
        fprintf(fid,'NPTS=  %s, DT= %s\n',npts1,dt1);
    end
    fprintf (fid,'%d\n',gm_history1);
    fclose(fid); 
    
    
    %%%%% For Y- Direction
    file2 = [filenameY,num2str(i),Extension];
    myStructure2 = importdata(file2,' ',4);
    data2 = myStructure2.data;
    text2 = myStructure2.textdata;
    npts_split2 = strsplit(text2{4,2},',');
    npts2 = npts_split2{1};
    dt2 = text2{4,4};
    gm_history2 = reshape(data2',size(data2,1)*size(data2,2),1);
    gm_history2(isnan(gm_history2)) = [];

    fid = fopen (file2,'w');
    if strcmpi(Header,'Yes')==1
        fprintf(fid,'PEER NGA DATABASE RECORD IN X-DIRECTION \n');
        fprintf(fid,'Earthquake:%s, Year:%.0f, Station:%s, Mechanism:%s \n', Earthquake{i,1},Year(i,1),Station{i,1},Mechanism{i,1});
        fprintf(fid,'Mw=%.1f, Rrup=%.2f, RjB=%.2f, Arias Intensity=%.2f, D5-95=%.2f, D5-75=%.2f, Vs30=%.1f, Lowest Usable Frequncy=%.2f \n', Mw(i,1),Rrup(i,1),RjB(i,1),Arias_Int(i,1),Dur_5_95(i,1),Dur_5_75(i,1),Vs30(i,1),Lowest_Usable_Freq(i,1));
        fprintf(fid,'NPTS=  %s, DT= %s\n',npts2,dt2);
    end
    fprintf (fid,'%d\n',gm_history2);
    fclose(fid); 
    
    
    fprintf('Ground Motions no. %d rewritten...\n',i)
    clearvars gm_history1 gm_history2  
end


%% ---------- ReWritting Spectra ---------- 
fprintf('Writing GM Spectra...\n') 
mkdir([direc,'\GM_Spectra'])
index_Period_Start = find(round(Data_nos(:,1),2)==0.01);
index_Period_End = find(round(Data_nos(:,1),2)==20);
ST = strsplit(Data_txt{28,2},' ');
Spectra_Type = ST{2};
Periods = Data_nos(index_Period_Start(1):index_Period_End(2),1);
cd ([direc,'\GM_Spectra'])
for i = 1:No_of_GMs 
    GM_Spectra(:,i) = Data_nos(index_Period_Start(1):index_Period_End(2),i+4);
    fid = fopen([Spectra_Type,'_GM',num2str(i),'.txt'],'w');
    fprintf(fid,'Period(s) %s(g)\n',Spectra_Type);
    fprintf (fid,'%.2f %.4f\n',[Periods,GM_Spectra(:,i)]');
    fclose(fid); 
end
cd (direc)

%% ---------- ReWritting Component Spectra ---------- 
fprintf('Writing Unscaled Component Spectra...\n') 
mkdir([direc,'\Unscaled_Component_Spectra'])
cd ([direc,'\Unscaled_Component_Spectra'])
Periods = Data_nos(index_Period_Start(2):index_Period_End(3),1);
for i = 1:No_of_GMs 
    Comp1_Spectra(:,i) = Data_nos(index_Period_Start(2):index_Period_End(3),3*i-1);
    fid = fopen(['CompX_GM',num2str(i),'.txt'],'w');
    fprintf(fid,'Period(s) Sa(g)\n');
    fprintf (fid,'%.2f %.6f \n', [Periods,Comp1_Spectra(:,i)]);
    fclose(fid); 
    
    Comp2_Spectra(:,i) = Data_nos(index_Period_Start(2):index_Period_End(3),3*i);
    fid = fopen(['CompY_GM',num2str(i),'.txt'],'w');
    fprintf(fid,'Period(s) Sa(g)\n');
    fprintf (fid,'%.2f %.4f \n', [Periods,Comp2_Spectra(:,i)]');
    fclose(fid); 
end
cd (direc)