class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/dlang-community/dfmt"
  url "https://github.com/dlang-community/dfmt.git",
      :tag => "v0.5.0",
      :revision => "fef85e388a41add75020675ab33ed7e55c3efe85"

  head "https://github.com/dlang-community/dfmt.git", :shallow => false

  bottle do
    rebuild 1
    sha256 "f7494f5709a3305cd955c892be601b1919ab5ce262a360c05693b19a9f9929d1" => :high_sierra
    sha256 "5432ad84900c68a110e8c1ad9ff8f028df5e894836d3dd5115968ffcce28b360" => :sierra
    sha256 "f3a6a08126805ffc2e1d5e0bab6e3244e844ac4ef477b10a70e5678cbbdc6696" => :el_capitan
  end

  devel do
    url "https://github.com/dlang-community/dfmt.git",
      :tag => "v0.6.0-alpha.1",
      :revision => "02a735cb0c10d711c5f08fc26572f98bc5fdf0ff"
    version "0.6.0-alpha.1"
  end

  depends_on "dmd" => :build

  def install
    system "make"
    bin.install "bin/dfmt"
  end

  test do
    (testpath/"test.d").write <<-EOS.undent
    import std.stdio; void main() { writeln("Hello, world without explicit compilations!"); }
    EOS

    expected = <<-EOS.undent
    import std.stdio;

    void main()
    {
        writeln("Hello, world without explicit compilations!");
    }
    EOS

    system "#{bin}/dfmt", "-i", "test.d"

    assert_equal expected, (testpath/"test.d").read
  end
end
