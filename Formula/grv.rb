class Grv < Formula
  desc "Terminal interface for viewing git repositories"
  homepage "https://github.com/rgburke/grv"
  url "https://github.com/rgburke/grv/releases/download/v0.1.1/grv-0.1.1-src.tar.gz"
  sha256 "5cb2a9a35b492df8ad188a294c41a1aecb7d293a0d5241f5e16f8c2613333a15"
  head "https://github.com/rgburke/grv.git"

  bottle do
    cellar :any
    sha256 "df9789b44e6be0127700111abe40f7e6c72b451f29a8ff15cad18523b5e26fd6" => :high_sierra
    sha256 "0c646f4c794b7f0d965d93ad4d79d50322a830118e9751a45cf9281be39ddfaa" => :sierra
    sha256 "14140223fc530124ffcdaff97a634523cb748335a39bb5fcae911a3f7b0b2dc2" => :el_capitan
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
      system "make"
      bin.install "grv"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/grv -version")
  end
end
