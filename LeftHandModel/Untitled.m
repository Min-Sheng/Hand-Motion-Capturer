COM_Port='COM1';
Baud_Rate=115200;
InputBuffer_Size = 500;
Time_Out=2;
s = serial(COM_Port, ...
                     'BaudRate', Baud_Rate, ...
                     'DataBits', 8, 'StopBits', 1, ...
                     'Parity', 'none', 'FlowControl', 'none', ...
                     'ReadAsyncMode' , 'continuous',...
                     'InputBufferSize', InputBuffer_Size, ...
                     'Timeout',Time_Out);
fclose(s);
fopen(s);
X=1;
pause(1);
while(X<100)
    s.BytesAvailable
    X=X+1;
end
fclose(s);
clear