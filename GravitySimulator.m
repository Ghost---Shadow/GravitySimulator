clc
clear all

opengl hardware

numberOfParticles = 2;
boardSize = 10;
axis([-boardSize boardSize -boardSize boardSize])

hold on
for i=1:numberOfParticles
    % Generate particles at random places
    %particles(i) = Particle([randi([-boardSize boardSize]) randi([-boardSize boardSize])],[0 0],i);
    
    % Generate a particle orbiting another particle
	particles(i) = Particle([0 i*3],[(i-1)*3 0],i);
    particles(i).mass = particles(i).mass + particles(i).mass*(1-i);
    
    % Initialize plotting handles
    handles(i) = plot(0,0,...
        'ko','MarkerFaceColor',[randi([0 10])/10 randi([0 10])/10 randi([0 10])/10],...
        'YDataSource','Y',...
        'XDataSource','X',...
        'markers',16);
end
hold off

deltaTime = 0;
for j = 1:1000
    t0 = clock;    
    
    % Calculate how much each particle should be moved
    for i=1:numberOfParticles
        particles = particles(i).update(particles,i,deltaTime);               
    end
    
    % Update position of particles after all have been calculated
    for i=1:numberOfParticles
        particles(i) = particles(i).updatePosition();
        X = particles(i).position(1);
        Y = particles(i).position(2);
        refreshdata(handles(i),'caller'); 
    end
    drawnow;
    deltaTime = etime(clock,t0);
    t0 = clock;
    %pause(0.1);
end
