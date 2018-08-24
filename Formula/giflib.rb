class Giflib < Formula
  desc "Library and utilities for processing GIFs"
  homepage "https://giflib.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/giflib/giflib-5.1.4.tar.bz2"
  sha256 "df27ec3ff24671f80b29e6ab1c4971059c14ac3db95406884fc26574631ba8d5"
  revision 1

  bottle do
    cellar :any
    sha256 "0bd2799f9326dc4a61652dddd4bac9cabaff0795fc31c3d2f3b7c6eaea8884dd" => :mojave
    sha256 "250915de5db6a37044cb2341299d1099a3d6530f8cccd5101f37751ae3aece5c" => :high_sierra
    sha256 "8562233fdcf07c8d1bc8b0a00654c8e344293afa6fa874b11132d3531e1feca2" => :sierra
    sha256 "36dc6bff0a8c5f9569ba2427a5d935388f93efa7701c80727fa4c8e2103860f6" => :el_capitan
    sha256 "b24a3b1647c0d8184415ee392a5b7f2e6b5046d4aed0ed1b901098b2ac83a9a0" => :yosemite
  end

  # CVE-2016-3977
  # https://sourceforge.net/p/giflib/bugs/102/
  # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=820526
  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/g/giflib/giflib_5.1.4-3.debian.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/g/giflib/giflib_5.1.4-3.debian.tar.xz"
    sha256 "767ea03c1948fa203626107ead3d8b08687a3478d6fbe4690986d545fb1d60bf"
    apply "patches/CVE-2016-3977.patch"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    assert_match /Screen Size - Width = 1, Height = 1/, shell_output("#{bin}/giftext #{test_fixtures("test.gif")}")
  end
end
