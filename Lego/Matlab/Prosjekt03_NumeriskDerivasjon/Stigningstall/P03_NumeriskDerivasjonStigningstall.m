%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% P03_NumeriskDerivasjonStigningstall
%
% Hensikten med programmet er å numerisk derivere filtrert 
% målesignal u_{f,k} som representere avstandsmåling [m]
% til å beregne v_{f,k} som fart [km/t]
% 
% Følgende sensorer brukes:
% - Ultralydsensor
% - Bryter
%--------------------------------------------------------------------------


%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%         EXPERIMENT SETUP, FILENAME AND FIGURE

clear; close all   % Alltid lurt å rydde workspace opp først
online = true;    % Online mot EV3 eller mot lagrede data?
plotting = true;   % Skal det plottes mens forsøket kjøres 
filename = 'P03_minedata.mat'; 

if online

    % LEGO EV3 og styrestikke
    mylego = legoev3('USB');
    joystick = vrjoystick(1);
    [JoyAxes,JoyButtons] = HentJoystickVerdier(joystick);
    
    % sensorer
    mySonicSensor = sonicSensor(mylego);
    myTouchSensor = touchSensor(mylego);
    
else
    % Dersom online=false lastes datafil. 
    load(filename)
end

fig1=figure;
%set(gcf,'Position',[.., .., .., ..])
drawnow

% setter skyteknapp til 0, og initialiserer tellevariabel k
JoyMainSwitch=0;
k=0;
%----------------------------------------------------------------------



while ~JoyMainSwitch

    %+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    %                       GET TIME AND MEASUREMENT
    % Få tid og målinger fra sensorer, motorer og joystick

    % oppdater tellevariabel
    k=k+1;
    
    if online
        if k==1
            tic
            Tid(1) = 0;
        else
            Tid(k) = toc;
        end
        
        % sensorer
        Avstand(k) = double(readDistance(mySonicSensor));
        Bryter(k)  = double(readTouch(myTouchSensor));
           
        % Data fra styrestikke. Utvid selv med andre knapper og akser
        [JoyAxes,JoyButtons] = HentJoystickVerdier(joystick);
        JoyMainSwitch = JoyButtons(1);
    else
        % online=false
        % Naar k er like stor som antall elementer i datavektpren Tid,
        % simuleres det at bryter paa styrestikke trykkes inn.
        if k==numel(Tid)
            JoyMainSwitch=1;
        end
       
        if plotting
            % Simulerer tiden som EV3-Matlab bruker på kommunikasjon 
            % når du har valgt "plotting=true" i offline
            pause(0.03)
        end

    end
    
    
    % +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    %             CONDITIONS, CALCULATIONS AND SET MOTOR POWER
    % Gjør matematiske beregninger og motorkraftberegninger.
   
    % Tilordne målinger til variabler
    u(k) = 100*Avstand(k);        
 
    if k==1
        % Spesifisering av initialverdier og parametere
        T_s(1) = 0.01;  % nominell verdi

    else
        % beregner tidsskritt

    end
    
    %--------------------------------------------------------------

    
    %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    %                  PLOT DATA
    %
    % Husk at syntaksen plot(Tid(1:k),data(1:k))
    % for gir samme opplevelse i online=true og online=false siden
    % hele datasettet (1:end) eksisterer i den lagrede .mat fila
    
    % Plotter enten i sann tid eller når forsøk avsluttes
    if plotting || JoyMainSwitch
        subplot(2,1,1)
        plot(Tid(1:k),u(1:k),'b-');
        grid

        subplot(2,1,2)
        plot(Tid(1:k),Bryter(1:k),'k');
        grid
        xlabel('Tid [sek]')

        % tegn naa (viktig kommando)
        drawnow
        %--------------------------------------------------------------
    end        
end



% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%           STOP MOTORS

if online

end
%------------------------------------------------------------------

subplot(2,1,1)
legend('$\{u_k\}$')
subplot(2,1,2)
legend('brytersignal')

