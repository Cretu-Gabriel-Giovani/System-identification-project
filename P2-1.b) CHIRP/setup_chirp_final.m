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
Tfin = 30*c2/c1*10; % simulation duration

gain = 10;
umin = 0; umax = gain; % input saturation
ymin = 0; ymax = b0*gain/1.5; % output saturation

whtn_pow_in = 1e-6*5*(((m-1)*8+n/2)/5)/2*6/8; % input white noise power and sampling time
whtn_Ts_in = Ts*3;
whtn_seed_in = 23341+m+2*n;
q_in = (umax-umin)/pow2(10); % input quantizer (DAC)

whtn_pow_out = 1e-5*5*(((m-1)*25+n/2)/5)*6/80*(0.5+0.3*(m-2)); % output white noise power and sampling time
whtn_Ts_out = Ts*5;
whtn_seed_out = 23342-m-2*n;
q_out = (ymax-ymin)/pow2(9); % output quantizer (ADC)

u_op_region = (m/2+n/5)/2; % operating point

%% Input setup (can be changed/replaced/deleted)
%wf =0.0671; % wf = 1/T1 , T1 usor de citit aproximativ din raspuns la treapa (y63) %pulsatie de frangere


T1= 16.1563
wf=1/T1;
fmin=  wf/2/pi/10;
fmax=  wf/2/pi*10;
Ain=0.67; % , arbitrar , suficent de mare ,amplitudinea de intrare( sa nu fie asa mica incat sa se confunda cu zogmotul) alegem noi o valoare

%% Data acquisition (use t, u, y to perform system identification)
out = sim("circuit_hidraulic_R2022_p3.slx");

t = out.tout;
u = out.u;
y = out.y;

figure;plot(t,u,t,y)

shg

%% System identification
%pentru Ain=0.6
yst=(0.714015+0.61553)/2;
ust=(1.37695+0.0195312)/2;
K=yst/ust; % K=0.9389
%K=0.9545
%%
%pentru Ain=0.65
yst=(0.714015+0.61553)/2;
ust=(1.35742+0.0390625)/2;
K=yst/ust; % K=0.9521
%%

%pentru Ain=0.67
yst=(0.714015+0.61553)/2;
ust=(1.37695+0.0195312)/2;
K=yst/ust; %   0.9521
%%

w1=pi/(794.283-777.548) 

DeltaT1=786.68-777.548; 
% sin(w*t+phi)

phi1=rad2deg(-w1*DeltaT1);  %phi1=  -98.2229
%%

w2=pi/(760.992-744.809);
DeltaT2=753.53-744.809;
phi2=rad2deg(-w2*DeltaT2) % phi2=  -97.0018

%%

w3=pi/(726.854-710.349);
DeltaT3=718.479-710.349;
phi3=rad2deg(-w3*DeltaT3) %-88.6640


%%
%%
%pentur phi3 - Au = 0.67 ales
Ay=(0.8863464-0.443182)/2;
Au=(1.38672-0.00976562)/2;
%Au=0.67
M=Ay/Au;
Im=-M;
%%
wn= w3;
zeta = -K/2/Im;

H=tf(K*wn^2,[1,2*zeta*wn,wn^2]);
ysim=lsim(H,u,t);
figure;
plot(t,u,t,y,t,ysim);
zpk(H)
%%
T1=1/0.07409; 
T2=1/0.489;
%%
A=[0,1;-1/T1/T2,-(1/T1+1/T2)];
 B=[0;K/T1/T2];
 C=[1,0];
D= 0;
sys=ss(A,B,C,D);

ysim2=lsim(sys,u,t,[y(1),0.40]); 
figure;
plot(t,u,t,y,t,ysim2);

J=1/sqrt(length(t))*norm(y-ysim2);


eMPN= norm(y-ysim2)/norm(y-mean(y))*100;


%% -- incercari esuate
%%
%LUAM ALTE OMEGA SI DELTA ( ALTa pulsatie si defazaj)

w4=pi/(800.461-787.193);
DeltaT4=794.373-787.193;
phi4=rad2deg(-w4*DeltaT4)  %% phi4=-97.4073
% cu cat phi ul e mai apropiat de -90 cu atat e mai ok , asta si vreem

%%
%LUAM ALTE OMEGA SI DELTA ( ALTa pulsatie si defazaj)

w5=pi/(762.302-746.659);
DeltaT5=754.442-746.659;
phi5=rad2deg(-w5*DeltaT5)  
% cu cat phi ul e mai apropiat de -90 cu atat e mai ok , asta si vreem
%%
%LUAM ALTE OMEGA SI DELTA ( ALTa pulsatie si defazaj)

w6=pi/(757.101-741.945);
DeltaT6=749.831-741.945;
phi6=rad2deg(-w6*DeltaT6)  
% cu cat phi ul e mai apropiat de -90 cu atat e mai ok , asta si vreem
%%
%LUAM ALTE OMEGA SI DELTA ( ALTa pulsatie si defazaj)

w7=pi/(726.931-710.247);
DeltaT7=718.479-710.247;
phi7=rad2deg(-w7*DeltaT7)  
% cu cat phi ul e mai apropiat de -90 cu atat e mai ok , asta si vreem
%%
% LUAM ALTE OMEGA SI DELTA ( ALTa pulsatie si defazaj)
%%pentru AIN=0.6
w8=pi/(794.116-778.395);
DeltaT8=786.615-778.395;
phi8=rad2deg(-w8*DeltaT8)  % -94.1162
% cu cat phi ul e mai apropiat de -90 cu atat e mai ok , asta si vreem


%%



%%pentru AIN=0.65
w9=pi/(794.656-777.715);
DeltaT9=786.667-777.715;
phi9=rad2deg(-w9*DeltaT9)  % -94.1162
% cu cat phi ul e mai apropiat de -90 cu atat e mai ok , asta si vreem
%%
%%pentru AIN=0.65
w10=pi/(826.059-810.184);
DeltaT10=818.391-810.184;
phi10=rad2deg(-w10*DeltaT10)  %-93.0557

% cu cat phi ul e mai apropiat de -90 cu atat e mai ok , asta si vreem


%%





%%
%Proiect initial
%Ay=(1.60038-0.677083)/2; % ampltitudinea la iesire; scadem y urile de pe liia rosie
%Au=2.5; %ampltiduniea la intrare ( am selectat o la inceput user input) A in arbitrat
Ay=(0.861742-0.507)/2;
Au=(1.30859-0.0976562)/2
M=Ay/Au;
Im=-M;
%%
Ay=(0.837121-0.492424)/2;
Au=(1.31836-0.0878906)/2;
M=Ay/Au;
Im=-M;
%%
%pentru phi8
Ay=(0.874053-0.49424)/2;
Au=(1.30859-0.107422)/2;
M=Ay/Au;
Im=-M;
%%
%pentur phi10 - Au = 0.65 ales
Ay=(0.874053-0.480114)/2;
Au=(1.37695-0.0292969)/2;
M=Ay/Au;
Im=-M;
wn= w10;
zeta = -K/2/Im;
%% 

%wn= w7;
wn= w8;
zeta = -K/2/Im;

%%
H=tf(K*wn^2,[1,2*zeta*wn,wn^2]);
ysim=lsim(H,u,t);
figure;
plot(t,u,t,y,t,ysim);
zpk(H)
T1=1/0.07409; 
T2=1/0.489;
%%
%T1=1/0.07582; %% din zpk luam polii de jos , aici polul cel mai mic
%T2=1/0.4677; %% aici polul cel mai mare
%pentru phi8
%T1=1/0.06792; %% din zpk luam polii de jos , aici polul cel mai mic
%T2=1/0.5766;


%% aici polul cel mai mare
% valorile de mai jos a lui t1 si t2 dau o eroare dee 10.4854
%T1=1/0.06389;
%T2=1/0.4400;
