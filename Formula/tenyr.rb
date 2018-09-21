class Tenyr < Formula
  desc "32-bit computing environment (including simulated CPU)"
  homepage "http://tenyr.info/"
  url "https://github.com/kulp/tenyr/archive/v0.9.6.tar.gz"
  sha256 "04b92514927abfb5b7814a203bd296e8b528ae759c755402427db4cbc3ddbc47"
  head "https://github.com/kulp/tenyr.git", :branch => "develop"

  bottle do
    cellar :any
    rebuild 1
    sha256 "67d274fbd3a8ecd07e13dff1c6b0fb1eb3ea2d3a1a5e164920e302642274cb76" => :mojave
  end

  depends_on "bison" => :build # tenyr requires bison >= 2.5
  depends_on "pkg-config" => :build
  depends_on "sdl2_image"

  def install
    system "make", "BISON=#{Formula["bison"].opt_bin}/bison",
                   "JIT=0", "BUILDDIR=build/homebrew"

    pkgshare.install "rsrc", "plugins"
    cd builddir do
      bin.install "tsim", "tas", "tld"
      lib.install Dir["*.dylib"]
    end
  end

  test do
    # sanity test assembler, linker and simulator
    (testpath/"part1").write "B <- 9\n"
    (testpath/"part2").write "C <- B * 3\n"

    system "#{bin}/tas", "--output=a.to", "part1"
    system "#{bin}/tas", "--output=b.to", "part2"
    system "#{bin}/tld", "--output=test.texe", "a.to", "b.to"

    assert_match "C 0000001b", shell_output("#{bin}/tsim -vvvv test.texe 2>&1")
  end
end
