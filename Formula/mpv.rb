class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.31.0.tar.gz"
  sha256 "805a3ac8cf51bfdea6087a6480c18835101da0355c8e469b6d488a1e290585a5"
  revision 1
  head "https://github.com/mpv-player/mpv.git"

  bottle do
    sha256 "c40d91d3cbab87957bd09138f6fe37be6f5ee3d4ca40d235363cbd5713807e45" => :catalina
    sha256 "f2f13954de52fc4b830b6e6e496d4cf20ef8d9635e40680586506108bb76d761" => :mojave
    sha256 "08e44bb2855446193369cbc7d7ad3990077f44b3914bc180757c0ffa9fa45d6b" => :high_sierra
  end

  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build

  depends_on "ffmpeg"
  depends_on "jpeg"
  depends_on "libarchive"
  depends_on "libass"
  depends_on "little-cms2"
  depends_on "lua@5.1"

  depends_on "mujs"
  depends_on "uchardet"
  depends_on "vapoursynth"
  depends_on "youtube-dl"

  def install
    # LANG is unset by default on macOS and causes issues when calling getlocale
    # or getdefaultlocale in docutils. Force the default c/posix locale since
    # that's good enough for building the manpage.
    ENV["LC_ALL"] = "C"

    args = %W[
      --prefix=#{prefix}
      --enable-html-build
      --enable-javascript
      --enable-libmpv-shared
      --enable-lua
      --enable-libarchive
      --enable-uchardet
      --confdir=#{etc}/mpv
      --datadir=#{pkgshare}
      --mandir=#{man}
      --docdir=#{doc}
      --zshdir=#{zsh_completion}
    ]

    system "python3", "bootstrap.py"
    system "python3", "waf", "configure", *args
    system "python3", "waf", "install"
  end

  test do
    system bin/"mpv", "--ao=null", test_fixtures("test.wav")
  end
end
