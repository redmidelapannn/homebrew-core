class Dfmt < Formula
  desc "Formatter for D source code"
  homepage "https://github.com/Hackerpilot/dfmt"
  url "https://github.com/Hackerpilot/dfmt.git",
      :tag => "v0.4.5",
      :revision => "4fe021df9771d83c325c879012842402a28ca5c7"

  head "https://github.com/Hackerpilot/dfmt.git", :shallow => false

  bottle do
    rebuild 1
    sha256 "2f803591cd958962361360a2bc4fa2cdad2671cafb4d8dd27006e1bbd30ede46" => :sierra
    sha256 "65db8a2730e4aa78591624b4494c6b3a64075acf0eed59e53948c7370d88627d" => :el_capitan
    sha256 "f495ee6b92058881f686e4a88da44b4aff46041ef14eff2141c8aca945315698" => :yosemite
  end

  devel do
    url "https://github.com/Hackerpilot/dfmt.git",
        :tag => "v0.5.0-beta.5",
        :revision => "9fb13d0cafb3a9f0252e7e45277c37c28889731c"
    version "0.5.0-beta5"
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
