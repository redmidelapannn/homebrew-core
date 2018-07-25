class Cquery < Formula
  desc "C/C++ language server"
  homepage "https://github.com/cquery-project/cquery"
  # pull from git tag to get submodules
  url "https://github.com/cquery-project/cquery.git", :tag => "v20180718",
                                                      :revision => "b523aa928acf8ffb3de6b22c79db7366a9672489"
  head "https://github.com/cquery-project/cquery.git"

  bottle do
    sha256 "ec26205deb2ebe7156af3aab0d040a88c3572d66bc396cb7bad126243ee785fa" => :high_sierra
    sha256 "41eb7b1e3508a8b52630bc37bc64eee89b8f48e1faffb94f8cf1c0f8ca52c244" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  needs :cxx14

  def install
    ENV.append "CPPFLAGS", "-L#{Formula["llvm"].opt_include}"
    ENV.append "LDFLAGS", "-L#{Formula["llvm"].opt_lib}"

    mkdir "build" do
      system "cmake", "..", "-DCMAKE_BUILD_TYPE=release",
                      "-DCMAKE_INSTALL_PREFIX=#{prefix}",
                      "-DCMAKE_EXPORT_COMPILE_COMMANDS=YES",
                      "-DSYSTEM_CLANG=ON"
      system "make", "all"
      system "make", "install"
    end
  end

  test do
    system bin/"cquery", "--test-unit"
  end
end
