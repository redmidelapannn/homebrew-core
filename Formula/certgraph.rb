class Certgraph < Formula
  desc "Intelligence tool to crawl the graph of certificate Alternate Names"
  homepage "https://lanrat.github.io/certgraph"
  url "https://github.com/lanrat/certgraph.git",
      :tag => "20180911",
      :revision => "98e0ef1f86b117a84a34c92a6b9197fa7b1d9a58"

  bottle do
    root_url "https://homebrew.bintray.com/bottles"
    cellar :any_skip_relocation
    sha256 "61c5eb25a0e6389246ae5d4f0f83ca99c0ca092ad5fca4b3bfe35471287d4836" => :mojave
    sha256 "5e3af3d229b14ef1131c47677e554a46ce44733c6f3b13bb26dedc3fdf4cf10f" => :high_sierra
    sha256 "4d36fc9023395835b8ad2481ef341e396deee94c5450fe7cc3490f2dc47ed3d4" => :sierra
    sha256 "2ba6d4d97947308f12c91a54abed07db8c1ad535995f1f23826269220bab4249" => :el_capitan
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
