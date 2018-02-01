class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://github.com/rbspy/rbspy"
  url "https://github.com/rbspy/rbspy/archive/v0.1.8.tar.gz"
  sha256 "87f759acd9d660178737b9f24cc07f0113a81a9fffc1604bae2c756d7f4d815b"

  bottle do
    sha256 "dc4e8536412380b155edf14b41f66379596c1c389b73610edd220b6c2697091d" => :high_sierra
    sha256 "06979fcc8f24807dd22221a82a5e91113e334baeac2b0fa2f91294df795ead67" => :sierra
    sha256 "4beee080f596226972d8d0333c89cffd9ea1e2cb5e1ea2d1abfb3972f20fe7a6" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/rbspy"
  end

  test do
    output = shell_output("#{bin}/rbspy -V")
    assert_includes output, "rbspy"
  end
end
