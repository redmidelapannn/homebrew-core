class Polyml < Formula
  desc "Standard ML implementation"
  homepage "http://www.polyml.org"
  url "https://github.com/polyml/polyml/archive/v5.6.tar.gz"
  sha256 "20d7b98ae56fe030c64054dbe0644e9dc02bae781caa8994184ea65a94a0a615"
  head "https://github.com/polyml/polyml.git"

  bottle do
    rebuild 1
    sha256 "80188de8b446f3d8913c140a5d863ff3a14f3e573e270fe7543678f1321d9132" => :sierra
    sha256 "5eef9b53ce0f2663f883c77c47291ca332699efd85770bcfdb25d79b240c49cc" => :el_capitan
    sha256 "921ce780e65a9a7f1971c532c1fc3e6e53914431ff6d9a1833f6697fbb7f6d27" => :yosemite
  end

  option "with-x", "With X11/Motif support"

  if build.with? "x"
    depends_on :x11
    depends_on "openmotif"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-debug
      --prefix=#{prefix}
    ]
    if build.with? "x"
      args << "--with-x"
    else
      args << "--without-x"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
