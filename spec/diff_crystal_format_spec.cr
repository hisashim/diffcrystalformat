require "./spec_helper"

describe DiffCrystalFormat do
  it "has version number" do
    DiffCrystalFormat::VERSION.should match(/\A\d+(?:\.\d+)*\z/)
  end
end
