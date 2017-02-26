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
    sha256 "3b5b2b169ab31ab3510b80ce83f1f1a8a87f38e663b98421eaeb72bc44c66254" => :sierra
    sha256 "ee78b30954572649b1be730ed070e110d796009a2a33ad1544adc86cd7381f3f" => :el_capitan
    sha256 "e963a5aefc45ed404045d928956f8ce191a1e38b29ed880085570de9783cf5f1" => :yosemite
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
