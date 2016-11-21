class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/"
  url "https://www.fossil-scm.org/download/fossil-src-1.35.tar.gz"
  sha256 "c1f92f925a87c9872cb40d166f56ba08b90edbab01a8546ff37025836136ba1d"

  head "https://www.fossil-scm.org/", :using => :fossil

  bottle do
    cellar :any
    rebuild 1
    sha256 "638f68e072947b7571a96e320ef8090f0e690776795ab74ece80d7e4d88e7083" => :sierra
    sha256 "181b4aa8ea29e61a152bb8b12b258442ccd2124b0343c86a24e1a762294f8fb8" => :el_capitan
    sha256 "84b468ffb0ea446478dcdbb4e0befb7cde78ff7b133c93e9cdda5e9ac1f0e9a1" => :yosemite
  end

  option "without-json", "Build without 'json' command support"
  option "without-tcl", "Build without the tcl-th1 command bridge"

  depends_on "openssl"
  depends_on :osxfuse => :optional

  def install
    args = [
      # fix a build issue, recommended by upstream on the mailing-list:
      # https://permalink.gmane.org/gmane.comp.version-control.fossil-scm.user/22444
      "--with-tcl-private-stubs=1",
    ]
    args << "--json" if build.with? "json"

    if MacOS::CLT.installed? && build.with?("tcl")
      args << "--with-tcl"
    else
      args << "--with-tcl-stubs"
    end

    if build.with? "osxfuse"
      ENV.prepend "CFLAGS", "-I/usr/local/include/osxfuse"
    else
      args << "--disable-fusefs"
    end

    system "./configure", *args
    system "make"
    bin.install "fossil"
  end

  test do
    system "#{bin}/fossil", "init", "test"
  end
end
