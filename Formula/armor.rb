class Armor < Formula
  desc "Simple HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/v0.1.0.tar.gz"
  sha256 "fc06d7fa1b6346dc3ab150d3eea5d85f35108cbd6b97c97ccff3e1732eb56209"
  head "https://github.com/labstack/armor.git"

  bottle do
    sha256 "1360b51fd2da40c923278f3a0fdfb041c6e81dae6664618a8ef2f28621d0fee4" => :sierra
    sha256 "6255da9a8a196e89e5665e65db1885f2fc896eb8fcb2845d2e88cf3e6dcde875" => :el_capitan
    sha256 "de3205a02eb8cba865df953af4abc1469b317077743ac843132daa67421d38d1" => :yosemite
  end

  depends_on "glide"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = buildpath/"glide_home"
    armorpath = buildpath/"src/github.com/labstack/armor"
    armorpath.install buildpath.children

    cd armorpath do
      system "glide", "install"
      system "go", "build", "-o", bin/"armor", "cmd/armor/main.go"
    end
  end

  test do
    system "armor", "-h"
  end
end
