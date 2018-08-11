class Scdoc < Formula
  desc "Tool designed to make the process of writing man pages more friendly"
  homepage "https://git.sr.ht/~sircmpwn/scdoc/"
  url "https://git.sr.ht/~sircmpwn/scdoc/snapshot/scdoc-1.4.1.tar.xz"
  sha256 "2bc96daae0ddfb858305e550eb00a544a7a6255edd0bd169dcb2fc0c035eca92"

  bottle do
    cellar :any_skip_relocation
    sha256 "1470fbdc835ede31d734e734668d15df2fd072ac44ef90319fbf710cb0467297" => :high_sierra
    sha256 "3546dc96b980a1313681dbb63cea9671750fa004a1edcef00a1336117a92bf5c" => :sierra
    sha256 "8f47e0462ed6515c995c14045564bca061f69b4ccdfb30ba814feea5a04518c0" => :el_capitan
  end

  def install
    system "make", "LDFLAGS=", "all"
    bin.install "scdoc"
    man1.install "scdoc.1"
  end

  test do
    (testpath/"test.1.scd").write "thisisatest(1)\n\n# TEST\n\nthis is a test"
    system "#{bin}/scdoc < test.1.scd > test_output.1"
    assert_match "troff", shell_output("file test_output.1")
  end
end
