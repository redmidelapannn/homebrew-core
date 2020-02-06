class AntlrAT2 < Formula
  desc "ANother Tool for Language Recognition"
  homepage "https://www.antlr2.org/"
  url "https://www.antlr2.org/download/antlr-2.7.7.tar.gz"
  sha256 "853aeb021aef7586bda29e74a6b03006bcb565a755c86b66032d8ec31b67dbb9"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "c4d1de239fc1d81ad42805cd4b74cc753ebf9fe767720fdace0359c98d55cbc0" => :catalina
    sha256 "b743d7bcd1e650b3a1e26b499e9dc8da2aa8af87e4d8f7c8886ada82d7f7f2d9" => :mojave
    sha256 "184108cef500fdbea750fa646f76b33734bc754b3cf63d237ef5c16341e901ec" => :high_sierra
  end

  keg_only :versioned_formula

  depends_on "openjdk"

  def install
    # C Sharp is explicitly disabled because the antlr configure script will
    # confuse the Chicken Scheme compiler, csc, for a C sharp compiler.
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-csharp"
    system "make"

    libexec.install "antlr.jar"
    include.install "lib/cpp/antlr"
    lib.install "lib/cpp/src/libantlr.a"

    (bin/"antlr").write <<~EOS
      #!/bin/sh
      exec "#{Formula["openjdk"].opt_bin}/java" -classpath #{libexec}/antlr.jar antlr.Tool "$@"
    EOS
  end

  test do
    assert_match "ANTLR Parser Generator   Version #{version}",
      shell_output("#{bin}/antlr --help 2>&1")
  end
end
