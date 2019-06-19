class Sshtrix < Formula
  desc "SSH login cracker"
  homepage "https://nullsecurity.net/tools/cracker.html"
  url "https://github.com/nullsecuritynet/tools/raw/master/cracker/sshtrix/release/sshtrix-0.0.3.tar.gz"
  sha256 "30d1d69c1cac92836e74b8f7d0dc9d839665b4994201306c72e9929bee32e2e0"

  bottle do
    cellar :any
    rebuild 1
    sha256 "616ce0f718339ed91f412df65361dd207b5fe05d17f54619dc0652556b9c7bcb" => :mojave
    sha256 "946b05b98a22c0becc8537a3391bb545937b1dd39782d58b433a8ac7925416be" => :high_sierra
    sha256 "7f309515846c174eec35a41659a060eb29ca5caf63398598d5650cada1602494" => :sierra
  end

  depends_on "libssh"

  def install
    bin.mkpath
    system "make", "sshtrix", "CC=#{ENV.cc}"
    system "make", "DISTDIR=#{prefix}", "install"
  end

  test do
    system "#{bin}/sshtrix", "-V"
    system "#{bin}/sshtrix", "-O"
  end
end
