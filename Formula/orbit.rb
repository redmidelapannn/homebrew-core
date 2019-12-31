class Orbit < Formula
  desc "CORBA 2.4-compliant object request broker (ORB)"
  homepage "https://projects.gnome.org/ORBit2"
  url "https://download.gnome.org/sources/ORBit2/2.14/ORBit2-2.14.19.tar.bz2"
  sha256 "55c900a905482992730f575f3eef34d50bda717c197c97c08fa5a6eafd857550"
  revision 1

  bottle do
    rebuild 1
    sha256 "395819db6af8805166862f2d55ce3678ddc40303ff11d335f49d258646bd8dec" => :catalina
    sha256 "0cd4c221d1cac74ab76ff29a83e220d3bd9496bb97bd3f1c550e2db87089bcef" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libidl"

  # per MacPorts, re-enable use of deprecated glib functions
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/6b7eaf2b/orbit/patch-linc2-src-Makefile.in.diff"
    sha256 "572771ea59f841d74ac361d51f487cc3bcb2d75dacc9c20a8bd6cbbaeae8f856"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/6b7eaf2b/orbit/patch-configure.diff"
    sha256 "34d068df8fc9482cf70b291032de911f0e75a30994562d4cf56b0cc2a8e28e42"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/orbit2-config --prefix --version")
  end
end
