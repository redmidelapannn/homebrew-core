class Voms < Formula
  desc "Virtual organization membership service"
  homepage "https://github.com/italiangrid/voms"
  url "https://github.com/italiangrid/voms-clients/archive/v3.0.7.tar.gz"
  sha256 "24cc29f4dc93f048e1cda9003ab8004e5d0ebc245d0139a058e6224bc2ca6ba7"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6e356d97c71c67b54a5896607308d279e1cec2eaad8fd4764dfbfe66e4f70f2c" => :high_sierra
    sha256 "6a9cc9f56fe2a6da569fb1ebffd58f58053b2538233bce543f289254d8c5113a" => :sierra
    sha256 "a38047cf80241268a03c1ca825b2c717ad0a4a1a0d6c0a26ab8719b751cfe6df" => :el_capitan
  end

  depends_on :java
  depends_on "maven" => :build
  depends_on "openssl"

  def install
    system "mvn", "package", "-Dmaven.repo.local=$(pwd)/m2repo/", "-Dmaven.javadoc.skip=true"
    system "tar", "-xf", "target/voms-clients.tar.gz"
    share.install "voms-clients/share/java"
    man5.install Dir["voms-clients/share/man/man5/*.5"]
    man1.install Dir["voms-clients/share/man/man1/*.1"]
    bin.install Dir["voms-clients/bin/*"]
  end

  test do
    system "#{bin}/voms-proxy-info", "--version"
  end
end
