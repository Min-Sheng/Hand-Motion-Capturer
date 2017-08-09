function [ qT,qI,qM ]=RestrictedAngle( qT,qI,qM )
    if(qT(1)>10) qT(1)=10;
    elseif(qT(1)<-15) qT(1)=-15;
    end
    if(qT(2)>60) qT(2)=60;
    elseif(qT(2)<-15) qT(2)=-15;
    end
    if(qT(3)>85) qT(3)=85;
    elseif(qT(3)<-25) qT(3)=-25;
    end
    if(qT(4)>5) qT(4)=5;
    elseif(qT(4)<-5) qT(4)=-5;
    end
    if(qT(5)>90) qT(5)=90;
    elseif(qT(5)<-20) qT(5)=-20;
    end

    if(qI(1)>10) qI(1)=10;
    elseif(qI(1)<-10) qI(1)=-10;
    end
    if(qI(2)>90) qI(2)=90;
    elseif(qI(2)<-40) qI(2)=-40;
    end
    if(qI(3)>145) qI(3)=145;
    elseif(qI(3)<-15) qI(3)=-15;
    end
    if(qI(4)>75) qI(4)=75;
    elseif(qI(4)<-10) qI(4)=-10;
    end

    if(qM(1)>10) qM(1)=10;
    elseif(qM(1)<-10) qM(1)=-10;
    end
    if(qM(2)>100) qM(2)=100;
    elseif(qM(2)<-40) qM(2)=-40;
    end
    if(qM(3)>145) qM(3)=145;
    elseif(qM(3)<-15) qM(3)=-15;
    end
    if(qM(4)>75) qM(4)=75;
    elseif(qM(4)<-10) qM(4)=-10;
    end
end

