require_relative 'fuel'

describe Fuel do
  it { expect(Fuel.for(12)).to eq 2 }
  it { expect(Fuel.for(14)).to eq 2 }
  it { expect(Fuel.for(42)).to eq 12 }
  it { expect(Fuel.for(1969)).to eq 654 }

  it { expect(Fuel.for(14, 1969)).to eq 656 }
  
  it { expect(Fuel.including_itself(12)).to eq 2 }
  it { expect(Fuel.including_itself(42)).to eq 12 + 2 }
  it { expect(Fuel.including_itself(1969)).to eq 966 }
  it { expect(Fuel.including_itself(100756)).to eq 50346 }
  it { expect(Fuel.including_itself(1969, 100756)).to eq 966 + 50346 }

end
