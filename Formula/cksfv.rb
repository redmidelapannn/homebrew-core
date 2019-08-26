class Cksfv < Formula
  desc "File verification utility"
  homepage "https://zakalwe.fi/~shd/foss/cksfv/"
  url "https://zakalwe.fi/~shd/foss/cksfv/files/cksfv-1.3.14.tar.bz2"
  sha256 "8f3c246f3a4a1f0136842a2108568297e66e92f5996e0945d186c27bca07df52"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "05a2c30a659e37e95f8fd8998948f329096d91c5d02f5cfed2c0991a95fb042e" => :mojave
    sha256 "41807cc9efbdf8c9144cff6484ac1975f78aae1e7dde05c92737d911f7e2d91a" => :high_sierra
    sha256 "3783723e1628f52f1088c7cd5401a4dc7679c9db016bd69781605afea7d07a7f" => :sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"foo"
    path.write "abcd"

    assert_match "#{path} ED82CD11", shell_output("#{bin}/cksfv #{path}")
  end
end
