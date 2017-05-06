# Upstream project has requested we use a mirror as the main URL
# https://github.com/Homebrew/homebrew/pull/21419
class Xz < Formula
  desc "General-purpose data compression with high compression ratio"
  homepage "https://tukaani.org/xz/"
  url "https://fossies.org/linux/misc/xz-5.2.3.tar.gz"
  mirror "https://tukaani.org/xz/xz-5.2.3.tar.gz"
  sha256 "71928b357d0a09a12a4b4c5fafca8c31c19b0e7d3b8ebb19622e96f26dbf28cb"

  bottle do
    cellar :any
    rebuild 1
    sha256 "2894d1a8cfe4990f1b997fa0f9e684d0a93bb1c6fa7bb1b2e36adeaf8e7b0c89" => :sierra
    sha256 "0b86e679e511619c28ea9b9cedd81e93b6ba5f6d8b4cdf92a605211cf0089fd1" => :el_capitan
    sha256 "c34f63f27247445f90ee6424fdd9e2fa181b861c17fb64ae9283ef4317018e81" => :yosemite
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    path = testpath/"data.txt"
    original_contents = "." * 1000
    path.write original_contents

    # compress: data.txt -> data.txt.xz
    system bin/"xz", path
    assert !path.exist?

    # decompress: data.txt.xz -> data.txt
    system bin/"xz", "-d", "#{path}.xz"
    assert_equal original_contents, path.read
  end
end
