function calibracion_eyetracker
% funcion para realizar la calibracion del eyetracker antes de comenzar
% con los exprimentos
% -----------------------------------------------------------------------------
% calibracion_eyetraccker
% La funcion contiene codigo extraido de los demos del eyetracker y codigo
% agregado por Anibal de Paul
% =========================

% Set up the Video Eyetracker.
% -----------------------------------------------------------------------------
% Se declaram las contantes del eye tracker que seran usadas para la
% calibracion. Es una estrutura llamada CRS
  global CRS;

% Si la variable CRS no ha sido inicializada, 
% se llama a la funcion siguente 
  if isempty(CRS); crsLoadConstants; end;
  
% La primera funcion VET. 
% Definimos que estamos usando un monitor secundario de Windows(Dual-VGA)
% para presentar los estimulos 
  vetSetStimulusDevice(CRS.deVGA);

% Seleccionamos la camara a utilizar, 
% en este caso usamos a 60 hz (16 ms) estamos por debajo de
% de la velocida maxima de una sacada (duracion de una sacada de
% desde el inicio con su duracion 220 mseg.)
  errorCode = vetSelectVideoSource(CRS.vsUserSelect);
  if(errorCode<0); error('No se selecionó la fuende de video.'); end;
  
% Crea un pantalla para ver la imagen de la camara. La idea es posicionar el at we can position the camera
% ojo del sujeto para obtener la mejor imagen. Es importante la posicion de 
% la camara para que la pupila y los reflejos de Purkinje puedan ser  
% detectados cuando el sujeto dirige su mirada a las cuatro esquinas de la 
% pantalla. Ajustar el foco de la camara y las luces del laborarotio para 
% evitar reflejos espureos.
  vetCreateCameraScreen;
  
% Esta funcion ejecuta el cuadro de dialogo calibracion

  errorCode = vetCalibrate;
  if(errorCode<0); 
    % Esta funcion libera la ventana de calbracion VGA
    vetSetStimulusDevice(CRS.deUser);

    vetDestroyCameraScreen;
    error('Calibración incompleta.'); 
  end;

  vetSetStimulusDevice(CRS.deUser);
  

end

  
  
  