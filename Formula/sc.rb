class Sc < Formula
  desc "Sauce Connect(TM) is a proxy server for Selenium automation."
  homepage "https://wiki.saucelabs.com/display/DOCS/Sauce+Connect+Proxy"
  url "https://saucelabs.com/downloads/sc-4.4.9-osx.zip"
  sha256 "c88731ffe03c1f0c7ff98e0036a467ea5bce1ff757b27b31c85d6e6e219cdfc5"

  bottle do
    cellar :any_skip_relocation
    sha256 "67bbc45b49218fd47a00bb26dfe0b9347291f1d409857348b9a4562a711e6cda" => :high_sierra
    sha256 "67bbc45b49218fd47a00bb26dfe0b9347291f1d409857348b9a4562a711e6cda" => :sierra
    sha256 "67bbc45b49218fd47a00bb26dfe0b9347291f1d409857348b9a4562a711e6cda" => :el_capitan
  end

  def install
    ohai "By installing this formula, you agree to the license.html file included with the installation"
    ohai "See: #{doc}/license.html"
    bin.install Dir["#{buildpath}/bin/sc"]
    doc.install "license.html"
  end

  test do
    output = pipe_output("#{bin}/sc")
    assert_no_match /.*No such file or directory.*/, output
    assert_no_match /.*command not found.*/, output
    assert_match /.*Error, no user specified..*/, output
    output = pipe_output("#{bin}/sc --version")
    assert_match /.*Sauce Connect.*/, output
    output = pipe_output("#{bin}/sc --help")
    assert_match /.*Show usage information.*/, output
  end
end
