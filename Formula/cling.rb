class Cling < Formula
  desc "The cling C++ interpreter"
  homepage "https://root.cern.ch/cling"
  url "http://root.cern.ch/git/cling.git",
      :tag => "v0.5",
      :revision => "0f1d6d24d4417fc02b73589c8b1d813e92de1c3f"
  revision 1

  bottle do
    sha256 "6aeba9d81dd204545c4498e83205746dff6f99bf4b8eb4b19ae6b446bddf76bf" => :high_sierra
    sha256 "728dfa2485e7ac43a1b0573a208e4723a6305c73fdbdc938381f2160530fbf93" => :sierra
    sha256 "d5075bd17352490e2b78e2c52f22209f11ad78a1e8421e0af2c16cd4b6daefea" => :el_capitan
  end

  keg_only :shadowed_by_macos, <<~EOS
    cling installs `clang` and `clang++` which shadow those executables
    in /usr/bin. Additionally this formula conflicts with clang-format
  EOS

  depends_on "cmake" => :build

  resource "clang" do
    url "http://root.cern.ch/git/clang.git",
        :tag => "cling-patches-r302975",
        :revision => "1f8b137c7eb06ed8e321649ef7e3f3e7a96f361c"
  end

  resource "llvm" do
    url "http://root.cern.ch/git/llvm.git",
        :tag => "cling-patches-r302975",
        :revision => "2a34248cb945d63ded5ee55128e68efd7e5b87c8"
  end

  def install
    (buildpath/"src").install resource("llvm")
    (buildpath/"src/tools/cling").install buildpath.children - [buildpath/"src"]
    (buildpath/"src/tools/clang").install resource("clang")
    mkdir "build" do
      system "cmake", *std_cmake_args, "../src"
      system "make", "install"
    end
    prefix.install_metafiles buildpath/"src/tools/cling"
  end

  test do
    test = <<~EOS
      '#include <stdio.h>' 'printf("Hello!")'
    EOS
    assert_equal "Hello!(int) 6", shell_output("#{bin}/cling #{test}").chomp
  end
end
