class SwigAT304 < Formula
  desc "Generate scripting interfaces to C/C++ code"
  homepage "http://www.swig.org/"
  url "https://downloads.sourceforge.net/project/swig/swig/swig-3.0.4/swig-3.0.4.tar.gz"
  sha256 "410ffa80ef5535244b500933d70c1b65206333b546ca5a6c89373afb65413795"

  bottle do
    rebuild 1
    sha256 "67c9aa76794bdde5f337b1815e9a7c409462382528ceb391313f50f63282f493" => :mojave
    sha256 "072d88f3ab968289c74913552126bd72aff4dddedeb65d51d2330e2c6b539dad" => :high_sierra
    sha256 "8881bd4cffd18a5a8f770e9d34556e05fd7775d55063f465c3c42ecb021733e5" => :sierra
  end

  keg_only :versioned_formula

  depends_on "pcre"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      int add(int x, int y)
      {
        return x + y;
      }
    EOS
    (testpath/"test.i").write <<~EOS
      %module test
      %inline %{
      extern int add(int x, int y);
      %}
    EOS
    (testpath/"run.rb").write <<~EOS
      require "./test"
      puts Test.add(1, 1)
    EOS
    system "#{bin}/swig", "-ruby", "test.i"
    system ENV.cc, "-c", "test.c"
    system ENV.cc, "-c", "test_wrap.c", "-I#{MacOS.sdk_path}/System/Library/Frameworks/Ruby.framework/Headers/"
    system ENV.cc, "-bundle", "-flat_namespace", "-undefined", "suppress", "test.o", "test_wrap.o", "-o", "test.bundle"
    assert_equal "2", shell_output("/usr/bin/ruby run.rb").strip
  end
end
