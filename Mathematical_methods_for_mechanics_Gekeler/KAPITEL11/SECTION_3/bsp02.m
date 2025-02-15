function F_WERT = bsp02(flag,T,X,Y,Z,parmtr3);
% Sieben-Koerper-Problem  -------------------
% Argument Z wird hier nicht gebraucht
% flag = 1: Funktion f
% flag = 2: Zwangsbedingung g
% flag = 3: Gradient von g
% flag = 4: t-Ableitung von g
% flag = 5: Massenmatrix M
% -------------------------------------------
% Gradient von f: R_n -> R_m ist (m,n)-Matrix
% -------------------------------------------
mom = parmtr3; % -----------
% -------------------
% Geometrische Daten -----------------------
d  = 0.028;    da = 0.0115;   e = 0.02;
ea = 0.01421;  zf = 0.02;    fa = 0.01421;
rr = 0.007;    ra = 0.00092; ss = 0.035;
sa = 0.01874;  sb = 0.01043; sc = 0.018;
sd = 0.02;     zt = 0.04;    ta = 0.02308;
tb = 0.00916;   u = 0.04;    ua = 0.01228;
ub = 0.00449;  c0 = 4530;    L0 = 0.07785;

sibe = sin(X(1)); cobe = cos(X(1));
sith = sin(X(2)); coth = cos(X(2));
siga = sin(X(3)); coga = cos(X(3));
siph = sin(X(4)); coph = cos(X(4));
side = sin(X(5)); code = cos(X(5));
siom = sin(X(6)); coom = cos(X(6));
siep = sin(X(7)); coep = cos(X(7));

sibeth = sin(X(1)+X(2)); cobeth = cos(X(1)+X(2));
siphde = sin(X(4)+X(5)); cophde = cos(X(4)+X(5));
siomep = sin(X(6)+X(7)); coomep = cos(X(6)+X(7));

bep = Y(1);  thp = Y(2);
php = Y(4);  dep = Y(5);
omp = Y(6);  epp = Y(7);

M = [0.04325, 0.00365, 0.02373, 0.00706, 0.07050, 0.00706, 0.05498];
IT = [2.194E-6, 4.410E-7, 5.255E-6, 5.667E-7,...
      1.169E-5, 5.667E-7, 1.912E-5];
% -- Fixpunkte ------------------------------------------------
FP = [-0.06934, -0.03635, 0.014;
      -0.00227,  0.03273, 0.072];
%--  Daten von Herrn Klimke -----
 %     FP(2,1) = FP(2,1) - 0.002;
 %     FP(2,2) = FP(2,2) + 0.0015;
 % --------------------------------
xd = sd*coga + sc*siga + FP(1,2);
yd = sd*siga - sc*coga + FP(2,2);
lang =  sqrt((xd-FP(1,3))^2 + (yd-FP(2,3))^2);
force = -c0*(lang - L0)/lang;
fx = force*(xd-FP(1,3));
fy = force*(yd-FP(2,3));

switch flag
case 1
   F_WERT = zeros(7,1);
   F_WERT(1) = mom - M(2)*da*rr*thp*(thp+2*bep)*sith;
   F_WERT(2) = M(2)*da*rr*bep^2*sith;
   F_WERT(3) = fx*(sc*coga-sd*siga)+fy*(sd*coga + sc*siga);
   F_WERT(4) = M(4)*zt*(e-ea)*dep^2*coph;
   F_WERT(5) = -M(4)*zt*(e-ea)*php*(php+2*dep)*coph;
   F_WERT(6) = -M(6)*u*(zf-fa)*epp^2*coom;
   F_WERT(7) = M(6)*u*(zf-fa)*omp*(omp+2*epp)*coom;
case 2
   F_WERT = zeros(6,1);
   F_WERT(1) = rr*cobe - d*cobeth - ss*siga - FP(1,2);
   F_WERT(2) = rr*sibe - d*sibeth + ss*coga - FP(2,2);
   F_WERT(3) = rr*cobe - d*cobeth - e*siphde -  zt*code - FP(1,1);
   F_WERT(4) = rr*sibe - d*sibeth + e*cophde  - zt*side - FP(2,1);
   F_WERT(5) = rr*cobe - d*cobeth - zf*coomep - u*siep  - FP(1,1);
   F_WERT(6) = rr*sibe - d*sibeth - zf*siomep + u*coep  - FP(2,1);
case 3
   F_WERT = zeros(6,7);
   F_WERT(1,1) = -rr*sibe + d*sibeth;
   F_WERT(1,2) = d*sibeth;
   F_WERT(1,3) = -ss*coga;
   F_WERT(2,1) = rr*cobe- d*cobeth;
   F_WERT(2,2) = -d*cobeth;
   F_WERT(2,3) = -ss*siga;
   F_WERT(3,1) = -rr*sibe + d*sibeth;
   F_WERT(3,2) = d*sibeth;
   F_WERT(3,4) = -e*cophde;
   F_WERT(3,5) = -e*cophde + zt*side;
   F_WERT(4,1) = rr*cobe-d*cobeth;
   F_WERT(4,2) = -d*cobeth;
   F_WERT(4,4) = -e*siphde;
   F_WERT(4,5) = -e*siphde - zt*code;
   F_WERT(5,1) = -rr*sibe+ d*sibeth;
   F_WERT(5,2) = d*sibeth;
   F_WERT(5,6) = zf*siomep;
   F_WERT(5,7) = zf*siomep-u*coep;
   F_WERT(6,1) = rr*cobe - d*cobeth;
   F_WERT(6,2) = - d*cobeth;
   F_WERT(6,6) = -zf*coomep;
   F_WERT(6,7) = -zf*coomep - u*siep;
case 4
   F_WERT = zeros(6,1);
case 5
   F_WERT = zeros(7,7);
   % Massenmatrix ist symmetrisch
   F_WERT(1,1) = M(1)*ra^2 + M(2)*(rr^2-2*da*rr*coth+da^2)...
                 + IT(1) + IT(2);
   F_WERT(2,1) = M(2)*(da^2-da*rr*coth) + IT(2);
   F_WERT(2,2) = M(2)*da^2 + IT(2);
   F_WERT(3,3) = M(3)*(sa^2+sb^2) + IT(3);
   F_WERT(4,4) = M(4)*(e-ea)^2 + IT(4);
   F_WERT(5,4) = M(4)*((e-ea)^2+zt*(e-ea)*siph) + IT(4);
   F_WERT(5,5) = M(4)*(zt^2+2*zt*(e-ea)*siph+(e-ea)^2)+ ...
                 M(5)*(ta^2+tb^2) + IT(4) + IT(5);
   F_WERT(6,6) = M(6)*(zf-fa)^2 + IT(6);
   F_WERT(7,6) = M(6)*((zf-fa)^2-u*(zf-fa)*siom) + IT(6);
   F_WERT(7,7) = M(6)*((zf-fa)^2-2*u*(zf-fa)*siom+u^2) + ...
                 M(7)*(ua^2 + ub^2) + IT(6) + IT(7);
   F_WERT(1,2) = F_WERT(2,1);
   F_WERT(4,5) = F_WERT(5,4);
   F_WERT(6,7) = F_WERT(7,6);
end
