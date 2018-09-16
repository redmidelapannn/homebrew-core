class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https://sourceforge.net/projects/opencubicplayer/"
  url "https://downloads.sourceforge.net/project/opencubicplayer/ocp-0.1.21/ocp-0.1.21.tar.bz2"
  sha256 "d88eeaed42902813869911e888971ab5acd86a56d03df0821b376f2ce11230bf"

  bottle do
    rebuild 1
    sha256 "8f534aca9a2b06c0bd237d0dd6fb57fa3883607433d0803879bd9217ea4184bc" => :mojave
    sha256 "ebbf22fdf976a374a76775b8d2860a832bd8960e8c01549d551588afea41b320" => :high_sierra
    sha256 "6dc1bf20773673b66dad4ed5fa941a0c9b9709c53e1c4eb511ed0c0380545cd7" => :sierra
    sha256 "ad794543191afd91d31944cdafb347448b4379797f6771bc6a07922cfb4fc3aa" => :el_capitan
  end

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
