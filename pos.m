#Encontra a posição do ponto dado dados absolutos
1;
function [p, foundPosition] = CalculatePosition(informacoes, tol)
  f1 = informacoes.f1;
  f2 = informacoes.f2;

  px1 = informacoes.px1;
  px2 = informacoes.px2;

  dS = informacoes.ds;

  alfaEBeta = (px2 - px1 + dS)/[f1-px1; -(f2 - px2); [0, 0, 0]];

  alfa = alfaEBeta(1);
  beta = alfaEBeta(2);
  gamma = alfaEBeta(3);

  pf1 = (f1-px1)*alfa + px1;
  pf2 = (f2-px2)*beta + px2 + dS;

  p = pf1;
  foundPosition = norm(pf1-pf2) < tol;
endfunction

informacoes.f1 = [0,3,0];
informacoes.f2 = [0,-2,-2];

informacoes.px1 = 0*[1,0,0] + 1*[0,1,-4];
informacoes.px2 = 0*[1,0,0] + 1*[0,-4,0];

informacoes.ds = [0,3,13];

[p, foundPosition] = CalculatePosition(informacoes, 1e-10);

if foundPosition
  p
endif
