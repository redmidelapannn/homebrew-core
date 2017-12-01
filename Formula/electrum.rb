class Electrum < Formula
  desc "Lightweight Bitcoin wallet"
  homepage "https://electrum.org/#home"
  url "https://download.electrum.org/3.0.2/Electrum-3.0.2.tar.gz"
  sha256 "4dff75bc5f496f03ad7acbe33f7cec301955ef592b0276f2c518e94e47284f53"

  bottle do
    cellar :any_skip_relocation
    sha256 "9032701ee860b11fbd3143e08e8807557e774016d731de925585b52604e179d6" => :high_sierra
    sha256 "9032701ee860b11fbd3143e08e8807557e774016d731de925585b52604e179d6" => :sierra
    sha256 "9032701ee860b11fbd3143e08e8807557e774016d731de925585b52604e179d6" => :el_capitan
  end

  depends_on "pyqt"
  depends_on "qt"
  depends_on "gettext"
  depends_on :python3

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"electrum"
  end

  test do
    ENV["LANG"] = "en_US.UTF-8"
    assert_match version.to_s, shell_output("#{bin}/electrum version 2>&1")
  end
end
