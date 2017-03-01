# Upstream project has requested we use a mirror as the main URL
# https://github.com/Homebrew/homebrew/pull/21419
class Xz < Formula
  desc "General-purpose data compression with high compression ratio"
  homepage "http://tukaani.org/xz/"
  url "https://fossies.org/linux/misc/xz-5.2.3.tar.gz"
  mirror "http://tukaani.org/xz/xz-5.2.3.tar.gz"
  sha256 "71928b357d0a09a12a4b4c5fafca8c31c19b0e7d3b8ebb19622e96f26dbf28cb"

  bottle do
    cellar :any
    rebuild 1
    sha256 "79a4796f925fc786e96e005418aaf35fa79115b8654917ff2d5baf18401c322e" => :sierra
    sha256 "16c0b0a009fc5850effee580e78f3bcc12c6d4b59a75bd702659ac073d764d62" => :el_capitan
    sha256 "86fc59dc0eaad70eb32e1b4b26c5a6896d1cc73bbfc97bf875eeb792013a1747" => :yosemite
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
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
