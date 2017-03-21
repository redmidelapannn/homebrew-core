class Nazghul < Formula
  desc "Computer role-playing game engine"
  homepage "https://web.archive.org/web/20130402222926/myweb.cableone.net/gmcnutt/nazghul.html"
  url "https://downloads.sourceforge.net/project/nazghul/nazghul/nazghul-0.7.1/nazghul-0.7.1.tar.gz"
  sha256 "f1b62810da52a116dfc1c407dbe683991b1b380ca611f57b5701cfbb803e9d2b"

  bottle do
    cellar :any
    rebuild 1
    sha256 "840a5e59bdb2229c54fcbaef2772ae73dc629700a48757c671f898098534008e" => :sierra
    sha256 "537c44259317532d4955e00c9e1331731bfbf134b69e2cf909dfde333dfb1bc6" => :el_capitan
    sha256 "efa833a626ed0715261399a4559b97f97fa9b5460b2151a5c465e411aa23ae2a" => :yosemite
  end

  depends_on "sdl"
  depends_on "sdl_image"
  depends_on "sdl_mixer"
  depends_on "libpng"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest",
                          "--bindir=#{libexec}"
    # Not sure why the ifdef is commented out in this file
    inreplace "src/skill.c", "#include <malloc.h>", ""
    system "make", "install"

    # installing into libexec then rewriting the wrapper script so the
    # program name is 'haxima' rather than 'haxima.sh' and there isn't
    # a 'nazghul' executable in bin to confuse the user
    (bin/"haxima").write <<-EOS.undent
      #!/bin/sh
      "/usr/local/Cellar/nazghul/0.7.1/libexec/nazghul" -I "/usr/local/Cellar/nazghul/0.7.1/share/nazghul/haxima" -G "$HOME/.haxima" "$@"
    EOS
  end

  test do
    assert_match version.to_s,
                 shell_output("#{bin}/haxima -v")
  end
end
