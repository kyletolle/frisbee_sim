class Action
  attr_accessor :x0, :y0, :vx0, :vy0, :g, :rho, :vx, :vy, :x, :y, :m, :area, :clo, :cla, :cdo, :cda, :alpha0, :alpha, :cl, :cd, :dt

  def initialize
    begin
      f = File.open("param.dat")
      line = f.readline
      self.alpha, self.x0, self.vx0, self.y0, self.vy0, self.dt = line.split.map(&:to_f)

      @out = File.open("data.rb.dat","w")
    rescue => e
      puts e
      exit
    end

    self.g = -9.81
    self.rho = 1.23
    self.area = 0.0568
    self.clo = 0.1
    self.cla = 1.4
    self.cdo = 0.08
    self.cda = 2.72
    self.alpha0 = -4.0

    self.m = 0.175

    self.vx = vx0
    self.x = x0
    self.y = y0
    self.vy = vy0

    self.cl = clo + cla*alpha*(Math::PI/180)

    self.cd = cdo + cda*(((alpha-alpha0)*(Math::PI/180))**2)

    @data = ""
  end

  #TODO: RENAME THIS!
  def print
    values = "#{x} #{y} #{vx} #{vy}"
    @data << values + "\n"
  end

  def run
    print
    while y > 0
      iterate
      print
    end
    @out << @data
  end

  private
    def iterate
      deltavx = -(rho*(vx**2)*area*cd*dt)
      deltavy = ((rho*(vx**2)*area*cl)/(2*m)+g)*dt

      self.vx = vx + deltavx
      self.vy = vy + deltavy
      self.x = x + vx*dt
      self.y = y + vy*dt
    end
end

a = Action.new

a.run
