#Encontra a posição do ponto dado dados absolutos
1;
function [p, foundPosition] = CalculatePosition(foto1, foto2, tol)
  f1 = foto1.f; # R * h/2 * cotan(fovHorizontalAngle) * f
  f2 = foto2.f; # R * h/2 * cotan(fovHorizontalAngle) * f

  px1 = foto1.px; # R*((x-w/2)&(-r) + (y-h/2)*(-u));
  px2 = foto2.px; # R*((x-w/2)&(-r) + (y-h/2)*(-u));

  dS = foto2.ds; # Se conseguirmos dS em termos de pixels (ou R),
                 # ai conseguiremos fazer em termos de pixels

  # Sim, essa matriz é singular, contudo faz sentido, pois são 3 equações para
  # duas variaveis (alfa e beta). O correto seria implementar a resolução da solução
  # e utilizar uma das equações ou para conferir ou no caso de uma linha ser zerada
  alfaEBeta = (px2 - px1 + dS)/[f1-px1; -(f2 - px2); [0, 0, 0]];

  alfa = alfaEBeta(1);
  beta = alfaEBeta(2);
  gamma = alfaEBeta(3);

  pf1 = (f1-px1)*alfa + px1;
  pf2 = (f2-px2)*beta + px2 + dS;

  p = pf1;
  foundPosition = norm(pf1-pf2) < tol;
endfunction

function px = CalculateAbsolutePixelPosition(x,y, r, u, dadosDaCamera)
  w = dadosDaCamera.horizontalResolution;
  h = dadosDaCamera.verticalResolution;
  R = dadosDaCamera.sensorToResolutionRatio;

  px = R*((x-w/2)&(-r) + (y-h/2)*(-u));
endfunction

function px = CalculatePixelPosition(x, y, r, u, dadosDaCamera)
  w = dadosDaCamera.horizontalResolution;
  h = dadosDaCamera.verticalResolution;

  px = ((x-w/2)&(-r) + (y-h/2)*(-u));
endfunction

function f = CalculateAbsoluteFocalLenght(dadosDaCamera)
  h = dadosDaCamera.verticalResolution;
  horizontalFov = dadosDaCamera.horizontalFov;
  R = dadosDaCamera.sensorToResolutionRatio;

  f = R * h/2 * cotan(horizontalFov);
endfunction

function f = CalculateFocalLenght(dadosDaCamera)
  h = dadosDaCamera.verticalResolution;
  horizontalFov = dadosDaCamera.horizontalFov;

  f = h/2 / tan(horizontalFov);
endfunction

#Informação Constante
informacoesDaCamera.horizontalResolution = 10;
informacoesDaCamera.verticalResolution = 10;
informacoesDaCamera.sensorToResolutionRatio = 10;
informacoesDaCamera.sensorToResolutionRatio = 10;
informacoesDaCamera.horizontalFov = 10;
informacoesDaCamera.focalLenght = CalculateFocalLenght(informacoesDaCamera);

#Informaçao por fotografia
foto1.foward = [0,3,0]; # É para estar normalzado
foto1.right = [1,0,0]; # //
foto1.up = [0,1,-4]; # //
foto1.pixel = [0,1]; # O pixel após passar por CalculatePixelPosition
                     #ou CalculateAbsolutePixelPositionPixelPosition

foto2.foward = [0,-2,-2];
foto2.right = [1,0,0];
foto2.up = [0,-4,0];
foto2.pixel = [0,1];

foto1.ds = [0,0,0];
foto2.ds = [0,3,13];

foto1.f = 1 * foto1.foward;
foto2.f = 1 * foto2.foward;
foto1.px = foto1.pixel(1) * foto1.right + foto1.pixel(2) * foto1.up;
foto2.px = foto2.pixel(1) * foto2.right + foto2.pixel(2) * foto2.up;

[p, foundPosition] = CalculatePosition(foto1, foto2, 1e-10);

if foundPosition
  p
endif
