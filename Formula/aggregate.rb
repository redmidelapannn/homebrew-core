class Aggregate < Formula
  desc "Optimizes lists of prefixes to reduce list lengths"
  # Note - Freecode is no longer being updated.
  homepage "http://freecode.com/projects/aggregate/"
  url "https://ftp.isc.org/isc/aggregate/aggregate-1.6.tar.gz"
  sha256 "166503005cd8722c730e530cc90652ddfa198a25624914c65dffc3eb87ba5482"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "8683e650fe54987eecf34e3fb2b14abdfd7001d21d8ee262e0bb30e8d751f426" => :sierra
    sha256 "3cdfa2a70ee451556f6ca663042c32ad41a0efb0c784e193ccdaa57eb5457224" => :el_capitan
    sha256 "c29e263d857d016fcc1434cc733182bf2ee3fd69d91f7e933fd8eccb096a0aae" => :yosemite
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
    test_input = <<-EOS.undent
      10.0.0.0/19
      10.0.255.0/24
      10.1.0.0/24
      10.1.1.0/24
      10.1.2.0/24
      10.1.2.0/25
      10.1.2.128/25
      10.1.3.0/25
    EOS

    expected_output = <<-EOS.undent
      10.0.0.0/19
      10.0.255.0/24
      10.1.0.0/23
      10.1.2.0/24
      10.1.3.0/25
    EOS

    assert_equal expected_output, pipe_output("#{bin}/aggregate", test_input), "Test Failed"
  end
end
