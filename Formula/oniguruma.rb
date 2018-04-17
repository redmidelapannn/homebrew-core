class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.8.2/onig-6.8.2.tar.gz"
  sha256 "adeada5f6b54c2a6f58ff021831a01b18a62b55ea9935e972e36ebb19e7c4903"

  bottle do
    cellar :any
    sha256 "e7bbd5885d2695ea8488eec1dcf7deed3e17de40eca94bf278820cdb2590cb38" => :high_sierra
    sha256 "f91ef3bdee096c1be69c337328fe4ded134f7010f04ae0261c68e7f4d5e3afab" => :sierra
    sha256 "8ba0df2621715ba6c47d4380fb554f7e6f554d983e1062b16a5ae81c8c99024f" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{prefix}/, shell_output("#{bin}/onig-config --prefix")
  end
end
