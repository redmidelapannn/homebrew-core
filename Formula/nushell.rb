class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.3.0.tar.gz"
  sha256 "0151f1a09b76c83b7e20932e5e3b0d3af41d32a7862e070ef1b3d5f1163b2876"
  head "https://github.com/nushell/nushell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "22b52171d832c7bedbd9f2b147b7014b319a73cbdfafa5d15983a06e5c40a79a" => :catalina
    sha256 "2ff0fe912d2edf587b2170d07c52ff7d29ba6acf2cf412137a957807541c2876" => :mojave
    sha256 "c5efeeb036976b56022a99f312ea99eedca6175dd016aea2f9899213a4adcf52" => :high_sierra
  end

  depends_on "openssl@1.1"

  # Nu requires features from Rust 1.39 to build, so we can't use Homebrew's
  # Rust; picking a known-good Rust nightly release to use instead.
  resource "rust-nightly" do
    url "https://static.rust-lang.org/dist/2019-09-29/rust-nightly-x86_64-apple-darwin.tar.xz"
    sha256 "20705fd08e2c2706a840f928eceac5f394d29fe34ad566df68ce046d9552dcbf"
  end

  def install
    resource("rust-nightly").stage do
      system "./install.sh", "--prefix=#{buildpath}/rust-nightly"
      ENV.prepend_path "PATH", "#{buildpath}/rust-nightly/bin"
    end
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nu --version")

    assert_equal "#{Dir.pwd}> 2\n#{Dir.pwd}> CTRL-D\n", pipe_output("#{bin}/nu", 'echo \'{"foo":1, "bar":2}\' | from-json | get bar | echo $it')
  end
end
