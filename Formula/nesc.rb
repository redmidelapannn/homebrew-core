class Nesc < Formula
  desc "Programming language for deeply networked systems"
  homepage "https://github.com/tinyos/nesc"
  url "https://github.com/tinyos/nesc/archive/v1.3.6.tar.gz"
  sha256 "80a979aacda950c227542f2ddd0604c28f66fe31223c608b4f717e5f08fb0cbf"

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on :java => :build
  depends_on :emacs => ["21.1", :build]

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "8749562794a765da97d7656bf127c47fcc14b67ef975a7349212736e3c9313b8" => :el_capitan
    sha256 "61618072caa69c144ba5af5714dc2023069ceeae512ebc1e2c099e8bb857517b" => :yosemite
    sha256 "cc34cbda19b6d7f18f81ce000d3966c7b0c343891d4f412b5428ff286e792e4f" => :mavericks
  end

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
