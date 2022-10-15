#Encontra a posição do ponto dado dados absolutos
1;
function [p1,p2, distance] = CalculateClosestPosition(foto1, foto2)
  f1 = foto1.f; # R * h/2 * cotan(fovHorizontalAngle) * f
  f2 = foto2.f; # R * h/2 * cotan(fovHorizontalAngle) * f

  px1 = foto1.px; # R*((x-w/2)&(-r) + (y-h/2)*(-u));
  px2 = foto2.px; # R*((x-w/2)&(-r) + (y-h/2)*(-u));

  v1 = f1 - px1;
  v2 = f2 - px2;

  dS = -foto2.ds + px1 - px2; # Se conseguirmos foto2.ds em termos de pixels (ou R),
                 # ai conseguiremos fazer em termos de pixels

                 #Esse método usa a primeira derivada da distância para encontrar os valores de alfa e beta
                 #que a minimizam
  alfaEBeta = [-2 * v1 * transpose(dS), 2 * v2 * transpose(dS)];

  params = [2*v1 * transpose(v1) , -2*v1 * transpose(v2);
              -2*v1 * transpose(v2) , 2*v2 * transpose(v2)];

  alfaEBeta = alfaEBeta / params;

  alfa = alfaEBeta(1);
  beta = alfaEBeta(2);

  p1 = v1*alfa + px1;
  p2 = v2*beta + px2 + foto2.ds;
  distance = norm(p1-p2);
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
foto2.ds = [0,3,13]; #Distancia entre os centros dos sensores de cada câmera

foto1.f = 1 * foto1.foward;
foto2.f = 1 * foto2.foward;
foto1.px = foto1.pixel(1) * foto1.right + foto1.pixel(2) * foto1.up;
foto2.px = foto2.pixel(1) * foto2.right + foto2.pixel(2) * foto2.up;

[p1, p2, distance] = CalculateClosestPosition(foto1, foto2);

if distance < 1e-10
  disp("Encontramos posicao exata! "), disp(p1);
else
  disp("Encontramos posicao media! "), disp((p1 + p2)/2);
endif
