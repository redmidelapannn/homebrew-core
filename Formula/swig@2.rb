class SwigAT2 < Formula
  desc "Generate scripting interfaces to C/C++ code"
  homepage "http://www.swig.org/"
  url "https://downloads.sourceforge.net/project/swig/swig/swig-2.0.12/swig-2.0.12.tar.gz"
  sha256 "65e13f22a60cecd7279c59882ff8ebe1ffe34078e85c602821a541817a4317f7"

  bottle do
    rebuild 1
    sha256 "0a227fa3f9fb2ac4ee16487338a109cd195a55a8660b559a391a6147ad062d64" => :high_sierra
    sha256 "d907d7e95ab878ce061973ba76aeb6439dd00621aee3b739df4845e0702ff8f7" => :sierra
    sha256 "bf11ec4f41443389ce520cbde780ea01d9ab0b4fa97df756bcc63711eb0bd773" => :el_capitan
  end

  keg_only :versioned_formula

  depends_on "pcre"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
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
    system ENV.cc, "-c", "test_wrap.c", "-I/System/Library/Frameworks/Ruby.framework/Headers/"
    system ENV.cc, "-bundle", "-flat_namespace", "-undefined", "suppress", "test.o", "test_wrap.o", "-o", "test.bundle"
    assert_equal "2", shell_output("/usr/bin/ruby run.rb").strip
  end
end
