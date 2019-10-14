class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https://sourceforge.net/projects/opencubicplayer/"
  url "https://downloads.sourceforge.net/project/opencubicplayer/ocp-0.1.21/ocp-0.1.21.tar.bz2"
  sha256 "d88eeaed42902813869911e888971ab5acd86a56d03df0821b376f2ce11230bf"

  bottle do
    rebuild 1
    sha256 "0027de6c7f165a0461d3496fb77e00f8aa3be238f36c73b29dbb6f15120f561d" => :catalina
    sha256 "871c42fcf0ae627e3f88b933b6e0f112452e726a2dd29846f1555b3b695e7eb3" => :mojave
    sha256 "bed0fbb814e5c0e81b03db5892a86083ff400effd859a556714bd2ac651116d0" => :high_sierra
  end

  depends_on "adplug"
  depends_on "flac"
  depends_on "libvorbis"
  depends_on "mad"

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --without-x11
      --without-sdl
      --without-desktop_file_install
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ocp", "--help"
  end
end
