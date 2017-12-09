class Tracebox < Formula
  desc "Middlebox detection tool"
  homepage "http://www.tracebox.org/"
  revision 2
  head "https://github.com/tracebox/tracebox.git"

  stable do
    url "https://github.com/tracebox/tracebox.git",
        :tag => "v0.4.2",
        :revision => "2e3326500ddf084bf761e83516909538d26240da"

    # Remove for > 0.4.2
    # Upstream commit from 2 Oct 2017 "Remove [--dirty] from the displayed
    # version string"
    patch do
      url "https://github.com/tracebox/tracebox/commit/5ee627c.patch?full_index=1"
      sha256 "af6fda9484e1188acf35c0fb5f871cebc608c8122e5ad1d94569fe30321549cc"
    end
  end

  bottle do
    cellar :any
    sha256 "9e69a0ac8c15151bccc73111b497b6a651b283ebe08835013a189671ca4c6c33" => :high_sierra
    sha256 "ee7690d2ecd0959a33fc1b8d369fd6c9dc17be2ff386cd459acb0b674596cc40" => :sierra
    sha256 "ec922cc8a0a0b4d03854d138c782613c6c52dd6c3b70b9d789af94ceb8fb5e95" => :el_capitan
  end

  needs :cxx11

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "lua"
  depends_on "json-c"

  def install
    ENV.libcxx
    system "autoreconf", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  def caveats; <<~EOS
    Tracebox requires superuser privileges e.g. run with sudo.

    You should be certain that you trust any software you are executing with
    elevated privileges.
    EOS
  end

  test do
    system bin/"tracebox", "-v"
  end
end
