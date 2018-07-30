class Cppp < Formula
  desc "Partial Preprocessor for C"
  homepage "https://www.muppetlabs.com/~breadbox/software/cppp.html"
  url "https://www.muppetlabs.com/~breadbox/pub/software/cppp-2.6.tar.gz"
  sha256 "d42cd410882c3b660c77122b232f96c209026fe0a38d819c391307761e651935"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "fbccbfacf99d1a28e21fc2cefff06c168515dcffc562701b7abfc34ad6df3b67" => :high_sierra
    sha256 "104e46ef2919e8b7edaaea225e3758b3795c70a3199ba53e6c81e195f7c3a7a4" => :sierra
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
