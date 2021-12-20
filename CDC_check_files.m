function [Tab,List,string] = CDC_check_files(dir_check, file, N_list, file2)

    % ****************************************
    % sample code for calling this function **
    % ****************************************
    if 0,
        addpath('/n/home10/dchan/script/Peter/Hvd_SST/Homo/');
        addpath('/n/home10/dchan/script/Peter/ICOAD_RE/function/');
        addpath('/n/home10/dchan/Matlab_Tool_Box/');
        addpath('/n/home10/dchan/Matlab_Tool_Box/Figure_Tool_Box_CD/');
        addpath('/n/home10/dchan/m_map/');

        dir_check = '/n/home10/dchan/holy_kuang/Hvd_SST/HM_NMAT/Step_05_corr_idv/';
        file = 'corr_idv_HM_NMAT_deck_level_1_en_';
        N_list = 0:224;
        [Tab,List,string] = CDC_check_files(dir_check,file,N_list,1);

        dir_check = '/n/home10/dchan/holy_kuang/Hvd_SST/HM_SST_Bucket/Step_05_corr_idv/';
        file = 'corr_idv_HM_SST_Bucket_deck_level_1_en_';
        N_list = 0:158;
        [Tab,List,string] = CDC_check_files(dir_check,file,N_list,1);

        dir_check = '/n/home10/dchan/holy_kuang/Hvd_SST/HM_SST_Bucket/Step_06_corr_rnd/';
        file = 'corr_rnd_HM_SST_Bucket_deck_level_1_en_';
        N_list = 1:1000;
        [Tab,List,string] = CDC_check_files(dir_check, file, N_list, 0);

        dir_check = '/n/home10/dchan/holy_kuang/Hvd_SST/HM_SST_ERI/Step_05_corr_idv/';
        file = 'corr_idv_HM_SST_ERI_deck_level_1_en_';
        N_list = 0:89;
        [Tab,List,string] = CDC_check_files(dir_check,file,N_list,1);

        dir_check = '/n/home10/dchan/holy_kuang/Hvd_SST/HM_SST_ERI/Step_06_corr_rnd/';
        file = 'corr_rnd_HM_SST_ERI_deck_level_1_en_';
        N_list = 1:1000;
        [Tab,List,string] = CDC_check_files(dir_check,file,N_list,0);

        dir_check = '/n/home10/dchan/work/SHIP_TRACK/Result/Others/';
        file = 'Year_1885_others_';
        file2 = '.mat';
        N_list = 1:577;
        [Tab,List,string] = CDC_check_files(dir_check,file,N_list,0);

        dir_check = '/n/home10/dchan/work/SHIP_TRACK/Result/Bad_2hourly/';
        file = 'Year_1885_2hr_bad_track_';
        file2 = '.mat';
        N_list = 1:398;
        [Tab,List,string] = CDC_check_files(dir_check,file,N_list,file2);
    end

    ct = 0;
    for en = N_list

        if rem(en,10) == 0,
           disp(['Starting year ',num2str(en)]);
        end

        % *********************************
        % File name for the loading data **
        % *********************************
        clear('Pairs','Meta')
        clear('file_load','file_save','sst_ascii')
        file_load = [dir_check,file,num2str(en),file2];

        fid = fopen(file_load);
        ct = ct + 1;
        Tab(ct) = fid > 0;
        if fid > 0;
            fclose(fid);
        end
    end

    List(1,:) = find(Tab == 0);

    string = [];
    for i = 1:numel(List(1,:))
        string = [string,num2str(N_list(List(1,i))),','];
    end
    string(end) = [];
end
