class Quex < Formula
  desc "Generate lexical analyzers"
  homepage "https://quex.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/quex/quex-0.69.3.tar.gz"
  sha256 "ad0fbb6bef8116ac312d6ab9e93b444ca5826f9c683a6dae1c1f606cf7e78fcf"
  head "https://svn.code.sf.net/p/quex/code/trunk"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "30c9edda9c58012b587b5df1d199accc33ec1abeb4da392b2c4639e46da1c4cf" => :mojave
    sha256 "30c9edda9c58012b587b5df1d199accc33ec1abeb4da392b2c4639e46da1c4cf" => :high_sierra
    sha256 "9ab6ab0b4bf8dd2b45ef101860db8cd58092d26e9e3ae2011f77ed5c25f7a7c1" => :sierra
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
    system bin/"quex", "-i", doc/"demo/C/01-Trivial/easy.qx", "-o", "tiny_lexer"
    assert_predicate testpath/"tiny_lexer", :exist?
  end
end
