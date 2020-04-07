class BaidupcsGo < Formula
  desc "The terminal utility for Baidu Network Disk"
  homepage "https://github.com/iikira/BaiduPCS-Go"
  url "https://github.com/iikira/BaiduPCS-Go/archive/v3.6.2.tar.gz"
  sha256 "27c64733e0d4dd276b6a914f521242fd33e97343da58a8b2de73a72c034c2bc7"

  bottle do
    cellar :any_skip_relocation
    sha256 "b853c93fbcd02fd982897bfaa720ad2257e0645d93b9fc6c6fbff51467e947e3" => :catalina
    sha256 "e3c5ffc3ac08d30ca99e98af2f240f4ca3b10d6f49ce5b06bd2a903707a0a025" => :mojave
    sha256 "4ca9d8864e8c9029afd0f3777e3c3cbe11bd6a7f25fdefd48ad140d6d50d3324" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"baidupcs-go", "run", "touch", "test.txt"
    assert_predicate testpath/"test.txt", :exist?
  end
end
