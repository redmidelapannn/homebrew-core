class AntlrAT2 < Formula
  desc "ANother Tool for Language Recognition"
  homepage "https://www.antlr2.org/"
  url "https://www.antlr2.org/download/antlr-2.7.7.tar.gz"
  sha256 "853aeb021aef7586bda29e74a6b03006bcb565a755c86b66032d8ec31b67dbb9"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "182afbeb2ba6cd8c9cd1ca3966371fa63f15daf7f9b0d9e2cdc55a940b516ed6" => :high_sierra
    sha256 "a7fca4457f3770f9c5d485120aef54ea1285010be3a7925c38f7b84d021b5867" => :sierra
    sha256 "5cdd47ca189681788919c666877602928482b1a5c4e11d25bb87423613402403" => :el_capitan
  end

  depends_on :java

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

    (bin/"antlr2").write <<~EOS
      #!/bin/sh
      java -classpath #{libexec}/antlr.jar antlr.Tool "$@"
    EOS
  end

  test do
    assert_match "ANTLR Parser Generator   Version #{version}",
      shell_output("#{bin}/antlr2 --help 2>&1")
  end
end
