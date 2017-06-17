class Aap < Formula
  desc "Make-like tool to download, build, and install software"
  homepage "http://www.a-a-p.org"
  url "https://downloads.sourceforge.net/project/a-a-p/aap-1.094.zip"
  sha256 "3f53b2fc277756042449416150acc477f29de93692944f8a77e8cef285a1efd8"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "be2f664b759495fab9c662e1b73933ba72ecb1377afc62902ffd9ea3c8a36394" => :sierra
    sha256 "dcc2d4a86f0c7e8504ec255331395ad70d7077c3751cf56b0ca8c23cc006f25b" => :el_capitan
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    # Aap is designed to install using itself
    system "./aap", "install", "PREFIX=#{prefix}", "MANSUBDIR=share/man"
  end

  test do
    # A dummy target definition
    (testpath/"main.aap").write("dummy:\n\t:print OK\n")
    system "#{bin}/aap", "dummy"
  end
end
