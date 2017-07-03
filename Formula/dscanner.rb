class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code."
  homepage "https://github.com/dlang-community/Dscanner"
  url "https://github.com/dlang-community/Dscanner.git",
    :tag => "v0.4.0",
    :revision => "87e42ae1941aeda81cc8e6c4343ab3c8d77036cd"

  head "https://github.com/dlang-community/Dscanner.git"

  bottle do
    rebuild 1
    sha256 "8ae41def80477c7c3a8b5027c3570a0998b48ddd375d185362eaa17aefa333ba" => :sierra
    sha256 "768fcc4df17415b0f8194aea231ddd434c08fcb1ab4afd9fd2417ce6a2b86300" => :el_capitan
    sha256 "84f49e5849bf89dfefa64220048e38b5087d8ad3f39bfdcc551509f5ea43b9f2" => :yosemite
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
