class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.50.2.tar.gz"
  sha256 "86401e3d3db2c98df3103dd3e787ac9cea5ba2570c89063e57f17d87231a305c"
  head "https://github.com/rclone/rclone.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b85f353ed21df7f1ab292b911a69de5458026db28906eb6dcc9e48b92b7e824f" => :catalina
    sha256 "1ad6e714af8ca88f36652dec10552be070390f7139fa05de85bb00370d916387" => :mojave
    sha256 "ac8fe1536899918f1d5337b59eac5bae3848eee5fde606560ea16f66512f1b78" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    mkdir_p buildpath/"src/github.com/rclone/"
    ln_s buildpath, buildpath/"src/github.com/rclone/rclone"
    system "go", "build", "-o", bin/"rclone"
    man1.install "rclone.1"
    system bin/"rclone", "genautocomplete", "bash", "rclone.bash"
    system bin/"rclone", "genautocomplete", "zsh", "_rclone"
    bash_completion.install "rclone.bash" => "rclone"
    zsh_completion.install "_rclone"
  end

  test do
    (testpath/"file1.txt").write "Test!"
    system "#{bin}/rclone", "copy", testpath/"file1.txt", testpath/"dist"
    assert_match File.read(testpath/"file1.txt"), File.read(testpath/"dist/file1.txt")
  end
end
