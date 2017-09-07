class Smake < Formula
  desc "Portable make program with automake features"
  homepage "https://s-make.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/s-make/smake-1.2.5.tar.bz2"
  sha256 "27566aa731a400c791cd95361cc755288b44ff659fa879933d4ea35d052259d4"

  bottle do
    rebuild 1
    sha256 "ac6482887b4e3d79ae9372fc28ef48b2fafa5e80547de37ce2284de4c557e861" => :sierra
    sha256 "e63bcd616c4645ec024a6631164a4decd74f7c36e93060cba19605d34b5f1386" => :el_capitan
    sha256 "1eecf6ea9fa08f4fa30701b55b35c9e46f4873661ae7ff97f23dbebcd20a7185" => :yosemite
  end

  def install
    # The bootstrap smake does not like -j
    ENV.deparallelize
    # Xcode 9 miscompiles smake if optimization is enabled
    # https://sourceforge.net/p/schilytools/tickets/2/
    ENV.O1 if DevelopmentTools.clang_build_version >= 900

    system "make", "GMAKE_NOWARN=true", "INS_BASE=#{libexec}", "INS_RBASE=#{libexec}", "install"
    bin.install_symlink libexec/"bin/smake"
    man1.install_symlink Dir["#{libexec}/share/man/man1/*.1"]
    man5.install_symlink Dir["#{libexec}/share/man/man5/*.5"]
  end

  test do
    system "#{bin}/smake", "-version"
  end
end
