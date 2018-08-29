class Mage < Formula
  desc "Make/rake-like build tool using Go"
  homepage "https://magefile.org"
  url "https://github.com/magefile/mage/archive/v2.2.0.tar.gz"
  sha256 "9a706d8b351bb395d3baca7ee98856a03f46a33ae3d884281c5841a9b8a4a924"

  bottle do
    cellar :any_skip_relocation
    sha256 "8df37da4f867b120957e5e986e1a84168435fb56f06816959d0b0df0130db72d" => :mojave
    sha256 "822c47f700b651bb9e19290c438fb66980d1d97a7091670508c339ac30856756" => :high_sierra
    sha256 "8024a4cbd85888cf34a950b815b68792e60531a22dd69b10a69902e8db929e9d" => :sierra
    sha256 "3683e9bda0f03fc2a1d53929ed45a87e19cfb49e69ae1444b383da8c989305d3" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/magefile/mage"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "go", "build", "-o", bin/"mage"
    end
  end

  test do
    cd testpath do
      system bin/"mage", "-init"

      # NOTE: install helper library used by mage template.  This allows the following test to run successfully.
      system "go", "get", "github.com/magefile/mage/mg"

      assert_match("installDeps", pipe_output(bin/"mage", "-l"))
    end
  end
end
