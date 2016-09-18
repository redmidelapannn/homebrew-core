class Ne < Formula
  desc "The nice editor"
  homepage "http://ne.di.unimi.it"
  url "http://ne.di.unimi.it/ne-3.0.1.tar.gz"
  sha256 "92b646dd2ba64052e62deaa4239373821050a03e1b7d09d203ce04f2adfbd0e4"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ff2c8069b2b4f5b37715bcc7743605a8e9ade38f230ebf27a98a46d3c1e2951e" => :sierra
    sha256 "2ecafb130be611d2a4e7bb623e9fda493c0b29ea7ac1e9c4dce5023263c5f413" => :el_capitan
    sha256 "9a5d6bc5a96ab3df88c10e355a53731dd63ea803dd73d9b046b821ac4aaf550b" => :yosemite
  end

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    ENV["TERM"] = "xterm"
    document = testpath/"test.txt"
    macros = testpath/"macros"
    document.write <<-EOS.undent
      This is a test document.
    EOS
    macros.write <<-EOS.undent
      GotoLine 2
      InsertString line 2
      InsertLine
      Exit
    EOS
    system "script", "-q", "/dev/null", bin/"ne", "--macro", macros, document
    assert_equal <<-EOS.undent, document.read
      This is a test document.
      line 2
    EOS
  end
end
