class Jython < Formula
  desc "Python implementation written in Java (successor to JPython)"
  homepage "http://www.jython.org"
  url "https://search.maven.org/remotecontent?filepath=org/python/jython-installer/2.7.1/jython-installer-2.7.1.jar"
  sha256 "6e58dad0b8565b95c6fb14b4bfbf570523d1c5290244cfb33822789fa53b1d25"

  # This isn't accidental; there is actually a compile process here.
  bottle do
    rebuild 1
    sha256 "ce08c9a1c3a227163ea883562c86bd6322e6a062ab93680e5504594c27dcb6af" => :sierra
    sha256 "81b6f1f79f6727a115f62b62cc6215a55660b0da80414aa759fc6b7b2eeeadf5" => :el_capitan
    sha256 "01ea36037a8316d3e92cf3dfb2689399f8cc8194d378501512c4639da157b1ce" => :yosemite
  end

  def install
    system "java", "-jar", cached_download, "-s", "-d", libexec
    bin.install_symlink libexec/"bin/jython"
  end

  test do
    jython = shell_output("#{bin}/jython -c \"from java.util import Date; print Date()\"")
    # This will break in the year 2100. The test will need updating then.
    assert_match jython.match(/20\d\d/).to_s, shell_output("/bin/date +%Y")
  end
end
