class RustVcprompt < Formula
  desc "Informative version control prompt for your shell"
  homepage "https://github.com/sscherfke/rust-vcprompt"
  url "https://github.com/sscherfke/rust-vcprompt/archive/0.1.0.tar.gz"
  sha256 "3c51261c7b75f04de566d97a95530521f71fb8b99529deab5ce8af97702c7acf"
  head "https://github.com/sscherfke/rust-vcprompt.git"

  bottle do
    sha256 "2148cdd9fe56650b8ee46f6f52388bc4aaeba17df39b43bc0e730a2f02913c17" => :high_sierra
    sha256 "d55e0c12a4f57583f4677f4acf32950c89c5e837bc957ee1fd71c3df1a895fa9" => :sierra
    sha256 "e9045fea892d5095c2d0366e0d20bbaf03963af12ca0459bbc6cc349fbc427a8" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/vcprompt" => "rust-vcprompt"
  end

  test do
    mkdir "repo" do
      system "git", "init"
      ENV.keys.grep(/^VCP_[A-Z]+/).each { |k| ENV.delete(k) }
      assert_equal " ±\e[34mmaster\e[00m|\e[32m\e[01m✔\e[00m\n", shell_output("#{bin}/rust-vcprompt")
    end
  end
end
