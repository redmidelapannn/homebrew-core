class Cppp < Formula
  desc "Partial Preprocessor for C"
  homepage "http://www.muppetlabs.com/~breadbox/software/cppp.html"
  url "http://www.muppetlabs.com/~breadbox/pub/software/cppp-2.6.tar.gz"
  sha256 "d42cd410882c3b660c77122b232f96c209026fe0a38d819c391307761e651935"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f26cfdf1fbed58ee7f5b01e3f48b3922fa6f4ce751daf1880611639916e5bbc6" => :el_capitan
  end

  def install
    system "make"
    bin.install "cppp"
  end

  test do
    (testpath/"hello.c").write <<~EOS
    /* Comments stand for code */
    #ifdef FOO
    /* FOO is defined */
    # ifdef BAR
    /* FOO & BAR are defined */
    # else
    /* BAR is not defined */
    # endif
    #else
    /* FOO is not defined */
    # ifndef BAZ
    /* FOO & BAZ are undefined */
    # endif
    #endif
    EOS
    system "#{bin}/cppp", "-DFOO", "hello.c"
  end
end
