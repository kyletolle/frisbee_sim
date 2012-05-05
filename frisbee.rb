# Class to hold constants
class Physics
    G = -9.81 # Gravity in m/s
    RHO = 1.23 # Air density in kg/m^3
    AREA = 0.0568 # Area of average frisbee
    CLO = 0.1 # Lift Coefficient at Alpha=0
    CLA = 1.4 # Lift Coefficient at Alpha
    CDO = 0.08 # Drag Coeff at Alpha=0
    CDA = 2.72 # Drag Coeff at Alpha
    ALPHA0 = -4.0 # Characterizes angular dependence of drag due to frisbee shape
    M = 0.175 # Average frisbee mass in kg
end

# Frisbee flight simulator
class Flight
  attr_accessor :vx0, :vy0, :x0, :y0, :vx, :vy, :x, :y, :alpha, :cl, :cd, :dt

  def initialize
    begin

      initial_values

      # Open the output file
      @out = File.open("data.rb.dat","w")

    rescue => e
      puts e
      exit
    end

    self.vx = vx0
    self.x = x0
    self.y = y0
    self.vy = vy0

    self.cl = Physics::CLO + Physics::CLA*alpha*(Math::PI/180)

    self.cd = Physics::CDO + Physics::CDA*(((alpha-Physics::ALPHA0)*(Math::PI/180))**2)

    @data = ""
  end

  def run
    output
    # Perform the simulation while the frisbee is still in the air
    while y > 0
      iterate
      output
    end

    # Write the data to the file
    @out << @data
  end

  private
    def params
      # Read in the frisbee's initial conditions
      f = File.open("param.dat")
      # This reads in the single line, breaks it on spaces and converts the
      # values to floats.
      line = f.readline
      line.split.map(&:to_f)
    end

    def initial_values
      self.alpha, self.x0, self.vx0, self.y0, self.vy0, self.dt = params
    end
  
    # Appends new state data to existing data
    def output
      @data << state + "\n"
    end

    # Serialized state data
    def state
      "#{x} #{y} #{vx} #{vy}"
    end

    # Perform the next step of the frisbee simulation
    def iterate
      # Change in horizontal velocity
      deltavx = -(Physics::RHO*(vx**2)*Physics::AREA*cd*dt)
      # Change in vertical velocity
      deltavy = ((Physics::RHO*(vx**2)*Physics::AREA*cl)/(2*Physics::M)+Physics::G)*dt

      # Update the frisbee's velocity and position
      self.vx = vx + deltavx
      self.vy = vy + deltavy
      self.x = x + vx*dt
      self.y = y + vy*dt
    end
end


fribee_sim = Flight.new

fribee_sim.run
