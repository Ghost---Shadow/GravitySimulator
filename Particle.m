classdef Particle
    properties
        position = [0 0];     % Position of the particle
        displacement = [0 0]; % How much particle has to move
        velocity = [0 0];     % Velocity of the particle       
        mass = 5*10^11;       % Mass of the particle
        id = -1;              % id     
    end
    
    properties(Constant)
        G = 6.67384 * 10^-11; % Universal Gravitational constant
        size = .5;            % Size of the particle  
        dampenning = .5;
    end
    
    methods
        
        % Constructor
        function this = Particle(position,velocity,id)
            this.position = position;
            this.velocity = velocity;
            this.id = id;
        end
        
        % Update the displacement and velocity of a pair of particles
        function particles = update(this,particles,iterations,deltaTime)            
            acceleration = [0 0];      % Reset the acceleration            
            for i=1:length(particles)
                
                % Dont calculate gravity for self wrt self
                if particles(i).id == this.id
                    continue;
                end
                
                % Calculate direction and distance between the other particle
                direction = particles(i).position - this.position;                
                distance = norm(direction);
                direction = direction/distance;      
                
                % Check if particles have collided
                if distance < 2*this.size && i < iterations   
                    
                    % Push the particles back
                    correction = direction*(2*this.size - distance);
                    this.displacement = this.displacement - correction;
                    particles(i).displacement = particles(i).displacement + correction;
                    
                    %reflectedVector = (particles(i).velocity - 2 * dot(particles(i).velocity,direction) * direction);             
                    %this.velocity = particles(i).mass * reflectedVector/this.mass; 
                    
                    % Apply conservation of momentum
                    tempVelocity = this.velocity;
                    this.velocity = this.dampenning * particles(i).mass * particles(i).velocity/this.mass;
                    particles(i).velocity = this.dampenning * this.mass * tempVelocity/particles(i).mass;                    
                end              
                % Calculate acceleration due to gravity
                gravity = this.G*particles(i).mass/(distance*distance);
                
                % Vector addition of all acceleration due to gravity, one               
                % by one
                acceleration = acceleration + gravity * direction;                
            end
            % Vector addition of existing velocity with velocity attained
            % due to gravity in this iteration
            this.velocity = this.velocity + acceleration * deltaTime;
            
            %if norm(this.velocity) > this.maxVelocity
            %    this.velocity = this.maxVelocity*this.velocity/norm(this.velocity);
            %end            
            
            this.displacement = this.velocity * deltaTime; 
            particles(this.id) = this;            
        end
        function this = updatePosition(this)
            this.position = this.position + this.displacement;
        end
    end
end