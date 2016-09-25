class Discount < Formula
  desc "C implementation of Markdown"
  homepage "http://www.pell.portland.or.us/~orc/Code/discount/"
  url "http://www.pell.portland.or.us/~orc/Code/discount/discount-2.2.1.tar.bz2"
  sha256 "88458c7c2cfc870f8e6cf42b300408c112e05a45c88f8af35abb33de0e96fe0e"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "377af2991c06156dda0d40540e101281acb777f8d774688a91ca4ec49ac61f66" => :el_capitan
    sha256 "c3911d329abc6fc299857c472c7c66fd865edc0967a7e60243f0c2b09e8da345" => :yosemite
  end

  option "with-fenced-code", "Enable Pandoc-style fenced code blocks."
  option "with-shared", "Install shared library"

  conflicts_with "markdown", :because => "both install `markdown` binaries"
  conflicts_with "multimarkdown", :because => "both install `markdown` binaries"

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --with-dl=Both
      --enable-dl-tag
      --enable-pandoc-header
      --enable-superscript
    ]
    args << "--with-fenced-code" if build.with? "fenced-code"
    args << "--shared" if build.with? "shared"
    system "./configure.sh", *args
    bin.mkpath
    lib.mkpath
    include.mkpath
    system "make", "install.everything"
  end

  test do
    markdown = "[Homebrew](http://brew.sh)"
    html = "<p><a href=\"http://brew.sh\">Homebrew</a></p>"
    assert_equal html, pipe_output(bin/"markdown", markdown, 0).chomp
  end
end
