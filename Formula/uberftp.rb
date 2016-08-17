class Uberftp < Formula
  desc "Interactive GridFTP client"
  homepage "http://dims.ncsa.illinois.edu/set/uberftp/"
  url "https://github.com/JasonAlt/UberFTP/archive/Version_2_8.tar.gz"
  sha256 "8a397d6ef02bb714bb0cbdb259819fc2311f5d36231783cd520d606c97759c2a"

  bottle do
    cellar :any
    revision 1
    sha256 "1df277607e61a58549de6eaee266add6fdf8aab0ed05dc51d96a7e9054fbe2c9" => :el_capitan
    sha256 "bcc7ce5987b3b7349d874fdf7a4db7af28e8f7109cf3436c49a86f00eb704de8" => :yosemite
    sha256 "dc845baef5730f40e4576b618c3cb7827f3a4cc9cdd5c8fe323dc4a5f0703c59" => :mavericks
  end

  depends_on "globus-toolkit"

  def install
    globus = Formula["globus-toolkit"].opt_prefix

    # patch needed since location changed with globus-toolkit versions>=6.0,
    # patch to upstream is not yet merged
    # (located at https://github.com/JasonAlt/UberFTP/pull/8)
    # but solves not whole problem (needs aditional patch)
    inreplace "configure", "globus_location/include/globus/gcc64dbg", "globus_location/libexec/include"
    inreplace "configure", "globus_location/lib64", "globus_location/libexec/lib"

    system "./configure", "--prefix=#{prefix}",
                          "--with-globus=#{globus}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/uberftp", "-v"
  end
end
