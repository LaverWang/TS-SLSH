clear;
close all;
clc;
final=zeros(10,10);
num=1000;
re=0;
samidx=28*28;
testnum=10000;
for ep=1:10
    for kind=1:7
        hash=5;
        ex_hash=hash;
        Wts=randn(samidx,ex_hash);
        Wts(Wts<0)=0;
        ts=zeros(hash,samidx);
        sample=randperm(testnum);
        Wts_change=reshape(Wts, [1,samidx*ex_hash]);
        ts_change=reshape(ts, [1,samidx*ex_hash]);
        ran = randperm(samidx*ex_hash);
        rad = ran(1,1:floor(0.5*samidx*ex_hash));
        Wts_change(1,rad)=0;
        ts_change(1,rad)=0;
        Wts = reshape(Wts_change,[samidx,ex_hash]);
        ts = reshape(ts_change, [samidx, hash]);
        
        numb=0;
        for level=1:1
            for p=1:testnum
                nu=num2str(p,'%05d');
                iname=strcat('',nu,'');
                img=imread(iname);
                noise=noiselevel(1,kind);
                numb=numb+1;
                imgmean=(mean(Ia(:)))/255;
                I=im2bw(Ia,imgmean);
                spn(numb,:)=reshape(I',[1,784]);
                spt(numb,:)=encode_phase(I);
                ptnTime=300;
            end
        end
        
        samplenum=100;
        
        ft=zeros(testnum,ex_hash);
        spk=zeros(testnum,ex_hash);
        for i=1:testnum
            firtimes=[];
            firetimes=[];
            ft_list=[];
            b=[];
            a=[];
            for iepoch=1:ex_hash
                allfiretime{i,iepoch}=spikefire(Wts(:,iepoch),(spt(i,:)+(ts(:,iepoch))'),samidx,300);
            end
        end
        
        sample=1:100;
        for i=1:samplenum
            q=0;
            for j=1:testnum
                q=q+1;
                dist1=zeros(hash,1);
                for iepoch=1:hash
                    dist1(iepoch,1)=spkDist(allfiretime{sample(i),iepoch},allfiretime{j,iepoch},8,300);
                end
                dist(q)=mean(dist1);
                lab_dist(q)=distance(spn(sample(i),:),spn(j,:));
            end
            [~,lab_list]=sort(lab_dist);
            [~,list]=sort(dist);
            fin_lab_list=lab_list(2:201);
            fin_list=list(2:201);
            num_correct=0;
            MAP=[];
            for idx=1:length(fin_list)
                if ismember(fin_list(idx),fin_lab_list)
                    num_correct=num_correct+ismember(fin_list(idx),fin_lab_list);
                    MAP(num_correct)=num_correct/(idx);
                end
            end
            if isnan(mean(MAP))
                MAP=0;
            end
            map(i) = mean(MAP);
        end
        final_map = mean(map)
        final(kind,ep) = final_map;
    end
end
