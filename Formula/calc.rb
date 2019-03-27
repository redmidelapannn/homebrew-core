class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "http://www.isthe.com/chongo/src/calc/calc-2.12.7.2.tar.bz2"
  sha256 "57af44181ca3af7348c82ee628cfd221677a09fef11a29d2e5667726d5aafc90"

  bottle do
    sha256 "723060e5c72e718c9cdb01523ff94383de55412a0d3277173fa6c039a393b09c" => :mojave
    sha256 "c39f0b4f5d5f72d4285b85b4344f75ba3bcdd4f0706281d26383df351a4fa297" => :high_sierra
    sha256 "fb3bed441f90696b0ef4f373fe4e4f3dcf83e1bafd735551851492657e33c606" => :sierra
  end

  depends_on "readline"

  def install
    ENV.deparallelize

    ENV["EXTRA_CFLAGS"] = ENV.cflags
    ENV["EXTRA_LDFLAGS"] = ENV.ldflags

    readline = Formula["readline"]

    system "make", "install", "INCDIR=#{MacOS.sdk_path}/usr/include",
                              "BINDIR=#{bin}",
                              "LIBDIR=#{lib}",
                              "MANDIR=#{man1}",
                              "CALC_INCDIR=#{include}/calc",
                              "CALC_SHAREDIR=#{pkgshare}",
                              "USE_READLINE=-DUSE_READLINE",
                              "READLINE_LIB=-L#{readline.opt_lib} -lreadline",
                              "READLINE_EXTRAS=-lhistory -lncurses"
    libexec.install "#{bin}/cscript"
  end

  test do
    assert_equal "11", shell_output("#{bin}/calc 0xA + 1").strip
  end
end
