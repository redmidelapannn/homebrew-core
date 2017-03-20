class Discount < Formula
  desc "C implementation of Markdown"
  homepage "http://www.pell.portland.or.us/~orc/Code/discount/"
  url "http://www.pell.portland.or.us/~orc/Code/discount/discount-2.2.2.tar.bz2"
  sha256 "ec7916731e3ef8516336333f8b7aa9e2af51e57c0017b1e03fa43f1ba6978f64"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "851cf996584e24dcfbe4d7c494a5f0e5b0ae7b7e985a47b56680d922e7264758" => :sierra
    sha256 "4f63df32348788845924cd7f3e2854511df4aeae205be09d9243c838d7c2b7f7" => :el_capitan
    sha256 "46e3c90a564e06e10e5f02613e4f626aa51b884d4b11ddc2d0cb1fe9997077e3" => :yosemite
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
    markdown = "[Homebrew](https://brew.sh/)"
    html = "<p><a href=\"https://brew.sh/\">Homebrew</a></p>"
    assert_equal html, pipe_output(bin/"markdown", markdown, 0).chomp
  end
end
