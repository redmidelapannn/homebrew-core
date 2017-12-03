class F3 < Formula
  desc "Test various flash cards"
  homepage "http://oss.digirati.com.br/f3/"
  url "https://github.com/AltraMayor/f3/archive/v6.0.tar.gz"
  sha256 "d72addb15809bc6229a08ac57e2b87b34eac80346384560ba1f16dae03fbebd5"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f475ae160e0a58772d0094e98549649034b86d9b626bad871cbe7d10b08d4bd0" => :high_sierra
    sha256 "65c9009616afd89fa3852eae780d0c875f53535135d526936c5a13d6438d57b6" => :sierra
    sha256 "a384af9f3df54cb7c2cb8aaa3659f61f445e63f5789793cc00305a9796a71d8a" => :el_capitan
  end

  head do
    url "https://github.com/AltraMayor/f3.git"
    depends_on "argp-standalone"
  end

  def install
    ENV.append "LDFLAGS", "-largp" if build.head?
    system "make", "all"
    bin.install %w[f3read f3write]
    man1.install "f3read.1"
    man1.install_symlink "f3read.1" => "f3write.1"
  end

  test do
    system "#{bin}/f3read", testpath
  end
end
