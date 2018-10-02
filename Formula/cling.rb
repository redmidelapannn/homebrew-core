class Cling < Formula
  desc "The cling C++ interpreter"
  homepage "https://root.cern.ch/cling"
  url "https://github.com/root-project/cling.git",
      :tag => "v0.5",
      :revision => "0f1d6d24d4417fc02b73589c8b1d813e92de1c3f"
  revision 1

  bottle do
    rebuild 1
    sha256 "4f48439ebb20b230f19adb5feae8a73a3374a718d933fadf9edffa0f1beccb9b" => :mojave
    sha256 "0165a035db2e56da031f0168cd197ec260ed159c7272faf6a0e0701f3c907945" => :high_sierra
    sha256 "970868500d833a825cf1c59d27c94b6bde332c67fccc95288cdf8cf58c7bf71b" => :sierra
  end

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
      system "cmake", *std_cmake_args, "-DCMAKE_INSTALL_PREFIX=#{libexec}", "../src"
      system "make", "install"
    end
    bin.install_symlink libexec/"bin/cling"
    prefix.install_metafiles buildpath/"src/tools/cling"
  end

  test do
    test = <<~EOS
      '#include <stdio.h>' 'printf("Hello!")'
    EOS
    assert_equal "Hello!(int) 6", shell_output("#{bin}/cling #{test}").chomp
  end
end
