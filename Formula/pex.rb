class Pex < Formula
  desc "Package manager for PostgreSQL"
  homepage "https://github.com/petere/pex"
  url "https://github.com/petere/pex/archive/1.20140409.tar.gz"
  sha256 "5047946a2f83e00de4096cd2c3b1546bc07be431d758f97764a36b32b8f0ae57"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "b72c1c39ceaf9b0d149c464e363a1bd55dc70b433ef8696f1ba80db2d1a0b11a" => :sierra
    sha256 "b72c1c39ceaf9b0d149c464e363a1bd55dc70b433ef8696f1ba80db2d1a0b11a" => :el_capitan
    sha256 "b72c1c39ceaf9b0d149c464e363a1bd55dc70b433ef8696f1ba80db2d1a0b11a" => :yosemite
  end

  depends_on :postgresql

  def install
    system "make", "install", "prefix=#{prefix}", "mandir=#{man}"
  end

  def caveats; <<-EOS.undent
    If installing for the first time, perform the following in order to setup the necessary directory structure:
      pex init
    EOS
  end

  test do
    assert_match "share/pex/packages", shell_output("#{bin}/pex --repo").strip
  end
end
