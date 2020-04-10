class Antibody < Formula
  desc "The fastest shell plugin manager"
  homepage "https://getantibody.github.io/"
  url "https://github.com/getantibody/antibody/archive/v6.0.1.tar.gz"
  sha256 "dad02a91cbf5715209ca2958dfeb29127f674a00615f80254efc87c33930dbe0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e391afa1cf7cfcff809344f857383a0d48dad5c2fde0d82793cb4c34e3e4feb8" => :catalina
    sha256 "b6f0de61e32fea9cc07af82b41c9057516f7a08b1920c4619191d9a27d96dc14" => :mojave
    sha256 "faa5b861deac5aa878d609a01de7b923fca31450adc4425f44f94d26d4bde857" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath", "-o", bin/"antibody"
  end

  test do
    # See if antibody can install a bundle correctly
    system "#{bin}/antibody", "bundle", "rupa/z"
    assert_match("rupa/z", shell_output("#{bin}/antibody list"))
  end
end
