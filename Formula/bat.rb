class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.6.0.tar.gz"
  sha256 "3e182844c861cad5e214e504a81930bccf3c3916ee6821a73e932540b1c2de46"

  bottle do
    rebuild 1
    sha256 "55a862d16b7931eb0e73728df1d20fc7cf5e55329da8bed17522c02236ba92c6" => :mojave
    sha256 "b72864da587bb34a11208deeb102b125c1958e60cca30199632559b75f1c7612" => :high_sierra
    sha256 "8d6159b75346aec18978b8e849dc2e8bb9af965fc745d051743084e73406fe38" => :sierra
    sha256 "b4dd214009076a88ba18f0d1962108a1555b54403c084655bc20a5786a9e3066" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output
  end
end
