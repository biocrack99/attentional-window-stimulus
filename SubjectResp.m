function [Resp,esc,keyCode,x,y]=SubjectResp(windows)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Funcion Presionar Botones
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

esc=0;
[x,y,bot] = GetMouse(windows);
while any(bot) %Wait for release buttons
    [x,y,bot] = GetMouse(windows);
end
escKey = KbName('esc');
[touch, secs, keyCode] = KbCheck;
    while ~any(bot) && ~keyCode(escKey) % wait for press or for esc key
        [touch, secs, keyCode] = KbCheck;
        if keyCode(escKey), esc=1; end
        [x,y,bot] = GetMouse;
    end
    if bot(1), Resp = 'First ';
      elseif bot(3), Resp= 'Second';
      else Resp = 'Otr   ';
    end
end
