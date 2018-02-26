class Aggregate < Formula
  desc "Optimizes lists of prefixes to reduce list lengths"
  homepage "https://web.archive.org/web/20160716192438/freecode.com/projects/aggregate/"
  url "https://ftp.isc.org/isc/aggregate/aggregate-1.6.tar.gz"
  sha256 "166503005cd8722c730e530cc90652ddfa198a25624914c65dffc3eb87ba5482"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "81ab12a3cb2152734049b6e761c2afa42eef989be3f91b0663d94168e0c1596c" => :high_sierra
    sha256 "80f27bcc5e6ddc6540b123bdfe7c94439818345ca33d7bdedd7666ca4e510ab3" => :sierra
    sha256 "af541f0c8afa7aa1a3499dd1e1add5f7f46f81a56fc264909710e7cacffb611e" => :el_capitan
  end

  conflicts_with "crush-tools", :because => "both install an `aggregate` binary"

  def install
    bin.mkpath
    man1.mkpath

    # Makefile doesn't respect --mandir or MANDIR
    inreplace "Makefile.in", "$(prefix)/man/man1", "$(prefix)/share/man/man1"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}",
                   "install"
  end

  test do
    # Test case taken from here: http://horms.net/projects/aggregate/examples.shtml
    test_input = <<~EOS
      10.0.0.0/19
      10.0.255.0/24
      10.1.0.0/24
      10.1.1.0/24
      10.1.2.0/24
      10.1.2.0/25
      10.1.2.128/25
      10.1.3.0/25
    EOS

    expected_output = <<~EOS
      10.0.0.0/19
      10.0.255.0/24
      10.1.0.0/23
      10.1.2.0/24
      10.1.3.0/25
    EOS

    assert_equal expected_output, pipe_output("#{bin}/aggregate", test_input), "Test Failed"
  end
end
