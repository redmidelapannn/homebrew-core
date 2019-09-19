class Vcpkg < Formula
  desc "C++ Library Manager for Windows, Linux, and MacOS"
  homepage "https://docs.microsoft.com/en-us/cpp/vcpkg"

  stable do
    url "https://github.com/microsoft/vcpkg/archive/2019.08.tar.gz"
    sha256 "d533d8b577ce527c018aaaa77cee88d1940e3772221b7a6b4b995d3e953730e1"
  end
  bottle do
    cellar :any
    sha256 "fecf03bb500fa514cc9f283431f37d6188ca805b6f8eea94bf80bc2abf0037d6" => :mojave
    sha256 "79bf645b494b2367f6a99e88ba85b9a14cdd4d2731b1f044c7653d31b62d87c4" => :high_sierra
    sha256 "376f2a8ef302356738600347e33acb0e79555365ac257472e357583d104bf156" => :sierra
  end


  head do
    url "https://github.com/microsoft/vcpkg.git"
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "ninja" => :build

  def install
    ENV["CC"] = Formula["gcc"].opt_bin/"gcc-#{Formula["gcc"].version_suffix}"
    ENV["CXX"] = Formula["gcc"].opt_bin/"g++-#{Formula["gcc"].version_suffix}"
    system "./bootstrap-vcpkg.sh", "-useSystemBinaries"
    libexec.install ["ports", "scripts", "triplets", "vcpkg", ".vcpkg-root"]
    bin.install_symlink libexec/"vcpkg"
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/vcpkg version")
  end
end
