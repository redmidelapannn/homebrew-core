class Colortools < Formula
  desc "List of shell scripts to print system colors and true colors."
  homepage "https://github.com/pvinis/colortools"
  url "https://github.com/pvinis/colortools/releases/download/v0.0.1/colortools-0.0.1.zip"
  sha256 "733f68ebbf942b8ee875f212804a416941962c8845e1cec5127056bd7d31a237"

  bottle do
    cellar :any_skip_relocation
    sha256 "bed8c203254cc8e6743fa6269a62440267b316ecead21ac1c9da10a8b488cf0d" => :el_capitan
    sha256 "a1adaad2764c62e4e1b4967f28d98ed568457f6234cb2053553380f231eb3a2a" => :yosemite
    sha256 "d7d1634d14c03234c8c7b990dbdc1d3567ca8bd9e050d9e47a07e0d1d6563f9d" => :mavericks
  end

  def install
    bin.install Dir["./*"]
  end

  test do
    assert_match "TRUECOLOR", shell_output("#{bin}/ct-true")
  end
end
