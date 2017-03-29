class Quex < Formula
  desc "Generate lexical analyzers"
  homepage "http://quex.org/"
  url "https://downloads.sourceforge.net/project/quex/DOWNLOAD/quex-0.67.2.tar.gz"
  sha256 "c48789698f0babd376bf4e70664a2b55a6a7f189c80f21581d800f89b63cfcd3"

  head "https://svn.code.sf.net/p/quex/code/trunk"

  bottle do
    cellar :any_skip_relocation
    sha256 "46a2e9d4c42d9e1a8339c915d654633a2e1ca83c434e73d36714c4616e0c0eea" => :sierra
    sha256 "46a2e9d4c42d9e1a8339c915d654633a2e1ca83c434e73d36714c4616e0c0eea" => :el_capitan
    sha256 "46a2e9d4c42d9e1a8339c915d654633a2e1ca83c434e73d36714c4616e0c0eea" => :yosemite
  end

  def install
    libexec.install "quex", "quex-exe.py"
    doc.install "README", "demo"
    # Use a shim script to set QUEX_PATH on the user's behalf
    (bin+"quex").write <<-EOS.undent
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
    system bin/"quex", "-i", doc/"demo/C/000/simple.qx", "-o", "tiny_lexer"
    File.exist? "tiny_lexer"
  end
end
