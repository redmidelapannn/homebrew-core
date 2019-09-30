class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://radare.mikelloc.com/get/3.9.0/radare2-3.9.0.tar.gz"
  sha256 "0b912c69fe4e00e6f0c67c5cc547ad3afcf316fc426d0b9c1fe6c3c768e9b6f5"
  head "https://github.com/radare/radare2.git"

  bottle do
    sha256 "2fb44b3bacaf6be99f0b932058a37d617030f7b43554983cbf1f66b581228008" => :mojave
    sha256 "0e7447ce55918fb2782713141a099e307cd72162835c71220099f6f26b609734" => :high_sierra
  end

  def install
    ENV.append "CFLAGS", "-arch #{MacOS.preferred_arch}"
    ENV.append "LDFLAGS", "-arch #{MacOS.preferred_arch}"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -version")
  end
end
