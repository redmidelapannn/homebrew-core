class Byacc < Formula
  desc "(Arguably) the best yacc variant"
  homepage "https://invisible-island.net/byacc/"
  url "https://invisible-mirror.net/archives/byacc/byacc-20170709.tgz"
  sha256 "27cf801985dc6082b8732522588a7b64377dd3df841d584ba6150bc86d78d9eb"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "14a95e8801b58baec5178ee198186a9be4456fd4e3d201708d8fb0238fdc2ef7" => :high_sierra
    sha256 "e4c9ae47a363aaa4e4672f49ee85a78bd03c8a1801b1e7086781caeb8b92126e" => :sierra
    sha256 "efe3ce56b109ff4f7d7549a4344a57f8f2bb2fc193ce3b4efb7367c31b533c70" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--program-prefix=b", "--prefix=#{prefix}", "--man=#{man}"
    system "make", "install"
  end

  test do
    system bin/"byacc", "-V"
  end
end
