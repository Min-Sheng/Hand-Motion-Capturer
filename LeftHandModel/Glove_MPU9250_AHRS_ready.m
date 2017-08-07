COM_Port='COM6';
s = serial(COM_Port);
if(isvalid(s))
    %Clean up and shut it down
    fclose (s);
    delete (s);
    clear s;
end
delete(instrfindall);
InputBuffer_Size = 100;
s = serial(COM_Port);
% s = Bluetooth('H-C-2010-06-01',1);
set(s,'BaudRate',115200);
set(s,'InputBufferSize',InputBuffer_Size);
fopen(s);
t=0;
t0=0;
duration=3600;
number=1;
store_limit=500;
y=[0,0,0,0,0,0,0,0,0,0];
p=[0,0,0,0,0,0,0,0,0,0];
r=[0,0,0,0,0,0,0,0,0,0];
time=[0,0,0,0,0,0,0,0,0,0];
buffer=nan(1,InputBuffer_Size);
data=zeros(1,5);
% First time read
buffer = fscanf(s,'%c',InputBuffer_Size);
data=str2num(buffer)
i=data(:,1)+1;
y(end,i)=data(:,2);
p(end,i)=data(:,3);
r(end,i)=data(:,4);
t0=data(:,5)
time(end,i)=0;
while(t<duration)
    buffer = fscanf(s,'%c',InputBuffer_Size);
    data=str2num(buffer);
    i=data(:,1)+1;
    if(number<=store_limit-1)
        if(time(end)==0)
            y(end,i)=data(:,2);
            p(end,i)=data(:,3);
            r(end,i)=data(:,4);
            t=data(:,5)-t0;
            time(end,i)=t;
        else
            y=[y;zeros(1,10)];
            p=[p;zeros(1,10)];
            r=[r;zeros(1,10)];
            time=[time;zeros(1,10)];
            y(end,i)=data(:,2);
            p(end,i)=data(:,3);
            r(end,i)=data(:,4);
            t=data(:,5)-t0;
            time(end,i)=t
            number=number+1;
        end
    else
         if(time(end)==0)
            y(end,i)=data(:,2);
            p(end,i)=data(:,3);
            r(end,i)=data(:,4);
            t=data(:,5)-t0;
            time(end,i)=t;
        else
            y(1:store_limit,1:10)=[y(2:store_limit,1:10);zeros(1,10)];
            p(1:store_limit,1:10)=[p(2:store_limit,1:10);zeros(1,10)];
            r(1:store_limit,1:10)=[r(2:store_limit,1:10);zeros(1,10)];
            time(1:store_limit,1:10)=[time(2:store_limit,1:10);zeros(1,10)];
            y(end,i)=data(:,2);
            p(end,i)=data(:,3);
            r(end,i)=data(:,4);
            t=data(:,5)-t0;
            time(end,i)=t
            number=number+1;
        end
    end
    t=t+1;
end