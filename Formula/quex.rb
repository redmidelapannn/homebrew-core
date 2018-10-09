class Quex < Formula
  desc "Generate lexical analyzers"
  homepage "https://quex.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/quex/DOWNLOAD/quex-0.68.2.tar.gz"
  sha256 "b6a9325f92110c52126fec18432d0d6c9bd8a7593bde950db303881aac16a506"
  head "http://svn.code.sf.net/p/quex/code/trunk"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "33f31c6e9b08c0425d5a33c86e8a56767680eb2a3ca4dd22923523d961003ac6" => :mojave
    sha256 "dadb74010c37aeea1aba59618620a056430f0e9caa348fcb60bb9c40049d236f" => :high_sierra
    sha256 "dadb74010c37aeea1aba59618620a056430f0e9caa348fcb60bb9c40049d236f" => :sierra
  end

  def install
    libexec.install "quex", "quex-exe.py"
    doc.install "README", "demo"

    # Use a shim script to set QUEX_PATH on the user's behalf
    (bin/"quex").write <<~EOS
      #!/bin/bash
      QUEX_PATH="#{libexec}" "#{libexec}/quex-exe.py" "$@"
    EOS

    if build.head?
      man1.install "doc/manpage/quex.1"
    else
      man1.install "manpage/quex.1"
    end
  end

  test do
    system bin/"quex", "-i", doc/"demo/C/01-Trivial/simple.qx", "-o", "tiny_lexer"
    assert_predicate testpath/"tiny_lexer", :exist?
  end
end
