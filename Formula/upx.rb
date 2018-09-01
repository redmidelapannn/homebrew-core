class Upx < Formula
  desc "Compress/expand executable files"
  homepage "https://upx.github.io/"
  url "https://github.com/upx/upx/releases/download/v3.95/upx-3.95-src.tar.xz"
  sha256 "3b0f55468d285c760fcf5ea865a070b27696393002712054c69ff40d8f7f5592"
  head "https://github.com/upx/upx.git", :branch => :devel

  bottle do
    cellar :any_skip_relocation
    sha256 "9d04c25bae099990a5d0782d89023665da6f60ae05ebd2fce0f8cacf8b947f7f" => :mojave
    sha256 "c71200281ea256197cdf380e2f55422dc47070d4786a04f1b88e886bab68c8df" => :high_sierra
    sha256 "23f5f02dc7265ad81468b09c5e39affeeee9c2e227dd58d2c352dea41c509ca2" => :sierra
    sha256 "cdadda8e5fd259d6f8c07180475603713732ce5735e26711c4a885ed1c2c32d4" => :el_capitan
  end

  depends_on "ucl"

  def install
    system "make", "all"
    bin.install "src/upx.out" => "upx"
    man1.install "doc/upx.1"
  end

  test do
    cp "#{bin}/upx", "."
    chmod 0755, "./upx"

    system "#{bin}/upx", "-1", "./upx"
    system "./upx", "-V" # make sure the binary we compressed works
    system "#{bin}/upx", "-d", "./upx"
  end
end
