function [ result ] = ConvertTimeFormat( t )
hh = fix(t/3600);
mm = fix(rem(t,3600)/60);
ss = rem(t,60);
result = [num2str(hh,'%02d') ':' num2str(mm,'%02d') ':' num2str(ss,'%05.2f')];
end

