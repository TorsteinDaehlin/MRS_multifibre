function [h] = PlotFiberLength(Results,DatStore)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


lw = 2;

Misc = Results.Misc;
h = figure('Name','Muscle fiber length');
nPhases = length(Misc.IKfile);
if nPhases > 1
    hTabGroup = uitabgroup;
end
Cs = linspecer(3);
for trial = 1:nPhases    
    % set the name of the tab
    if nPhases>1
        [path,file,ext]=fileparts(Misc.IKfile{trial});
        tab = uitab(hTabGroup, 'Title', file);
        axes('parent',tab);
    end
    
    % get the number muscles with fiber length tracking
    Minds = DatStore(trial).USsel(:);
    nMus  = length(Minds);
    p     = numSubplots(nMus);
    
    for j=1:nMus
       subplot(p(1),p(2),j)   
        % simulated fiber length -- parameter estimation
       if Misc.UStracking
            lMSim = Results.lM(trial).MTE(Minds(j),:);
            tSim = Results.Time(trial).MTE;
            plot(tSim,lMSim,'Color',Cs(1,:),'LineWidth',lw); hold on;
       end        
       % simulated fiber length -- validation simulation
       if Misc.ValidationBool
            lMSim = Results.lM(trial).validationMRS(Minds(j),:);
            tSim = Results.Time(trial).validationMRS;
            plot(tSim,lMSim,'Color',Cs(2,:),'LineWidth',lw);  hold on;
       end 
       % generic MRS results
       if Misc.UStracking
            lMSim = Results.lM(trial).genericMRS(Minds(j),:);
            tSim = Results.Time(trial).genericMRS;
            plot(tSim,lMSim,'Color',Cs(3,:),'LineWidth',lw);hold on;
       end  
       % measured fiber length
       if Misc.UStracking
           if nMus == 1
             plot(Results.Time(trial).MTE,DatStore(trial).USTracking(j,:)/1000,'--k','LineWidth',lw);hold on;
           else
             plot(Results.Time(trial).MTE,DatStore(trial).USTracking(:,j)/1000,'--k','LineWidth',lw);hold on;
           end
       end
       title(DatStore(trial).MuscleNames{Minds(j)});
    end
    if Misc.ValidationBool==1 && Misc.UStracking==1  && Misc.MRSBool==1          
        legend('Parameter estimation','Validation','Generic','Experimental');
    elseif Misc.ValidationBool==0 && Misc.UStracking==1  && Misc.MRSBool==1  
        legend('Parameter estimation','Generic','Experimental');
    elseif Misc.ValidationBool==0 && Misc.UStracking==1  && Misc.MRSBool==0
        legend('Parameter estimation','Experimental');
    elseif Misc.ValidationBool==0 && Misc.UStracking==0  && Misc.MRSBool==1
        legend('Experimental','Generic');
    elseif Misc.ValidationBool==0 && Misc.UStracking==0  && Misc.MRSBool==0
        legend('Experimental');
    end    
end



end
