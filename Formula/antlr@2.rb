class AntlrAT2 < Formula
  desc "ANother Tool for Language Recognition"
  homepage "https://www.antlr2.org/"
  url "https://www.antlr2.org/download/antlr-2.7.7.tar.gz"
  sha256 "853aeb021aef7586bda29e74a6b03006bcb565a755c86b66032d8ec31b67dbb9"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1dfc9bffc2e3e3d88e46ce7c3fa67413834a486dac06532e9357ff54a54ecc05" => :catalina
    sha256 "bb587532f1527077377b245d4db4db28d33ecc1b63a33181487c4efab6528362" => :mojave
    sha256 "b9debfc54b4cee8f3a5a6136fc8d8aeac5f0255fee72008ae872afb1bcc83b12" => :high_sierra
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
