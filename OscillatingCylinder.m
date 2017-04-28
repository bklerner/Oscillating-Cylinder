clear all; close all; clc;
%% Set up Graphics and Video Writer

fig= figure(); ax = axes();
writerObj = VideoWriter('OscillatingCylinder3d.avi');
set(writerObj,'FrameRate',10);
open(writerObj);

%% Preallocate and Initialize Variables
tmax=50; dti=.005; dt=.01; offset=200; psize=.8; ptrack=11; rcil=.5; npoints=15;
yi=linspace(-10,5,npoints)'; % y grid
z=linspace(-5,5,npoints);    % z grid
ti=0:dti:2.5';               % time steps
yp=zeros(length(ti),length(yi)); xp=zeros(length(ti),length(yi)); % particle positions
x=zeros(tmax/dt+1,1); y=zeros(tmax/dt+1,1); x(1)=-4;              %'particle' positions

%% Compute
for q=1:length(ti)
    
    [xc,yc,zc] = cylinder(rcil, 100); zc(1,:)=-3; zc(2,:) = 3; surf(xc,yc,zc); %plot cylinder
    axis equal; xlabel('x'); ylabel('y'); zlabel('z'); hold on; %Initialize axes
    
    for j=1:length(yi) % Step through each time interval
        y(1)=yi(j); t=0; i=2; % Reset tickers and initialize y
        while t<=tmax % For a given time, follow a particle 'trajectory'
            [x(i),y(i)]=GovEq(x(i-1),y(i-1),ti(q),dt);
            if i-offset == q %for a particular particle, record it's position
                xp(q,j)=x(i); yp(q,j)=y(i);
            end
            t=t+dt; i=i+1;
        end
        
        plot3(xp(q,j),yp(q,j),z(j),'o','markeredgecolor','k','markerfacecolor',...
            [psize,psize,psize],'markersize',10); hold on; %Plot particle position
        plot3(x,y,ones(length(x),1)*z(j), 'b'); %plot streamlines
        axis([-3,3,-3,3,-3,3])
        
    end
    
    plot3(xp(2:find(xp==0,1)-1,ptrack),...
        yp(2:find(yp==0,1)-1,ptrack),...
        ones(length(xp(2:find(xp==0,1)-1)),...
        1)*z(11),'r'); % Plot a single streakline
    set(ax,'nextplot','replacechildren'); % Set axis update preferences
    writeVideo( writerObj, getframe(gcf) ); % Write video frame
end
close(writerObj);