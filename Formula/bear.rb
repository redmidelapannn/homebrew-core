class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/2.3.11.tar.gz"
  sha256 "4616237fd63066603793dca3fbf3f2c39e8c75bbe9967bdda103a56f31071cd4"
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9d6e51261d0ad78225ab7409dab000dda7e19ae88eb118ab43e543828005c8b0" => :high_sierra
    sha256 "91be39be567b43a70b1a518e5ce3fe852286d8f2e3e7e02f0ff70aa9c1e0d737" => :sierra
    sha256 "5407e18566538ab1eee618bfa081923c983dd6aa9275ff58f3fc6068a64e3d45" => :el_capitan
  end

  depends_on "python@2"
  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/bear", "true"
    assert_predicate testpath/"compile_commands.json", :exist?
  end
end
