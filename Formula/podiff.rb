class Podiff < Formula
  desc "Compare textual information in two PO files"
  homepage "https://puszcza.gnu.org.ua/software/podiff/"
  url "https://download.gnu.org.ua/pub/release/podiff/podiff-1.1.tar.gz"
  sha256 "a97480109c26837ffa868ff629a32205622a44d8b89c83b398fb17352b5be6ff"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ee310c3e274f31a852b8cc2d366481baf20eccb4307178d36b9beeefff6c3851" => :sierra
    sha256 "4b6639e2b49884c019923798c2cc26dca6941e631044dc78f989af01874366ba" => :el_capitan
    sha256 "6b74613ed7e39da5501057a0968459e4d7398243107517e636c781b69c1e8fc6" => :yosemite
  end

  def install
    system "make"
    bin.install "podiff"
    man1.install "podiff.1"
  end

  def caveats; <<-EOS.undent
    To use with git, add this to your .git/config or global git config file:

      [diff "podiff"]
      command = #{HOMEBREW_PREFIX}/bin/podiff -D-u

    Then add the following line to the .gitattributes file in
    the directory with your PO files:

      *.po diff=podiff

    See `man podiff` for more information.
    EOS
  end

  test do
    system "#{bin}/podiff", "-v"
  end
end
