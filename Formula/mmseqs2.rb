class Mmseqs2 < Formula
  desc "Software suite for very fast protein sequence search and clustering"
  homepage "https://mmseqs.org/"
  url "https://github.com/soedinglab/MMseqs2/archive/4-bff50.tar.gz"
  version "4-bff50"
  sha256 "8dbea05ff7ec990377a5d8061d7fceea6332faf572a7dc1d28ad961a165f642f"

  bottle do
    cellar :any
    sha256 "98f179a3b7f70ea6da0fdbed1970c0adda073bd94f838f7c0dc8735afbc1ed58" => :mojave
    sha256 "c8b9f7faf7620a00dab69a765fa6029026fd900ab7f656264a48290e41917ced" => :high_sierra
    sha256 "c2c9ee45c45ac522ad5d4578a432b42607742910fa8b21c0cf87716d4764c883" => :sierra
    sha256 "38a9563d7e800a13934b9a3200dc0e73d9d59ef06ef84d06b7ebdc76b71b8857" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "gcc"

  cxxstdlib_check :skip

  fails_with :clang # needs OpenMP support

  resource "documentation" do
    url "https://github.com/soedinglab/MMseqs2.wiki.git",
        :revision => "d3607c7913e67c7bb553a8dff0cc66eeb3387506"
  end

  def install
    args = *std_cmake_args << "-DHAVE_TESTS=0" << "-DHAVE_MPI=0"
    args << "-DVERSION_OVERRIDE=#{version}"

    args << "-DHAVE_SSE4_1=1" if build.bottle?

    system "cmake", ".", *args
    system "make", "install"

    resource("documentation").stage { doc.install Dir["*"] }
    pkgshare.install "examples"
    bash_completion.install "util/bash-completion.sh" => "mmseqs.sh"
  end

  def caveats
    unless Hardware::CPU.sse4?
      "MMseqs2 requires at least SSE4.1 CPU instruction support. The binary will not work correctly."
    end
  end

  test do
    system "#{bin}/mmseqs", "createdb", "#{pkgshare}/examples/QUERY.fasta", "q"
    system "#{bin}/mmseqs", "cluster", "q", "res", "tmp", "-s", "1"
    assert_predicate testpath/"res", :exist?
    assert_predicate (testpath/"res").size, :positive?
    assert_predicate testpath/"res.index", :exist?
    assert_predicate (testpath/"res.index").size, :positive?
  end
end
