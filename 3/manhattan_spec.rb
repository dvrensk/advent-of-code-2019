require_relative 'manhattan'

describe Manhattan do
  it { expect(Manhattan::Wire.new("R1,U1").positions).to eq [[1,0],[1,1]] }

  it { expect(Manhattan.min_grid_distance("R8,U5,L5,D3", "U7,R6,D4,L4")).to eq 6 }
  it { expect(Manhattan.min_grid_distance("R75,D30,R83,U83,L12,D49,R71,U7,L72", "U62,R66,U55,R34,D71,R55,D58,R83")).to eq 159 }
  it { expect(Manhattan.min_grid_distance("R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51", "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7")).to eq 135 }

  it { expect(Manhattan.min_wire_distance("R8,U5,L5,D3", "U7,R6,D4,L4")).to eq 30 }
  it { expect(Manhattan.min_wire_distance("R75,D30,R83,U83,L12,D49,R71,U7,L72", "U62,R66,U55,R34,D71,R55,D58,R83")).to eq 610 }
  it { expect(Manhattan.min_wire_distance("R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51", "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7")).to eq 410 }
end
