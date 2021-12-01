require "./spec_helper"

describe DiffCrystalFormat do
  it "has version number" do
    DiffCrystalFormat::VERSION.should match(/\A\d+(?:\.\d+)*\z/)
  end

  describe ".diffs" do
    it "returns diffs between before and after formatting" do
      src = <<-EOS + "\n"
        p  1
        EOS
      expected = <<-EOS + "\n"
        -p  1
        +p 1
        EOS
      tf = File.tempfile { |f| File.write(f.path, src) }

      actual = DiffCrystalFormat.diffs([tf.path]).map { |diff|
        diff.lines(chomp: false)[3..].join # Skip diff header (first 3 lines).
      }
      actual.should eq [expected]
    end
  end
end
