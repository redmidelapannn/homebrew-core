class Hashcat < Formula
  desc "World's fastest and most advanced password recovery utility"
  homepage "https://hashcat.net/hashcat/"
  url "https://hashcat.net/files/hashcat-3.30.tar.gz"
  sha256 "3acd1d783f13183c57383069403de0554534ac2b06a30e7e078544e524f940d2"

  bottle do
    sha256 "36cc2009768e8c572a9f3452e1690493e99bf56a2044839f528fdbbbc3a12601" => :sierra
    sha256 "2211740e7e87fe0ca87ef53800a026d17f755d3d80d449e7bead2f1ff03e42d6" => :el_capitan
    sha256 "7a93b71f80fdd687a350a114dfad3b7767cedfc599478f799d32f9f9e93ede0b" => :yosemite
  end

  depends_on "gnu-sed" => :build

  # Upstream could not fix OpenCL issue on Mavericks.
  # https://github.com/hashcat/hashcat/issues/366
  # https://github.com/Homebrew/homebrew-core/pull/4395
  depends_on :macos => :yosemite

  def install
    system "make", "install", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
  end

  test do
    cp_r pkgshare.children, testpath
    cp bin/"hashcat", testpath
    (testpath/"my.dict").write <<-EOS.undent
      foo
      test
      bar
    EOS
    hash = "098f6bcd4621d373cade4e832627b4f6"
    cmd = "./hashcat -m 0 --potfile-disable --quiet #{hash} #{testpath}/my.dict"
    assert_equal "#{hash}:test", shell_output(cmd).chomp
  end
end
