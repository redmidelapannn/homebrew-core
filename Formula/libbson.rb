class Libbson < Formula
  desc "BSON utility library"
  homepage "https://github.com/mongodb/libbson"
  # Note: libbson and libmongoc must be kept in sync. Do not update one without updating the other.
  url "https://github.com/mongodb/libbson/releases/download/1.5.0/libbson-1.5.0.tar.gz"
  sha256 "ba49eeebedfc1e403d20abb080f3a67201b799a05f4a012eee94139ad54a6e6f"

  bottle do
    cellar :any
    rebuild 1
    sha256 "dc8134c7c6d03e0f1a88b20d0421f33f04cfd92176e9e1b62ef88485a5b647a6" => :sierra
    sha256 "3a1bc34baf4ba94e0d90a67fbb487a396a09e72239efed24e85efa2213c49d2f" => :el_capitan
    sha256 "e0718e280291bd5ec3ea85ac2d61287f5367fff13502659cfb3fcf61182046e9" => :yosemite
  end

  def install
    system "./configure", "--enable-silent-rules", "--prefix=#{prefix}"
    system "make", "install"
  end
end
