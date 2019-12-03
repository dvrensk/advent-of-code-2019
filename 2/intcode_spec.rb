require_relative "intcode"

describe Intcode do
  it { expect(Intcode.run([1,0,0,0,99])).to eq [2,0,0,0,99] } # (1 + 1 = 2).
  it { expect(Intcode.run([2,3,0,3,99])).to eq [2,3,0,6,99] } # (3 * 2 = 6).
  it { expect(Intcode.run([2,4,4,5,99,0])).to eq [2,4,4,5,99,9801] } # (99 * 99 = 9801).
  it { expect(Intcode.run([1,1,1,4,99,5,6,0,99])).to eq [30,1,1,4,2,5,6,0,99] }

  it { expect(Intcode.noun_verb(12,2)).to eq 3895705 }
end
