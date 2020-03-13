class F3 < Formula
  desc "Test various flash cards"
  homepage "https://web.archive.org/web/20200110163924/oss.digirati.com.br/f3/"
  url "https://github.com/AltraMayor/f3/archive/v7.2.tar.gz"
  sha256 "ba9210a0fc3a42c2595fe19bf13b8114bb089c4f274b4813c8f525a695467f64"
  head "https://github.com/AltraMayor/f3.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "080792eb884ee179b86608164d45ac8056cae9d55e87dbb58fbddc82643d3a35" => :catalina
    sha256 "ada4cca33f8eec20af60c9576f77d8bb61f63ae1c6af6f122e798ab603f07999" => :mojave
    sha256 "34355a9ef9970b7da327cfb9d36b68a901b634f111b487f9fadcafff286d5881" => :high_sierra
  end

  depends_on "argp-standalone"

  def install
    system "make", "all", "ARGP=#{Formula["argp-standalone"].opt_prefix}"
    bin.install %w[f3read f3write]
    man1.install "f3read.1"
    man1.install_symlink "f3read.1" => "f3write.1"
  end

  test do
    system "#{bin}/f3read", testpath
  end
end
