class Htpdate < Formula
  desc "Synchronize time with remote web servers"
  homepage "http://www.vervest.org/htp/"
  url "http://www.vervest.org/htp/archive/c/htpdate-1.2.0.tar.xz"
  sha256 "22b2cf3ec45b0eedecddd3ad2a3d754ac57942ae7dcbac410d254935f0bdbc03"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c33233fa65d82503d7d11fdd2e10e99a22828bba1a247ae67592e222988ecab" => :mojave
    sha256 "91b9033e156f1d69de8e48a3dad90956e88387d25bf85f2d14be6954d276257f" => :high_sierra
  end

  depends_on :macos => :high_sierra # needs <sys/timex.h>

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
