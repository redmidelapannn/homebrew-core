class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark"
  url "https://github.com/github/cmark/archive/0.27.1.gfm.3.tar.gz"
  version "0.27.1.gfm.3"
  sha256 "928d3c548267106b59f7a3dfad82489cfb9ce8a17551d8c0c0b44c291923a3bd"

  bottle do
    cellar :any
    sha256 "6acb4ae06e9733fb40767eff82812d2a86925effeedbd8cc9b472bc75f539d0c" => :sierra
    sha256 "7c1050d73d6ec38890bb1c7d35f098082d6259ae5cbf8614e2f12b3fa5c10559" => :el_capitan
    sha256 "a299298d8b1c84011303c42d0793d8cf3846359a2e297da086197e1623097339" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on :python3 => :build

  conflicts_with "cmark", :because => "both install a `cmark.h` header"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "test"
      system "make", "install"
    end
  end

  test do
    output = pipe_output("#{bin}/cmark-gfm --extension autolink", "https://brew.sh")
    assert_equal '<p><a href="https://brew.sh">https://brew.sh</a></p>', output.chomp
  end
end
