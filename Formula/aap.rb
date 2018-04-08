class Aap < Formula
  desc "Make-like tool to download, build, and install software"
  homepage "http://www.a-a-p.org"
  url "https://downloads.sourceforge.net/project/a-a-p/aap-1.094.zip"
  sha256 "3f53b2fc277756042449416150acc477f29de93692944f8a77e8cef285a1efd8"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "88afa168b804e81682f76349cf5d41165f948c72c0e04a28e779950999e1402d" => :high_sierra
    sha256 "88afa168b804e81682f76349cf5d41165f948c72c0e04a28e779950999e1402d" => :sierra
    sha256 "88afa168b804e81682f76349cf5d41165f948c72c0e04a28e779950999e1402d" => :el_capitan
  end

  depends_on "python@2"

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
