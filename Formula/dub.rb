class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.7.2.tar.gz"
  sha256 "1801e2d8f0069ad68ef7c63ed44dc3923a8f7617fd3c9db5e5e748846b0d79cb"
  version_scheme 1

  head "https://github.com/dlang/dub.git"

  bottle do
    rebuild 1
    sha256 "cd468bf553e63626aaf5bf586164ec1f0dd24f607ac88044238cba008e33afe2" => :high_sierra
    sha256 "0a27f3f124f07fb9b120caa43938e8c71efa4e11a4b805e23dbf0d35cf1e96af" => :sierra
    sha256 "fabf659afd4b674c3698607862e9cba2385130a23837f7f8233ec67e666ec8be" => :el_capitan
  end

  devel do
    url "https://github.com/dlang/dub/archive/v1.8.0-beta.1.tar.gz"
    sha256 "2eabf29ed93b86e7b8e084ff00ce87ccda2267eabf77c2ce7f9fff9b47226c01"
  end

  depends_on "pkg-config" => [:recommended, :run]
  depends_on "dmd" => :build

  def install
    ENV["GITVER"] = version.to_s
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dub --version").split(/[ ,]/)[2]
  end
end
