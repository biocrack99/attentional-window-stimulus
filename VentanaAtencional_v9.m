%%Script para la medicion del ancho de la ventana atencional
%%Anibal de Paul 27/12/2018
%%Descripcion: la ventana de atencion mide la capacidad de identificar 
%%simultaneamente dos estmulos perif`iricos definidos por la conjuncion de dos 
%%rasgos (color y forma). Dos estimulos presentados perifericamente a lo largo 
%%de tres ejes (hor. ver. diag.) variando la distancia entre ellos. 
%%Objetivo: determinar la maxima distacia entre los dos est?mulos perif?ricos 
%%a traves del centro del campo visual. 

%Version 9: 
%- Corregido bug sobre la cantidad de estimulos presentados 
%Limpiar el workspace y la pantalla 
clear all;
sca;
close all;
 
%Ingresar nombre del sujeto
obs = inputdlg('Ingrese las iniciales del Participante');
%12 veces cada posicion 
%Numero de trials 336
trials = 336;

calibracion_eyetracker;
      


try

%Obtener el numero de pantallas
screens = Screen('Screens');

%Para dibujar usamos el maximo numero de screens por si hay un monitor externo 
%conectado. Si uso min seleciona la pantalla de mi laptop
screenNumber = max(screens);

%Definir el blanco y el negro(blanco 1 y negro 0). 
blanco = WhiteIndex(screenNumber);
negro = BlackIndex(screenNumber);  

%Definir un gris.
gris = blanco / 2;

%Luego de calibracion
distObs = 1.530 ;
ancho_display = 1.650;
alto_display = 1.265;

%Tama?o angular en pixeles
%[degXpix, pixXdeg, size_display] = PixParameters(ancho_display, alto_display, distObs);

%Valores medidos sobre la pantalla
%pixXdeg(1) = vertical
%pixXdeg(2) = horizontal
%pixXdeg(3) = oblicuo
pixXdeg = [0.058 0.055 0.053] ;

%%%% Inicio Psychtoolbox
%Screen('Preference', 'SkipSyncTests', 1);
window = Screen('OpenWindow',screenNumber,blanco,[],32,2);

Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
Priority(MaxPriority(window));

Screen('Flip', window);

%Obtener el centro de coordenadas de la ventana en pixeles.
[xCenter, yCenter] = RectCenter(Screen(screenNumber,'Rect'));

%Obtener el tama?o de la pantalla
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

%Consultar por el intervalo entre frames. Es el tiempo minimo entre.
%Tiempo minimo posible entre el momento en que se dibuja en la pantalla. 
ifi = Screen('GetFlipInterval', window);

%%%%Presentacion de la cruz de fijacion

%Set el tama?o de la cruz de fijacion. 
fixCrossDimPix = 10;

%Configurar las coordenadas de la cruz (relativas a 0 
%en el centro del monitor).
xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
allCoords = [xCoords; yCoords];

%Tama?os del ancho de las lineas de la cruz.
lineWidthPix = 2;

%----------------------------------------------------------------------
%                       Timing Information
%----------------------------------------------------------------------
%Tiempo de presentacion de la cruz de fijacion 
numSecs = 1;
numFrames = round(numSecs / ifi);
waitframes = 1;
vbl = Screen('Flip', window);

%----------------------------------------------------------------------
%                     Matriz de respuesta
%----------------------------------------------------------------------
% Matriz de 6 columnas. La primera columna guarda la cantidad de triangulos
% grises claros presententados en la posicion 1. La segunda guarda la 
% cantidad de triangulos grises claros presententados en la posicion 2 . La 
% tercera la cantidad de triangulos grises claros que el sujeto "atendio" en la 
% posicion 1. La cuarta la cantidad de triangulos grises claros que el sujeto 
% "atendio" en la posicion 2. La quinta guarda la direccion de la presentacion
% de los est?mulos. La 6 guarda la separacion de los estimulos en angulos. 
respMat = nan(trials, 6);
responseA = nan;
responseB = nan;
nTRI_R = nan;
nTRI_L = nan;
header = {'Cantidad TGC 1','Cantidad TGC 2','Respuesta A', 'Respuesta B', 'Direccion', 'Separacion'};
%Fecha y hora
c = clock;
h = num2str(c(4));
m = num2str(c(5));
dia = date;
diahm = [dia,'_',h,'_',m];
%Verifica si el directorio Datos esta creado, si no lo crea
directorio = pwd; 
d_datos = fullfile(directorio, 'Datos\');

if ~exist(d_datos, 'dir')

    mkdir(d_datos)

end
%% ESTRUCTURA DATOS

%Estructura para manipular y guardar los datos
estructura_datos (1:trials) = struct('Cantidad_TGC_1',[], 'Cantidad_TGC_2', ...
    [], 'Respuesta_A', [], 'Respuesta_B', [],  'Direccion', [], ...
    'Separacion', [], 'XGaze_mm', [], 'YGaze_mm', [], 'Fijacion', []);

%----------------------------------------------------------------------
%                       Parametros del experimento
%----------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Huttermann and Memmert 38 (2018) Psychology of Sport and Exercise 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Multiplicador del angulo de la posicion del estimulos
%Angulos horizontal 0-180? Vertical 90?-270? Diagonales 45?-225? 135?-315?
%Cada posicion la repite 12 veces
%n = [0.0 0.25 0.50 0.75];

%n = repmat(n,1,84);
%R = randperm(length(n));
%ang = n(R);

    a = [0 3; 0 5; 0 8; 0 11; 0 14; 0 17; 0 20];    
    b = [0.25 3; 0.25 5; 0.25 8; 0.25 11; 0.25 14; 0.25 17; 0.25 20];
    c = [0.50 3; 0.50 5; 0.50 8; 0.50 11; 0.50 14; 0.50 17; 0.50 20];
    d = [0.75 3; 0.75 5; 0.75 8; 0.75 11; 0.75 14; 0.75 17; 0.75 20];
    comb = [a ;b ;c ;d];
    comb = repmat(comb, [12 1]);
    index = randperm(length(comb(:,2)));



%Distancia al centro 10?-15?-20?-25?-30?-35?-40?-45? 
%m= 1:1:8;
%m =  pixXdeg * [10 15 20 25 30 35 40 45];
%m =  pixXdeg * [5 10 15 20 25 30 35 40];


%m = [3 5 8 11 14 17 20];%207 cantidad de pixeles a 20?
%m = [207 207 207 207 207 207 207 207]

%m = repmat(m,1,48);
%R = randperm(length(m));
%rad = datasample(m,352, 'Replace', false);
%rad = m(R);
%

%Cargo las imagenes de los est?mulos para generar las texturas
[image_1,~,alpha_1] = imread('C:\Documents and Settings\Administrador\Escritorio\Experimento Anibal\MATLAB\VENTANA ATENCION\MoreGrayCircle.png');
[image_2,~,alpha_2] = imread('C:\Documents and Settings\Administrador\Escritorio\Experimento Anibal\MATLAB\VENTANA ATENCION\LightGrayCircle1.png');
[image_3,~,alpha_3] = imread('C:\Documents and Settings\Administrador\Escritorio\Experimento Anibal\MATLAB\VENTANA ATENCION\MoreGrayTriangle.png');
[image_4,~,alpha_4] = imread('C:\Documents and Settings\Administrador\Escritorio\Experimento Anibal\MATLAB\VENTANA ATENCION\LightGrayTriangle1.png');

%Cargo las im?genes para las respuestas
[image_cero,~,alpha_cero] = imread('C:\Documents and Settings\Administrador\Escritorio\Experimento Anibal\MATLAB\VENTANA ATENCION\cero.png');
[image_uno,~,alpha_uno] = imread('C:\Documents and Settings\Administrador\Escritorio\Experimento Anibal\MATLAB\VENTANA ATENCION\uno.png');
[image_dos,~,alpha_dos] = imread('C:\Documents and Settings\Administrador\Escritorio\Experimento Anibal\MATLAB\VENTANA ATENCION\dos.png');
[image_tres,~,alpha_tres] = imread('C:\Documents and Settings\Administrador\Escritorio\Experimento Anibal\MATLAB\VENTANA ATENCION\tres.png');
[image_cuatro,~,alpha_cuatro] = imread('C:\Documents and Settings\Administrador\Escritorio\Experimento Anibal\MATLAB\VENTANA ATENCION\cuatro.png');
[image_flecha,~,alpha_flecha] = imread('C:\Documents and Settings\Administrador\Escritorio\Experimento Anibal\MATLAB\VENTANA ATENCION\flecha4.png');



%Tamano de las imagenes para que salgan completas  
size_image=size(image_1);
wEstimuli=size_image(1);
hEstimuli=size_image(2); 

size_image_resp = size(image_cero);
wResp_img = size_image_resp(1);
hResp_img = size_image_resp(2);

size_image_flecha = size(image_flecha);
wFlecha_img = size_image_flecha(1);
hFlecha_img = size_image_flecha(2);

%Ingreso las matrices de imagenes en una variable cell
imageT = uint8(zeros(wEstimuli,hEstimuli,4));  
imagenes_cell = cell(1,10);

imageR = uint8(zeros(wResp_img,hResp_img,3));  
imageF = uint8(zeros(wFlecha_img,hFlecha_img,1));  


%Circulo gris
imageT(:,:,1:3)=image_1;
imageT(:,:,4)=alpha_1;
imagenes_cell{1} =  imageT;
%Circulo gris claro;
imageT(:,:,1:3)=image_2;
imageT(:,:,4)=alpha_2;
imagenes_cell{2} =  imageT;
%Triangulo gris
imageT(:,:,1:3)=image_3;
imageT(:,:,4)=alpha_3;
imagenes_cell{3} =  imageT;
%Triangulo gris claro
imageT(:,:,1:3)=image_4;
imageT(:,:,4)=alpha_4;
imagenes_cell{4} =  imageT;
%Numero cero
imageR(:,:,1:3)=image_cero;
%imageR(:,:,4)=alpha_cero;
imagenes_cell{5} =  imageR;
%Numero uno
imageR(:,:,1:3)=image_uno;
%imageR(:,:,4)=alpha_uno;
imagenes_cell{6} =  imageR;
%Numero dos
imageR(:,:,1:3)=image_dos;
%imageR(:,:,4)=alpha_dos;
imagenes_cell{7} =  imageR;
%Numero tres
imageR(:,:,1:3)=image_tres;
%imageR(:,:,4)=alpha_tres;
imagenes_cell{8} =  imageR;
%Numero cuatro
imageR(:,:,1:3)=image_cuatro;
%imageR(:,:,4)=alpha_cuatro;
imagenes_cell{9} =  imageR;
%Flecha
imageF(:,:,1:3)=image_flecha;
imageF(:,:,4)=alpha_flecha;
imagenes_cell{10} =  imageF;



%creo las texturas a partir de la imagen cargada
texture_cell = cell(1,10);
for k = 1:10
texture_cell{k}=Screen('MakeTexture', window, imagenes_cell{k});
end
%vector de texturas para pasar a la funcion drawtextures

%creo los rectangulos donde dibujo los estimulos
%aqui controlo el tama?o de los estimulos
%Datos 2013 Hutermman
size_deg = 1.91; %  
%distancia de separacion entre estimulos 
size_gap_deg = 0.21;
size_pix = size_deg/pixXdeg(3);
size_gap_pix = size_gap_deg/pixXdeg(3);
[s1, s2] = size(image_1(:,:,1));
baseRect = [0 0 size_pix size_pix];

%indice para la estructura de datos;
%j = 0;

%% Eyetracking    
% Segun Hutterman 2013
% .." cuando un sujeto fallaba en mantener la fijacion en la cruz de
% fijacion al comienza de cada trial, ese trial se descartaba para el 
% analisis posterior"
%Track lo que dure la presentacion de las pistas y los targets
%limpio el buffer
%Declara las constantes del sistema
global CRS;
if isempty(CRS); crsLoadConstants; end;

%Seteo el dispostivo del estimulo a Dual-VGA, dos monitores
%Chequear si seria una mejor opcion CRS.deUser
vetSetStimulusDevice(CRS.deVGA);

%Seleciona una fuente de video a video source
errorCode = vetSelectVideoSource(CRS.vsUserSelect);
if(errorCode<0); error('Video Source not selected.');
end;

%Crea un display que muestra en vivo los ojos del sujeto para poder
%posicionar la camara adecuadamente
vetCreateCameraScreen;

%----------------------------------------------------------------------
%                       Experimental loop
%----------------------------------------------------------------------
descanso = 1;
for i = 1:trials
    
    %Descanso 30 segundos cada 60 trials
    
    if i == descanso*60
        DrawFormattedText(window, 'Unos segundos de descanso...', 'center', 'center', negro);
        Screen('Flip', window);
        java.lang.Thread.sleep(30000)
        DrawFormattedText(window, 'Presionar Cualquier Tecla para Comenzar', 'center', 'center', negro);
        Screen('Flip', window);
        KbStrokeWait;
        descanso = descanso + 1;
    end
    
    
    %Flag para determinar si el sujeto respondio 
    respToBeMadeA = true;
    respToBeMadeB = true; 
    HideCursor;
    
    %Agrego calibracion realizada en el laborarotio
    %para los valores de pixeles por grados
    switch comb(index(1,i),1)
    
        case 0
            comb(index(1,i),2) = round((comb(index(1,i),2))/pixXdeg(2));
            
        case 0.25
            comb(index(1,i),2) = round((comb(index(1,i),2))/pixXdeg(3));
        
        case 0.75
            comb(index(1,i),2) = round((comb(index(1,i),2))/pixXdeg(3));
             
        case 0.5
            comb(index(1,i),2) = round((comb(index(1,i),2))/pixXdeg(1));
            
    end
    %ShowCursor;
    %Screen('Close', window);
 
    %Posicion del est?mulo
    angle = 0 + comb(index(1,i),1)*pi;
    x_est = comb(index(1,i),2)* cos (angle);
    y_est = comb(index(1,i),2)* sin (angle);
    
    %Si es el primer trial presentamos una pantalla de inicio y esperamos
    %por que se presione una tecla
    if i == 1
        DrawFormattedText(window, 'Presionar Cualquier Tecla para Comenzar', 'center', 'center', negro);
        Screen('Flip', window);
        KbStrokeWait;
    end
    
%%Eyetracking    
% Segun Hutterman 2013
% .." cuando un sujeto fallaba en mantener la fijacion en la cruz de
% fijacion al comienza de cada trial, ese trial se descartaba para el 
% analisis posterior"
vetClearDataBuffer;
%comienzo a grabar
vetStartTracking;

HideCursor;

%%
%Presentacion cruz de fijacion por 5000 mseg para eyetracking
if i == 1
numSecs = 5;
    for frame = 1 : round(numSecs / ifi)
        %Dibujar la cruz de fijacion en el centro de la pantalla.
        Screen('DrawLines', window, allCoords, lineWidthPix, negro, [xCenter yCenter]);

        %Flip a la pantalla
        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

    end
end




%Presentacion cruz de fiajcion por 1000 mseg
numSecs = 1;
for frame = 1 : round(numSecs / ifi)
    %Dibujar la cruz de fijacion en el centro de la pantalla.
    %Screen('DrawLines', window, allCoords, lineWidthPix, negro, [xCenter yCenter]);

    %Flip a la pantalla
    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

end


%%%%Presentacion de las pistas por 200 ms
numSecs = 0.200;
for frame = 1:round(numSecs / ifi)

    %Dibujar la pista ciruclar para el observador .
    %Screen('FrameOval', window, blanco, [341 384 341+40 384+40], 4);% [,rect] [,penWidth] [,penHeight] [,penMode]);
    Screen('FrameOval', window, negro, [xCenter+x_est-10 yCenter+y_est-10 xCenter+x_est+10 yCenter+y_est+10], 2);% [,rect] [,penWidth] [,penHeight] [,penMode]);
    %Screen('FrameOval', window, negro, [xCenter-20 yCenter-20 xCenter+20 yCenter+20], 4);% [,rect] [,penWidth] [,penHeight] [,penMode]);
   
    %Dibujar la pista ciruclar para el observador .
    %Screen('FrameOval', window, blanco, [683+341 384 683+341+40 384+40], 4);% [,rect] [,penWidth] [,penHeight] [,penMode]);
    Screen('FrameOval', window, negro, [xCenter-x_est-10 yCenter-y_est-10 xCenter-x_est+10 yCenter-y_est+10], 2);% [,rect] [,penWidth] [,penHeight] [,penMode]);
    
    %Fijacion
    Screen('DrawLines', window, allCoords, lineWidthPix, negro, [xCenter yCenter]);

    %Flip a la pantalla
    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

end

%%%%%%%%Presentacion de blanco por 200 ms 
for frame = 1:round(numSecs / ifi)
    
    %Fijacion
    Screen('DrawLines', window, allCoords, lineWidthPix, negro, [xCenter yCenter]);
    
    %Flip a la pantalla
    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

end

dstRects_R = nan(4, 4);
%Rect derecho
dstRects_R(:, 1) = CenterRectOnPointd(baseRect, xCenter+x_est-size_pix/2, yCenter+y_est-size_pix/2);
dstRects_R(:, 2) = CenterRectOnPointd(baseRect, xCenter+x_est+size_pix/2+size_gap_pix, yCenter+y_est-size_pix/2);
dstRects_R(:, 3) = CenterRectOnPointd(baseRect, xCenter+x_est-size_pix/2, yCenter+y_est+size_pix/2+size_gap_pix);
dstRects_R(:, 4) = CenterRectOnPointd(baseRect, xCenter+x_est+size_pix/2+size_gap_pix, yCenter+y_est+size_pix/2+size_gap_pix);
%Rect izquierdo
dstRects_L = nan(4, 4);
dstRects_L(:, 1) = CenterRectOnPointd(baseRect, xCenter-x_est-size_pix/2, yCenter-y_est-size_pix/2);
dstRects_L(:, 2) = CenterRectOnPointd(baseRect, xCenter-x_est+size_pix/2+size_gap_pix, yCenter-y_est-size_pix/2);
dstRects_L(:, 3) = CenterRectOnPointd(baseRect, xCenter-x_est-size_pix/2, yCenter-y_est+size_pix/2+size_gap_pix);
dstRects_L(:, 4) = CenterRectOnPointd(baseRect, xCenter-x_est+size_pix/2+size_gap_pix, yCenter-y_est+size_pix/2+size_gap_pix);
%Indice para las texturas
index_C = [1 2 3 4];
index_R = [randsample(index_C,1) randsample(index_C,1) randsample(index_C,1) randsample(index_C,1)];
index_L = [randsample(index_C,1) randsample(index_C,1) randsample(index_C,1) randsample(index_C,1)];    

%%%%%%%%Presentacion de targets por 300 ms 
if i == 1
    numSecs = 5.300;
else
    numSecs = 0.300;
end
for frame = 1:round(numSecs / ifi)
      
    texture_vector = [texture_cell{index_R(1)} texture_cell{index_R(2)} texture_cell{index_R(3)} texture_cell{index_R(4)}]; 
    Screen('DrawTextures', window, texture_vector, [], dstRects_R, 0);
    %index = vector(randperm(length(index)));
    texture_vector = [texture_cell{index_L(1)} texture_cell{index_L(2)} texture_cell{index_L(3)} texture_cell{index_L(4)}];   
    Screen('DrawTextures', window, texture_vector, [], dstRects_L, 0);
    %Screen('FrameOval', window, blanco, [xCenter+x_est yCenter+y_est xCenter+x_est+40 yCenter+y_est+40], 4);
    %Screen('FrameOval', window, blanco, [xCenter-x_est yCenter-y_est xCenter-x_est+40 yCenter-y_est+40], 4);
    %Fijacion
    Screen('DrawLines', window, allCoords, lineWidthPix, negro, [xCenter yCenter]);
    %Flip a la pantalla
    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

end

%dejar de grabar
vetStopTracking;
%recuperar los datos del lugar de  fijacion  the recorded eye positions
remove = false;
eye_track_data = vetGetBufferedEyePositions(remove);

%Cantidad de triangulo grises claro posicion 1
nTRI_R = sum(index_R == 4);

%Cantidad de triangulo grises claro posicion 2
nTRI_L = sum(index_L == 4);


%%%%Preguntas al sujeto
line1 = ' Cuantos triangulos gris claro';
line2 = ' se presentaron en la ';
line3 = ' posicion 1?';
line4 = ' posicion 2?'; 


%%%%Rectangulos destinos de los botones para la respuesta
%baseRectResp = [0 0 wResp_img/2 hResp_img/2];

baseRectResp = [0 0 size_pix size_pix];

dstRectsResp = nan(4, 5);

dstRectsResp(:, 1) = CenterRectOnPointd(baseRectResp, xCenter+x_est-size_pix/2, yCenter+y_est-size_pix/2);

dstRectsResp(:, 2) = CenterRectOnPointd(baseRectResp, xCenter+x_est+size_pix/2+size_gap_pix, yCenter+y_est-size_pix/2);

dstRectsResp(:, 3) = CenterRectOnPointd(baseRectResp, xCenter+x_est-size_pix/2, yCenter+y_est+size_pix/2+size_gap_pix);

dstRectsResp(:, 4) = CenterRectOnPointd(baseRectResp, xCenter+x_est+size_pix/2+size_gap_pix, yCenter+y_est+size_pix/2+size_gap_pix);

if comb(index(1,i),1)

    dstRectsResp(:, 5) = CenterRectOnPointd(baseRectResp, xCenter+x_est+(size_pix*3/2)+2*size_gap_pix, yCenter+y_est-size_pix/2);

else

    dstRectsResp(:, 5) = CenterRectOnPointd(baseRectResp, xCenter+x_est, yCenter+y_est+size_pix*3/2+size_gap_pix*3/2);

end

%Muestra el cursor
ShowCursor('Arrow');

for frame = 1:numFrames

    %Dibujar la pista ciruclar para el observador .
    %texture_vector = [texture_cell{10}];%texture_cell{6} texture_cell{7} texture_cell{8} texture_cell{9}];
    
    %Screen('DrawLines', window, allCoords, lineWidthPix, negro, [xCenter+x_est+20 yCenter+y_est+20]);
    %Screen('DrawTextures', window, texture_vector, [], [xCenter+x_est+20 yCenter+y_est+20 xCenter+x_est+100 yCenter+y_est+100], 90 );

    %Flip a la pantalla
    %Screen('TextSize', window, 20);
    %DrawFormattedText(window, [line1 line2 line3 ], 'center', xCenter, [1 0 0]);
    %Botones 
    resp_vector = [texture_cell{5} texture_cell{6} texture_cell{7} texture_cell{8} texture_cell{9}];
    Screen('DrawTextures', window, resp_vector, [], dstRectsResp, 0);
    
    
    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    

end


%Respuesta sujeto al estimulo en posicion 1

 while respToBeMadeA == true
      
         %Se monitorea el teclado.
         %[keyIsDown,secs, keyCode] = KbCheck;
         [Resp,esc,keyCode,x,y] = SubjectResp(window);
         
         %Screen('Close', window);
         
         %xcz = 1;
         
         if esc
             respToBeMadeA = false;
             sca;
             
             return   
         elseif x >= dstRectsResp(1, 1)+ screenXpixels &&   x <= dstRectsResp(3, 1)+ screenXpixels && y >= dstRectsResp(2, 1) && y <= dstRectsResp(4, 1)   
             responseA = 0;
             respToBeMadeA = false;
         elseif x >= dstRectsResp(1, 2)+ screenXpixels &&   x <= dstRectsResp(3, 2) + screenXpixels && y >= dstRectsResp(2, 2) && y <= dstRectsResp(4, 2)
             responseA = 1;
             respToBeMadeA = false;
         elseif x >= dstRectsResp(1, 3)+ screenXpixels &&   x <= dstRectsResp(3, 3)+ screenXpixels && y >= dstRectsResp(2, 3) && y <= dstRectsResp(4, 3)
             responseA = 2;
             respToBeMadeA = false;
         elseif x >= dstRectsResp(1, 4)+ screenXpixels &&   x <= dstRectsResp(3, 4)+ screenXpixels && y >= dstRectsResp(2, 4) && y <= dstRectsResp(4, 4)
             responseA = 3;
             respToBeMadeA = false;
         elseif x >= dstRectsResp(1, 5)+ screenXpixels &&   x <= dstRectsResp(3, 5)+ screenXpixels && y >= dstRectsResp(2, 5) && y <= dstRectsResp(4, 5)
             responseA = 4;
             respToBeMadeA = false;
         else
             responseA = 'NAN';
             respToBeMadeA = true;
         end
 
         
 end
 
 
 
%%%%Rectangulos destinos de los botones para la respuesta
dstRectsResp(:, 1) = CenterRectOnPointd(baseRectResp, xCenter-x_est-size_pix/2, yCenter-y_est-size_pix/2);

dstRectsResp(:, 2) = CenterRectOnPointd(baseRectResp, xCenter-x_est+size_pix/2+size_gap_pix, yCenter-y_est-size_pix/2);

dstRectsResp(:, 3) = CenterRectOnPointd(baseRectResp, xCenter-x_est-size_pix/2, yCenter-y_est+size_pix/2+ size_gap_pix);

dstRectsResp(:, 4) = CenterRectOnPointd(baseRectResp, xCenter-x_est+size_pix/2+size_gap_pix, yCenter-y_est+size_pix/2+ size_gap_pix);

%dstRectsResp(:, 5) = CenterRectOnPointd(baseRectResp, xCenter-x_est, yCenter-y_est + size_pix*3/2 +size_gap_pix*3/2);

if comb(index(1,i),1) == 0.5

    dstRectsResp(:, 5) = CenterRectOnPointd(baseRectResp, xCenter-x_est+(size_pix*3/2)+2*size_gap_pix, yCenter-y_est-size_pix/2);

else

    dstRectsResp(:, 5) = CenterRectOnPointd(baseRectResp, xCenter-x_est, yCenter-y_est+size_pix*3/2+size_gap_pix*3/2);

end


for frame = 1:numFrames

    %Dibujar la pista ciruclar para el observador .
    %Screen('DrawLines', window, allCoords, lineWidthPix, negro, [xCenter-x_est+20 yCenter-y_est+20]);           
    
    %Screen('DrawTextures', window, texture_vector, [], [xCenter-x_est+20 yCenter-y_est+20 xCenter-x_est+100 yCenter-y_est+100], 90 );
    
    %Screen('TextSize', window, 20);
    %DrawFormattedText(window, [line1 line2 line4 ], 'center', xCenter, [1 0 0]);
    resp_vector = [texture_cell{5} texture_cell{6} texture_cell{7} texture_cell{8} texture_cell{9}];
    Screen('DrawTextures', window, resp_vector, [], dstRectsResp, 0);
    
    
    
    %Flip a la pantalla
    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

end

%Respuesta sujeto al estimulo en posicion 2

while respToBeMadeB == true
     
        % Se monitorea el teclado.
        [Resp,esc,keyCode,x,y] = SubjectResp(window);
         
        %Screen('Close', window);
        if esc
             respToBeMadeB = false;
             sca;
             return   
         elseif x >= dstRectsResp(1, 1)+ screenXpixels &&   x <= dstRectsResp(3, 1)+ screenXpixels && y >= dstRectsResp(2, 1) && y <= dstRectsResp(4, 1)   
             responseB = 0;
             respToBeMadeB = false;
         elseif x >= dstRectsResp(1, 2)+ screenXpixels &&   x <= dstRectsResp(3, 2)+ screenXpixels && y >= dstRectsResp(2, 2) && y <= dstRectsResp(4, 2)
             responseB = 1;
             respToBeMadeB = false;
         elseif x >= dstRectsResp(1, 3)+ screenXpixels &&   x <= dstRectsResp(3, 3)+ screenXpixels && y >= dstRectsResp(2, 3) && y <= dstRectsResp(4, 3)
             responseB = 2;
             respToBeMadeB = false;
         elseif x >= dstRectsResp(1, 4)+ screenXpixels &&   x <= dstRectsResp(3, 4)+ screenXpixels && y >= dstRectsResp(2, 4) && y <= dstRectsResp(4, 4)
             responseB = 3;
             respToBeMadeB = false;
         elseif x >= dstRectsResp(1, 5)+ screenXpixels &&   x <= dstRectsResp(3, 5)+ screenXpixels && y >= dstRectsResp(2, 5) && y <= dstRectsResp(4, 5)
             responseB = 4;
             respToBeMadeB = false;
         else
             responseB = 'NAN';
             respToBeMadeB = true;
         end

        
end


%%Matriz de respuestas y parametros
respMat (i,1) =  nTRI_R;
respMat (i,2) =  nTRI_L;
respMat (i,3) =  responseA;
respMat (i,4) =  responseB;
respMat (i,5) =  comb(index(1,i),1)*180;

 switch comb(index(1,i),1)
     
     case 0
        respMat (i,6) =  comb(index(1,i),2)*pixXdeg(2);
     case 0.25
        respMat (i,6) =  comb(index(1,i),2)*pixXdeg (3);
     case 0.75    
        respMat (i,6) =  comb(index(1,i),2)*pixXdeg(3);
     case 0.5
        respMat (i,6) =  comb(index(1,i),2)*pixXdeg(1);
     
 
 end

estructura_datos(i).Cantidad_TGC_1 = respMat (i,1);
estructura_datos(i).Cantidad_TGC_2 = respMat (i,2);
estructura_datos(i).Respuesta_A = respMat (i,3);
estructura_datos(i).Respuesta_B = respMat (i,4);
estructura_datos(i).Direccion = respMat (i,5);
estructura_datos(i).Separacion = respMat (i,6);
estructura_datos(i).XGaze_mm = eye_track_data.mmPositions(:,1);
estructura_datos(i).YGaze_mm = eye_track_data.mmPositions(:,2);
estructura_datos(i).Fijacion = eye_track_data.fixation;

   
end
%%Guardar los datos del experimento
dataMatrix = [header; num2cell(respMat)];
filename = strcat(d_datos, obs{1},'_',diahm, '.mat'); 
%save(strcat('D:\Dropbox\Posdoc\Percepcion Deporte\MATLAB\VENTANA ATENCION\Datos\',obs{1},'_',datestr(datetime), '.mat'),'respMat');
save(filename, 'estructura_datos');

%save(filename, 'dataMatrix');

%D:\Dropbox\Posdoc\Percepcion Deporte\MATLAB\VENTANA ATENCION
%Despejo el display de la camara 
vetDestroyCameraScreen;
vetClearDataBuffer;

sca;

catch
    
Priority(0);
    
ShowCursor
    
sca;
    
rethrow(lasterror);
    
end  




    
