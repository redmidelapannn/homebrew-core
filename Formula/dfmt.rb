class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/Hackerpilot/dfmt"
  url "https://github.com/Hackerpilot/dfmt.git",
      :tag => "v0.4.5",
      :revision => "4fe021df9771d83c325c879012842402a28ca5c7"

  head "https://github.com/Hackerpilot/dfmt.git", :shallow => false

  bottle do
    rebuild 1
    sha256 "7141e5f8c8f77786e8dfd14c8d5f05ec40cc7cfd6d8b79c3f065169aaaea42c4" => :sierra
    sha256 "d9fdbc33e26e77709ce18687a4a2938d4f378fbe9faf6c04319467eec488323b" => :el_capitan
    sha256 "37d0c574d24ffb9f83052bbd9a6196a83f01b4803fb915e20563e39aaf3a4247" => :yosemite
  end

  devel do
    url "https://github.com/Hackerpilot/dfmt.git",
        :tag => "v0.5.0-beta4",
        :revision => "4a4704896ba960c3ffc22c25b38557d89ce13b79"
    version "0.5.0-beta4"
  end

  depends_on "dmd" => :build

  def install
    if build.stable?
      rmtree "libdparse/experimental_allocator"
    end
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
