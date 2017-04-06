class Jython < Formula
  desc "Python implementation written in Java (successor to JPython)"
  homepage "http://www.jython.org"
  url "https://search.maven.org/remotecontent?filepath=org/python/jython-installer/2.7.0/jython-installer-2.7.0.jar"
  sha256 "b44352ece72382268a60e2848741c96609a91d796bb9a9c6ebeff62f0c12c9cf"

  # This isn't accidental; there is actually a compile process here.
  bottle do
    rebuild 1
    sha256 "c33ae4315806f2d5a3de15a8f2e3a26cf81542f2a398266d334d0d6c7535f021" => :sierra
    sha256 "af0ad3658a8e3a0acf7fb9e3e3e9a02b71e2ec76b0105e8947d6f847bc0a5d52" => :el_capitan
    sha256 "5aaf0ebe103c37749104c416ac10541cf2ea305a5611cf8f7fa6817d5e356cfc" => :yosemite
  end

  devel do
    url "https://search.maven.org/remotecontent?filepath=org/python/jython-installer/2.7.1b3/jython-installer-2.7.1b3.jar"
    sha256 "5c6c7dc372a131dbc2b29b95407c69a4ebab22c1823d9098b7f993444f3090c5"
  end

  def install
    system "java", "-jar", cached_download, "-s", "-d", libexec
    bin.install_symlink libexec/"bin/jython"
  end

  test do
    ENV.java_cache

    jython = shell_output("#{bin}/jython -c \"from java.util import Date; print Date()\"")
    # This will break in the year 2100. The test will need updating then.
    assert_match jython.match(/20\d\d/).to_s, shell_output("/bin/date +%Y")
  end
end
