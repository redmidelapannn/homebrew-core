class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.15.1.tar.gz"
  sha256 "249dec1c9bc86a4d2382670a0c9a17e59197171ac889c3427bfb2d5929438978"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "25a3b9209ed827d647ee963da6d9b50e5cbd1a63a9cb41d5408a6152de82333b" => :high_sierra
    sha256 "6a47aa29a7996d546999b6ee9b6a2649c994e63665b05dd5e7dbb2d3996452a3" => :sierra
    sha256 "e04fbe8d1e16ea8b6080f05754579f0de6836f64b9b63a916a814186e114ed15" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/direnv/direnv").install buildpath.children
    cd "src/github.com/direnv/direnv" do
      system "make", "install", "DESTDIR=#{prefix}"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"direnv", "status"
  end
end
