class Pkcrack < Formula
  desc "Implementation of an algorithm for breaking the PkZip cipher"
  homepage "https://www.unix-ag.uni-kl.de/~conrad/krypto/pkcrack.html"
  url "https://www.unix-ag.uni-kl.de/~conrad/krypto/pkcrack/pkcrack-1.2.2.tar.gz"
  sha256 "4d2dc193ffa4342ac2ed3a6311fdf770ae6a0771226b3ef453dca8d03e43895a"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "534ca470868eb5c8ddba9d6cad0b32a2b61aa2ce24894bf845b54e8848450b34" => :sierra
    sha256 "73fd9802d53d40ec28d4a8d520e77113e2c6d97116f0ffed825589a9e50d8c9d" => :el_capitan
  end

  conflicts_with "libextractor", :because => "both install `extract` binaries"

  def install
    # Fix "fatal error: 'malloc.h' file not found"
    # Reported 18 Sep 2017 to conrad AT unix-ag DOT uni-kl DOT de
    ENV.prepend "CPPFLAGS", "-I#{MacOS.sdk_path}/usr/include/malloc"

    system "make", "-C", "src/"
    bin.install Dir["src/*"].select { |f| File.executable? f }
  end

  test do
    shell_output("#{bin}/pkcrack", 1)
  end
end
