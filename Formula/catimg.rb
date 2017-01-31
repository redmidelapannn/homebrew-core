class Catimg < Formula
  desc "Insanely fast image printing in your terminal"
  homepage "https://github.com/posva/catimg"
  url "https://github.com/posva/catimg/archive/v2.2.2.tar.gz"
  sha256 "167118d138c7e5b088584f2fe2406b432ac22e7bd850101785bdf5be4e00a519"
  head "https://github.com/posva/catimg.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cc7a30295e2243395e134414d99362202c5c74d60e00915e70743ec50aecf07f" => :sierra
    sha256 "4e31bd016d46bbc915d116c439aea744f8e55922f81d05755a852c7c4c8045c6" => :el_capitan
    sha256 "5d8d3e9358ef001e7c24199f94a0a0656cfa40c7dfac71e893fe761d642963aa" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    man.mkpath
    man1.install "man/catimg.1"
  end

  test do
    system "#{bin}/catimg", test_fixtures("test.png")
  end
end
