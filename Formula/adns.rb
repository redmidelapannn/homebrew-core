class Adns < Formula
  desc "C/C++ resolver library and DNS resolver utilities"
  homepage "https://www.chiark.greenend.org.uk/~ian/adns/"
  url "https://www.chiark.greenend.org.uk/~ian/adns/ftp/adns-1.5.1.tar.gz"
  sha256 "5b1026f18b8274be869245ed63427bf8ddac0739c67be12c4a769ac948824eeb"
  head "git://git.chiark.greenend.org.uk/~ianmdlvl/adns.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7508a9e43b80f7550411219f4780be1a3860c0c0fda1b901174e42c374dc7940" => :sierra
    sha256 "41f77f9125b1e03725635c3672b8456c675f5bf531e1bdab8e8e877f350d3299" => :el_capitan
    sha256 "53fb50727754b517e2feb9e4c21534b7aa82066cba0c71138145da55b8e9dcc7" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dynamic"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/adnsheloex", "--version"
  end
end
