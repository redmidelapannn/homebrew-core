class Certgraph < Formula
  desc "Intelligence tool to crawl the graph of certificate Alternate Names"
  homepage "https://lanrat.github.io/certgraph"
  url "https://github.com/lanrat/certgraph.git",
      :tag => "20180911",
      :revision => "98e0ef1f86b117a84a34c92a6b9197fa7b1d9a58"

  bottle do
    cellar :any_skip_relocation
    sha256 "d22173305e900b60cc3837c9ccc8f0fc24ae6a96cee51fc61a090ea7b43fda62" => :mojave
    sha256 "8eb2593465a64017260a22b6f0028199a5078b67a8120f64d2be4ca8fd8bf043" => :high_sierra
    sha256 "a962a0a9805078d7874fea87e715435b6727e353436f0451b67ee1ee12d1295e" => :sierra
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "certgraph"
  end

  test do
    cmd = "#{bin}/certgraph -depth 0 example.com"
    assert_equal "example.com", shell_output(cmd).strip
  end
end
