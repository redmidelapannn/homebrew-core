class Nesc < Formula
  desc "Programming language for deeply networked systems"
  homepage "https://github.com/tinyos/nesc"
  url "https://github.com/tinyos/nesc/archive/v1.3.6.tar.gz"
  sha256 "80a979aacda950c227542f2ddd0604c28f66fe31223c608b4f717e5f08fb0cbf"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "61734a7a9247994e214a883d7071f8d9a0aa2bc491404a3e6322e71a7648ab38" => :high_sierra
    sha256 "c970be5c91a4631a81b6a98370d8ea23051f94564690cff2f2a1479858722d6f" => :sierra
    sha256 "b93b4cc43079da6643b0d3627b863590ef58e0642021ace8877fd835f72073b2" => :el_capitan
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on :java => :build

  def install
    # nesc is unable to build in parallel because multiple emacs instances
    # lead to locking on the same file
    ENV.deparallelize

    system "./Bootstrap"
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
