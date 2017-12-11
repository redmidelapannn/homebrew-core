class Qtads < Formula
  desc "TADS multimedia interpreter"
  homepage "https://qtads.sourceforge.io/"
  revision 1
  head "https://github.com/realnc/qtads.git"

  stable do
    url "https://downloads.sourceforge.net/project/qtads/qtads-2.x/2.1.7/qtads-2.1.7.tar.bz2"
    sha256 "7477bb3cb1f74dcf7995a25579be8322c13f64fb02b7a6e3b2b95a36276ef231"

    # Remove for > 2.1.7
    # fix infinite recursion
    patch do
      url "https://github.com/realnc/qtads/commit/d22054b.patch?full_index=1"
      sha256 "e6af1eb7a8a4af72c9319ac6032a0bb8ffa098e7dd64d76da08ed0c7e50eaa7f"
    end

    # Remove for > 2.1.7
    # fix pointer/integer comparison
    patch do
      url "https://github.com/realnc/qtads/commit/46701a2.patch?full_index=1"
      sha256 "02c86bfa44769ec15844bbefa066360fb83ac923360ced140545fb782f4f3397"
    end

    # Fix "error: ordered comparison between pointer and zero"
    # Reported 11 Dec 2017 https://github.com/realnc/qtads/issues/7
    if DevelopmentTools.clang_build_version >= "900"
      patch do
        url "https://raw.githubusercontent.com/Homebrew/formula-patches/1cbb81b/qtads/xcode9.diff"
        sha256 "1523a181cf45294ec2bb5b261279427c8673d547aae885ee50770d06d2231a6c"
      end
    end
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "752be99b2aa596893c581de412360fcac40bf943e288de812a8b786b000d86d2" => :high_sierra
    sha256 "752be99b2aa596893c581de412360fcac40bf943e288de812a8b786b000d86d2" => :sierra
    sha256 "12ee1171695c843c338371f033d6af0101e88313a374533ba6c7ad7504a339a9" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "qt"
  depends_on "sdl2"
  depends_on "sdl2_mixer"
  depends_on "sdl_sound"

  def install
    sdl_sound_include = Formula["sdl_sound"].opt_include
    inreplace "qtads.pro",
      "INCLUDEPATH += src $$T2DIR $$T3DIR $$HTDIR",
      "INCLUDEPATH += src $$T2DIR $$T3DIR $$HTDIR #{sdl_sound_include}/SDL"

    system "qmake", "DEFINES+=NO_STATIC_TEXTCODEC_PLUGINS"
    system "make"
    prefix.install "QTads.app"
    bin.write_exec_script "#{prefix}/QTads.app/Contents/MacOS/QTads"
    man6.install "share/man/man6/qtads.6"
  end

  test do
    assert_predicate testpath/"#{bin}/QTads", :exist?, "I'm an untestable GUI app."
  end
end
