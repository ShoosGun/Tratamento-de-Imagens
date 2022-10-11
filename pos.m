#Encontra a posição do ponto dado dados absolutos
1;
#function [p]

#endfunction

f1 = [0,3,0];
f2 = [0,-2,-2];

px1 = 0*[1,0,0] + 1*[0,1,-4];
px2 = 0*[1,0,0] + 1*[0,-4,0];

dS = [0,3,13];

(px2 - px1 + dS)
[f1-px1; f2 - px2; [0, 0, 0]]


alfaEBeta = (px2 - px1 + dS)/[f1-px1; -(f2 - px2); [0, 0, 0]]

alfa = alfaEBeta(1)
beta = alfaEBeta(2)
gamma = alfaEBeta(3)

pf1 = (f1-px1)*alfa + px1

pf2 = (f2-px2)*beta + px2 + dS
