# Version is "pre-release", but is what Debian, MacPorts, etc.
# package, and upstream has not had any movement in a long time.
class Iftop < Formula
  desc "Display an interface's bandwidth usage"
  homepage "http://www.ex-parrot.com/~pdw/iftop/"
  url "http://www.ex-parrot.com/pdw/iftop/download/iftop-1.0pre4.tar.gz"
  version "1.0pre4"
  sha256 "f733eeea371a7577f8fe353d86dd88d16f5b2a2e702bd96f5ffb2c197d9b4f97"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "52a20fee5c1d54b5a5d65cdd71a6a9d74b1c13f5998c2f7c2a8685f9f42ebf19" => :sierra
    sha256 "6ab889b82621726a1e2e6f6c1f8ed490be74be1c05800618d542301f6e464038" => :el_capitan
    sha256 "1229bf6e7dfd8c11ab5a2a5d1900c0884c12c3daca7d49a29e46886c2f11859a" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    iftop requires root privileges so you will need to run `sudo iftop`.
    You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    assert_match "interface:", pipe_output("#{sbin}/iftop -t -s 1 2>&1")
  end
end
