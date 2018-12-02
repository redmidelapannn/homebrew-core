class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark-gfm"
  url "https://github.com/github/cmark-gfm/archive/0.28.3.gfm.19.tar.gz"
  version "0.28.3.gfm.19"
  sha256 "d2c8cb255e227d07533a32cfd4a052e189f697e2a9681d8b17d15654259e2e4b"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e4710b1cd2229faae95ca00061fb4e9b7149821c38a8550127038832c6bec843" => :mojave
    sha256 "33008f0a2b63d9efcb1bd256c365f9692bd6690e653e87b2d157589b4e58d580" => :high_sierra
    sha256 "0f82978c32c0028619af01669a59c13ce736279bf7e5453496ce4e8a3b554236" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "python" => :build

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
