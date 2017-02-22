class Hashcat < Formula
  desc "World's fastest and most advanced password recovery utility"
  homepage "https://hashcat.net/hashcat/"
  url "https://hashcat.net/files_legacy/hashcat-3.10.tar.gz"
  sha256 "3b555e5f7b35ab6a4558bc460f28d80b32f5a211bf9e08d6a1ba1bad5203e3e9"

  bottle do
    rebuild 1
    sha256 "1be4b64c899ff6a1244509b284d8abc573b5e43ee22020454985defac7a704fc" => :sierra
    sha256 "dc076220361a5b5aa7f2b5d7344876f5c4967444dc9b8974eabd14a06588817c" => :el_capitan
    sha256 "d240413993c1ff3d79e12b2f64571a989df537450444a5ece0d04b7b4daaa33a" => :yosemite
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
