function [xn,yn,tn] = GovEq(x0, y0, t0, dt)
% Convert Cartesian to Polar
r=(x0^2+y0^2)^.5;
theta=atan(y0/x0);
if x0<0
    theta=theta+pi;
end

% Differential Velocity Equations from streamfunction (in polar)
ur=(1-.25/r^2)*cos(theta);
utheta=-(1+.25/r^2)*sin(theta)/r-sin(3*t0)*sin(4*t0)/r;

% Newton's Method to differentiate streamfunction
rn=r+ur*.01;
thetan=theta+utheta*dt;

% Convert back to Cartesian
xn=rn*cos(thetan);
yn=rn*sin(thetan);
tn=t0+dt;

end