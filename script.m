Ra=0.6;
La=0.012;
Kt=0.8;
Kb=0.8;
J=0.0167;
b=0.0167;


%A=[-b/J Kt/J; -Kb/La -Ra/La];
%B=[0; 1/La];
%C=[1 0];
%D=0;

%[y, u] = ss2tf(A, B, C, D);