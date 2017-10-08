class Htpdate < Formula
  desc "Synchronize time with remote web servers"
  homepage "http://www.vervest.org/htp/"
  url "http://www.vervest.org/htp/archive/c/htpdate-1.2.0.tar.xz"
  sha256 "22b2cf3ec45b0eedecddd3ad2a3d754ac57942ae7dcbac410d254935f0bdbc03"

  bottle do
    cellar :any_skip_relocation
    sha256 "536951cf2270af7a03936528dabae3a4bfb2e8dbd334ced928580192cb1462cd" => :high_sierra
    sha256 "f8c6badd478b959fdfc814daf77972efeb804cd314d4b14be5729c64631bfd7f" => :sierra
  end

  def install
    system "make", "prefix=#{prefix}",
                   "STRIP=/usr/bin/strip",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "install"
  end

  test do
    system "#{bin}/htpdate", "-h"
  end
end
