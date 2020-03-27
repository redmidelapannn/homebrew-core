class Keydb < Formula
  desc "Multithreaded fork of Redis"
  homepage "https://keydb.dev"
  url "https://github.com/JohnSully/KeyDB/archive/v5.3.3.tar.gz"
  sha256 "07ad8344984ed8c896b75d19863c11cd7e9786220d93c9abaa3a65c34df075a3"

  bottle do
    cellar :any_skip_relocation
    sha256 "51c86035ecdd86fe59b573d749ae8222841780558add264b1990de8794c3fc6b" => :catalina
    sha256 "30876cf91cd777c99e33ab6cad0f734615141eff300d82bc0433f55368ae7d4e" => :mojave
    sha256 "f9615304e1887c551390d60190d2977e0296d816c3eac12067c0930d7b84d496" => :high_sierra
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/keydb-server --test-memory 2")
    assert_match "Your memory passed this test", output
  end
end
