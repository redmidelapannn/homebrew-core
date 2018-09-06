class Poac < Formula
  desc "Package manager for C/C++"
  homepage "https://github.com/poacpm"
  url "https://github.com/poacpm/poac.git",
      :tag => "0.0.1-beta",
      :revision => "e0edca899587f4cc5ac82874fff2ad66f75e342e"

  bottle do
    cellar :any
    sha256 "31c160b4ac4906c40067ae575bfbbbfacf9f72f5159536bb65ea3d2750275e7f" => :mojave
    sha256 "3665c9f9c9e7889b99d9b9e156c13efc4dbab3e0e4df64261110f42f3c6afcf5" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "openssl"
  depends_on "yaml-cpp"

  def install
    mkdir "bulid" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end

    man1.install Dir["docs/man/man1/*.1"]
    bash_completion.install "docs/comp/poac.bash" => "poac"
  end

  test do
    assert_match /Usage/, shell_output("#{bin}/poac --help")
  end
end
