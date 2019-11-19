class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.50.1.tar.gz"
  sha256 "aba9aadd3d20f8684a0150482011a8f9aa36feaf31d987660912378e7892553a"
  head "https://github.com/rclone/rclone.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9e42a40f49641128ac219287b6416c3252227f2f13b65366018ed932abea7262" => :catalina
    sha256 "7ca076e50adaa477ebe638cd8be7c366b31c02572fc2c2ed55794952ac8db8ed" => :mojave
    sha256 "d271ecd9126cdbc3dc367d81874e727248a8312d8df5be5e95815154b9d9a17d" => :high_sierra
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
