class Nesc < Formula
  desc "Programming language for deeply networked systems"
  homepage "https://github.com/tinyos/nesc"
  url "https://github.com/tinyos/nesc/archive/v1.3.6.tar.gz"
  sha256 "80a979aacda950c227542f2ddd0604c28f66fe31223c608b4f717e5f08fb0cbf"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4081f8187e845ce5e75356a95518ceb708b874d787a853530076ef767acbd875" => :high_sierra
    sha256 "c357d7c3fee58aee28bfbf40f171fdb010fa6ac6c72ab804abe095ac0bb496d6" => :sierra
    sha256 "2185b73456bde11406004ae7035aeb83fdc75ceee6fc183ccbf0727e9be30347" => :el_capitan
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
