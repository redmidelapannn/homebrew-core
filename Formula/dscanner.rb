class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code."
  homepage "https://github.com/Hackerpilot/Dscanner"
  url "https://github.com/Hackerpilot/Dscanner.git",
    :tag => "v0.3.0",
    :revision => "ab08f0b28b2851063e273f5f8073b575a4d17083"

  head "https://github.com/Hackerpilot/Dscanner.git"

  bottle do
    rebuild 1
    sha256 "b5f6cbdffeddf2e17a8ad833ff3d01554157a5beb479d3e6c9b4c8a65538784a" => :sierra
    sha256 "62fb0f5c203ff270aac288fa910c99ba83495431f8d20c6605277c51f6cd8d4c" => :el_capitan
    sha256 "7ed01cd8a18347e03e2798e6c74f367f60e453f79dd90971e2d19b7bd34a76ed" => :yosemite
  end

  devel do
    url "https://github.com/Hackerpilot/Dscanner.git",
      :tag => "v0.4.0-beta.3",
      :revision => "bf3b942b9a102616c4c67611301738883845c906"
    version "0.4.0-beta.3"
  end

  depends_on "dmd" => :build

  def install
    system "make", "dmdbuild"
    bin.install "bin/dscanner"
  end

  test do
    (testpath/"test.d").write <<-EOS.undent
      import std.stdio;
      void main(string[] args)
      {
        writeln("Hello World");
      }
    EOS

    assert_match(/test.d:\t28\ntotal:\t28\n/, shell_output("#{bin}/dscanner --tokenCount test.d"))
  end
end
