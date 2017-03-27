class Jump < Formula
  desc "Helps you navigate your file system faster by learning your habits."
  homepage "https://github.com/gsamokovarov/jump"
  url "https://github.com/gsamokovarov/jump/archive/v0.11.0.tar.gz"
  sha256 "e3f7f6640fe13f5b482bbbfdd73a133d361d1304d6fb8aee9b45b0875f6b478b"
  head "https://github.com/gsamokovarov/jump.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1dcd613dde11b69a9a56d9c0517bf64931b2c069624991ff30fa1427fbab0853" => :sierra
    sha256 "a03a25c4c11d7218cd2339a0b000e4da988913e646ba36429fff1a515c93113e" => :el_capitan
    sha256 "498b98a86294f5af1b0326bffe7166247abbc0ccac058d5c701fd11ae39c5b8f" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gsamokovarov").mkpath
    ln_s buildpath, buildpath/"src/github.com/gsamokovarov/jump"

    system "go", "build", "-o", "#{bin}/jump"
    man1.install "man/jump.1"
  end

  test do
    (testpath/"test_dir").mkpath
    ENV["JUMP_HOME"] = testpath.to_s
    system "#{bin}/jump", "chdir", "#{testpath}/test_dir"

    assert_equal (testpath/"test_dir").to_s, shell_output("#{bin}/jump cd tdir").chomp
  end
end
