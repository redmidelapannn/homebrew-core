class Libbson < Formula
  desc "BSON utility library"
  homepage "https://github.com/mongodb/libbson"
  url "https://github.com/mongodb/libbson/releases/download/1.4.0/libbson-1.4.0.tar.gz"
  sha256 "1f4e330d40601c4462534684bbc6e868205817c8cee54be8c12d2d73bd02b751"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4d7c730f85d4c10bec1f992f194fae195a75be752a122ba59e9b787c878b689e" => :sierra
    sha256 "9816ae2a6959a76c765101f15a19d9df53e4c58599457c9313cf8f6207454590" => :el_capitan
    sha256 "da1d1f109628ee208788c8ae2d546a1d2f17fca4018e536d4cc206e303bb4497" => :yosemite
  end

  conflicts_with "libmongoc",
                 :because => "libmongoc comes with a bundled libbson"

  def install
    system "./configure", "--enable-silent-rules", "--prefix=#{prefix}"
    system "make", "install"
  end
end
