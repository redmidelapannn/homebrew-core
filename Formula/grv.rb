class Grv < Formula
  desc "Terminal interface for viewing git repositories"
  homepage "https://github.com/rgburke/grv"
  url "https://github.com/rgburke/grv/releases/download/v0.1.2/grv-0.1.2-src.tar.gz"
  sha256 "81f06796b94791b2b4e10e5c92dabd91bcebab185747446c8f2974539e4ef001"
  head "https://github.com/rgburke/grv.git"

  bottle do
    cellar :any
    sha256 "d852055653b9bd2c6950bea13231d07b9db2cd57c7bb115f09a60a9806db2062" => :high_sierra
    sha256 "5e78fd3be501b65e72d4076bd599127ab1fe5eaa71a76d7009f8d6e5e1fd95d8" => :sierra
    sha256 "4803b6c7cbdb34ad16597de9b654c168a78dc985bc30110d4516f73a90310fc8" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "readline"

  def install
    ENV["GOPATH"] = buildpath
    path = buildpath/"src/github.com/rgburke/grv"
    path.install buildpath.children

    cd path do
      system "make", "build-only"
      bin.install "grv"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/grv -version")
  end
end
