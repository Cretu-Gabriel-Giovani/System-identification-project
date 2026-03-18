%%
% Nume si prenume: TODO
%

clearvars
clc

%% Magic numbers (replace with received numbers)
m = 2; 
n = 2; 

%% Process data (fixed, do not modify)
c1 = (1000+n*300)/10000;
c2 = (1.15+2*(m+n/10)/20);
a1 = 2*c2*c1;
a2 = c1;
b0 = (1.2+m+n)/5.5;

rng(m+10*n)
x0_slx = [2*(m/2+rand(1)*m/5); m*(n/20+rand(1)*n/100)];

%% Experiment setup (fixed, do not modify)
Ts = 10*c2/c1/1e4*1.5; % fundamental step size
Tfin = 30*c2/c1; % timpul experiemntuliui;

gain = 10;
umin = 0; umax = gain; % input saturation
ymin = 0; ymax = b0*gain/1.5; % output saturation

whtn_pow_in = 1e-6*5*(((m-1)*8+n/2)/5)/2*6/8; % input white noise power and sampling time
whtn_Ts_in = Ts*3;
whtn_seed_in = 23341+m+2*n;
q_in = (umax-umin)/pow2(10); % input quantsizer (DAC)

whtn_pow_out = 1e-5*5*(((m-1)*25+n/2)/5)*6/80*(0.5+0.3*(m-2)); % output white noise power and sampling time
whtn_Ts_out = Ts*5;
whtn_seed_out = 23342-m-2*n;
q_out = (ymax-ymin)/pow2(9); % output quantizer (ADC)

u_op_region = (m/2+n/5)/2; % operating point % valorea stationara 

%% Input setup (can be changed/replaced/deleted)
u0 = 0;        % fixed
ust = 3;     % must be modified (saturation)
t1 = 10*c2/c1; % recommended 

%% Data acquisition (use t, u, y to perform system identification)
out = sim("circuit_hidraulic_R2022b_p2.slx");

t = out.tout;
u = out.u;
y = out.y;

plot(t,u,t,y)
shg
%%
i1=6176;
i2=6675;
i3=12901;
i4=13310;

u0=mean(u(i1:i2));
y0=mean(y(i1:i2));
ust=mean(u(i3:i4));
yst=mean(y(i3:i4));

K=(yst-y0)/(ust-u0);
%% 
 K=0.9545; % asta o dat pentru indexii de mai sus
%% AFLAM T1 ( DOMINANTA)
%prima incercare din dominanta.mat

%a doua incercare din dominanta_incercare2
%i9=6671;
%i10=9126;
%i5=6315; % pentru valorile astea imi da tot 16.1560
%i6=10640; % pentru valorile astea imi da tot 16.1560

i5=6315;
i6=10650;
% T1=16.1563; -- asta i valoarea pentru indexii de mai sus
t_reg=t(i5:i6); % facem regresia 
y_reg=log(yst-y(i5:i6)); %

figure;
plot(t_reg,y_reg) %% plot de t regresie si y regresie;

A_reg = [ sum(t_reg.^2), sum(t_reg); sum(t_reg), length(t_reg)];

    B_reg=[sum(y_reg.*t_reg); sum(y_reg)];

    theta=inv(A_reg)*B_reg;
    
T1=-1/theta(1);
%T1=16.1551 
%T1=14.9124
%% Defineste indecsii tai aici (inlocuieste cu numerele tale daca sunt altele)
idx_test = [6318,10650]; % Indecsii din exemplul tau anterior

fprintf('---------------------------------------------------\n');
fprintf('| Index | Timp (X) [s] | Intrare (u) | Iesire (y) |\n');
fprintf('---------------------------------------------------\n');

for k = 1:length(idx_test)
    ix = idx_test(k);
    
    % Aici e "magia": t(ix) iti da timpul, y(ix) iti da valoarea
    val_t = t(ix); 
    val_u = u(ix);
    val_y = y(ix);
    
    fprintf('| %5d | %10.4f   | %10.4f  | %10.4f |\n', ix, val_t, val_u, val_y);
end
fprintf('---------------------------------------------------\n');

subplot(2,1,2); plot(t,y); hold on;
plot(t(idx_test), y(idx_test), 'ro', 'MarkerSize', 10, 'LineWidth', 2); % Puncte rosii pe y
title('Locatia indecsilor'); grid on;
%% AFLAM T2 ( Nedominanta)
%%datele aflate la prima incercare
i7=6659;
i8=6983;
%%
%i11=6705;
%i12=7151;
Ti=(t(i8)-t(i7));
T2vec=0.1:0.1:3.5;
Y_functie= T1*T2vec.*log(T2vec)-T2vec*(Ti+T1*log(T1))+T1*Ti;
figure;
plot(T2vec,Y_functie); grid;

 T2=1.67;

%T2=1.72; %% alegem de pe 0

%% Validare
H=tf(K,conv([T1,1],[T2,1]));

ysim=lsim(H,u,t);


figure;
plot(t,u,t,y,t,ysim);
 A=[0,1;-1/T1/T2,-(1/T1+1/T2)];
 B=[0;K/T1/T2];
 C=[1,0];
 D= 0;
sys=ss(A,B,C,D);
    %%
    ysim2=lsim(sys,u,t,[y(1),0.49]); %% aici se schimba pentru a imbunatati eroarea medie patratica  (( CONDITII INTIALE)) % e gresit trebuie ales alt punct in functie  de intrare( vezi partea 3 laborator)
    figure;
    plot(t,u,t,y,t,ysim2);
    
    J=1/sqrt(length(t))*norm(y-ysim2);
    
    eMPN= norm(y-ysim2)/norm(y-mean(y))*100; %% pentru a iesi sub 10% se modifica si K si condtiile initiale
