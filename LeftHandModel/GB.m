%% Translate the Local System to the Global System
function [output] = GB( gamma, loo )
output=[
     cos(gamma)   -sin(gamma)   0  loo*sin(gamma); 
     sin(gamma)   cos(gamma)   0   loo*cos(gamma); 
              0            0   1                0;
              0            0   0                1];
end