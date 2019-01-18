class Tzdiff < Formula
  desc "Displays Timezone differences with localtime in CLI (shell script)"
  homepage "https://github.com/belgianbeer/tzdiff"
  url "https://github.com/belgianbeer/tzdiff/archive/1.0.tar.gz"
  sha256 "a02aa5a5c97471dcdc7588cfd3f3f216c01ff0d518cb2ed2df1553959849ea34"

  bottle do
    cellar :any_skip_relocation
    sha256 "60957a8ed101e2f890aaa552767ae0cd0e738e2ab0e4959cec24cb3f207e043b" => :mojave
    sha256 "917e486bc04abc8bdeb00e7c9cbb31f7e63940601c6d7e26ede6c9c09d064c0f" => :high_sierra
    sha256 "917e486bc04abc8bdeb00e7c9cbb31f7e63940601c6d7e26ede6c9c09d064c0f" => :sierra
  end

  def install
    bin.install "tzdiff"
    man1.install "tzdiff.1"
  end

  test do
    system "#{bin}/tzdiff", "Tokyo"
  end
end
