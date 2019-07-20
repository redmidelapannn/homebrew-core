class Ne < Formula
  desc "The nice editor"
  homepage "https://github.com/vigna/ne"
  url "https://github.com/vigna/ne/archive/3.1.2.tar.gz"
  sha256 "bdf09a377660527857bd25217fc91505ae2b19c41590f8a25efc91aef785a3e2"
  head "https://github.com/vigna/ne.git"

  bottle do
    rebuild 1
    sha256 "6bcd448ff7833d6dbac14c646e51fbdb98ae7b5d08dd627e246631eca241a343" => :mojave
    sha256 "8fc7d740b025837084731feb378cee017748cc141892ce2581f842407532655f" => :high_sierra
    sha256 "769fd1fbc5fbd511eb9864d8fccb9e932156c7fabb97f90a1a521e6162edf8df" => :sierra
  end

  depends_on "texinfo" => :build

  def install
    ENV.deparallelize
    cd "src" do
      system "make"
    end
    system "make", "build", "PREFIX=#{prefix}", "install"
  end

  test do
    ENV["TERM"] = "xterm"
    document = testpath/"test.txt"
    macros = testpath/"macros"
    document.write <<~EOS
      This is a test document.
    EOS
    macros.write <<~EOS
      GotoLine 2
      InsertString line 2
      InsertLine
      Exit
    EOS
    system "script", "-q", "/dev/null", bin/"ne", "--macro", macros, document
    assert_equal <<~EOS, document.read
      This is a test document.
      line 2
    EOS
  end
end
